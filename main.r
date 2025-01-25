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

# list of tickers we're gonna analyze
wig_tickers <- c('BUDIMEX', 'CDPROJEKT', 'PKOBP', 'CYFRPLSAT', 'KGHM', 'PKNORLEN', 'PGE', 'PEKAO', 'ORANGEPL', 'MBANK', 'SANPL', 'KETY', 'LPP', 'PZU', 'KRUK', 'JSW', 'ALIOR', 'DINOPL')

# filter by tickers we're gonna analyze
stock_data <- stock_data[stock_data$INSTRUMENT %in% wig_tickers, ]

# sort the data frame by instrument and then by date
stock_data <- stock_data[order(stock_data$INSTRUMENT, stock_data$TRADING_DATE), ]

# add column with percentage change from day to day
stock_data$PERCENT_CHANGE <- ave(
  stock_data$CLOSE_VAL_PLN, 
  stock_data$INSTRUMENT, 
  FUN = function(x) c(NA, diff(x) / head(x, -1) * 100)
)

# save to CSV for debug purposes
write.csv(stock_data, "preprocessed_data.csv", row.names = FALSE)

# add percent rise of value for 1, 5 and 10 days ahead
stock_data <- do.call(rbind, lapply(split(stock_data, stock_data$INSTRUMENT), function(group) {
  n <- nrow(group)

  group$MAX_1_DAY_AHEAD <- sapply(1:n, function(i) max(group$CLOSE_VAL_PLN[i:min(i + 1, n)]))
  group$MAX_5_DAYS_AHEAD <- sapply(1:n, function(i) max(group$CLOSE_VAL_PLN[i:min(i + 5, n)]))
  group$MAX_10_DAYS_AHEAD <- sapply(1:n, function(i) max(group$CLOSE_VAL_PLN[i:min(i + 10, n)]))

  group$PERCENT_CHANGE_1_DAY <- (group$MAX_1_DAY_AHEAD - group$CLOSE_VAL_PLN) / group$CLOSE_VAL_PLN * 100
  group$PERCENT_CHANGE_5_DAYS <- (group$MAX_5_DAYS_AHEAD - group$CLOSE_VAL_PLN) / group$CLOSE_VAL_PLN * 100
  group$PERCENT_CHANGE_10_DAYS <- (group$MAX_10_DAYS_AHEAD - group$CLOSE_VAL_PLN) / group$CLOSE_VAL_PLN * 100
  
  return(group)
}))

# save to CSV for debug purposes
write.csv(stock_data, "preprocessed_data_rise.csv", row.names = FALSE)
