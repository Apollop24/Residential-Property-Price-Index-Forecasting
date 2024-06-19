
# Residential Property Price Index Forecasting

This repository contains scripts for forecasting Residential Property Price Indexes for the eight capital cities in Australia. The data spans from 1972 to 2022 and includes various forecasting models such as Naive Forecasting, Simple Exponential Smoothing, Holt's Trend Method, and ARIMA.

## Table of Contents
1. [Introduction](#introduction)
2. [Data Source](#data-source)
3. [Attribute Information](#attribute-information)
4. [Installation](#installation)
5. [Data Preparation](#data-preparation)
6. [Forecasting Models](#forecasting-models)
7. [Model Evaluation](#model-evaluation)
8. [Conclusion](#conclusion)

## Introduction

This project aims to forecast the Residential Property Price Index for various cities in Australia using different time series models. The data used for the analysis spans from 1972 to 2022 and includes indexes for eight capital cities.

## Data Source

The data used in this project is sourced from the Australian Bureau of Statistics (ABS) and can be accessed [here](https://www.abs.gov.au/statistics/economy/price-indexes-and-inflation/residential-property-price-indexes-eight-capital-cities/mar-2021/641601.xls).

## Attribute Information

The dataset contains the following attributes:

1. **Residential Property Price Index ; Sydney**
2. **Residential Property Price Index ; Melbourne**
3. **Residential Property Price Index ; Brisbane**
4. **Residential Property Price Index ; Adelaide**
5. **Residential Property Price Index ; Perth**
6. **Residential Property Price Index ; Hobart**
7. **Residential Property Price Index ; Darwin**
8. **Residential Property Price Index ; Canberra**
9. **Residential Property Price Index ; Weighted average of eight capital cities**
10. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Sydney**
11. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Melbourne**
12. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Brisbane**
13. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Adelaide**
14. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Perth**
15. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Hobart**
16. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Darwin**
17. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Canberra**
18. **Residential Property Price Index percentage change from corresponding quarter of previous year ; Weighted average of eight capital cities**
19. **Residential Property Price Index percentage change from previous quarter ; Sydney**
20. **Residential Property Price Index percentage change from previous quarter ; Melbourne**
21. **Residential Property Price Index percentage change from previous quarter ; Brisbane**
22. **Residential Property Price Index percentage change from previous quarter ; Adelaide**
23. **Residential Property Price Index percentage change from previous quarter ; Perth**
24. **Residential Property Price Index percentage change from previous quarter ; Hobart**
25. **Residential Property Price Index percentage change from previous quarter ; Darwin**
26. **Residential Property Price Index percentage change from previous quarter ; Canberra**
27. **Residential Property Price Index percentage change from previous quarter ; Weighted average of eight capital cities**

## Installation

Ensure you have the following R packages installed:
```r
Package_Names <- c("readr", "ggplot2", "forecast", "fpp2", "TTR", "dplyr", "readxl", "caret", "Metrics")

lapply(Package_Names, require, character.only = TRUE)

# Checking if the package is already installed
for(Package_Names in Package_Names) {
  if(!require(Package_Names, character.only = TRUE)) {
    install.packages(Package_Names)
  } else {
    message(paste0(Package_Names, " is already installed"))
  }
}

# Load multiple packages using library()
for(Package_Names in Package_Names) {
  library(Package_Names, character.only = TRUE)
}
```

## Data Preparation

Load the data from the Excel file:
```r
# Reading the Data
sydney <- read_excel("C:/Users/TOO/Documents/sydney.xlsx")
glimpse(sydney)
str(sydney)
```

Partition the data into training and testing sets:
```r
# Data Partitioning
set.seed(1234)
sample <- createDataPartition(sydney$A83728383L, p=0.9, list=FALSE)
training <- sydney[sample,]
testing <- sydney[-sample,]
glimpse(training)
glimpse(testing)
```

Prepare the time series data:
```r
# Preparing the Time Series 
dat_ts <- ts(sydney[,2], start=c(2003,1), frequency=4)
```

## Forecasting Models

### Naive Forecasting Method
```r
# Naive Forecasting Method
naive_mod <- naive(dat_ts, h = 4, level=0.95)
summary(naive_mod)

testing$naive = 183.1 
mape(testing$A83728383L, testing$naive)
```

### Simple Exponential Smoothing Model
```r
# Simple Exponential Smoothing Model
se_model <- ses(dat_ts, h = 4, level=0.95)
summary(se_model)

df_fc = as.data.frame(se_model)
testing$simplexp = df_fc$`Point Forecast`
mape(testing$A83728383L, testing$simplexp)
```

### Holt's Trend Method
```r
# Holt's Trend Method
holt_model <- holt(dat_ts, h = 4, level=0.95)
summary(holt_model)

df_holt = as.data.frame(holt_model)
testing$holt = df_holt$`Point Forecast`
mape(testing$A83728383L, testing$holt)
```

### ARIMA Model
```r
# ARIMA MODEL
arima_model <- auto.arima(dat_ts)
summary(arima_model)

fore_arima = forecast::forecast(arima_model, h=4, level=0.95)
df_arima = as.data.frame(fore_arima)
testing$arima = df_arima$`Point Forecast`
mape(testing$A83728383L, testing$arima)
```

## Model Evaluation

The Mean Absolute Percentage Error (MAPE) is used to evaluate the performance of the forecasting models:
```r
# MAPE used to evaluate the performance of the forecasting models
mape <- function(actual, pred) {
  mape <- mean(abs((actual - pred)/actual)) * 100
  return(mape)
}
```

## Conclusion

This project demonstrates how to forecast Residential Property Price Index data using various time series models in R. The models evaluated include Naive Forecasting, Simple Exponential Smoothing, Holt's Trend Method, and ARIMA. The performance of each model is assessed using the MAPE metric.

