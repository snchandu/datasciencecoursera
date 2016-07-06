options(warn=-1)
library(caret)
library(randomForest)
library(Hmisc)
set.seed(1024)

## Read the data given, Train data  and evaluation data and NA strings are #DIV/0!
training_data <- read.csv("/Users/502573958/Downloads/pml-training.csv",na.strings=c("", "NA", "NULL") )
evaluation_data <- read.csv("/Users/502573958/Downloads/pml-testing.csv", na.strings=c("", "NA", "NULL") )
##head of the data
#head(training_data,2)na.strings=c("", "NA", "NULL")
#head(evaluation_data,2)
dim(training_data)
dim(evaluation_data)
## There are 160 features/variables present in the trainings set .. Remove all NA's and 
training_cor <- training_data[ , colSums(is.na(training_data)) == 0]
#head(training1)
#training3 <- training.decor[ rowSums(is.na(training.decor)) == 0, ]
dim(training_cor)
## Remove further unrelated variables to the Depdendent variable classe
undesirable_features = c('X', 'user_name', 'raw_timestamp_part_1', 'raw_timestamp_part_2', 'cvtd_timestamp', 'new_window', 'num_window')
training_corrected <- training_cor[, -which(names(training_cor) %in% undesirable_features)]
dim(training_corrected)

##  Use 
# only numeric variabls can be evaluated in this way.
corrMatrix <- cor(na.omit(training_corrected[sapply(training_corrected, is.numeric)]))
dim(corrMatrix)

# there are 52 variables.
corrDF <- expand.grid(row = 1:52, col = 1:52)
corrDF$correlation <- as.vector(corrMatrix)
levelplot(correlation ~ row+ col, corrDF)

# Remove the correlation so that we can use only independent variables
removecor = findCorrelation(corrMatrix, cutoff = .90, verbose = TRUE)
training_corrected = training_corrected[,-removecor]
dim(training_corrected)
## we got 19622 rows and 46 columns
##Split the Data in to training and testing
inTrain <- createDataPartition(y=training_corrected$classe, p=0.7, list=FALSE)
training <- training_corrected[inTrain,]
testing <- training_corrected[-inTrain,]
dim(training)
dim(testing)
## We got 13737 x 46 in Training and 5885 x 46 in Testing

##Tree Classification
install.packages(tree)
library(tree)
set.seed(12345)
tree.training <- tree(classe~., data=training)
summary(tree.training)


#Variables actually used in tree construction:
#[1] "pitch_forearm"     "magnet_belt_y"     "accel_forearm_z"   "magnet_dumbbell_y"
#[5] "roll_forearm"      "magnet_dumbbell_z" "accel_dumbbell_y"  "pitch_belt"       
#[9] "yaw_belt"          "accel_forearm_x"   "yaw_dumbbell"      "magnet_forearm_y" 
#[13] "magnet_arm_x"      "accel_dumbbell_z"  "gyros_belt_z"     
#Number of terminal nodes:  21 
#Residual mean deviance:  1.638 = 22470 / 13720 
#Misclassification error rate: 0.3181 = 4370 / 13737 

#Plot tree
plot(tree.training)
text(tree.training,pretty=0, cex =.8)

## method rpart
library(caret)
modFit <- train(classe ~ .,method="rpart",data=training)
print(modFit$finalModel)

## Error rate in Prediction using tree 
tree.pred=predict(tree.training,testing,type="class")
predMatrix = with(testing,table(tree.pred,classe))
sum(diag(predMatrix))/sum(as.vector(predMatrix)) # 67% Pred error rate 31%

### Error rate in Prediction using rpart
tree.pred=predict(modFit, testing)
predMatrix = with(testing,table(tree.pred,classe))
sum(diag(predMatrix))/sum(as.vector(predMatrix)) # error rate 49% and 31%

## Prune the Misclass
cv.training=cv.tree(tree.training,FUN=prune.misclass)
cv.training

## PLot the training 
plot(cv.training)

## Prune further
prune.training <- prune.misclass(tree.training, best=18)

## Predict using Prune data
tree.pred=predict(prune.training,testing,type="class")
predMatrix = with(testing,table(tree.pred,classe))
sum(diag(predMatrix))/sum(as.vector(predMatrix)) # 65.89 and  error rate is 31.81

## Use Random forest and Predict
require(randomForest)
set.seed(12345)
rf.training <- randomForest(classe~., data=training, ntree=100, importance=TRUE)
rf.training

##Plot the RF Training data
varImpPlot(rf.training)

## Prediction using random Forest Data
tree.pred <- predict(rf.training, testing, type="class")
predMatrix <- with(testing, table(tree.pred, classe))
sum(diag(predMatrix))/sum(as.vector(predMatrix))  ## gave 99.35% accuracy

## Conclusion
## Predict the Testing data from teh web site 
answers <- predict(rf.training, evaluation_data)
answers

## 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
## B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E

