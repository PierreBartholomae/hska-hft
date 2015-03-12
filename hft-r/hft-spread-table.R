
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

plotAllData <- function (spreadTableDataFull, spreadTableDataHFT, spreadTableDatanonHFT, yRange = range(0.005,0.035), mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  color1 <- "#31a84a"  
  color2 <- "#b33438"
  color3 <- "#0076e7"
  color4 <- "#f2811c"
  
  plot(spreadTableDatanonHFT$CurrentStep, spreadTableDatanonHFT$Spread,
       xlab="Summarized IDs", ylab="Spread",
       ylim = yRange, type = plotType, col = color1, bg = color1, pch=21)
  lines(spreadTableDataHFT$CurrentStep, spreadTableDataHFT$Spread,
        ylim = yRange, type = plotType, col = color2, bg = color2, pch=21)
  lines(spreadTableDataFull$CurrentStep, spreadTableDataFull$Spread,
        ylim = yRange, type = plotType, col = color3, bg = color3, pch=21)
  
  title(main=paste("Spreads - Step size:",spreadTableDataFull$CurrentStep[1], sep=" "), col.main="black", font.main=4)
  
  legend("topright", inset=.05, c("Full Data Spread","HFT Data Spread","nonHFT Data Spread"), fill=c(color1,color2,color3), bty="n")
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

plotFullData <- function (spreadTableDataFull, yRange = range(0.005,0.035), mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  color1 <- "#31a84a"  
  color2 <- "#b33438"
  color3 <- "#0076e7"
  
  plot(spreadTableDataFull$CurrentStep, spreadTableDataFull$Spread,
        xlab="Summarized IDs", ylab="Spread",
        ylim = yRange, type = plotType, col = color3, bg = color3, pch=21)
  
  title(main=paste("Spreads - Step size:",spreadTableDataFull$CurrentStep[1], sep=" "), col.main="black", font.main=4)
  
  legend("topright", inset=.05, c("Full Data Spread"), fill=c(color3), bty="n")
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

plotHFTnonHFTData <- function (spreadTableDataHFT, spreadTableDatanonHFT, yRange = range(0.005,0.035), mode, plotType = "s") {  
  
  startDate <- as.numeric(Sys.time());
  
  color1 <- "#31a84a"  
  color2 <- "#b33438"
  color3 <- "#0076e7"
  color4 <- "#f2811c"
  
  plot(spreadTableDatanonHFT$CurrentStep, spreadTableDatanonHFT$Spread,
       xlab="Summarized IDs", ylab="Spread",
       ylim = yRange, type = plotType, col = color1, bg = color1, pch=21)
  lines(spreadTableDataHFT$CurrentStep, spreadTableDataHFT$Spread,
        ylim = yRange, type = plotType, col = color2, bg = color2, pch=21)
  
  title(main=paste("Spreads - Step size:",spreadTableDataFull$CurrentStep[1], sep=" "), col.main="black", font.main=4)
  
  legend("topright", inset=.05, c("HFT Data Spread","nonHFT Data Spread"), fill=c(color1,color2), bty="n")
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# use only for when range is -1
plotAllDataBarplot <- function (spreadTableDataFull, spreadTableDataHFT, spreadTableDatanonHFT) {  
  
  startDate <- as.numeric(Sys.time());
  
  color1 <- "#b33438"
  color2 <- "#0076e7"
  color3 <- "#31a84a"
  color4 <- "#f2811c"
  
  data <- matrix(c(spreadTableDataFull[1,2], spreadTableDataHFT[1,2], spreadTableDatanonHFT[1,2]), nrow=3, ncol=1)
  
  lineHeader <- c("Full", "HFT", "Non HFT")
  
  barplot(data, main="Activity frequencies",
          col=c(color1,color2,color3),
          ylim=c(0,0.03),
          xlab="Data Source", ylab="Spread",
          beside=TRUE, space=c(0.2,0.75), xaxt="n")
  
  axis(1, at=c(1.25,2.5,3.75), label=lineHeader)
  
  labelFull <- "Full Data"
  labelHFT <- "HFT Data"
  labelnonHFT <- "Non HFT Data"
  
  legend("top", c(labelFull, labelHFT, labelnonHFT), fill=c(color1,color2,color3),
         inset=.05, bty="n")
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Paths
# modes: Full, HFT, nonHFT

getPath <- function(mode="Full", isDataRanged=TRUE) {
    
  if (isDataRanged) {
    pathExtension <- "-ranged"
  } else {
    pathExtension <- "-all"
  }
  
  dataPath <- "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/statistics/"
  #dataPath <- "C:\\Users\\Moe\\Desktop\\BigData\\statistics\\"
  
  spreadTableDataPath <- paste(dataPath, "hft-data-spreadTable", mode, pathExtension, ".csv", sep="")
  print (spreadTableDataPath)
  
  return(spreadTableDataPath)
}

# -------------------------------- #
# Main

# splitted: TRUE or FALSE
isDataRanged <- TRUE

# modes: Full, HFT, nonHFT
mode <- "Full"
path <- getPath(mode, isDataRanged)
spreadTableDataFull <- loadSpreadTable(path)

mode <- "HFT"
path <- getPath(mode, isDataRanged)
spreadTableDataHFT <- loadSpreadTable(path)

mode <- "nonHFT"
path <- getPath(mode, isDataRanged)
spreadTableDatanonHFT <- loadSpreadTable(path)

# -------------------------------- #
# Plot for step size > 0
if (isDataRanged) {
  plotAllData(spreadTableDataFull, spreadTableDataHFT, spreadTableDatanonHFT, yRange = range(0.004,0.045), mode, plotType = "o")

  #plotFullData(spreadTableDataFull, yRange = range(0.004,0.045), mode, plotType = "o")

  #plotHFTnonHFTData(spreadTableDataHFT, spreadTableDatanonHFT, yRange = range(0.004,0.045), mode, plotType = "o")
}

# -------------------------------- #
# Plot for step size == -1 (for spread over all rows)

if (!isDataRanged) {
  plotAllDataBarplot(spreadTableDataFull, spreadTableDataHFT, spreadTableDatanonHFT)
}