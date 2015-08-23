> getwd()
[1] "C:/Users/LeilaK/Documents"
> setwd("C://Users/LeilaK/Documents/Getting and Cleaning Data/UCI Har Dataset")
> getwd()
[1] "C:/Users/LeilaK/Documents/Getting and Cleaning Data/UCI Har Dataset"

> list.files()
[1] "activity_labels.txt" "features.txt"        "features_info.txt"   "README.txt"         
[5] "test"     

> install.packages("dplyr")
> install.packages("plyr")
> library(plyr)
> library(dplyr)



## PART ONE: Merges the training and the test sets to create one data set.

> activityLabels <- read.table("activity_labels.txt", header = F)
> featureNames <- read.table("features.txt")

> subjectTrain <- read.table("train/subject_train.txt", header = F)
> activityTrain <- read.table("train/y_train.txt", header = F)
> featuresTrain <- read.table("train/X_train.txt", header = F)

> subjectTest <- read.table("test/subject_test.txt", header = F)
> activityTest <- read.table("test/y_test.txt", header = F)
> featuresTest <- read.table("test/X_test.txt", header = F)

> subjectMERGE <- rbind(subjectTrain, subjectTest)
> activityMERGE <- rbind(activityTrain, activityTest)
> featuresMERGE <- rbind(featuresTrain, featuresTest)

> colnames(featuresMERGE) <- t(featureNames[2])
> colnames(activityMERGE) <- "Activity"
> colnames(subjectMERGE) <- "Subject"
> MERGEDData <- cbind(subjectMERGE, activityMERGE, featuresMERGE)
> dim(MERGEDData)
[1] 10299   563


## PART TWO: Extracts only the measurements on the mean and standard deviation for each measurement.

> MeanSDData <- grep(".*Mean.*|.*STD.*", names(MERGEDData), ignore.case=T)
> ReqCol <- c(1, 2, MeanSDData)
> EXTData <- MERGEDData[,ReqCol]
> dim(EXTData)
[1] 10299    88



## PART THREE: Uses descriptive activity names to name the activities in the data set

> EXTData$Activity <- as.character(EXTData$Activity)
> for (i in 1:6){
      EXTData$Activity[EXTData$Activity ==i] <- as.character(activityLabels[i,2])
   }
> EXTData$Activity <- as.factor(EXTData$Activity)



## PART FOUR: Appropriately labels the data set with descriptive variable names. 

> names(EXTData)<-gsub("Acc", "Accelerometer", names(EXTData))
> names(EXTData)<-gsub("Gyro", "Gyroscope", names(EXTData))
> names(EXTData)<-gsub("BodyBody", "Body", names(EXTData))
> names(EXTData)<-gsub("Mag", "Magnitude", names(EXTData))
> names(EXTData)<-gsub("^t", "Time", names(EXTData))
> names(EXTData)<-gsub("^f", "Frequency", names(EXTData))
> names(EXTData)<-gsub("tBody", "TimeBody", names(EXTData))
> names(EXTData)<-gsub("-mean()", "Mean", names(EXTData), ignore.case = T)
> names(EXTData)<-gsub("-std()", "STD", names(EXTData), ignore.case = T)
> names(EXTData)<-gsub("-freq()", "Frequency", names(EXTData), ignore.case = T)
> names(EXTData)<-gsub("angle", "Angle", names(EXTData))
> names(EXTData)<-gsub("gravity", "Gravity", names(EXTData))

> names(EXTData)



## PART FIVE: From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.

> install.packages("data.table")
> library(data.table)

> EXTData$Subject <- as.factor(EXTData$Subject)
> EXTData <- data.table(EXTData)

> TidyData <- aggregate(. ~Subject + Activity, EXTData, mean)
> TidyData <- TidyData[order(TidyData$Subject,TidyData$Activity),]
> write.table(TidyData, file = "Tidy.txt", row.names = FALSE)




