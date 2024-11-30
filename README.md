# Sakura Florescence Prediction

## Overview

The Sakura Florescence Prediction project aims to investigate and model the factors influencing the blooming dates of cherry blossoms across Japan. By integrating historical and modern data on temperature, location, and flowering dates, the project develops two predictive models to explore how climatic and geographical factors interact with floral phenology.The data used in this project spans a wide range of sources, including simulated, raw, cleaned, and processed data, providing a comprehensive foundation for predictive modeling of sakura bloom dynamics.

## Project Structure

### data

This directory contains all data files used in the project.

#### `00-simulated_data/`: Contains simulated data files in Parquet format.

-   `simulated_latitude_time.parquet`: Simulated data for latitude time and month average temperature.
-   `simulated_temp.parquet`: Simulated data for temperature and florescence.

#### `01-raw_data/`: Contains the raw data collected for the analysis.

-   `sakura-historical.csv`: Historical Sakura Flowering (812-2015, Kyoto only).
-   `sakura-modern.csv`: Modern Sakura Flowering (1953-2019, Japan-wide).
-   `temperatures-modern.csv`: Temperature data (1953-2019, Japan-wide).

#### `02-analysis_data/`: Contains data files prepared for model analysis, divided into training and testing sets.

-   `latitude&time_test_data.parquet`: Training datasets for model 2.
-   `latitude&time_train_data.parquet`: Testing datasets for model 2.
-   `temp_test_data.parquet`: Testing datasets for model 1.
-   `temp_train_data.parquet`: Training datasets for model 1.

#### `03-cleaned_data/`: Contains cleaned data files.

-   `sakura-historical-cleaned.parquet`: Cleaned data for Historical Sakura Flowering.
-   `sakura-modern-cleaned.parquet`: Cleaned data for Modern Sakura Flowering and Temperature data.

### models

This directory contains the trained models for predicting florescence.

-   `model1.rds`: Trained linear model for illustrating relationship between temperature and florescence.
-   `model2.rds`: Trained linear model for illustrating relationship between latitude, month, date and temperature.

### other

Contains auxiliary files and documentation.

#### `llm_usage/`: Information on model usage, LaTeX formatting, and plotting.

-   `01-Model`: Resources related to model usage.
-   `02-Latex`: LaTeX resources for document preparation.
-   `03-Plots_and_tables`: Resources for plotting and tables.

#### `sketches/`: This folder contains preliminary drafts, diagrams, or conceptual sketches related to the project.
-   `sketch.png`: Draft of plots used in paper.

### paper

This directory includes files related to the research paper.

-   `paper.pdf`: Final version of the research paper in PDF format.
-   `paper.qmd`: Quarto document source file for the paper.
-   `references.bib`: Contain all references, used together with quarto source file.

### scripts

R scripts used for data simulation, processing, model training, testing, and replication.

-   `00-simulate_data.R`: Script to simulate data for candidates.
-   `01-test_simulated_data.R`: Tests to validate the simulated data.
-   `02-download_data.R`: Script to download raw data from external sources.
-   `03-clean_data.R`: Cleans and preprocesses the raw data.
-   `04-test_analysis_data.R`: Tests to validate the processed analysis data.
-   `05-exploratory_data_analysis.qmd`: Quarto document for exploratory data analysis.
-   `06-model_data.R`: Script for model training and evaluation.
-   `07-replications.R`: Script to replicate key results in the analysis.
-   `08-packages_install.R`: Script to install all neccesary packages for scripts and paper (please run this script first).

### Project File

`Sakura_Florescence_Prediction.Rproj`: R project file for setting up the project environment.

## Statement on LLM usage

This project utilized a Language Learning Model (LLM), specifically OpenAI's ChatGPT, to assist with various tasks, including data processing, code generation, troubleshooting, and documentation writing. The LLM was used to expedite the development process by providing structured guidance, generating sample code snippets, and suggesting improvements for code efficiency and readability. The entire chat history is available in other/llm_usage.
