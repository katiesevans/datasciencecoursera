# Programming Assignment: Getting and Cleaning Data

setwd("~/Documents/Work/datasciencecoursera/Getting_Cleaning_Data/UCI HAR Dataset/")
library(data.table)
library(dplyr)

#Load training text files
subject_train <- fread("train/subject_train.txt")
xtrain <- fread("train/X_train.txt")
ytrain <- fread("train/Y_train.txt")

#Load test text files
subject_test <- fread("test/subject_test.txt")
xtest <- fread("test/X_test.txt")
ytest <- fread("test/Y_test.txt")

#Load features and activity
features <- fread("features.txt")
activity <- fread("activity_labels.txt")

#Combine subject data
x <- rbind(xtest, xtrain)
y <- rbind(ytest, ytrain)

#rename variables
names(x) <- features$V2
subject <- rbind(subject_test, subject_train)
names(subject) <- "subject"

#Add activity labels to y
y_activity <- left_join(y, activity)

#Add subject number to x and y data
y_subjects <- cbind(subject, y_activity) %>%
  dplyr::select(subject, activity = V2)

#Combine all data to one dataset
complete_df <- cbind(y_subjects, x)

### Extract only measurements on mean and sd for each measurement ###
features_wanted <- features[grep("mean|std", features$V2),]
non_duplicated_data <- complete_df %>% subset(., select=which(!duplicated(names(.)))) 
meanstd <- non_duplicated_data %>%
  select(subject, activity, one_of(features_wanted$V2))

# Create new dataframe with average of each variable for each activity and subject
average_df <- meanstd %>%
  dplyr::group_by(subject, activity) %>%
  dplyr::summarise_all(funs(mean))

