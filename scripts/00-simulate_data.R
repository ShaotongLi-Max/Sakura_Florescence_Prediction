#### Preamble ####
# Purpose: Simulate datasets of latitude, flowerdate and temperature in Japan.
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####

library(tidyverse)
library(lubridate)
library(arrow)

#### Simulate Data 1: Similar to latitude&time_test_data.parquet ####

# Parameters for simulation
latitude_min <- 24.34
latitude_max <- 45.42
start_day <- 1
end_day <- 31
start_month <- 1
end_month <- 5
start_year <- 1953
end_year <- 2019

# Initialize an empty tibble
sim_latitude_time <- tibble()

# Loop to generate valid rows until we reach 100
set.seed(123)
while (nrow(sim_latitude_time) < 100) {
  # Generate a batch of random latitude, day, month, and year
  batch <- tibble(
    latitude = runif(100, latitude_min, latitude_max),
    day = sample(start_day:end_day, 100, replace = TRUE),
    month = sample(start_month:end_month, 100, replace = TRUE),
    year = sample(start_year:end_year, 100, replace = TRUE)
  )
  
  # Create flower_date and filter invalid dates
  batch <- batch %>%
    mutate(flower_date = as.Date(paste(year, month, day, sep = "-"), format = "%Y-%m-%d")) %>%
    filter(!is.na(flower_date))  # Keep only valid dates
  
  # Bind valid rows to the main dataset
  sim_latitude_time <- bind_rows(sim_latitude_time, batch) %>%
    slice_head(n = 100)  # Ensure we don't exceed 100 rows
}

# Define the linear model: mean_temp_month = -15 + 0.35 * latitude - 0.12 * day + 2 * month
sim_latitude_time <- sim_latitude_time %>%
  mutate(mean_temp_month = -15 + 0.35 * latitude - 0.12 * day + 2 * month)

# Select and reorder columns to match the original file
sim_latitude_time <- sim_latitude_time %>%
  select(flower_date, mean_temp_month, latitude)

# Save as a Parquet file
write_parquet(sim_latitude_time, "data/00-simulated_data/simulated_latitude_time.parquet")

cat("Simulated latitude_time dataset saved to data/00-simulated_data/simulated_latitude_time.parquet\n")


#### Simulate Data 2: Similar to temp_test_data.parquet ####

# Parameters for simulation
temp_min <- 1.0   # Minimum temperature from provided data
temp_max <- 11.8  # Maximum temperature from provided data

# Generate 100 rows of random temp
set.seed(456)
sim_temp <- tibble(
  temp = runif(100, temp_min, temp_max)  # Random temperature
)

# Define the linear model: flower_doy = 126 - 3.5 * temp
sim_temp <- sim_temp %>%
  mutate(flower_doy = 126 - 3.5 * temp)

# Select and reorder columns to match the original file
sim_temp <- sim_temp %>%
  select(temp, flower_doy)

# Save as a Parquet file
write_parquet(sim_temp, "data/00-simulated_data/simulated_temp.parquet")

cat("Simulated temp dataset saved to data/00-simulated_data/simulated_temp.parquet\n")