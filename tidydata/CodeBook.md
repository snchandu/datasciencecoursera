# CodeBook

### This code book describes the data and transformations used by run_analysis.R and the variables to produce the output of Tidy.txt
## The Data Source 

* Original Data Source
* Original Description of the Data Set
* Data Set Information


## Input Data Set

'X_train.txt' contains variable features that are intended for training.
'y_train.txt' contains the activities corresponding to X_train.txt.
'subject_train.txt' contains information on the subjects from whom data is collected.
'X_test.txt' contains variable features that are intended for testing.
'y_test.txt' contains the activities corresponding to X_test.txt.
'subject_test.txt' contains information on the subjects from whom data is collected.
'activity_labels.txt' contains metadata on the different types of activities.
'features.txt' contains the name of the features in the data sets.

### Transformations

#### The following are the transformations:
'train_features' is read into table train_features
'train_activity' is read into table train_activity
'train_subject' is read into table train_subject
'test_features' is read into table test_features
'test_activity' is read into table test_activity
'test_subject' is read into table test_subject
'FeatureNames' is read into table FeatureNames
'ActivityLabels' is read into table ActivityLabels

The respective files for Train and Test are Subject, Features and Activity are merged into the corresponding 'Subject, Activity and Features' variables
The 'Subject, Activity and Features' are merged to create 'CompleteData'
Indices of columns that contain std or mean, activity and subject are taken into requiredColumns .
'extractedData' is created with data from columns in filterCols
Activity column in extractedData is updated with descriptive names of activities taken from ActivityLabels. Activity column is expressed as a factor variable.
Acronyms in variable names in extractedData, like ‘Acc’, ‘Gyro’, ‘Mag’, ’t’ and ‘f’ are replaced with descriptive labels such as ‘Accelerometer’, ‘Gyroscpoe’, ‘Magnitude’, ‘Time’ and ‘Frequency’.
tidyData is created as a set with average for each activity and subject of extractedData. Entries in tidyData are ordered based on activity and subject.
Finally, the data in tidyData is written into 'calculated_tidy_data.txt'

#### Output Data Set

The output data 'calculated_tidy_data.txt' is a space delimited value file. The header line contains the names of the variables. It contains the mean and standard deviation values of the data contained in the input files