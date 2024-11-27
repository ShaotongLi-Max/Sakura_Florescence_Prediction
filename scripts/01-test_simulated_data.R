#### Preamble ####
# Purpose: Tests the structure and validity of the simulated variables
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: Simulated data stored in data/00-simulated_data
# Any other information needed? None

#### Workspace setup ####

# Load necessary libraries
library(testthat)
library(tidyverse)
library(arrow)
#### Load Simulated Data ####

# Load the simulated datasets
simulated_latitude_time <- read_parquet(here::here("data/00-simulated_data/simulated_latitude_time.parquet"))
simulated_temp <- read_parquet(here::here("data/00-simulated_data/simulated_temp.parquet"))

#### Test Simulated Data ####

# Set up test context
context("Validation tests for simulated datasets")

#### Test 1: Validate latitude_time dataset ####
test_that("Simulated latitude_time dataset contains expected columns", {
  expected_columns <- c("flower_date", "mean_temp_month", "latitude")
  expect_true(all(expected_columns %in% colnames(simulated_latitude_time)), 
              info = "Missing columns in simulated_latitude_time")
})

test_that("Latitude values are within the expected range", {
  expect_true(all(simulated_latitude_time$latitude >= 24.34 & 
                    simulated_latitude_time$latitude <= 45.42),
              info = "Latitude values out of range in simulated_latitude_time")
})

test_that("Mean temperature is correctly computed using the linear model", {
  computed_mean_temp <- -15 + 0.35 * simulated_latitude_time$latitude - 
    0.12 * day(simulated_latitude_time$flower_date) + 
    2 * month(simulated_latitude_time$flower_date)
  expect_equal(simulated_latitude_time$mean_temp_month, computed_mean_temp, tolerance = 1e-5,
               info = "Mean temperature not correctly computed in simulated_latitude_time")
})

test_that("Flower dates are valid and within range", {
  expect_true(all(simulated_latitude_time$flower_date >= as.Date("1953-01-01") & 
                    simulated_latitude_time$flower_date <= as.Date("2019-12-31")),
              info = "Flower dates out of range in simulated_latitude_time")
})


#### Test 2: Validate temp dataset ####
test_that("Simulated temp dataset contains expected columns", {
  expected_columns <- c("temp", "flower_doy")
  expect_true(all(expected_columns %in% colnames(simulated_temp)), 
              info = "Missing columns in simulated_temp")
})

test_that("Temperature values are within the expected range", {
  expect_true(all(simulated_temp$temp >= 1.0 & 
                    simulated_temp$temp <= 11.8),
              info = "Temperature values out of range in simulated_temp")
})

test_that("Flower DOY is correctly computed using the linear model", {
  computed_flower_doy <- 126 - 3.5 * simulated_temp$temp
  expect_equal(simulated_temp$flower_doy, computed_flower_doy, tolerance = 1e-5,
               info = "Flower DOY not correctly computed in simulated_temp")
})

#### Test 3: General consistency tests ####
test_that("Simulated datasets contain the expected number of rows", {
  expect_equal(nrow(simulated_latitude_time), 100, 
               info = "Simulated latitude_time does not contain 100 rows")
  expect_equal(nrow(simulated_temp), 100, 
               info = "Simulated temp does not contain 100 rows")
})

test_that("There are no missing values in simulated datasets", {
  expect_true(all(complete.cases(simulated_latitude_time)), 
              info = "Missing values found in simulated_latitude_time")
  expect_true(all(complete.cases(simulated_temp)), 
              info = "Missing values found in simulated_temp")
})

#### Test 4: Validate unique constraints ####
test_that("Simulated latitude_time dataset has unique flower dates", {
  expect_equal(nrow(simulated_latitude_time), nrow(distinct(simulated_latitude_time, flower_date)),
               info = "Duplicate flower dates found in simulated_latitude_time")
})

test_that("Simulated temp dataset has unique temperature values", {
  expect_equal(nrow(simulated_temp), nrow(distinct(simulated_temp, temp)),
               info = "Duplicate temperature values found in simulated_temp")
})

#### Test 5: Validate realistic ranges ####
test_that("Mean temperature in latitude_time dataset has realistic values", {
  expect_true(all(simulated_latitude_time$mean_temp_month >= -50 & 
                    simulated_latitude_time$mean_temp_month <= 50),
              info = "Mean temperature out of realistic range in simulated_latitude_time")
})

test_that("Flower DOY in temp dataset is within the valid range", {
  expect_true(all(simulated_temp$flower_doy >= 1 & simulated_temp$flower_doy <= 366),
              info = "Flower DOY out of range in simulated_temp")
})

#### Test 6: Cross-variable consistency ####
test_that("Mean temperature increases with latitude in latitude_time dataset", {
  increasing_trend <- cor(simulated_latitude_time$latitude, simulated_latitude_time$mean_temp_month) > 0
  expect_true(increasing_trend, 
              info = "Mean temperature does not increase with latitude in simulated_latitude_time")
})

test_that("Flower DOY decreases as temperature increases in temp dataset", {
  decreasing_trend <- cor(simulated_temp$temp, simulated_temp$flower_doy) < 0
  expect_true(decreasing_trend, 
              info = "Flower DOY does not decrease with temperature in simulated_temp")
})

#### Test 7: Data type validation ####
test_that("All columns in latitude_time dataset have the correct data types", {
  expect_true(is.Date(simulated_latitude_time$flower_date), 
              info = "flower_date column is not of type Date in simulated_latitude_time")
  expect_true(is.numeric(simulated_latitude_time$mean_temp_month), 
              info = "mean_temp_month column is not numeric in simulated_latitude_time")
  expect_true(is.numeric(simulated_latitude_time$latitude), 
              info = "latitude column is not numeric in simulated_latitude_time")
})

test_that("All columns in temp dataset have the correct data types", {
  expect_true(is.numeric(simulated_temp$temp), 
              info = "temp column is not numeric in simulated_temp")
  expect_true(is.numeric(simulated_temp$flower_doy), 
              info = "flower_doy column is not numeric in simulated_temp")
})

#### Test 8: Distribution checks ####
test_that("Latitude values in latitude_time dataset are approximately uniformly distributed", {
  latitude_hist <- hist(simulated_latitude_time$latitude, plot = FALSE)
  expect_true(all(abs(diff(latitude_hist$counts)) < 10), 
              info = "Latitude values are not uniformly distributed in simulated_latitude_time")
})

test_that("Temperature values in temp dataset are approximately uniformly distributed", {
  temp_hist <- hist(simulated_temp$temp, plot = FALSE)
  expect_true(all(abs(diff(temp_hist$counts)) < 10), 
              info = "Temperature values are not uniformly distributed in simulated_temp")
})

cat("All tests completed.\n")
