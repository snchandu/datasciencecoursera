## dataselected is my subset selected from the entire data using load_data.R program
## Created from the main data
## Create a plot3  using dataselected
## Converting dates
datetime <- paste(as.Date(dataselected$Date), dataselected$Time)
dataselected$Datetime <- as.POSIXct(datetime)

## Plot 3
with(dataselected, {
  plot(Sub_metering_1~Datetime, type="l",
       ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~Datetime,col='Red')
  lines(Sub_metering_3~Datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()