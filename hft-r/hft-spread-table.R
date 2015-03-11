
# -------------------------------- #
# loadDataExecutionTable

loadSpreadTable <- function(dataPath) {  
  startDate <- as.numeric(Sys.time());
  
  dataHeader <- read.csv(dataPath, sep=";", header=FALSE, nrows=1)
  spreadTableData <- read.csv(dataPath, sep=";", skip=1, header=FALSE)
  colnames(spreadTableData) <- unlist(dataHeader)
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(spreadTableData)
}

# -------------------------------- #
# plot function

plotData <- function (spreadTableDataFull, spreadTableDataHFT, spreadTableDatanonHFT, yRange = range(0.005,0.035), mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  plot(spreadTableDataFull$Spreads, ylim = yRange, type = plotType, col = "#b33438", bg = "#b33438", pch=21)
  lines(spreadTableDataHFT$Spreads, ylim = yRange, type = plotType, col = "#0076e7", bg = "#0076e7", pch=21)
  lines(spreadTableDatanonHFT$Spreads, ylim = yRange, type = plotType, col = "#31a84a", bg = "#31a84a", pch=21)
  title(main="Spreads", col.main="red", font.main=4)
  legend("topright", inset=.05, c("Full Data Spread","HFT Data Spread","nonHFT Data Spread"), fill=c("#b33438","#0076e7","#31a84a"))
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Paths
# modes: Full, HFT, nonHFT

getPath <- function(mode="Full") {
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/statistics/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\statistics\\"
  
  spreadTableDataPath <- paste(dataPath, "hft-data-spreadTable", mode, ".csv", sep="")
  
  return(spreadTableDataPath)
}

# -------------------------------- #
# Main

# modes: Full, HFT, nonHFT
mode <- "Full"
path <- getPath(mode)
spreadTableDataFull <- loadSpreadTable(path)

mode <- "HFT"
path <- getPath(mode)
spreadTableDataHFT <- loadSpreadTable(path)

mode <- "nonHFT"
path <- getPath(mode)
spreadTableDatanonHFT <- loadSpreadTable(path)

plotData(spreadTableDataFull, spreadTableDataHFT, spreadTableDatanonHFT, yRange = range(0.005,0.035), mode, plotType = "p")

