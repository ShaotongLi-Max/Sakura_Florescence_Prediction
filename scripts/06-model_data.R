#### Preamble ####
# Purpose: use train data to train linear models
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: analysis training data generated in 02-analysis_data
# Any other information needed? None

#### Workspace setup ####
#install necessary libraries
install.packages("tidyverse")
install.packages("arrow")
# Load necessary libraries
library(tidyverse)
library(arrow)

#### Load Data ####
# Load temp_train_data
temp_train_data <- read_parquet("data/02-analysis_data/temp_train_data.parquet")

# Load latitude&time_train_data
latitude_time_train_data <- read_parquet("data/02-analysis_data/latitude&time_train_data.parquet")

#### Model 1: Train a linear model with temp_train_data ####
# Fit a linear model: flower_doy ~ temp
model1 <- lm(flower_doy ~ temp, data = temp_train_data)

# Display summary of Model 1
cat("Model 1: Linear model for Flowering Day ~ Temperature\n")
print(summary(model1))

#### Prepare Data for Combined Model ####
# Extract month and day from flower_date
latitude_time_train_data <- latitude_time_train_data %>%
  mutate(month = factor(month(flower_date)),  # Convert month to a factor (categorical variable)
         day = day(flower_date))             # Extract the day

#### Model 2: Train a linear model with latitude_time_train_data ####
# Fit a linear model: mean_temp_month ~ day + latitude + month
model2 <- lm(mean_temp_month ~ day + latitude + month, data = latitude_time_train_data)

# Display summary of the combined model
cat("\nCombined Model: Linear model for Mean Temperature ~ Day + Latitude + Month\n")
print(summary(model2))

#### Save Models ####
# Save the models for future use
saveRDS(model1, file = "models/model1.rds")
saveRDS(model2, file = "models/model2.rds")

cat("\nModels have been saved in models directory.\n")

