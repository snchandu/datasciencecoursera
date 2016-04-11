# Tidy Mean and Standard Deviation Data from the UCI HAR Data Set
### The Data
#### This script uses the data from UC Irvine's Human Activity Recognition Using Smartphones Data Set. The data used is here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
More information about the data can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## The Script
#### This repository contains a script called run_analysis.R.
## Requirements
The data files should be in the working directory when you run the script.
#### The script depends on the following packages:
  * dplyr
  * data.table 

#### Read files. Must have data in working directory.
train_subject   	<- read.table("train/subject_train.txt")
train_features     <- read.table("train/X_train.txt")
train_activity     <- read.table("train/y_train.txt")
test_subject    	<- read.table("test/subject_test.txt")
test_features      <- read.table("test/X_test.txt")
test_activity      <- read.table("test/y_test.txt")
FeatureNames       <- read.table("features.txt")
ActivityLabels 	<- read.table("activity_labels.txt")
## Merge the Training and Testing data
Subject <- rbind(train_subject,test_subject)
Activity <- rbind(train_activity,test_activity)
Features <- rbind(train_features,test_features)
## Appropriately label the data set with descriptive variable names.
In the step above the column for activities was labeled as ‘Activity’
The data column from the subject_ files is labeled as ‘Subject’
The data columns from the X_ files are labeled with the descriptions from the ‘Features’ file.
## Merge the training and the test sets to create one data set.
The sets are combined with rbind.
  Subject <- rbind(train_subject,test_subject)
  Activity <- rbind(train_activity,test_activity)
  Features <- rbind(train_features,test_features)
## Name the Columns
colnames(Features) <- t(FeatureNames[2])
colnames(Activity) <- "Activity"
colnames(Subject) <- "Subject"

## Extract only the measurements on the mean and standard deviation for each measurement.
Here the script takes the "Subject" and "Activity" columns as well as columns with names containing "mean()" or "std()".
The original data has some other columns with "Mean" in their names which are angle of means but are not means themselves. These columns are not included in our final data.
This step also writes the tidy data to a file.
  colMeanStd <- grep(".*Mean.*|.*Std.*",x = names(CompleteData), ignore.case=TRUE)
  filteredCols <- c(colMeanStd,562:563)
  extractedData <- CompleteData[,filteredCols]

#### Assign Descriptive Names to the Activity Field

extractedData$Activity <- as.character(extractedData$Activity)
  for(i in 1:6) {
    extractedData$Activity[extractedData$Activity == i] <- as.character(ActivityLabels[,2])
  }
  extractedData$Activity <- as.factor(extractedData$Activity)

##	Label the Data Set with descriptive variable names
  names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
  names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
  names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
  names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
  names(extractedData)<-gsub("^t", "Time", names(extractedData))
  names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
  names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
  names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
  names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
  names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
  names(extractedData)<-gsub("angle", "Angle", names(extractedData))
  names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))


## Extract Tidy data set and write the output to a calculated_tidy_data.txt file in the working directory
 extractedData$Subject <- as.factor(extractedData$Subject)
  extractedData <- data.table(extractedData)

  tidydata <- aggregate(. ~Subject+Activity,extractedData,mean) 
  tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
  write.table(x = tidydata,file = "calculated_tidy_data.txt",row.names = FALSE)