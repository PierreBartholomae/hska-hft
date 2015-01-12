
# load data
startDate <- as.numeric(Sys.time());
dataHeader <- read.csv("C:\\Users\\Moe\\Desktop\\BigData\\hft-data.csv", sep=";", header=FALSE, nrows=1)
data <- read.csv("C:\\Users\\Moe\\Desktop\\BigData\\hft-data.csv", sep=";", nrows=300000)
colnames(data) <- unlist(dataHeader)
endDate <- as.numeric(Sys.time())

loadingDuration <- endDate-startDate
loadingDuration
#ExecutionPrice linie
executionPriceData <- subset(data, data$EXECUTION_PRICE != "")
executionPrice <- executionPriceData$EXECUTION_PRICE
timeAsInteger <- as.numeric(executionPriceData$TS_ENTRY, format="%dd-%MM-%yyyy %hh:%mm:%ss")
PriceToTime <- data.frame(timeAsInteger, executionPrice)
yRange <- range(9.055,9.06)
medians <- c();

maxValue <- 1000
minValue <- 0
for(i in 0:59){

subsets <- subset(PriceToTime, PriceToTime$timeAsInteger > minValue & PriceToTime$timeAsInteger <= maxValue)
exPrice <- subsets$executionPrice

medianTemp <- median(exPrice)
#print(medianTemp)
medians <- c(medians, medianTemp)
#print(medians)
minValue <- maxValue
maxValue <- maxValue+1000
}
print(medians)
timeAsInteger
plot(medians, ylim = yRange, type = "o",col = "blue")


# sanitize sell and buy values
limitData <- subset(data, data$LIMIT_PRICE != "")
sells <- subset(limitData, data$SIDE == "SELL")
sellPrice <- c()
sellLength <- length(sells$SIDE)
exPrice <- sells$EXECUTION_PRICE
 
for(i in 1:sellLength)
{
 # print(exPrice[i])
	if(is.na(exPrice[i]) == TRUE){
		sellPrice <- c(sellPrice, sells$LIMIT_PRICE[i])
	}
	else {
		sellPrice <- c(sellPrice, sells$EXECUTION_PRICE[i])
	}
}
print(sellPrice)
sells["sellPrice"] <- NA
sells$sellPrice <- sellPrice

# get medians for specific time ranges
sellMedians <- c();
timeAsInteger <- as.numeric(sells$TS_ENTRY, format="%dd-%MM-%yyyy %hh:%mm:%ss")
sellPrice <- sells$sellPrice
sellTable <- data.frame(timeAsInteger, sellPrice)

maxValue <- 1000
minValue <- 0
for(i in 0:59){
  
  subsets <- subset(sellTable, sellTable$timeAsInteger > minValue & sellTable$timeAsInteger <= maxValue)
  sellPrice <- subsets$sellPrice
  medianTemp <- median(sellPrice)
  sellMedians <- c(sellMedians, medianTemp)
  minValue <- maxValue
  maxValue <- maxValue+1000
}


# BID GRAPH
buys <- subset(limitData, data$SIDE == "BUY") 
buyPrice <- c()
buyLength <- length(buys$SIDE)
exPriceBuy <- buys$EXECUTION_PRICE
 
for(i in 1:buyLength)
{
 # print(exPriceBuy[i])
	if(is.na(exPriceBuy[i]) == TRUE){
		buyPrice <- c(buyPrice, buys$LIMIT_PRICE[i])
	}
	else {
		buyPrice <- c(buyPrice, buys$EXECUTION_PRICE[i])
	}
}
print(buyPrice)
buys["buyPrice"] <- NA
buys$buyPrice <- buyPrice

# get medians for specific time ranges
buyMedians <- c();
timeAsInteger <- as.numeric(buys$TS_ENTRY, format="%dd-%MM-%yyyy %hh:%mm:%ss")
buyPrice <- buys$buyPrice
buyTable <- data.frame(timeAsInteger, buyPrice)

maxValue <- 1000
minValue <- 0
for(i in 0:59){
  
  subsets <- subset(buyTable, buyTable$timeAsInteger > minValue & buyTable$timeAsInteger <= maxValue)
  buyPrice <- subsets$buyPrice
  medianTemp <- median(buyPrice)
  buyMedians <- c(buyMedians, medianTemp)
  minValue <- maxValue
  maxValue <- maxValue+1000
}
#PRINTING
plot(sellMedians, ylim = yRange, type = "l",col = "blue")
lines(buyMedians, ylim = yRange, type = "l",col = "green")
lines(medians, ylim = yRange, type = "l",col = "red")
