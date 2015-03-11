
# -------------------------------- #
# loadDataExecutionTable

loadTable <- function(dataPath) {  
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
  
  tableDataPath <- paste(dataPath, "hft-data-activityTable.csv", sep="")
  
  print(tableDataPath)
  
  return(tableDataPath)
}

# -------------------------------- #
# plot function

plotData <- function (tableData) {  
  
  startDate <- as.numeric(Sys.time());
  
  color1 <- "#b33438"
  color2 <- "#0076e7"
  color3 <- "#31a84a"
  color4 <- "#f2811c"
  
  lineAddOrder <- c(tableData[1,3],tableData[2,3],tableData[3,3],tableData[4,3])
  lineModifyOrder <- c(tableData[1,5],tableData[2,5],tableData[3,5],tableData[4,5])
  lineDeleteOrder <- c(tableData[1,4],tableData[2,4],tableData[3,4],tableData[4,4])
  lineFullOrderExecution <- c(tableData[1,6],tableData[2,6],tableData[3,6],tableData[4,6])
  
  data <- matrix(c(lineAddOrder, lineModifyOrder, lineDeleteOrder, lineFullOrderExecution), nrow=4, ncol=4)
  
  lineHeader <- c("Add Order", "Modify Order", "Delete Order", "Full Order Execution")
    
  barplot(data, main="Activity frequencies",
          col=c(color1,color2,color3,color4),
          xlab="Activity types", ylab="Frequency",
          beside=TRUE, space=c(0.2,0.75), xaxt="n")
  
  axis(1, at=c(3, 8.5, 14, 19), label=lineHeader)
  
  label1 <- paste("HFT:", tableData[1,1], "- Side:", tableData[1,2], sep=" ")
  label2 <- paste("HFT:", tableData[2,1], "- Side:", tableData[2,2], sep=" ")
  label3 <- paste("HFT:", tableData[3,1], "- Side:", tableData[3,2], sep=" ")
  label4 <- paste("HFT:", tableData[4,1], "- Side:", tableData[4,2], sep=" ")
  
  legend("topright", c(label1, label2, label3, label4), fill=c(color1,color2,color3,color4),
         inset=.05, bty="n")
  
  endDate <- as.numeric(Sys.time())
  plottingDuration <- endDate-startDate
  plottingDuration
}

# -------------------------------- #
# Main

path <- getPath()
tableData <- loadTable(path)
plotData(tableData)