## dataselected is my subset selected from the entire data using load_data.R program
## Created from the main data
## Create a plot2 using dataselected
## Plot 2
## Converting dates
datetime <- paste(as.Date(dataselected$Date), dataselected$Time)
dataselected$Datetime <- as.POSIXct(datetime)

plot(dataselected$Global_active_power~dataselected$Datetime, type="l",
     ylab="Global Active Power (kilowatts)", xlab="")
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()

