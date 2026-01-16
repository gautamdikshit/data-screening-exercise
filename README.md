# ICE Detention Facilities Data Analysis

## Project Overview
This project analyzes a dataset containing basic information about detention facilities
holding immigrants in the United States. The dataset is updated semimonthly and includes
facility names, locations, inspection dates, and average population levels (from A to D).

The primary goal of this analysis is to:
- Clean and preprocess the dataset
- Compute total population per detention facility
- Identify and visualize the **top 10 largest detention facilities by population**

---

## Files in This Repository

- `messy_ice_detention.csv`  
  Original dataset containing formatting issues, missing values, and non-standard characters.

- `exercise.R`  
  R script that performs data cleaning, transformation, and visualization.

- `clean_ice_dentention.csv`  
  Cleaned dataset exported after preprocessing.

---

## Requirements

To run this analysis, you need:

- R (version 4.0 or later recommended)
- R packages:
  - `dplyr`
  - `ggplot2`

You can install the required packages using:

```r
install.packages(c("dplyr", "ggplot2"))
