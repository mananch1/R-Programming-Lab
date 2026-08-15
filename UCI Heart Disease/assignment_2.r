# ============================================================
# LAB 3: CONTROL FLOW FOR DATA CLEANING
# Topic: Loops, Functions, and Error Handling in R
# Dataset: UCI Heart Disease - Cleveland Dataset
# File: processed.cleveland.data
# ============================================================


# ------------------------------------------------------------
# 1. CLEAR WORKSPACE
# ------------------------------------------------------------

rm(list = ls())
cat("\014")


# ------------------------------------------------------------
# 2. SET FILE PATH
# ------------------------------------------------------------

data_file <- "./heart disease/processed.cleveland.data"

if (!file.exists(data_file)) {

  stop(
    paste(
      "File not found:",
      data_file,
      "\nCurrent working directory:",
      getwd()
    )
  )

}

cat("Current working directory:\n")
print(getwd())

cat("\nDataset file found successfully.\n")


# ------------------------------------------------------------
# 3. COLUMN NAMES
# ------------------------------------------------------------

column_names <- c(
  "age",
  "sex",
  "cp",
  "trestbps",
  "chol",
  "fbs",
  "restecg",
  "thalach",
  "exang",
  "oldpeak",
  "slope",
  "ca",
  "thal",
  "num"
)


# ------------------------------------------------------------
# 4. LOAD THE DATASET
# ------------------------------------------------------------

heart_data <- read.csv(
  data_file,
  header = FALSE,
  col.names = column_names,
  stringsAsFactors = FALSE
)


# ------------------------------------------------------------
# 5. DISPLAY BASIC INFORMATION
# ------------------------------------------------------------

cat("\n========== DATASET INFORMATION ==========\n")

cat(
  "Number of rows    :",
  nrow(heart_data),
  "\n"
)

cat(
  "Number of columns :",
  ncol(heart_data),
  "\n"
)

cat("\nFirst 5 rows:\n")
print(head(heart_data))


cat("\nDataset structure:\n")
str(heart_data)


# ============================================================
# 6. CONVERT UCI MISSING VALUE MARKER TO NA
# ============================================================

# In the processed Cleveland dataset, missing values
# are represented using -9.

heart_data[heart_data == -9] <- NA


cat("\nMissing values in each column:\n")
print(colSums(is.na(heart_data)))


# ============================================================
# 7. CREATE WORKING COPY
# ============================================================

heart_clean <- heart_data


# ============================================================
# 8. INTRODUCE ARTIFICIAL DATA-ENTRY ERRORS
# ============================================================

# The practical asks us to deliberately introduce:
#
#   - negative BP values
#   - missing BP values
#   - extreme BP values > 300
#
# We use set.seed() so the same rows are selected every time.

set.seed(123)

n <- nrow(heart_clean)


# Select rows for negative values
negative_rows <- sample(
  1:n,
  5
)


# Select different rows for missing values
remaining_rows <- setdiff(
  1:n,
  negative_rows
)

missing_rows <- sample(
  remaining_rows,
  5
)


# Select different rows for extreme values
remaining_rows <- setdiff(
  remaining_rows,
  missing_rows
)

extreme_rows <- sample(
  remaining_rows,
  5
)


# Introduce negative BP values
heart_clean$trestbps[negative_rows] <-
  -sample(
    10:50,
    5
  )


# Introduce missing BP values
heart_clean$trestbps[missing_rows] <- NA


# Introduce extreme BP values > 300
heart_clean$trestbps[extreme_rows] <-
  sample(
    301:400,
    5
  )


# ------------------------------------------------------------
# Display modified rows
# ------------------------------------------------------------

modified_rows <- sort(
  c(
    negative_rows,
    missing_rows,
    extreme_rows
  )
)

cat("\n========== INTRODUCED ERRORS ==========\n")

cat(
  "Negative BP rows:",
  paste(
    negative_rows,
    collapse = ", "
  ),
  "\n"
)

cat(
  "Missing BP rows:",
  paste(
    missing_rows,
    collapse = ", "
  ),
  "\n"
)

cat(
  "Extreme BP rows:",
  paste(
    extreme_rows,
    collapse = ", "
  ),
  "\n"
)

cat("\nModified records:\n")

print(
  heart_clean[
    modified_rows,
    c(
      "age",
      "trestbps",
      "chol"
    )
  ]
)


# ============================================================
# 9. CUSTOM BP CLEANING FUNCTION
# ============================================================

# Cleaning rules:
#
# Negative BP       -> NA
# BP > 250          -> 250
# BP = NA           -> NA
# Valid BP          -> unchanged

clean_bp <- function(bp) {

  if (is.na(bp)) {

    return(NA)

  } else if (bp < 0) {

    return(NA)

  } else if (bp > 250) {

    return(250)

  } else {

    return(bp)

  }

}


# ------------------------------------------------------------
# Test the function
# ------------------------------------------------------------

cat("\n========== TESTING clean_bp() ==========\n")

cat(
  "clean_bp(-20) =",
  clean_bp(-20),
  "\n"
)

cat(
  "clean_bp(320) =",
  clean_bp(320),
  "\n"
)

cat(
  "clean_bp(120) =",
  clean_bp(120),
  "\n"
)

cat(
  "clean_bp(NA)  =",
  clean_bp(NA),
  "\n"
)


# ============================================================
# 10. LOOP-BASED CLEANING
# ============================================================

loop_cleaned <- heart_clean


loop_time <- system.time({

  for (i in 1:nrow(loop_cleaned)) {

    loop_cleaned$trestbps[i] <-
      clean_bp(
        loop_cleaned$trestbps[i]
      )

  }

})


cat("\n========== LOOP CLEANING ==========\n")

cat(
  "Loop cleaning completed.\n"
)

cat(
  "Loop elapsed time:",
  loop_time["elapsed"],
  "seconds\n"
)


# ============================================================
# 11. VECTORIZED CLEANING
# ============================================================

vector_cleaned <- heart_clean


vector_time <- system.time({

  # ----------------------------------------------------------
  # Negative values -> NA
  # ----------------------------------------------------------

  negative_index <-
    !is.na(vector_cleaned$trestbps) &
    vector_cleaned$trestbps < 0

  vector_cleaned$trestbps[
    negative_index
  ] <- NA


  # ----------------------------------------------------------
  # Values greater than 250 -> 250
  # ----------------------------------------------------------

  extreme_index <-
    !is.na(vector_cleaned$trestbps) &
    vector_cleaned$trestbps > 250

  vector_cleaned$trestbps[
    extreme_index
  ] <- 250

})


cat("\n========== VECTORIZED CLEANING ==========\n")

cat(
  "Vectorized cleaning completed.\n"
)

cat(
  "Vectorized elapsed time:",
  vector_time["elapsed"],
  "seconds\n"
)


# ============================================================
# 12. COMPARE LOOP AND VECTORIZED RESULTS
# ============================================================

same_results <- identical(
  loop_cleaned$trestbps,
  vector_cleaned$trestbps
)


cat("\n========== RESULT COMPARISON ==========\n")

cat(
  "Loop and vectorized results identical:",
  same_results,
  "\n"
)


# ============================================================
# 13. PERFORMANCE COMPARISON
# ============================================================

cat("\n========== PERFORMANCE COMPARISON ==========\n")

cat(
  "Loop elapsed time       :",
  loop_time["elapsed"],
  "seconds\n"
)

cat(
  "Vectorized elapsed time :",
  vector_time["elapsed"],
  "seconds\n"
)

if (
  loop_time["elapsed"] >
  vector_time["elapsed"]
) {

  cat(
    "Vectorized cleaning was faster.\n"
  )

} else {

  cat(
    "The execution times are very close for this small dataset.\n"
  )

}


# ============================================================
# 14. SAFE MEAN BP FUNCTION USING tryCatch()
# ============================================================

safe_mean_bp <- function(bp) {

  tryCatch({

    # Check whether input is numeric
    if (!is.numeric(bp)) {
      stop("Blood pressure values must be numeric.")
    }

    # Check whether all values are missing
    if (all(is.na(bp))) {
      stop("Cannot calculate mean: all BP values are missing.")
    }

    # Informative message when missing values are present
    if (any(is.na(bp))) {
      message(
        "Warning: Missing BP values detected. ",
        "They will be ignored while calculating the mean."
      )
    }

    # Calculate mean while ignoring NA values
    result <- mean(
      bp,
      na.rm = TRUE
    )

    return(result)

  }, error = function(e) {

    message(
      "Mean BP calculation error: ",
      e$message
    )

    return(NA)
  })
}
# ------------------------------------------------------------
# Calculate mean BP
# ------------------------------------------------------------

cat("\n========== SAFE MEAN BP ==========\n")

mean_bp_safe <- safe_mean_bp(
  vector_cleaned$trestbps
)

cat(
  "Mean BP:",
  mean_bp_safe,
  "\n"
)


# ============================================================
# 15. SAFE CHOLESTEROL / BP RATIO
# ============================================================

safe_ratio <- function(chol, bp) {

  tryCatch({

    # Check data types
    if (
      !is.numeric(chol) ||
      !is.numeric(bp)
    ) {

      stop(
        "Cholesterol and BP must be numeric."
      )

    }


    # Check missing values
    if (
      is.na(chol) ||
      is.na(bp)
    ) {

      stop(
        "Cannot calculate ratio because chol or BP is NA."
      )

    }


    # Check zero denominator
    if (bp == 0) {

      stop(
        "Cannot divide by zero: BP is 0."
      )

    }


    # Check negative BP
    if (bp < 0) {

      stop(
        "Invalid BP: denominator cannot be negative."
      )

    }


    # Calculate ratio
    return(
      chol / bp
    )


  },

  error = function(e) {

    message(
      "Ratio calculation error: ",
      e$message
    )

    return(NA)

  })

}


# ============================================================
# 16. TEST tryCatch() ERROR HANDLING
# ============================================================

cat("\n========== RATIO ERROR-HANDLING TESTS ==========\n")


# Valid case

cat("\nValid case:\n")

print(
  safe_ratio(
    200,
    120
  )
)


# Missing BP

cat("\nMissing BP:\n")

print(
  safe_ratio(
    200,
    NA
  )
)


# Zero BP

cat("\nZero BP:\n")

print(
  safe_ratio(
    200,
    0
  )
)


# Negative BP

cat("\nNegative BP:\n")

print(
  safe_ratio(
    200,
    -50
  )
)


# Invalid data type

cat("\nInvalid data type:\n")

print(
  safe_ratio(
    "200",
    120
  )
)


# ============================================================
# 17. CALCULATE CHOL / TREstBPS RATIO FOR ALL RECORDS
# ============================================================

vector_cleaned$chol_bp_ratio <- mapply(
  safe_ratio,
  vector_cleaned$chol,
  vector_cleaned$trestbps
)


cat("\nFirst 10 cholesterol/BP ratios:\n")

print(
  head(
    vector_cleaned[
      ,
      c(
        "chol",
        "trestbps",
        "chol_bp_ratio"
      )
    ],
    10
  )
)


# ============================================================
# 18. VALIDATE CLEANED DATA
# ============================================================


# Count missing BP values

missing_bp <- sum(
  is.na(
    vector_cleaned$trestbps
  )
)


# Minimum BP

minimum_bp <- min(
  vector_cleaned$trestbps,
  na.rm = TRUE
)


# Maximum BP

maximum_bp <- max(
  vector_cleaned$trestbps,
  na.rm = TRUE
)


# Mean BP

mean_bp <- mean(
  vector_cleaned$trestbps,
  na.rm = TRUE
)


# Median BP

median_bp <- median(
  vector_cleaned$trestbps,
  na.rm = TRUE
)


# Count negative BP values

negative_count <- sum(
  vector_cleaned$trestbps < 0,
  na.rm = TRUE
)


# Count BP values > 250

above_250_count <- sum(
  vector_cleaned$trestbps > 250,
  na.rm = TRUE
)


# ============================================================
# 19. DISPLAY VALIDATION RESULTS
# ============================================================

cat("\n")
cat("==============================================\n")
cat("           CLEANED DATA VALIDATION\n")
cat("==============================================\n")

cat(
  "Missing BP values     :",
  missing_bp,
  "\n"
)

cat(
  "Minimum BP            :",
  minimum_bp,
  "\n"
)

cat(
  "Maximum BP            :",
  maximum_bp,
  "\n"
)

cat(
  "Mean BP               :",
  mean_bp,
  "\n"
)

cat(
  "Median BP             :",
  median_bp,
  "\n"
)

cat(
  "Negative BP remaining :",
  negative_count,
  "\n"
)

cat(
  "BP > 250 remaining    :",
  above_250_count,
  "\n"
)

cat("==============================================\n")


# ============================================================
# 20. FINAL VALIDATION CHECKS
# ============================================================

cat("\n========== FINAL VALIDATION ==========\n")


if (negative_count == 0) {

  cat(
    "PASS: No negative BP values remain.\n"
  )

} else {

  cat(
    "FAIL: Negative BP values remain.\n"
  )

}


if (above_250_count == 0) {

  cat(
    "PASS: No BP values greater than 250 remain.\n"
  )

} else {

  cat(
    "FAIL: BP values greater than 250 remain.\n"
  )

}


if (same_results) {

  cat(
    "PASS: Loop and vectorized results are identical.\n"
  )

} else {

  cat(
    "FAIL: Loop and vectorized results differ.\n"
  )

}


# ============================================================
# 21. EXPORT CLEANED DATASET
# ============================================================

output_file <- "cleaned_heart_data.csv"


write.csv(
  vector_cleaned,
  output_file,
  row.names = FALSE
)


# ============================================================
# 22. CONFIRM FILE CREATION
# ============================================================

if (file.exists(output_file)) {

  cat(
    "\nCleaned dataset successfully saved as:\n",
    output_file,
    "\n"
  )

} else {

  cat(
    "\nERROR: Could not create output file.\n"
  )

}


# ============================================================
# END OF LAB 3
# ============================================================