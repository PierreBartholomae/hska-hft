
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
yRange <- range(9.04,9.08)
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
buys <- subset(limitData, data$SIDE == "BUY") 
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
#  print(medianTemp)
  sellMedians <- c(sellMedians, medianTemp)
  #print(medians)
  minValue <- maxValue
  maxValue <- maxValue+1000
}
print(sellMedians)
plot(sellMedians, ylim = yRange, type = "o",col = "blue")
lines(medians, ylim = yRange, type = "o",col = "red")
