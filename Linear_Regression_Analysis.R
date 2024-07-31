library(data.table)
library(ggplot2)
library(caret)
library(corrplot)

load("C:/Users/rdc26/TB_WHO2023/data/gtb/snapshot_2023-07-21/tb.rda")

ls()

tb <- as.data.table(tb)  # Use the correct variable name here

# Select non-empty columns
non_empty_columns <- colSums(is.na(tb)) < nrow(tb)
tb_non_empty <- tb[, ..non_empty_columns]

# Select relevant columns based on non-empty columns
tb_relevant <- tb[, ..non_empty_columns]

# Summarize the cleaned and selected data
summary(tb_relevant)

# Visualize the data
ggplot(tb_relevant, aes(x = year, y = new.sp)) +
  geom_line() +
  labs(title = "New TB Cases per Year", x = "Year", y = "New TB Cases (new.sp)")

# Check for missing values
missing_values_summary <- sapply(tb_relevant, function(x) sum(is.na(x)))
missing_values_summary <- missing_values_summary[missing_values_summary > 0]
print(missing_values_summary)

# Impute missing values with median for numeric columns
numeric_cols <- sapply(tb_relevant, is.numeric)
tb_relevant[, (names(tb_relevant)[numeric_cols]) := lapply(.SD, function(x) ifelse(is.na(x), median(x, na.rm = TRUE), x)), .SDcols = numeric_cols]

# Impute missing values with the mode for categorical columns
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
categorical_cols <- sapply(tb_relevant, is.factor)
tb_relevant[, (names(tb_relevant)[categorical_cols]) := lapply(.SD, function(x) ifelse(is.na(x), Mode(x), x)), .SDcols = categorical_cols]

# Check for any remaining missing values
missing_values_summary <- sapply(tb_relevant, function(x) sum(is.na(x)))
missing_values_summary <- missing_values_summary[missing_values_summary > 0]
print(missing_values_summary)

# Ensure no missing values in new.sp
tb_relevant$new.sp <- ifelse(is.na(tb_relevant$new.sp), median(tb_relevant$new.sp, na.rm = TRUE), tb_relevant$new.sp)

# Verify no missing values in new.sp
sum(is.na(tb_relevant$new.sp))

# Cleaned data for modeling
tb_cleaned <- tb_relevant

# Double-check the data
summary(tb_cleaned)

# Split the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(tb_cleaned$new.sp, p = .8, 
                                  list = FALSE, 
                                  times = 1)
tb_train <- tb_cleaned[trainIndex, ]
tb_test <- tb_cleaned[-trainIndex, ]

# Ensure no missing values in tb_train and tb_test
numeric_cols_train <- sapply(tb_train, is.numeric)
tb_train[, (names(tb_train)[numeric_cols_train]) := lapply(.SD, function(x) ifelse(is.na(x), median(x, na.rm = TRUE), x)), .SDcols = numeric_cols_train]

numeric_cols_test <- sapply(tb_test, is.numeric)
tb_test[, (names(tb_test)[numeric_cols_test]) := lapply(.SD, function(x) ifelse(is.na(x), median(x, na.rm = TRUE), x)), .SDcols = numeric_cols_test]

# Check for any remaining missing values
sum(is.na(tb_train))
sum(is.na(tb_test))

# Fit a linear regression model
model <- train(new.sp ~ ., data = tb_train, method = "lm")

# Predict on the test set
predictions <- predict(model, tb_test)

# Evaluate the model
evaluation <- postResample(pred = predictions, obs = tb_test$new.sp)
print(evaluation)

# Predictions vs. Actual Values Plot
ggplot(data = data.frame(actual = tb_test$new.sp, predicted = predictions), aes(x = actual, y = predicted)) +
  geom_point(color = "blue") +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Predictions vs Actual Values", x = "Actual Values", y = "Predictions") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma)

# Residuals Plot
ggplot(data = data.frame(predicted = predictions, residuals = residuals), aes(x = predicted, y = residuals)) +
  geom_point(color = "blue") +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Residuals Plot", x = "Predictions", y = "Residuals") +
  theme_minimal() +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma)
