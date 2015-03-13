
# -------------------------------- #
# loadDataExecutionTable

loadStandardDeviationTable <- function(dataPath) {  
  startDate <- as.numeric(Sys.time());
  
  header <- read.csv(dataPath, sep=";", header=FALSE, nrows=1, stringsAsFactors=FALSE)
  table <- read.csv(dataPath, sep=";", header=FALSE, skip=1)
  colnames(table) <- unlist(header)
  
  endDate <- as.numeric(Sys.time())
  loadingDuration <- endDate-startDate
  loadingDuration
  
  return(table)
}

# -------------------------------- #
# Paths
# modes: Full, HFT, nonHFT

getPath <- function() {
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/statistics/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\statistics\\"
  
  tableDataPath <- paste(dataPath, "hft-data-StandardDeviationTable.csv", sep="")
  print(tableDataPath)
  
  return(tableDataPath)
}

# -------------------------------- #
# plot function

plotBars <- function (standardDeviationTableData) {  
  
  startDate <- as.numeric(Sys.time());
  
  zoomFactor <- 1.25
  
  color1 <- "#b33438"
  color2 <- "#0076e7"
  color3 <- "#31a84a"
  color4 <- "#f2811c"
  
  data <- matrix(standardDeviationTableData[,2], nrow=3, ncol=3)
  
  lineHeader <- c("Execution price", "Buy side price", "Sell side price")
  
  image <- barplot(data, col=c(color1,color2,color3),
                   ylim=c(0,0.11), legend=TRUE,
                   xlab="Execution/Side", ylab="Deviation",
                   beside=TRUE, space=c(0.2,0.75),
                   xaxt="n", yaxt="n",
                   cex.lab=zoomFactor, cex.axis=zoomFactor, cex.main=zoomFactor, cex.sub=zoomFactor)
    
  axis(1, at=c(2.5,6.5,11), label=lineHeader, cex.axis=zoomFactor)
  axis(2, cex.axis=zoomFactor)
  
  labelFull <- "Full Data"
  labelHFT <- "HFT Data"
  labelnonHFT <- "Non HFT Data"
  
  legend("topright",
         c(labelFull, labelHFT, labelnonHFT),
         fill=c(color1,color2,color3),
         pt.cex=1, cex=zoomFactor, bty="n")
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Main

path <- getPath()
standardDeviationTableData <- loadStandardDeviationTable(path)
plotBars(standardDeviationTableData)
