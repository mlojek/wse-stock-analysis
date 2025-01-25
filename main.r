# read stock data from csv file
stock_data <- read.csv('stock_data.csv', header=TRUE, dec='.')

# remove unnecessary columns
stock_data$X <- NULL
stock_data$OPEN_VAL_PLN <- NULL
stock_data$LOW_VAL_PLN <- NULL
stock_data$VOLUME <- NULL
stock_data$OP_OBV <- NULL