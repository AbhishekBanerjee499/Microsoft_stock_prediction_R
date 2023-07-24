# all used libraies loading
library(ggplot2)
library(forecast)
library(tseries)
library(rugarch)
library(rpart)

# loading dataset and convert date to datetime format
df = read.csv('Microsoft_Stock.csv')
df$Date = as.POSIXct(df$Date, format = "%m/%d/%Y %H:%M")
str(df)

# checking for missing values
sum(is.na(df))

dev.new()
ggplot(df, aes(x = Date, y = Close)) +
  geom_line() +
  ggtitle("Close Stock Price Over Time") +
  xlab("Date") +
  ylab("Close Price") + theme(plot.title = element_text(hjust = 0.5))

adf.test(df$Close, alternative = "stationary")

# Making time series stationary by log transformation
df$Close_new <- log(df$Close)

# Check if the log data is stationary
adf.test(df$Close_new, alternative = "stationary")

# normality testing
jarque.bera.test(df$Close_new)

# Use ACF and PACF plots
dev.new()
acf(df$Close_new,lag.max = 40,main='ACF of Log(close price)',col='magenta')
dev.new()
pacf(df$Close_new,main='Partial auto-correlation of Log(close price)',col='magenta')

# extracting day, month and year from date column
df$year = as.integer(format(df$Date,"%y"))
df$month = as.integer(format(df$Date,"%m"))
df$day = as.integer(format(df$Date,"%d"))

# Split Close price data into train and test sets
train <- df[df$Date < as.POSIXct("2021-02-01"), ]
test <- df[df$Date >= as.POSIXct("2021-02-01"), ]

# ARIMA model
fit_arima <- auto.arima(train$Close_new)
fcast_arima <- forecast(fit_arima, h = nrow(test))
accuracy(fcast_arima, test$Close_new)



# Decision tree model
control <- rpart.control(minsplit = 4,
                         minbucket = round(5 / 3),
                         maxdepth = 10,
                         cp = 0)
fit_tree <- rpart(Close_new ~ day + month + year + Open, data = train,control= control)
fcast_tree <- predict(fit_tree, test)
accuracy(fcast_tree, test$Close_new)


# Garch model
MSF_garch <- ugarchspec(mean.model = list(armaOrder=c(2,5)),variance.model = list(model = 'eGARCH', 
                                                                                    garchOrder = c(1, 1)),distribution = 'std')
fit_garch <- ugarchfit(spec = MSF_garch, data= train$Close_new)
garch_pred <- ugarchforecast(fit_garch, n.ahead = length(test$Close_new), data = test$Close_new)
# display accuracy with GARCH
c(garch_pred@forecast$seriesFor)
accuracy(c(garch_pred@forecast$seriesFor), test$Close_new)

dev.new()
plot(fit_garch,which='all')

# Combine train and test sets
data <- rbind(train, test)

# Add predictions to data
data$Pred_arima <- c(fitted(fit_arima), fcast_arima$mean)
data$Pred_tree <- c(predict(fit_tree, train), fcast_tree)
data$Pred_garch = c(fit_garch@fit$fitted.values,garch_pred@forecast$seriesFor)

# Plot actual and predicted Close prices
dev.new()
ggplot(data, aes(x = Date)) +
  geom_line(aes(y = exp(Close_new), color = "Actual")) +
  geom_line(aes(y = exp(Pred_arima), color = "ARIMA")) +
  geom_line(aes(y = exp(Pred_tree), color = "Decision Tree")) +
  geom_line(aes(y = exp(Pred_garch), color = "GARCH")) +
  ggtitle("Actual vs. Predicted Close Prices") +
  xlab("Date") +
  ylab("Close Price") +
  scale_color_manual(name = "Legend", values = c("Actual" = "blue", "ARIMA" = "red", "Decision Tree" = "green","GARCH" = "chocolate"))+ 
  theme(plot.title = element_text(hjust = 0.5))
