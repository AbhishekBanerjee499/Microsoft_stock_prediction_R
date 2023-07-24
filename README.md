# Microsoft_stock_prediction_R
**Project:** Microsoft's closing stock price prediction by ARIMA, Decision Tree and GARCH models in R Studio

**Data Source:** https://www.kaggle.com/datasets/vijayvvenkitesh/microsoft-stock-time-series-analysis

**Approach**
* Three prediction models: ARIMA, Decision Tree and GARCH are used to fit and predict on Microsoft's closing stock price data from 04-01-2015 to 3/31/2021.
* The trend of stock price is visualized to identify patterns and then Stationarity check is performed with ADF test.
* The stock time series is found to be non-stationary and thus using log transformation it is made stationary.
* Jarque Bera test is used to test normality and it is found that the time series is not approximately normal.
* Train-test splitting: Data before 1st Feb 2021 is train set and rest data for approx 2 months is used as test set.
* Autocorrelation and Partial autocorrelation testing performed with ACF and PACF plots.
* ACF plot shows evidence of autocorrelation as spikes for different lags go outside of blue region i.e. stock price in the present day depends on the past days.
* PACF plot shows no evidence of partial autocorrelation as only one significant spike is observed at 0 lag and for the rest lags the spikes are within the blue region.
* ARIMA model parameters tuned automatically with auto.arima() function. Optimal hyperparameters: p = 1, d= 1 and q=0.
* Decision tree model parameters tuned manually. Optimal hyperparameters: max depth = 10, min samples required for split = 4, min bucket size = 2 and rest kept as default.
* GARCH model tuned manually. Optimal hyperparameters: variance model= 'eGARCH' with p = q = 1, mean model = 'ARMA' with p = 2, q = 5 and rest kept as default.
* All models are tuned to minimize MSE and then tuned models are evaluated in test set in terms of RMSE, MAE and MAPE.

**Performance comparison**
| Model | RMSE | MAE | MAPE(%) |
| --- | --- | --- | --- |
| **ARIMA** | 0.034 | 0.032 | 0.589 |
| **Decision Tree** | 0.029 | 0.024 | 0.438 |
| **Decision Tree** | 0.069 | 0.060 | 1.107 |

**FIndings and Recommendations**
* Microsoft stock is increasing rapidly in the period 2020-21 and a similar or even better rise is expected in the near future from the given period.
* The lowest scores of metrics in the test set are produced by the decision tree as supported by line chart of actual and predicted close prices.
* Investors at present time are recommended to invest in Microsoft stock to gain significant profit.
* To precisely monitor Microsoft stock the decision tree model can be used by investors or shareholders to gain some rough idea about the trend in the future.
* Forecasting in distant future from the last date in sample data is not recommended as even the best model, decision tree would predict significantly inaccurate prices.
