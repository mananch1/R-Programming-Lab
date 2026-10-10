#############################
# AIR QUALITY DATA CLEANING
#############################


setwd("D:/DOCS/VIT Ebooks/Fourth Year/Sem 7/R/Lab/air-quality-data-cleaning/data/PRSA2017_Data_20130301-20170228/PRSA_Data_20130301-20170228")
file_name <- "PRSA_Data_Aotizhongxin_20130301-20170228.csv"


###############################
# Task 1 : Import and Inspect
###############################

air_data <- tryCatch({

    read.csv(file_path)

}, warning=function(w){

    message("Warning: ", w$message)

}, error=function(e){

    stop(paste("Error while reading file:", e$message))

})

cat("First 6 Records:\n")
head(air_data)

cat("\nStructure:\n")
str(air_data)

cat("\nDimensions:\n")
print(dim(air_data))

cat("\nAny Missing Values?\n")
print(any(is.na(air_data)))

cat("\nTotal Missing Values:\n")
print(sum(is.na(air_data)))

###############################################################
# Task 2 : NA, NULL and NaN
###############################################################

cat("\n------------ TASK 2 ------------\n")

temperature <- c(28,30,NA,32)
missing_object <- NULL
undefined_value <- 0/0

cat("NA Example:\n")
print(temperature)
print(is.na(temperature))

cat("\nNULL Example:\n")
print(missing_object)
print(is.null(missing_object))

cat("\nNaN Example:\n")
print(undefined_value)
print(is.nan(undefined_value))

###############################################################
# Task 3 : Missing Summary Function
###############################################################

missing_summary <- function(df){

    selected_variables <- c(
        "PM2.5",
        "PM10",
        "SO2",
        "NO2",
        "TEMP",
        "WSPM",
        "wd"
    )

    summary_table <- data.frame(
        Variable=character(),
        Total_Records=integer(),
        Missing_Values=integer(),
        Missing_Percentage=double(),
        stringsAsFactors=FALSE
    )

    for(variable in selected_variables){

        if(variable %in% names(df)){

            total <- nrow(df)

            missing <- sum(is.na(df[[variable]]))

            percentage <- (missing/total)*100

            summary_table <- rbind(
                summary_table,
                data.frame(
                    Variable=variable,
                    Total_Records=total,
                    Missing_Values=missing,
                    Missing_Percentage=round(percentage,2)
                )
            )

            if(percentage>20){

                warning(
                    paste(variable,
                          "contains more than 20% missing values.")
                )

            }

        }

    }

    return(summary_table)

}

cat("\nMissing Summary Before Cleaning:\n")

missing_before <- missing_summary(air_data)

print(missing_before)

###############################################################
# Task 4 : Pollution Ratio
###############################################################

air_data$pollution_ratio <- air_data$PM2.5 / air_data$PM10

cat("\nNA Count:\n")
print(sum(is.na(air_data$pollution_ratio)))

cat("\nNaN Count:\n")
print(sum(is.nan(air_data$pollution_ratio)))

cat("\nInfinite Count:\n")
print(sum(is.infinite(air_data$pollution_ratio)))

air_data$pollution_ratio[
    is.nan(air_data$pollution_ratio) |
    is.infinite(air_data$pollution_ratio)
] <- NA

###############################################################
# Task 5 : Replace Missing Numerical Values
###############################################################

numeric_variables <- c(
    "PM2.5",
    "PM10",
    "SO2",
    "NO2",
    "TEMP",
    "WSPM"
)

before_missing <- c()
after_missing <- c()

cat("\nNumerical Variable Cleaning\n")

for(variable in numeric_variables){

    if(variable %in% names(air_data)){

        before <- sum(is.na(air_data[[variable]]))

        median_value <- median(
            air_data[[variable]],
            na.rm=TRUE
        )

        air_data[[variable]][
            is.na(air_data[[variable]])
        ] <- median_value

        after <- sum(is.na(air_data[[variable]]))

        before_missing <- c(before_missing,before)
        after_missing <- c(after_missing,after)

        cat("-----------------------------------\n")
        cat("Variable:",variable,"\n")
        cat("Missing Before:",before,"\n")
        cat("Median Used:",median_value,"\n")
        cat("Missing After:",after,"\n")

    }

}

###############################################################
# Task 6 : Mode Function for wd
###############################################################

calculate_mode <- function(x){

    unique_values <- unique(x)

    unique_values <- unique_values[!is.na(unique_values)]

    unique_values[
        which.max(
            tabulate(match(x,unique_values))
        )
    ]

}

mode_value <- calculate_mode(air_data$wd)

before_wd <- sum(is.na(air_data$wd))

air_data$wd[is.na(air_data$wd)] <- mode_value

after_wd <- sum(is.na(air_data$wd))

cat("\nWind Direction Cleaning\n")
cat("Mode:",mode_value,"\n")
cat("Missing Before:",before_wd,"\n")
cat("Missing After:",after_wd,"\n")

###############################################################
# Task 7 : Error Handling Function
###############################################################

clean_variable <- function(df,variable){

    tryCatch({

        if(!(variable %in% names(df)))
            stop("Variable does not exist.")

        if(!is.numeric(df[[variable]]))
            stop("Variable is not numerical.")

        if(all(is.na(df[[variable]])))
            stop("Variable contains only missing values.")

        median_value <- median(
            df[[variable]],
            na.rm=TRUE
        )

        if(is.na(median_value))
            stop("Median cannot be calculated.")

        df[[variable]][
            is.na(df[[variable]])
        ] <- median_value

        return(df[[variable]])

    },

    error=function(e){

        message("Error: ",e$message)

        return(NULL)

    })

}

air_data$PM2.5 <- clean_variable(
    air_data,
    "PM2.5"
)

###############################################################
# Task 8 : Comparison Table
###############################################################

missing_after <- missing_summary(air_data)

comparison <- data.frame(

    Variable=c(
        numeric_variables,
        "wd"
    ),

    Missing_Before=c(
        before_missing,
        before_wd
    ),

    Missing_After=c(
        after_missing,
        after_wd
    )

)

comparison$Values_Replaced <-
comparison$Missing_Before -
comparison$Missing_After

cat("\nComparison Table\n")
print(comparison)

###############################################################
# Task 9 : Visualization
###############################################################

before_plot <- comparison$Missing_Before
after_plot <- comparison$Missing_After

barplot(

    rbind(before_plot,after_plot),

    beside=TRUE,

    names.arg=comparison$Variable,

    legend.text=c(
        "Before",
        "After"
    ),

    col=c(
        "red",
        "green"
    ),

    main="Missing Values Before and After Cleaning",

    xlab="Variables",

    ylab="Missing Values"

)

###############################################################
# Task 10 : Export Cleaned Dataset
###############################################################

write.csv(

    air_data,

    "cleaned_air_quality_data.csv",

    row.names=FALSE

)

cat("\nCleaned dataset exported successfully.\n")

###############################################################
# End of Program
###############################################################