#### Preamble ####
# Purpose: Downloads and saves the data from Github.
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(readr)

#### Download data ####

# Define URLs for the raw data files on GitHub
sakura_historical_url <- "https://raw.githubusercontent.com/tacookson/data/master/sakura-flowering/sakura-historical.csv"
sakura_modern_url <- "https://raw.githubusercontent.com/tacookson/data/master/sakura-flowering/sakura-modern.csv"
temperatures_modern_url <- "https://raw.githubusercontent.com/tacookson/data/master/sakura-flowering/temperatures-modern.csv"

#### Save data ####
# Download sakura-historical.csv
sakura_historical_data <- read.csv(sakura_historical_url)
write_csv(sakura_historical_data, "data/01-raw_data/sakura-historical.csv")

# Download sakura-modern.csv
sakura_modern_data <- read.csv(sakura_modern_url)
write_csv(sakura_modern_data, "data/01-raw_data/sakura-modern.csv")

# Download temperatures-modern.csv
temperatures_modern_data <- read.csv(temperatures_modern_url)
write_csv(temperatures_modern_data, "data/01-raw_data/temperatures-modern.csv")