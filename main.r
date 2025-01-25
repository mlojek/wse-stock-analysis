library('lubridate')

# read stock data from csv file
stock_data <- read.csv('stock_data.csv', header=TRUE, dec='.')

# get only values from years 2010-2018
stock_data <- stock_data[year(stock_data$TRADING_DATE) >= 2010 & year(stock_data$TRADING_DATE) <= 2018, ]

# remove unnecessary columns
stock_data$X <- NULL
stock_data$OPEN_VAL_PLN <- NULL
stock_data$LOW_VAL_PLN <- NULL
stock_data$VOLUME <- NULL
stock_data$OP_OBV <- NULL

# get list of stock ticker symbols
ticker_symbols <- unique(stock_data$INSTRUMENT)