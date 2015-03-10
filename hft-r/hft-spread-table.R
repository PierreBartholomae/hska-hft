
# -------------------------------- #
# loadDataExecutionTable

loadSpreadTable <- function(dataPath) {  
  startDate <- as.numeric(Sys.time());
  
  spreadTableData <- read.csv(dataPath, sep=";", skip=1, col.names="Spreads")
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(spreadTableData)
}

# -------------------------------- #
# plot function

plotData <- function (spreadTable, mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  plot(spreadTable$Spreads, spreadTable$SellPrice, type = plotType, col = "red")
  title(main=paste("Mode:", mode), col.main="red", font.main=4)
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Paths
# modes: Full, HFT, nonHFT

getPath <- function(mode="Full") {
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\"
  
  spreadTableDataPath <- paste(dataPath, "hft-data-spreadTable", mode, ".csv", sep="")
  
  return(spreadTableDataPath)
}

# -------------------------------- #
# Main

# modes: Full, HFT, nonHFT
mode <- "HFT"
path <- getPath(mode)

spreadTableData <- loadSpreadTable(path)

plotData(spreadTableData, mode, plotType = "l")

