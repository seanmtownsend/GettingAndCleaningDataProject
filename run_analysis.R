#For use on Windows systems runing RStudio Version 0.99.902 and R version 3.3.0 (2016-05-03) 

#Setting the path for the data
data_path <- file.path("UCI HAR Dataset")

#Setting url path
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download file
if(!file.exists("./Data.zip")){download.file(fileUrl,destfile="./Data.zip")}

#Extract files
if(!file.exists("./UCI HAR Dataset")){unzip(zipfile="Data.zip")}

#Inporting data in to R
y_Test  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
y_Train <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)
Subject_Test  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)
Subject_Train <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)
x_Test  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
x_Train <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)
features <-  read.table(file.path(data_path, "features.txt"),head=FALSE)

#Combinding the data together
y_Test_Train <- rbind(y_Test, y_Train)
Subject_Test_Train <- rbind(Subject_Test, Subject_Train)
x_Test_Train <- rbind(x_Test, x_Train)

#Setting the names for the data
names(y_Test_Train) <- c("activity")
names(Subject_Test_Train) <- c("subject")

#Setting the feature names in to data set
names(x_Test_Train)<- features$V2

#Creating data frame
temp_data <- cbind(Subject_Test_Train, y_Test_Train)
tidy_data <- cbind(x_Test_Train, temp_data)

#Finding the location of mean and standard devation
Loc_Mean_std <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

#Subseting the data for mean and stdandard devation
select_data <- c(as.character(Loc_Mean_std), "subject", "activity")
mean_std_data <- subset(tidy_data, select=select_data)

#Getting activity names
activity_labels <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)

#Labeling the activaties
mean_std_data$activity <- factor(mean_std_data$activity, labels = activity_labels[,2])
tidy_data$activity <- factor(tidy_data$activity, labels = activity_labels[,2])

#Renaming
names(mean_std_data) <- gsub("^t", "time", names(mean_std_data))
names(mean_std_data) <- gsub("^f", "frequency", names(mean_std_data))
names(mean_std_data) <- gsub("Acc", "accelerometer", names(mean_std_data))
names(mean_std_data) <- gsub("Gyro", "gyroscope", names(mean_std_data))
names(mean_std_data) <- gsub("Mag", "magnitude", names(mean_std_data))
names(mean_std_data) <- gsub("BodyBody", "body", names(mean_std_data))
names(mean_std_data) <- gsub("\\(\\)", "", names(mean_std_data))
names(mean_std_data) <- tolower(names(mean_std_data))

names(tidy_data) <- gsub("^t", "time", names(tidy_data))
names(tidy_data) <- gsub("^f", "frequency", names(tidy_data))
names(tidy_data) <- gsub("Acc", "accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "magnitude", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "body", names(tidy_data))
names(tidy_data) <- gsub("\\(\\)", "", names(tidy_data))
names(tidy_data) <- tolower(names(tidy_data))

#Loading plyr
library(plyr);

#Consolidating data
tidy_data_mean <- aggregate(. ~subject + activity, mean_std_data, mean)
tidy_data_mean<- tidy_data_mean[order(tidy_data_mean$subject, tidy_data_mean$activity),]

#Exporting data to disk
write.table(tidy_data, file = "all_tidy_data.txt",row.name=FALSE)
write.table(mean_std_data, file = "tidy_data_for_mean_standard_devation.txt",row.name=FALSE)
write.table(tidy_data_mean, file = "tidy_data_for_avrage.txt",row.name=FALSE)
