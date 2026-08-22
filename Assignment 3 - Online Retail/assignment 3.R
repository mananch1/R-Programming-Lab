
required_pkgs <- c("readxl","dplyr","tidyr","lubridate","stringr","data.table","DBI","RSQLite","arrow")
new_pkgs <- setdiff(required_pkgs, rownames(installed.packages()))
if(length(new_pkgs)) install.packages(new_pkgs, repos = "https://cran.r-project.org")
suppressPackageStartupMessages(lapply(required_pkgs, library, character.only = TRUE))

options(stringsAsFactors = FALSE)
infile <- "Online Retail.xlsx"
if(!file.exists(infile)) stop("Input file not found: ", infile)

# Read data and standardize column names
raw <- read_xlsx(infile)
names(raw) <- names(raw) %>% tolower() %>% str_replace_all("\\s+", "_")

# Parse invoice date robustly
if(inherits(raw$invoicedate, "POSIXt")) {
  raw$invoicedate_parsed <- raw$invoicedate
} else {
  parse_safe_date <- function(x) {
    x <- trimws(as.character(x))
    dt <- suppressWarnings(lubridate::dmy_hm(x))
    if(all(is.na(dt))) dt <- suppressWarnings(lubridate::mdy_hm(x))
    if(all(is.na(dt))) dt <- suppressWarnings(lubridate::parse_date_time(x, orders = c("d/m/Y H:M","m/d/Y H:M","Y-m-d H:M:S","Y-m-d")))
    return(dt)
  }
  raw$invoicedate_parsed <- parse_safe_date(raw$invoicedate)
}

# Remove exact duplicates
data <- raw %>% distinct()

# Ensure numeric types
if("quantity" %in% names(data)) data$quantity <- as.numeric(data$quantity)
if("unitprice" %in% names(data)) data$unitprice <- as.numeric(data$unitprice)

# Filter to positive quantities and prices and compute revenue
data_clean <- data %>%
  filter(if ("quantity" %in% names(.) ) (!is.na(quantity) & quantity > 0) else TRUE,
         if ("unitprice" %in% names(.) ) (!is.na(unitprice) & unitprice > 0) else TRUE) %>%
  mutate(revenue = if ("quantity" %in% names(.) & "unitprice" %in% names(.)) quantity * unitprice else NA_real_)

transaction_total_revenue <- sum(data_clean$revenue, na.rm = TRUE)

# Build canonical product lookup (one row per stockcode)
products_unique <- data_clean %>%
  filter(!is.na(stockcode)) %>%
  group_by(stockcode, description) %>%
  summarise(median_price = if ("unitprice" %in% names(.) ) median(unitprice, na.rm = TRUE) else NA_real_, cnt = n(), .groups = "drop") %>%
  group_by(stockcode) %>%
  slice_max(order_by = cnt, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  rename(unitprice_lookup = median_price) %>%
  select(stockcode, description, unitprice_lookup)

# Build canonical customer lookup (one row per customerid)
customers_unique <- data_clean %>%
  filter(!is.na(customerid)) %>%
  group_by(customerid, country) %>%
  summarise(cnt = n(), .groups = "drop") %>%
  group_by(customerid) %>%
  slice_max(order_by = cnt, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  select(customerid, country)

# Prepare transactions table
transactions <- data_clean %>%
  transmute(
    invoiceno = if("invoiceno" %in% names(.)) invoiceno else NA_character_,
    stockcode = if("stockcode" %in% names(.)) stockcode else NA_character_,
    customerid = if("customerid" %in% names(.)) customerid else NA_real_,
    quantity = if("quantity" %in% names(.)) quantity else NA_real_,
    invoicedate = invoicedate_parsed,
    unitprice_trans = if("unitprice" %in% names(.)) unitprice else NA_real_,
    revenue = revenue
  )

# Re-join lookups
retail_joined <- transactions %>%
  left_join(products_unique, by = "stockcode") %>%
  left_join(customers_unique, by = "customerid")

# Resolve unitprice columns
retail_joined <- retail_joined %>%
  mutate(unitprice = coalesce(unitprice_trans, unitprice_lookup)) %>%
  select(-matches("^unitprice_trans$|^unitprice_lookup$"))

# Remove leftover suffixed columns if any
suffixed_cols <- names(retail_joined)[grepl("\\.x$|\\.y$", names(retail_joined))]
if(length(suffixed_cols) > 0) {
  retail_joined <- retail_joined %>% select(-all_of(suffixed_cols))
}

# Final tables
final_keep_desc <- retail_joined %>%
  select(invoiceno, invoicedate, stockcode, description, quantity, unitprice, revenue, customerid, country)

final_normalized <- retail_joined %>%
  select(invoiceno, invoicedate, stockcode, quantity, unitprice, revenue, customerid)

# Backup existing large files if present
if(!dir.exists("backup_large_files")) dir.create("backup_large_files")
mv_if_exists <- function(fn) {
  if(file.exists(fn)) {
    fn_new <- file.path("backup_large_files", paste0(basename(fn), ".old_", format(Sys.time(), "%Y%m%d%H%M%S")))
    file.rename(fn, fn_new)
  }
}
mv_if_exists("retail_sales_final.csv")
mv_if_exists("retail_sales_final.csv.gz")
mv_if_exists("retail_sales_final.parquet")
mv_if_exists("retail_sales.db")

# Write compressed CSV and parquet
data.table::fwrite(final_keep_desc, "retail_sales_final.csv.gz", compress = "gzip")
arrow::write_parquet(final_keep_desc, "retail_sales_final.parquet")

# Write normalized SQLite DB
con <- DBI::dbConnect(RSQLite::SQLite(), "retail_sales.db")
DBI::dbWriteTable(con, "retail_sales", final_normalized, overwrite = TRUE)
DBI::dbWriteTable(con, "products", products_unique, overwrite = TRUE)
DBI::dbWriteTable(con, "customers", customers_unique, overwrite = TRUE)
DBI::dbExecute(con, "CREATE INDEX IF NOT EXISTS idx_stockcode ON retail_sales(stockcode);")
DBI::dbExecute(con, "CREATE INDEX IF NOT EXISTS idx_customerid ON retail_sales(customerid);")
DBI::dbDisconnect(con)

# Write a small sample and business insights
write.csv(head(final_keep_desc, 200), "retail_sample_200.csv", row.names = FALSE)

ins <- c(
  "Top SKUs contribute a large share of revenue; prioritize inventory for them.",
  "A few countries account for most revenue; consider regional marketing and fulfillment improvements.",
  "A small premium customer cohort contributes disproportionate revenue; implement retention measures."
)
writeLines(ins, "business_insights.txt")

# Basic analysis outputs (printed)
total_revenue <- sum(final_keep_desc$revenue, na.rm = TRUE)
cat("Total sales revenue (final):", total_revenue, "\n")

top_products <- final_keep_desc %>%
  group_by(stockcode, description) %>%
  summarise(product_revenue = sum(revenue, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(product_revenue)) %>%
  slice_head(n = 10)
print(top_products)

top_countries <- final_keep_desc %>%
  group_by(country) %>%
  summarise(country_revenue = sum(revenue, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(country_revenue)) %>%
  slice_head(n = 10)
print(top_countries)

top_customers <- final_keep_desc %>%
  filter(!is.na(customerid)) %>%
  group_by(customerid) %>%
  summarise(customer_revenue = sum(revenue, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(customer_revenue)) %>%
  slice_head(n = 10)
print(top_customers)

# Final file size report
file.size.mb <- function(f) if (file.exists(f)) file.info(f)$size/1024^2 else NA
cat("Files written:\n")
cat("CSV.gz MB:", file.size.mb("retail_sales_final.csv.gz"), "\n")
cat("Parquet MB:", file.size.mb("retail_sales_final.parquet"), "\n")
cat("SQLite MB:", file.size.mb("retail_sales.db"), "\n")
cat("Script finished.\n")