#### Preamble ####
# Purpose: Complete replication of the data analysis pipeline
# Author: Shaotong Li
# Date: 11 November 2024
# Contact: maxst.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: Requires all provided scripts and necessary data files
# Any other information needed? None

install.packages("tidyverse")
library(tidyverse)

# 1. Simulate Data
source("scripts/00-simulate_data.R")
message("Data simulation complete.")

# 2. Download Data
source("scripts/02-download_data.R")
message("Data download complete.")

# 3. Clean Data
source("scripts/03-clean_data.R")
message("Data cleaning complete.")

# 4. Test Simulated Data
source("scripts/01-test_simulated_data.R")
message("Simulated data testing complete.")

# 5. Test Analysis Data
source("scripts/04-test_analysis_data.R")
message("Analysis data testing complete.")

# 6. Model Data
source("scripts/06-model_data.R")
message("Modeling data complete.")
