## dataselected is my subset selected from the entire data using load_data.R program
## Created from the main data
## Create a plot1 Histogram using the dataselected
hist(dataselected$Global_active_power, main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

## Copy the histogram to a png file with height and width 480 pixels
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()
