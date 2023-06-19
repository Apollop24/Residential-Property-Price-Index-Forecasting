

Package_Names <- c("readr","ggplot2","forecast","fpp2","TTR","dplyr","readxl",
                   "caret","Metrics")

lapply(Package_Names,require,character.only = TRUE)
#checking if the package is already installed
# Loop over package names
for(Package_Names in Package_Names){
if(!require(Package_Names,character.only = TRUE))#checks if the package is not installed and installs it 
  {install.packages(Package_Names)}else{#if the package is already installed it notify us
  message(paste0(Package_Names,"is already installed"))}
}

# Load multiple packages using library()
for(Package_Names in Package_Names){
  library(Package_Names, character.only = TRUE)}
#Reading the Data
sydney <- read_excel("C:/Users/TOO/Documents/sydney.xlsx")
glimpse(sydney)
str(sydney)
#Data Partitioning
set.seed(1234)

sample <- createDataPartition(sydney$A83728383L,p=0.9,list=FALSE)

training<- sydney[sample,]
testing<- sydney[-sample,]
glimpse(training)
glimpse(testing)
#Preparing the Time Series 
dat_ts<- ts(sydney[,2],start=c(2003,1),frequency=4)
#MAPE used to evaluate the performance of the forecasting models. 
mape <- function(actual,pred){
  mape <- mean(abs((actual - pred)/actual))*100
  return (mape)
}
#Naive Forecasting Method
naive_mod <- naive(dat_ts, h = 4,level=0.95)
summary(naive_mod)

testing$naive =183.1 
mape(testing$A83728383L, testing$naive)

#Simple Exponential Smoothing Model
se_model <- ses(dat_ts, h =4, level=0.95)
summary(se_model)

df_fc = as.data.frame(se_model)
testing$simplexp = df_fc$`Point Forecast`
mape(testing$A83728383L, testing$simplexp) 

#Holt's Trend Method

holt_model <- holt(dat_ts, h =4, level=0.95)
summary(holt_model)

df_holt = as.data.frame(holt_model)
testing$holt = df_holt$`Point Forecast`
mape(testing$A83728383L, testing$holt) 
#ARIMA MODEL
arima_model <- auto.arima(dat_ts)
summary(arima_model)

fore_arima = forecast::forecast(arima_model, h=4, level=0.95)
df_arima = as.data.frame(fore_arima)
testing$arima = df_arima$`Point Forecast`
mape(testing$A83728383L, testing$arima)
