#### Preamble ####
# Purpose: Cleans the raw sakura historical and modern data by 
 #selecting and combining columns. Create analysis data for modeling
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: raw data downloaded in 01-raw_data
# Any other information needed? None

#### Workspace setup ####
# install necessary package
install.packages("tidyr")
install.packages("dplyr")
install.packages("readr")
install.packages("lubridate")
install.packages("arrow")
install.packages("caTools")
# Load necessary package
library(tidyr)
library(dplyr)
library(readr)
library(lubridate)
library(arrow)  
library(caTools)  
#### Clean Historical Data ####
# Read the raw data
sakura_historical <- read_csv("data/01-raw_data/sakura-historical.csv")

# Step 1: Remove rows where all columns except 'year' are NA
sakura_historical <- sakura_historical %>%
  filter(!if_all(-year, is.na))

# Step 2: Combine 'temp_c_recon' and 'temp_c_obs' into a new column 'temp'
sakura_historical <- sakura_historical %>%
  mutate(temp = coalesce(temp_c_obs, temp_c_recon))

# Step 3: Drop the columns 'flower_source', 'flower_source_name', 'study_source', 'temp_c_recon', and 'temp_c_obs'
sakura_historical <- sakura_historical %>%
  select(-flower_source, -flower_source_name, -study_source, -temp_c_recon, -temp_c_obs)

# Step 4: Remove rows with any NA values
sakura_historical <- sakura_historical %>%
  drop_na()

# Create directory for cleaned data if it doesn't exist
dir.create("data/03-cleaned_data", recursive = TRUE, showWarnings = FALSE)

# Save the cleaned data as parquet
write_parquet(sakura_historical, "data/03-cleaned_data/sakura-historical-cleaned.parquet")

cat("Cleaned historical data saved to data/03-cleaned_data/sakura-historical-cleaned.parquet\n")

#### Clean Modern Data ####
# Read the raw data files
sakura_modern <- read_csv("data/01-raw_data/sakura-modern.csv")
temperatures_modern <- read_csv("data/01-raw_data/temperatures-modern.csv")

# Step 1: Extract year and month from 'flower_date' in sakura_modern
sakura_modern <- sakura_modern %>%
  mutate(flower_date = as.Date(flower_date, format = "%Y-%m-%d"),
         flower_year = year(flower_date),
         flower_month = month(flower_date))

# Step 2: Convert month names in temperatures_modern to numbers and ensure unique year, month, and station_name combinations
temperatures_modern <- temperatures_modern %>%
  mutate(month = match(month, month.abb)) %>%
  group_by(year, month, station_name) %>%
  summarize(mean_temp_c = mean(mean_temp_c, na.rm = TRUE), .groups = "drop")

# Step 3: Merge sakura_modern with temperatures_modern by flower_year, flower_month, and station_name
merged_data <- sakura_modern %>%
  left_join(temperatures_modern, by = c("flower_year" = "year", 
                                        "flower_month" = "month", 
                                        "station_name" = "station_name")) %>%
  rename(mean_temp_month = mean_temp_c)

# Step 4: Round latitude and longitude to two decimal places
merged_data <- merged_data %>%
  mutate(latitude = round(latitude, 2),
         longitude = round(longitude, 2))

# Step 5: Select only the required columns
cleaned_data <- merged_data %>%
  select(year = flower_year, flower_date, flower_doy, station_name, mean_temp_month, latitude, longitude)

# Step 6: Remove rows with any NA values
cleaned_data <- cleaned_data %>%
  drop_na()

# Create directory for cleaned data if it doesn't exist
dir.create("data/03-cleaned_data", recursive = TRUE, showWarnings = FALSE)

# Save the cleaned data as parquet
write_parquet(cleaned_data, "data/03-cleaned_data/sakura-modern-cleaned.parquet")

cat("Cleaned modern data saved to data/03-cleaned_data/sakura-modern-cleaned.parquet\n")

#### Prepare Analysis Data ####

# Read the cleaned historical data
sakura_historical <- read_parquet("data/03-cleaned_data/sakura-historical-cleaned.parquet")

# Step 1: Select only temp and flower_doy
sakura_historical_selected <- sakura_historical %>%
  select(temp, flower_doy)

# Step 2: Split into train (70%) and test (30%) datasets
set.seed(123)  # For reproducibility
split <- sample.split(sakura_historical_selected$temp, SplitRatio = 0.7)

temp_train_data <- sakura_historical_selected %>%
  filter(split == TRUE)
temp_test_data <- sakura_historical_selected %>%
  filter(split == FALSE)

# Step 3: Save train and test datasets as parquet files
write_parquet(temp_train_data, "data/02-analysis_data/temp_train_data.parquet")
write_parquet(temp_test_data, "data/02-analysis_data/temp_test_data.parquet")

cat("Saved temp_train_data.parquet and temp_test_data.parquet to data/02-analysis_data\n")


# Read the cleaned modern data
sakura_modern <- read_parquet("data/03-cleaned_data/sakura-modern-cleaned.parquet")

# Step 4: Select only flower_date, mean_temp_month, and latitude
sakura_modern_selected <- sakura_modern %>%
  select(flower_date, mean_temp_month, latitude)

# Step 5: Split into train (70%) and test (30%) datasets
set.seed(123)  # Ensure the same split is reproducible
split <- sample.split(sakura_modern_selected$flower_date, SplitRatio = 0.7)

latitude_time_train_data <- sakura_modern_selected %>%
  filter(split == TRUE)
latitude_time_test_data <- sakura_modern_selected %>%
  filter(split == FALSE)

# Step 6: Save train and test datasets as parquet files
write_parquet(latitude_time_train_data, "data/02-analysis_data/latitude&time_train_data.parquet")
write_parquet(latitude_time_test_data, "data/02-analysis_data/latitude&time_test_data.parquet")

cat("Saved latitude&time_train_data.parquet and latitude&time_test_data.parquet to data/02-analysis_data\n")
