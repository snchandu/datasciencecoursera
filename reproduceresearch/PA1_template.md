# Reproducible Research: Peer Assessment 1
## Loading and preprocessing the data

```r
unzip (zipfile="activity.zip")
data <- read.csv("activity.csv")
head(data,2)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
```
## What is mean total number of steps taken per day?
Mean: 9354.23 and Median: 10395

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.2.4
```

```r
total.steps <- tapply(data$steps, data$date, FUN=sum, na.rm=TRUE)
dev.copy(png, file='frequencyeachday.png', height=480, width=480)
```

```
## quartz_off_screen 
##                 3
```

```r
hist(total.steps,main="Frequency of Steps Each Day",col="green")
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
# Calculate Mean
mean(total.steps, na.rm=TRUE)
```

```
## [1] 9354.23
```

```r
# Caluclate Median
median(total.steps, na.rm=TRUE)
```

```
## [1] 10395
```
## What is the average daily activity pattern?
On an average across all the days in the dataset, the 5-minute interval contains the maximum number of steps.



```r
library(ggplot2)
averages <- aggregate(x=list(steps=data$steps), by=list(interval=data$interval),
                      FUN=mean, na.rm=TRUE)
dev.copy(png, file="averagedailyactivitypattern.png", height=480, width=480)
```

```
## quartz_off_screen 
##                 3
```

```r
ggplot(data=averages, aes(x=interval, y=steps)) +
    geom_line() +
    xlab("5-minute interval") +
    ylab("average number of steps taken")
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
averages[which.max(averages$steps),]
```

```
##     interval    steps
## 104      835 206.1698
```
 
## Imputing missing values

```r
missing <- is.na(data$steps)
table(missing)
```

```
## missing
## FALSE  TRUE 
## 15264  2304
```

```r
fill_value <- function(steps, interval) {
    filled <- NA
    if (!is.na(steps))
        filled <- c(steps)
    else
        filled <- (averages[averages$interval==interval, "steps"])
    return(filled)
}
filled.data <- data
filled.data$steps <- mapply(fill_value, filled.data$steps, filled.data$interval)
head(filled.data$steps,2)
```

```
## [1] 1.7169811 0.3396226
```

```r
## Total Number of steps taken each Day
total.steps <- tapply(filled.data$steps, filled.data$date, FUN=sum)
dev.copy(png, file="stepcoveredeachday.png", height=480, width=480)
```

```
## quartz_off_screen 
##                 3
```

```r
qplot(total.steps, binwidth=1000, xlab="total number of steps taken each day")
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
mean(total.steps)
```

```
## [1] 10766.19
```

```r
median(total.steps)
```

```
## [1] 10766.19
```
## Are there differences in activity patterns between weekdays and weekends?
During week days the activity started at 5 AM and it was its maximum at 8 to 8:30 AM. Rest of the week day the activity is very normal till 7:30 PM. On the other hand during week end the activity starts at 7:30 AM and it was its maximum during 9 to 9:45 AM. For the rest of the week end the activity is medium since 9:45 AM to 8:30 PM, which conveys that people go for different week end activities.

```r
weekdayorweekend <- function(d) {
    day <- weekdays(d)
    if (day %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"))
        return("weekday")
    else if (day %in% c("Saturday", "Sunday"))
        return("weekend")
    else
        stop("invalid date")
}
filled.data$date <- as.Date(filled.data$date)
filled.data$day <- sapply(filled.data$date, FUN=weekdayorweekend)
head(filled.data$date,2)
```

```
## [1] "2012-10-01" "2012-10-01"
```

```r
head(filled.data$day,2)
```

```
## [1] "weekday" "weekday"
```
#Create the panel plot 

```r
avgs <- aggregate(steps ~ interval + day, data=filled.data, mean)
dev.copy(png, file="createpanelplot.png", height=480, width=480)
```

```
## quartz_off_screen 
##                 3
```

```r
ggplot(avgs, aes(interval, steps)) + geom_line() + facet_grid(day ~ .) +
    xlab("5-minute interval") + ylab("Number of steps")
dev.off()
```

```
## quartz_off_screen 
##                 2
```



