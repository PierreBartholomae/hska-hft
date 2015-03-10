
# -------------------------------- #
# loadDataExecutionTable

loadSpreadTable <- function(dataPath) {  
  startDate <- as.numeric(Sys.time());
  
  dataHeader <- read.csv(dataPath, sep=";", header=FALSE, nrows=1)
  spreadTableData <- read.csv(dataPath, sep=";")
  colnames(spreadTableData) <- unlist(dataHeader)
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(spreadTableData)
}

# -------------------------------- #
# plot function

plotData <- function (spreadTable) {  
  
  startDate <- as.numeric(Sys.time());
  
  plot(sellTableData$ID, col = "green")
  title(main=paste("Mode: SpreadTable"), col.main="red", font.main=4)
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Path

getPaths <- function() {
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\"
  
  spreadTableDataPath <- paste(dataPath, "hft-data-spreadTable.csv", sep="")
  
  return(spreadTableDataPath)
}
