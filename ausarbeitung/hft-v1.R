# TODOS:
#   1.

# load data
startDate <- as.numeric(Sys.time())
dataHeader <- read.csv("/hft-data.csv", sep=";", header=FALSE, nrows=1)
data <- read.csv("/hft-data.csv", sep=";", nrows=300000)
colnames(data) <- unlist(dataHeader)
endDate <- as.numeric(Sys.time())

loadingDuration <- endDate-startDate
loadingDuration

executionPriceData <- subset(data, data$EXECUTION_PRICE != "")
executionPrice <- executionPriceData$EXECUTION_PRICE
timeAsInteger <- as.numeric(executionPriceData$TS_ENTRY, format="%dd-%MM-%yyyy %hh:%mm:%ss")
PriceToTime <- data.frame(timeAsInteger, executionPrice)
# PriceToTime
# executionPrice
# timeAsInteger
yRange <- range(9.04,9.08)
medians <- c();

maxValue <- 1000
minValue <- 0

for (i in 0:59) {
  subsets <- subset(PriceToTime, PriceToTime$timeAsInteger > min(PriceToTime$timeAsInteger))
  # print(subsets)
  medianTemp <- median(subsets$executionPrice, na.rm = FALSE)
  c(medians, medianTemp)
  # print(medianTemp)
  # print(medians)
  minValue <- maxValue
  maxValue <- maxValue+1000
}

medians

timeAsInteger
plot(timeAsInteger,executionPrice$EXECUTION_PRICE, ylim = yRange, type = "o",col = "blue")
