
# -------------------------------- #
# loadDataExecutionTable

loadDataExecutionTable <- function(dataPath, rows) {  
  startDate <- as.numeric(Sys.time());
  
  dataHeader <- read.csv(dataPath, sep=";", header=FALSE, nrows=1)
  executionPriceTableData <- read.csv(dataPath, sep=";", nrows=rows)
  colnames(executionPriceTableData) <- unlist(dataHeader)
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(executionPriceTableData)
}

# -------------------------------- #
# loadDataSellTable

loadDataSellTable <- function(dataPath, rows) {  
  startDate <- as.numeric(Sys.time());
  
  dataHeader <- read.csv(dataPath, sep=";", header=FALSE, nrows=1)
  sellTableData <- read.csv(dataPath, sep=";", nrows=rows)
  colnames(sellTableData) <- unlist(dataHeader)
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(sellTableData)
}

# -------------------------------- #
# loadDataBuyTable Function

loadDataBuyTable <- function(dataPath,rows) {
  startDate <- as.numeric(Sys.time());
  
  dataHeader <- read.csv(dataPath, sep=";", header=FALSE, nrows=1)
  buyTableData <- read.csv(dataPath, sep=";", nrows=rows)
  colnames(buyTableData) <- unlist(dataHeader)
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(buyTableData)
}

# -------------------------------- #
# plot function

plotData <- function (executionPriceTableData, sellTableData, buyTableData, yRange = range(9.035,9.08), mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  plot(sellTableData$ID, sellTableData$SellPrice, ylim = yRange, type=plotType, col = "blue", xlab="ID", ylab="Price",)
  lines(buyTableData$ID, buyTableData$BuyPrice, ylim = yRange, type=plotType, col = "red")
  lines(executionPriceTableData$ID, executionPriceTableData$EXECUTION_PRICE, ylim = yRange, type=plotType, col = "white")
  title(main=paste("Mode:", mode), col.main="red", font.main=4)
  legend("bottomleft", inset=.05, c("Buy price","Sell price","Execution price"), fill=c("blue","red","white"))
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Paths
# modes: Full, HFT, nonHFT

getPaths <- function(mode="Full") {
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\"
  
  dataExecutionPriceTablePath <- paste(dataPath, "hft-data-executionPriceTable", mode, ".csv", sep="")
  dataBuyTablePath <- paste(dataPath, "hft-data-buyTable", mode, ".csv", sep="")
  dataSellTablePath <- paste(dataPath, "hft-data-sellTable", mode, ".csv", sep="")
  
  paths <- c(dataExecutionPriceTablePath, dataSellTablePath, dataBuyTablePath)
  
  return(paths)
}

# -------------------------------- #
# Main

# modes: Full, HFT, nonHFT
mode <- "Full"
paths <- getPaths(mode)

# any number. negativ value will ignore this parameter (for all rows) 
rows <- -1

executionPriceTableData <- loadDataExecutionTable(paths[1], rows)
sellTableData <- loadDataSellTable(paths[2], rows)
buyTableData <- loadDataBuyTable(paths[3], rows)

# range(9.035,9.08)
plotData(executionPriceTableData, sellTableData, buyTableData, range(8.98,9.1), mode, plotType = "s")
