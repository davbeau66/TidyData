# load needed libraries

library(data.table)
library(dplyr)

# Read in Test measurements, Test Subject info and Test Activity Info

X_test <- read.table("./R/Clean_Data_Project/test/X_test.txt", header=FALSE)
subject_test <- read.table("./R/Clean_Data_Project/test/subject_test_fix.txt", sep = " ", header=FALSE)
y_test <- read.table("./R/Clean_Data_Project/test/y_test.txt", header=FALSE)

# Read in Training measurements, Training Subject info and Training Activity Info

X_train <- read.table("./R/Clean_Data_Project/train/X_train.txt", header=FALSE)
subject_train <- read.table("./R/Clean_Data_Project/train/subject_train.txt", header=FALSE)
y_train <- read.table("./R/Clean_Data_Project/train/y_train.txt", header=FALSE)

# Read in file giving measurement names for each column 

features <- read.table("./R/Clean_Data_Project/features.txt", header=FALSE)

# Merge Test and Training Measurement data tables and give column names from 
#  names in features file

testData<- rbind(X_test, X_train)
colnames(testData) <- features[,2]

# Use grepl to create logicial vectors identifying columns with 
#  measurements of mean or standard deviation

mean_cols<-grepl("Mean", features[,2], ignore.case = TRUE)
std_cols<-grepl("std", features[,2], ignore.case = TRUE)
mean_std_cols <- mean_cols | std_cols

# Create new table with only columns for measurements using mean 
#  and standard deviation, then convert back to data table

testMeanStd<-subset(testData, select = mean_std_cols)

# Merge Test and Training Activity vectors and give "Activity" as column name

yData<-rbind(y_test,y_train)
colnames(yData) <- "Activity"

# Merge Test and Training Subjects vectors and give "Subject" as column name

subjectData<-rbind(subject_test,subject_train)
colnames(subjectData) <- "Subject"

# Bind Subject vector, Activity vector and Measurement Data Table into one table

testMeanStd<-data.table(subjectData, yData, testMeanStd)

# Rename Activities with names describing the Activities

testMeanStd$Activity<-gsub("1","Walking",testMeanStd$Activity)
testMeanStd$Activity<-gsub("2","Walking_Upstairs",testMeanStd$Activity)
testMeanStd$Activity<-gsub("3","Walking_Downstairs",testMeanStd$Activity)
testMeanStd$Activity<-gsub("4","Sitting",testMeanStd$Activity)
testMeanStd$Activity<-gsub("5","Standing",testMeanStd$Activity)
testMeanStd$Activity<-gsub("6","Laying",testMeanStd$Activity)

# Create new table with means for each Subject and Activity for each Measurement

meanSubjAct <- testMeanStd[, lapply(.SD,mean), by = list(Subject,Activity)]
  
# Write table to text file

write.table(meanSubjAct, file = "Mean_by_Subject_Activity.txt", row.names=FALSE)
