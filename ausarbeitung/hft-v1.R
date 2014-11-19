
# load data
startDate <- as.numeric(Sys.time())
dataHeader <- read.csv("/hft-data.csv", sep=";", header=FALSE, nrows=1)
data <- read.csv("/hft-data.csv", sep=";", nrows=300000)
colnames(data) <- unlist(dataHeader)
endDate <- as.numeric(Sys.time())

loadingDuration <- endDate-startDate
loadingDuration


# data$ACTIVITY_TYPE

# filters orders
loadOrders <- which(data$ACTIVITY_TYPE == "LOAD_ORDER")
addOrders <- which(data$ACTIVITY_TYPE == "ADD_ORDER")
fullOrders <- which(data$ACTIVITY_TYPE == "FULL_ORDER_EXECUTION")

#
sortedData <- data[order(data$TS_ENTRY),]
oneLineOfSortedData <- sortedData[100,]
oneLineOfSortedData

# 
plot(c(length(loadOrders), length(addOrders), length(fullOrders)))
