#### Preamble ####
# Purpose: test on the analysis data for validation
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: analysis data generated in 02-analysis_data
# Any other information needed? None

#### Workspace setup ####

# Load necessary libraries
library(tidyverse)
library(testthat)
library(arrow)  # For reading Parquet files
library(here)

# Read the analysis data
temp_train <- read_parquet(here::here("data/02-analysis_data/temp_train_data.parquet"))
temp_test <- read_parquet(here::here("data/02-analysis_data/temp_test_data.parquet"))
latitude_time_train <- read_parquet(here::here("data/02-analysis_data/latitude&time_train_data.parquet"))
latitude_time_test <- read_parquet(here::here("data/02-analysis_data/latitude&time_test_data.parquet"))

#### Test data ####

# Ensure testthat setup
context("Data validation tests for analysis datasets")

# Test 1: Check if the datasets have the expected columns
test_that("Expected columns are present in all datasets", {
  # Columns for temp datasets
  temp_expected_columns <- c("temp", "flower_doy")
  
  # Columns for latitude & time datasets
  lat_time_expected_columns <- c("flower_date", "mean_temp_month", "latitude")
  
  # Check columns
  expect_true(all(temp_expected_columns %in% colnames(temp_train)))
  expect_true(all(temp_expected_columns %in% colnames(temp_test)))
  expect_true(all(lat_time_expected_columns %in% colnames(latitude_time_train)))
  expect_true(all(lat_time_expected_columns %in% colnames(latitude_time_test)))
})

# Test 2: Check for missing values
test_that("No missing values in critical columns", {
  # Critical columns for temp datasets
  temp_critical_columns <- c("temp", "flower_doy")
  
  # Critical columns for latitude & time datasets
  lat_time_critical_columns <- c("flower_date", "mean_temp_month", "latitude")
  
  # Check missing values
  for (col in temp_critical_columns) {
    expect_true(all(!is.na(temp_train[[col]])), info = paste("Missing values in temp_train:", col))
    expect_true(all(!is.na(temp_test[[col]])), info = paste("Missing values in temp_test:", col))
  }
  
  for (col in lat_time_critical_columns) {
    expect_true(all(!is.na(latitude_time_train[[col]])), info = paste("Missing values in latitude_time_train:", col))
    expect_true(all(!is.na(latitude_time_test[[col]])), info = paste("Missing values in latitude_time_test:", col))
  }
})

# Test 3: Check data types of columns
test_that("Columns have the correct data types", {
  # Data type checks for temp datasets
  expect_true(is.numeric(temp_train$temp))
  expect_true(is.numeric(temp_test$temp))
  expect_true(is.numeric(temp_train$flower_doy))
  expect_true(is.numeric(temp_test$flower_doy))
  
  # Data type checks for latitude & time datasets
  expect_true(is.Date(latitude_time_train$flower_date))
  expect_true(is.Date(latitude_time_test$flower_date))
  expect_true(is.numeric(latitude_time_train$mean_temp_month))
  expect_true(is.numeric(latitude_time_test$mean_temp_month))
  expect_true(is.numeric(latitude_time_train$latitude))
  expect_true(is.numeric(latitude_time_test$latitude))
})

# Test 4: Check ranges of numeric columns
test_that("Numeric columns fall within reasonable ranges", {
  # Reasonable ranges for temp and flower_doy
  expect_true(all(temp_train$temp >= -50 & temp_train$temp <= 50), info = "temp out of range in temp_train")
  expect_true(all(temp_test$temp >= -50 & temp_test$temp <= 50), info = "temp out of range in temp_test")
  expect_true(all(temp_train$flower_doy >= 1 & temp_train$flower_doy <= 366), info = "flower_doy out of range in temp_train")
  expect_true(all(temp_test$flower_doy >= 1 & temp_test$flower_doy <= 366), info = "flower_doy out of range in temp_test")
  
  # Reasonable ranges for latitude & time datasets
  expect_true(all(latitude_time_train$latitude >= -90 & latitude_time_train$latitude <= 90), info = "latitude out of range in latitude_time_train")
  expect_true(all(latitude_time_test$latitude >= -90 & latitude_time_test$latitude <= 90), info = "latitude out of range in latitude_time_test")
  expect_true(all(latitude_time_train$mean_temp_month >= -50 & latitude_time_train$mean_temp_month <= 50), info = "mean_temp_month out of range in latitude_time_train")
  expect_true(all(latitude_time_test$mean_temp_month >= -50 & latitude_time_test$mean_temp_month <= 50), info = "mean_temp_month out of range in latitude_time_test")
})

# Test 5: Check if flower_date is in the expected format (YYYY-MM-DD)
test_that("flower_date is in correct date format", {
  expect_true(all(lubridate::is.Date(latitude_time_train$flower_date)), info = "flower_date format incorrect in latitude_time_train")
  expect_true(all(lubridate::is.Date(latitude_time_test$flower_date)), info = "flower_date format incorrect in latitude_time_test")
})


# Test 6: Check basic statistics of columns to verify distribution
test_that("Mean and standard deviation of numeric columns are within expected ranges", {
  # Check temperature statistics
  expect_true(mean(temp_train$temp) > -10 & mean(temp_train$temp) < 30, info = "Mean of temp in temp_train out of expected range")
  expect_true(sd(temp_train$temp) < 15, info = "Standard deviation of temp in temp_train is unusually high")
  
  # Check mean_temp_month statistics
  expect_true(mean(latitude_time_train$mean_temp_month) > -10 & mean(latitude_time_train$mean_temp_month) < 30, info = "Mean of mean_temp_month in latitude_time_train out of expected range")
  expect_true(sd(latitude_time_train$mean_temp_month) < 15, info = "Standard deviation of mean_temp_month in latitude_time_train is unusually high")
})
