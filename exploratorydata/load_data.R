## This file is for loading the large dataset.
filename <- "./household_power_consumption.txt"
datafull <- read.table(filename, header = TRUE,sep = ";", na.strings="?",
    nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
dim(datafull) # 2075259 9
datafull$Date <- as.Date(datafull$Date, format="%d/%m/%Y")
## Sub setting the data
dataselected <- subset(datafull, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))

## Remove the data full
rm(datafull)
## Converting dates
datetime <- paste(as.Date(dataselected$Date), dataselected$Time)
dataselected$datetime <- as.POSIXct(datetime)

dim(dataselected) # 2880   10

