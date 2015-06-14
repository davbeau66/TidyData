The R program run_analysis.R uses data files taken from the 'getdata_projectfiles_UCI HAR Dataset.zip' zipfile downloaded from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The program reads in subject_test.txt, X_test.txt, y_test.txt, subject_train.txt, X_train.txt, y_train.txt and features.txt. as tables.  It then merges the data measurement files (X_test.txt and X_train.txt) to create testData and then uses the features file to name the columns.  It also merges the subject files to create subjectData and the y files which have the  activities for each measurement observation to create activityData.

It then uses the grepl command to create logical vectors indicating which measurements are means or standard deviations. By "OR"ing the vectors, a vector with the measurements wanted for the final data set are identified.  This is used to take a subset of the measurement data with the measuremetns of interest.

The program then creates a new table (testMeanStd) which adds the subjectData and activityData to testData.

The program then uses gsub to replace the activity numbers with the associated activity (i.e. 1 = "Sitting")

The program then uses lapply to find the means of each of the measuremetns for each subject and activity and then writes that file to Mean_by_Subject_Activity.txt.

A description of the measurements used in the study is given in CodeBook.md.
