# sql_layoffs
# Data Cleaning SQL Queries

This repository includes SQL queries used to clean data in the database. Each script handles a specific part of the cleaning process.

## Query Files

1. **01_remove_duplicates.sql**: Removes duplicate records based on email and phone number.
2. **02_handle_null_values.sql**: Handles null values by replacing them with default values or removing the records.
3. **03_format_dates.sql**: Ensures all dates are correct.
4. **04_normalize_data.sql**: Normalizes certain fields to maintain consistency across the dataset.

### Exploratory Data Analysis (EDA)
- `eda/group_analysis.sql`: SQL script for analyzing data by different groups or categories.
- `eda/correlation_analysis.sql`: SQL script to analyze correlations between different fields in the data.

## How to Use

1. Clone the repository: `C:\Users\user\OneDrive\Documents\GitHub\sql_layoffs`
2. Review each SQL file in the `cleaning/` directory.
3. Run the queries in your MySQL environment to replicate the data cleaning process.

