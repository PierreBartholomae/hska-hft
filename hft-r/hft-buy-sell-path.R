
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
# Paths
# modes: Full, HFT, nonHFT

getPaths <- function(mode="Full") {
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/data/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\data\\"
  
  dataExecutionPriceTablePath <- paste(dataPath, "hft-data-executionPriceTable", mode, ".csv", sep="")
  dataBuyTablePath <- paste(dataPath, "hft-data-buyTable", mode, ".csv", sep="")
  dataSellTablePath <- paste(dataPath, "hft-data-sellTable", mode, ".csv", sep="")
  
  paths <- c(dataExecutionPriceTablePath, dataSellTablePath, dataBuyTablePath)
  print(paths)
  
  return(paths)
}

# -------------------------------- #
# plot function

plotData <- function (executionPriceTableData, sellTableData, buyTableData, yRange = range(9.035,9.08), mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  color1 <- "#b33438"
  color2 <- "#0076e7"
  color3 <- "#31a84a"
  color4 <- "#f2811c"
  
  plot(buyTableData$ID, buyTableData$BuyPrice, ylim = yRange, xlim=range(1:500000), type=plotType, col = color2, xlab="ID", ylab="Price")
  lines(sellTableData$ID, sellTableData$SellPrice, ylim = yRange, type=plotType, col = color1)
  lines(executionPriceTableData$ID, executionPriceTableData$EXECUTION_PRICE, ylim = yRange, type=plotType, col = "Black")
  title(main=paste("Mode:", mode), col.main="red", font.main=4)
  legend("bottomleft", inset=.05, c("Ask","Execution price","Bid"), fill=c(color1,"Black",color2))
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Main

# modes: Full, HFT, nonHFT
mode <- "HFT"
paths <- getPaths(mode)

# any number. negativ value will ignore this parameter (for all rows) 
rows <- -1

executionPriceTableData <- loadDataExecutionTable(paths[1], rows)
sellTableData <- loadDataSellTable(paths[2], rows)
buyTableData <- loadDataBuyTable(paths[3], rows)

# range(9.035,9.08)
plotData(executionPriceTableData, sellTableData, buyTableData, range(9.06,9.07), mode, plotType = "s")

