---
title: "Getting and Cleaning Data Course Project"
author: "Sean Townsend"
date: "September 4, 2016"
output: html_document
---
#General information
For use on Windows systems runing RStudio Version 0.99.902 and R version 3.3.0 (2016-05-03) 

Scorce of the data (acessed on 9/4/2016): 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Informaion form the orginization that collected the data:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Tasks that where done:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Script file:
run_analysis.R

Files that where created:
all_tidy_data.txt
tidy_data_for_mean_standard_devation.txt
tidy_data_for_avrage.txt

requiered packages:
plyr

#Intent

The intent for this project was to consalidate the data in multiple locations in to one data set. To make the data sets tidy and with clear discripteve names.

#Process

Running the file run_analysis.R, will download the scroce file, unzip file, load data, combined the data, orginize the data, rename data varibles, and export data to disk. 

The code run is as fallows:

1. Geting data and unziping the data
```

#Setting url path
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download file
if(!file.exists("./Data.zip")){download.file(fileUrl,destfile="./Data.zip")}

#Extract files
if(!file.exists("./UCI HAR Dataset")){unzip(zipfile="Data.zip")}
```
2. Setting data path

```
data_path <- file.path("UCI HAR Dataset")
```
3. Reading data into R from files that where extracted

```
y_Test  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
y_Train <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)
Subject_Test  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)
Subject_Train <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)
x_Test  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
x_Train <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)
features <-  read.table(file.path(data_path, "features.txt"),head=FALSE)
```
4. Combinding the test and train data

```
y_Test_Train <- rbind(y_Test, y_Train)
Subject_Test_Train <- rbind(Subject_Test, Subject_Train)
x_Test_Train <- rbind(x_Test, x_Train)
```
5. Setting the names for the data

```
names(y_Test_Train) <- c("activity")
names(Subject_Test_Train) <- c("subject")
```
6. Setting the feature names in to data set

```
names(x_Test_Train)<- features$V2
```
7. Creating data frame

```
temp_data <- cbind(Subject_Test_Train, y_Test_Train)
tidy_data <- cbind(x_Test_Train, temp_data)
```
8.Finding the location of mean and standard devation

````
Loc_Mean_std <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
```
9. Subseting the data for mean and stdandard devation

```
select_data <- c(as.character(Loc_Mean_std), "subject", "activity")
mean_std_data <- subset(tidy_data, select=select_data)
```
10.Getting activity names

```
activity_labels <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)
```
11. Labeling the activaties

```
mean_std_data$activity <- factor(mean_std_data$activity, labels = activity_labels[,2])
tidy_data$activity <- factor(tidy_data$activity, labels = activity_labels[,2])
```
12. Renaming Varibles

```
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
```

13. Consolidating data
```
tidy_data_mean <- aggregate(. ~subject + activity, mean_std_data, mean)
tidy_data_mean<- tidy_data_mean[order(tidy_data_mean$subject, tidy_data_mean$activity),]
```
14.Exporting data to disk

```
write.table(tidy_data, file = "all_tidy_data.txt",row.name=FALSE)
write.table(mean_std_data, file = "tidy_data_for_mean_standard_devation.txt",row.name=FALSE)
write.table(tidy_data_mean, file = "tidy_data_for_avrage.txt",row.name=FALSE)
```

#Information in data
##Readme.txt in data set
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - UniversitÓ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

##features_info.txt in data set

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

##Puropse
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 


#List of varibles in each file

##Varibles in all_tidy_data.txt

  [1] "timebodyaccelerometer-mean-x"                    
  [2] "timebodyaccelerometer-mean-y"                    
  [3] "timebodyaccelerometer-mean-z"                    
  [4] "timebodyaccelerometer-std-x"                     
  [5] "timebodyaccelerometer-std-y"                     
  [6] "timebodyaccelerometer-std-z"                     
  [7] "timebodyaccelerometer-mad-x"                     
  [8] "timebodyaccelerometer-mad-y"                     
  [9] "timebodyaccelerometer-mad-z"                     
 [10] "timebodyaccelerometer-max-x"                     
 [11] "timebodyaccelerometer-max-y"                     
 [12] "timebodyaccelerometer-max-z"                     
 [13] "timebodyaccelerometer-min-x"                     
 [14] "timebodyaccelerometer-min-y"                     
 [15] "timebodyaccelerometer-min-z"                     
 [16] "timebodyaccelerometer-sma"                       
 [17] "timebodyaccelerometer-energy-x"                  
 [18] "timebodyaccelerometer-energy-y"                  
 [19] "timebodyaccelerometer-energy-z"                  
 [20] "timebodyaccelerometer-iqr-x"                     
 [21] "timebodyaccelerometer-iqr-y"                     
 [22] "timebodyaccelerometer-iqr-z"                     
 [23] "timebodyaccelerometer-entropy-x"                 
 [24] "timebodyaccelerometer-entropy-y"                 
 [25] "timebodyaccelerometer-entropy-z"                 
 [26] "timebodyaccelerometer-arcoeff-x,1"               
 [27] "timebodyaccelerometer-arcoeff-x,2"               
 [28] "timebodyaccelerometer-arcoeff-x,3"               
 [29] "timebodyaccelerometer-arcoeff-x,4"               
 [30] "timebodyaccelerometer-arcoeff-y,1"               
 [31] "timebodyaccelerometer-arcoeff-y,2"               
 [32] "timebodyaccelerometer-arcoeff-y,3"               
 [33] "timebodyaccelerometer-arcoeff-y,4"               
 [34] "timebodyaccelerometer-arcoeff-z,1"               
 [35] "timebodyaccelerometer-arcoeff-z,2"               
 [36] "timebodyaccelerometer-arcoeff-z,3"               
 [37] "timebodyaccelerometer-arcoeff-z,4"               
 [38] "timebodyaccelerometer-correlation-x,y"           
 [39] "timebodyaccelerometer-correlation-x,z"           
 [40] "timebodyaccelerometer-correlation-y,z"           
 [41] "timegravityaccelerometer-mean-x"                 
 [42] "timegravityaccelerometer-mean-y"                 
 [43] "timegravityaccelerometer-mean-z"                 
 [44] "timegravityaccelerometer-std-x"                  
 [45] "timegravityaccelerometer-std-y"                  
 [46] "timegravityaccelerometer-std-z"                  
 [47] "timegravityaccelerometer-mad-x"                  
 [48] "timegravityaccelerometer-mad-y"                  
 [49] "timegravityaccelerometer-mad-z"                  
 [50] "timegravityaccelerometer-max-x"                  
 [51] "timegravityaccelerometer-max-y"                  
 [52] "timegravityaccelerometer-max-z"                  
 [53] "timegravityaccelerometer-min-x"                  
 [54] "timegravityaccelerometer-min-y"                  
 [55] "timegravityaccelerometer-min-z"                  
 [56] "timegravityaccelerometer-sma"                    
 [57] "timegravityaccelerometer-energy-x"               
 [58] "timegravityaccelerometer-energy-y"               
 [59] "timegravityaccelerometer-energy-z"               
 [60] "timegravityaccelerometer-iqr-x"                  
 [61] "timegravityaccelerometer-iqr-y"                  
 [62] "timegravityaccelerometer-iqr-z"                  
 [63] "timegravityaccelerometer-entropy-x"              
 [64] "timegravityaccelerometer-entropy-y"              
 [65] "timegravityaccelerometer-entropy-z"              
 [66] "timegravityaccelerometer-arcoeff-x,1"            
 [67] "timegravityaccelerometer-arcoeff-x,2"            
 [68] "timegravityaccelerometer-arcoeff-x,3"            
 [69] "timegravityaccelerometer-arcoeff-x,4"            
 [70] "timegravityaccelerometer-arcoeff-y,1"            
 [71] "timegravityaccelerometer-arcoeff-y,2"            
 [72] "timegravityaccelerometer-arcoeff-y,3"            
 [73] "timegravityaccelerometer-arcoeff-y,4"            
 [74] "timegravityaccelerometer-arcoeff-z,1"            
 [75] "timegravityaccelerometer-arcoeff-z,2"            
 [76] "timegravityaccelerometer-arcoeff-z,3"            
 [77] "timegravityaccelerometer-arcoeff-z,4"            
 [78] "timegravityaccelerometer-correlation-x,y"        
 [79] "timegravityaccelerometer-correlation-x,z"        
 [80] "timegravityaccelerometer-correlation-y,z"        
 [81] "timebodyaccelerometerjerk-mean-x"                
 [82] "timebodyaccelerometerjerk-mean-y"                
 [83] "timebodyaccelerometerjerk-mean-z"                
 [84] "timebodyaccelerometerjerk-std-x"                 
 [85] "timebodyaccelerometerjerk-std-y"                 
 [86] "timebodyaccelerometerjerk-std-z"                 
 [87] "timebodyaccelerometerjerk-mad-x"                 
 [88] "timebodyaccelerometerjerk-mad-y"                 
 [89] "timebodyaccelerometerjerk-mad-z"                 
 [90] "timebodyaccelerometerjerk-max-x"                 
 [91] "timebodyaccelerometerjerk-max-y"                 
 [92] "timebodyaccelerometerjerk-max-z"                 
 [93] "timebodyaccelerometerjerk-min-x"                 
 [94] "timebodyaccelerometerjerk-min-y"                 
 [95] "timebodyaccelerometerjerk-min-z"                 
 [96] "timebodyaccelerometerjerk-sma"                   
 [97] "timebodyaccelerometerjerk-energy-x"              
 [98] "timebodyaccelerometerjerk-energy-y"              
 [99] "timebodyaccelerometerjerk-energy-z"              
[100] "timebodyaccelerometerjerk-iqr-x"                 
[101] "timebodyaccelerometerjerk-iqr-y"                 
[102] "timebodyaccelerometerjerk-iqr-z"                 
[103] "timebodyaccelerometerjerk-entropy-x"             
[104] "timebodyaccelerometerjerk-entropy-y"             
[105] "timebodyaccelerometerjerk-entropy-z"             
[106] "timebodyaccelerometerjerk-arcoeff-x,1"           
[107] "timebodyaccelerometerjerk-arcoeff-x,2"           
[108] "timebodyaccelerometerjerk-arcoeff-x,3"           
[109] "timebodyaccelerometerjerk-arcoeff-x,4"           
[110] "timebodyaccelerometerjerk-arcoeff-y,1"           
[111] "timebodyaccelerometerjerk-arcoeff-y,2"           
[112] "timebodyaccelerometerjerk-arcoeff-y,3"           
[113] "timebodyaccelerometerjerk-arcoeff-y,4"           
[114] "timebodyaccelerometerjerk-arcoeff-z,1"           
[115] "timebodyaccelerometerjerk-arcoeff-z,2"           
[116] "timebodyaccelerometerjerk-arcoeff-z,3"           
[117] "timebodyaccelerometerjerk-arcoeff-z,4"           
[118] "timebodyaccelerometerjerk-correlation-x,y"       
[119] "timebodyaccelerometerjerk-correlation-x,z"       
[120] "timebodyaccelerometerjerk-correlation-y,z"       
[121] "timebodygyroscope-mean-x"                        
[122] "timebodygyroscope-mean-y"                        
[123] "timebodygyroscope-mean-z"                        
[124] "timebodygyroscope-std-x"                         
[125] "timebodygyroscope-std-y"                         
[126] "timebodygyroscope-std-z"                         
[127] "timebodygyroscope-mad-x"                         
[128] "timebodygyroscope-mad-y"                         
[129] "timebodygyroscope-mad-z"                         
[130] "timebodygyroscope-max-x"                         
[131] "timebodygyroscope-max-y"                         
[132] "timebodygyroscope-max-z"                         
[133] "timebodygyroscope-min-x"                         
[134] "timebodygyroscope-min-y"                         
[135] "timebodygyroscope-min-z"                         
[136] "timebodygyroscope-sma"                           
[137] "timebodygyroscope-energy-x"                      
[138] "timebodygyroscope-energy-y"                      
[139] "timebodygyroscope-energy-z"                      
[140] "timebodygyroscope-iqr-x"                         
[141] "timebodygyroscope-iqr-y"                         
[142] "timebodygyroscope-iqr-z"                         
[143] "timebodygyroscope-entropy-x"                     
[144] "timebodygyroscope-entropy-y"                     
[145] "timebodygyroscope-entropy-z"                     
[146] "timebodygyroscope-arcoeff-x,1"                   
[147] "timebodygyroscope-arcoeff-x,2"                   
[148] "timebodygyroscope-arcoeff-x,3"                   
[149] "timebodygyroscope-arcoeff-x,4"                   
[150] "timebodygyroscope-arcoeff-y,1"                   
[151] "timebodygyroscope-arcoeff-y,2"                   
[152] "timebodygyroscope-arcoeff-y,3"                   
[153] "timebodygyroscope-arcoeff-y,4"                   
[154] "timebodygyroscope-arcoeff-z,1"                   
[155] "timebodygyroscope-arcoeff-z,2"                   
[156] "timebodygyroscope-arcoeff-z,3"                   
[157] "timebodygyroscope-arcoeff-z,4"                   
[158] "timebodygyroscope-correlation-x,y"               
[159] "timebodygyroscope-correlation-x,z"               
[160] "timebodygyroscope-correlation-y,z"               
[161] "timebodygyroscopejerk-mean-x"                    
[162] "timebodygyroscopejerk-mean-y"                    
[163] "timebodygyroscopejerk-mean-z"                    
[164] "timebodygyroscopejerk-std-x"                     
[165] "timebodygyroscopejerk-std-y"                     
[166] "timebodygyroscopejerk-std-z"                     
[167] "timebodygyroscopejerk-mad-x"                     
[168] "timebodygyroscopejerk-mad-y"                     
[169] "timebodygyroscopejerk-mad-z"                     
[170] "timebodygyroscopejerk-max-x"                     
[171] "timebodygyroscopejerk-max-y"                     
[172] "timebodygyroscopejerk-max-z"                     
[173] "timebodygyroscopejerk-min-x"                     
[174] "timebodygyroscopejerk-min-y"                     
[175] "timebodygyroscopejerk-min-z"                     
[176] "timebodygyroscopejerk-sma"                       
[177] "timebodygyroscopejerk-energy-x"                  
[178] "timebodygyroscopejerk-energy-y"                  
[179] "timebodygyroscopejerk-energy-z"                  
[180] "timebodygyroscopejerk-iqr-x"                     
[181] "timebodygyroscopejerk-iqr-y"                     
[182] "timebodygyroscopejerk-iqr-z"                     
[183] "timebodygyroscopejerk-entropy-x"                 
[184] "timebodygyroscopejerk-entropy-y"                 
[185] "timebodygyroscopejerk-entropy-z"                 
[186] "timebodygyroscopejerk-arcoeff-x,1"               
[187] "timebodygyroscopejerk-arcoeff-x,2"               
[188] "timebodygyroscopejerk-arcoeff-x,3"               
[189] "timebodygyroscopejerk-arcoeff-x,4"               
[190] "timebodygyroscopejerk-arcoeff-y,1"               
[191] "timebodygyroscopejerk-arcoeff-y,2"               
[192] "timebodygyroscopejerk-arcoeff-y,3"               
[193] "timebodygyroscopejerk-arcoeff-y,4"               
[194] "timebodygyroscopejerk-arcoeff-z,1"               
[195] "timebodygyroscopejerk-arcoeff-z,2"               
[196] "timebodygyroscopejerk-arcoeff-z,3"               
[197] "timebodygyroscopejerk-arcoeff-z,4"               
[198] "timebodygyroscopejerk-correlation-x,y"           
[199] "timebodygyroscopejerk-correlation-x,z"           
[200] "timebodygyroscopejerk-correlation-y,z"           
[201] "timebodyaccelerometermagnitude-mean"             
[202] "timebodyaccelerometermagnitude-std"              
[203] "timebodyaccelerometermagnitude-mad"              
[204] "timebodyaccelerometermagnitude-max"              
[205] "timebodyaccelerometermagnitude-min"              
[206] "timebodyaccelerometermagnitude-sma"              
[207] "timebodyaccelerometermagnitude-energy"           
[208] "timebodyaccelerometermagnitude-iqr"              
[209] "timebodyaccelerometermagnitude-entropy"          
[210] "timebodyaccelerometermagnitude-arcoeff1"         
[211] "timebodyaccelerometermagnitude-arcoeff2"         
[212] "timebodyaccelerometermagnitude-arcoeff3"         
[213] "timebodyaccelerometermagnitude-arcoeff4"         
[214] "timegravityaccelerometermagnitude-mean"          
[215] "timegravityaccelerometermagnitude-std"           
[216] "timegravityaccelerometermagnitude-mad"           
[217] "timegravityaccelerometermagnitude-max"           
[218] "timegravityaccelerometermagnitude-min"           
[219] "timegravityaccelerometermagnitude-sma"           
[220] "timegravityaccelerometermagnitude-energy"        
[221] "timegravityaccelerometermagnitude-iqr"           
[222] "timegravityaccelerometermagnitude-entropy"       
[223] "timegravityaccelerometermagnitude-arcoeff1"      
[224] "timegravityaccelerometermagnitude-arcoeff2"      
[225] "timegravityaccelerometermagnitude-arcoeff3"      
[226] "timegravityaccelerometermagnitude-arcoeff4"      
[227] "timebodyaccelerometerjerkmagnitude-mean"         
[228] "timebodyaccelerometerjerkmagnitude-std"          
[229] "timebodyaccelerometerjerkmagnitude-mad"          
[230] "timebodyaccelerometerjerkmagnitude-max"          
[231] "timebodyaccelerometerjerkmagnitude-min"          
[232] "timebodyaccelerometerjerkmagnitude-sma"          
[233] "timebodyaccelerometerjerkmagnitude-energy"       
[234] "timebodyaccelerometerjerkmagnitude-iqr"          
[235] "timebodyaccelerometerjerkmagnitude-entropy"      
[236] "timebodyaccelerometerjerkmagnitude-arcoeff1"     
[237] "timebodyaccelerometerjerkmagnitude-arcoeff2"     
[238] "timebodyaccelerometerjerkmagnitude-arcoeff3"     
[239] "timebodyaccelerometerjerkmagnitude-arcoeff4"     
[240] "timebodygyroscopemagnitude-mean"                 
[241] "timebodygyroscopemagnitude-std"                  
[242] "timebodygyroscopemagnitude-mad"                  
[243] "timebodygyroscopemagnitude-max"                  
[244] "timebodygyroscopemagnitude-min"                  
[245] "timebodygyroscopemagnitude-sma"                  
[246] "timebodygyroscopemagnitude-energy"               
[247] "timebodygyroscopemagnitude-iqr"                  
[248] "timebodygyroscopemagnitude-entropy"              
[249] "timebodygyroscopemagnitude-arcoeff1"             
[250] "timebodygyroscopemagnitude-arcoeff2"             
[251] "timebodygyroscopemagnitude-arcoeff3"             
[252] "timebodygyroscopemagnitude-arcoeff4"             
[253] "timebodygyroscopejerkmagnitude-mean"             
[254] "timebodygyroscopejerkmagnitude-std"              
[255] "timebodygyroscopejerkmagnitude-mad"              
[256] "timebodygyroscopejerkmagnitude-max"              
[257] "timebodygyroscopejerkmagnitude-min"              
[258] "timebodygyroscopejerkmagnitude-sma"              
[259] "timebodygyroscopejerkmagnitude-energy"           
[260] "timebodygyroscopejerkmagnitude-iqr"              
[261] "timebodygyroscopejerkmagnitude-entropy"          
[262] "timebodygyroscopejerkmagnitude-arcoeff1"         
[263] "timebodygyroscopejerkmagnitude-arcoeff2"         
[264] "timebodygyroscopejerkmagnitude-arcoeff3"         
[265] "timebodygyroscopejerkmagnitude-arcoeff4"         
[266] "frequencybodyaccelerometer-mean-x"               
[267] "frequencybodyaccelerometer-mean-y"               
[268] "frequencybodyaccelerometer-mean-z"               
[269] "frequencybodyaccelerometer-std-x"                
[270] "frequencybodyaccelerometer-std-y"                
[271] "frequencybodyaccelerometer-std-z"                
[272] "frequencybodyaccelerometer-mad-x"                
[273] "frequencybodyaccelerometer-mad-y"                
[274] "frequencybodyaccelerometer-mad-z"                
[275] "frequencybodyaccelerometer-max-x"                
[276] "frequencybodyaccelerometer-max-y"                
[277] "frequencybodyaccelerometer-max-z"                
[278] "frequencybodyaccelerometer-min-x"                
[279] "frequencybodyaccelerometer-min-y"                
[280] "frequencybodyaccelerometer-min-z"                
[281] "frequencybodyaccelerometer-sma"                  
[282] "frequencybodyaccelerometer-energy-x"             
[283] "frequencybodyaccelerometer-energy-y"             
[284] "frequencybodyaccelerometer-energy-z"             
[285] "frequencybodyaccelerometer-iqr-x"                
[286] "frequencybodyaccelerometer-iqr-y"                
[287] "frequencybodyaccelerometer-iqr-z"                
[288] "frequencybodyaccelerometer-entropy-x"            
[289] "frequencybodyaccelerometer-entropy-y"            
[290] "frequencybodyaccelerometer-entropy-z"            
[291] "frequencybodyaccelerometer-maxinds-x"            
[292] "frequencybodyaccelerometer-maxinds-y"            
[293] "frequencybodyaccelerometer-maxinds-z"            
[294] "frequencybodyaccelerometer-meanfreq-x"           
[295] "frequencybodyaccelerometer-meanfreq-y"           
[296] "frequencybodyaccelerometer-meanfreq-z"           
[297] "frequencybodyaccelerometer-skewness-x"           
[298] "frequencybodyaccelerometer-kurtosis-x"           
[299] "frequencybodyaccelerometer-skewness-y"           
[300] "frequencybodyaccelerometer-kurtosis-y"           
[301] "frequencybodyaccelerometer-skewness-z"           
[302] "frequencybodyaccelerometer-kurtosis-z"           
[303] "frequencybodyaccelerometer-bandsenergy-1,8"      
[304] "frequencybodyaccelerometer-bandsenergy-9,16"     
[305] "frequencybodyaccelerometer-bandsenergy-17,24"    
[306] "frequencybodyaccelerometer-bandsenergy-25,32"    
[307] "frequencybodyaccelerometer-bandsenergy-33,40"    
[308] "frequencybodyaccelerometer-bandsenergy-41,48"    
[309] "frequencybodyaccelerometer-bandsenergy-49,56"    
[310] "frequencybodyaccelerometer-bandsenergy-57,64"    
[311] "frequencybodyaccelerometer-bandsenergy-1,16"     
[312] "frequencybodyaccelerometer-bandsenergy-17,32"    
[313] "frequencybodyaccelerometer-bandsenergy-33,48"    
[314] "frequencybodyaccelerometer-bandsenergy-49,64"    
[315] "frequencybodyaccelerometer-bandsenergy-1,24"     
[316] "frequencybodyaccelerometer-bandsenergy-25,48"    
[317] "frequencybodyaccelerometer-bandsenergy-1,8"      
[318] "frequencybodyaccelerometer-bandsenergy-9,16"     
[319] "frequencybodyaccelerometer-bandsenergy-17,24"    
[320] "frequencybodyaccelerometer-bandsenergy-25,32"    
[321] "frequencybodyaccelerometer-bandsenergy-33,40"    
[322] "frequencybodyaccelerometer-bandsenergy-41,48"    
[323] "frequencybodyaccelerometer-bandsenergy-49,56"    
[324] "frequencybodyaccelerometer-bandsenergy-57,64"    
[325] "frequencybodyaccelerometer-bandsenergy-1,16"     
[326] "frequencybodyaccelerometer-bandsenergy-17,32"    
[327] "frequencybodyaccelerometer-bandsenergy-33,48"    
[328] "frequencybodyaccelerometer-bandsenergy-49,64"    
[329] "frequencybodyaccelerometer-bandsenergy-1,24"     
[330] "frequencybodyaccelerometer-bandsenergy-25,48"    
[331] "frequencybodyaccelerometer-bandsenergy-1,8"      
[332] "frequencybodyaccelerometer-bandsenergy-9,16"     
[333] "frequencybodyaccelerometer-bandsenergy-17,24"    
[334] "frequencybodyaccelerometer-bandsenergy-25,32"    
[335] "frequencybodyaccelerometer-bandsenergy-33,40"    
[336] "frequencybodyaccelerometer-bandsenergy-41,48"    
[337] "frequencybodyaccelerometer-bandsenergy-49,56"    
[338] "frequencybodyaccelerometer-bandsenergy-57,64"    
[339] "frequencybodyaccelerometer-bandsenergy-1,16"     
[340] "frequencybodyaccelerometer-bandsenergy-17,32"    
[341] "frequencybodyaccelerometer-bandsenergy-33,48"    
[342] "frequencybodyaccelerometer-bandsenergy-49,64"    
[343] "frequencybodyaccelerometer-bandsenergy-1,24"     
[344] "frequencybodyaccelerometer-bandsenergy-25,48"    
[345] "frequencybodyaccelerometerjerk-mean-x"           
[346] "frequencybodyaccelerometerjerk-mean-y"           
[347] "frequencybodyaccelerometerjerk-mean-z"           
[348] "frequencybodyaccelerometerjerk-std-x"            
[349] "frequencybodyaccelerometerjerk-std-y"            
[350] "frequencybodyaccelerometerjerk-std-z"            
[351] "frequencybodyaccelerometerjerk-mad-x"            
[352] "frequencybodyaccelerometerjerk-mad-y"            
[353] "frequencybodyaccelerometerjerk-mad-z"            
[354] "frequencybodyaccelerometerjerk-max-x"            
[355] "frequencybodyaccelerometerjerk-max-y"            
[356] "frequencybodyaccelerometerjerk-max-z"            
[357] "frequencybodyaccelerometerjerk-min-x"            
[358] "frequencybodyaccelerometerjerk-min-y"            
[359] "frequencybodyaccelerometerjerk-min-z"            
[360] "frequencybodyaccelerometerjerk-sma"              
[361] "frequencybodyaccelerometerjerk-energy-x"         
[362] "frequencybodyaccelerometerjerk-energy-y"         
[363] "frequencybodyaccelerometerjerk-energy-z"         
[364] "frequencybodyaccelerometerjerk-iqr-x"            
[365] "frequencybodyaccelerometerjerk-iqr-y"            
[366] "frequencybodyaccelerometerjerk-iqr-z"            
[367] "frequencybodyaccelerometerjerk-entropy-x"        
[368] "frequencybodyaccelerometerjerk-entropy-y"        
[369] "frequencybodyaccelerometerjerk-entropy-z"        
[370] "frequencybodyaccelerometerjerk-maxinds-x"        
[371] "frequencybodyaccelerometerjerk-maxinds-y"        
[372] "frequencybodyaccelerometerjerk-maxinds-z"        
[373] "frequencybodyaccelerometerjerk-meanfreq-x"       
[374] "frequencybodyaccelerometerjerk-meanfreq-y"       
[375] "frequencybodyaccelerometerjerk-meanfreq-z"       
[376] "frequencybodyaccelerometerjerk-skewness-x"       
[377] "frequencybodyaccelerometerjerk-kurtosis-x"       
[378] "frequencybodyaccelerometerjerk-skewness-y"       
[379] "frequencybodyaccelerometerjerk-kurtosis-y"       
[380] "frequencybodyaccelerometerjerk-skewness-z"       
[381] "frequencybodyaccelerometerjerk-kurtosis-z"       
[382] "frequencybodyaccelerometerjerk-bandsenergy-1,8"  
[383] "frequencybodyaccelerometerjerk-bandsenergy-9,16" 
[384] "frequencybodyaccelerometerjerk-bandsenergy-17,24"
[385] "frequencybodyaccelerometerjerk-bandsenergy-25,32"
[386] "frequencybodyaccelerometerjerk-bandsenergy-33,40"
[387] "frequencybodyaccelerometerjerk-bandsenergy-41,48"
[388] "frequencybodyaccelerometerjerk-bandsenergy-49,56"
[389] "frequencybodyaccelerometerjerk-bandsenergy-57,64"
[390] "frequencybodyaccelerometerjerk-bandsenergy-1,16" 
[391] "frequencybodyaccelerometerjerk-bandsenergy-17,32"
[392] "frequencybodyaccelerometerjerk-bandsenergy-33,48"
[393] "frequencybodyaccelerometerjerk-bandsenergy-49,64"
[394] "frequencybodyaccelerometerjerk-bandsenergy-1,24" 
[395] "frequencybodyaccelerometerjerk-bandsenergy-25,48"
[396] "frequencybodyaccelerometerjerk-bandsenergy-1,8"  
[397] "frequencybodyaccelerometerjerk-bandsenergy-9,16" 
[398] "frequencybodyaccelerometerjerk-bandsenergy-17,24"
[399] "frequencybodyaccelerometerjerk-bandsenergy-25,32"
[400] "frequencybodyaccelerometerjerk-bandsenergy-33,40"
[401] "frequencybodyaccelerometerjerk-bandsenergy-41,48"
[402] "frequencybodyaccelerometerjerk-bandsenergy-49,56"
[403] "frequencybodyaccelerometerjerk-bandsenergy-57,64"
[404] "frequencybodyaccelerometerjerk-bandsenergy-1,16" 
[405] "frequencybodyaccelerometerjerk-bandsenergy-17,32"
[406] "frequencybodyaccelerometerjerk-bandsenergy-33,48"
[407] "frequencybodyaccelerometerjerk-bandsenergy-49,64"
[408] "frequencybodyaccelerometerjerk-bandsenergy-1,24" 
[409] "frequencybodyaccelerometerjerk-bandsenergy-25,48"
[410] "frequencybodyaccelerometerjerk-bandsenergy-1,8"  
[411] "frequencybodyaccelerometerjerk-bandsenergy-9,16" 
[412] "frequencybodyaccelerometerjerk-bandsenergy-17,24"
[413] "frequencybodyaccelerometerjerk-bandsenergy-25,32"
[414] "frequencybodyaccelerometerjerk-bandsenergy-33,40"
[415] "frequencybodyaccelerometerjerk-bandsenergy-41,48"
[416] "frequencybodyaccelerometerjerk-bandsenergy-49,56"
[417] "frequencybodyaccelerometerjerk-bandsenergy-57,64"
[418] "frequencybodyaccelerometerjerk-bandsenergy-1,16" 
[419] "frequencybodyaccelerometerjerk-bandsenergy-17,32"
[420] "frequencybodyaccelerometerjerk-bandsenergy-33,48"
[421] "frequencybodyaccelerometerjerk-bandsenergy-49,64"
[422] "frequencybodyaccelerometerjerk-bandsenergy-1,24" 
[423] "frequencybodyaccelerometerjerk-bandsenergy-25,48"
[424] "frequencybodygyroscope-mean-x"                   
[425] "frequencybodygyroscope-mean-y"                   
[426] "frequencybodygyroscope-mean-z"                   
[427] "frequencybodygyroscope-std-x"                    
[428] "frequencybodygyroscope-std-y"                    
[429] "frequencybodygyroscope-std-z"                    
[430] "frequencybodygyroscope-mad-x"                    
[431] "frequencybodygyroscope-mad-y"                    
[432] "frequencybodygyroscope-mad-z"                    
[433] "frequencybodygyroscope-max-x"                    
[434] "frequencybodygyroscope-max-y"                    
[435] "frequencybodygyroscope-max-z"                    
[436] "frequencybodygyroscope-min-x"                    
[437] "frequencybodygyroscope-min-y"                    
[438] "frequencybodygyroscope-min-z"                    
[439] "frequencybodygyroscope-sma"                      
[440] "frequencybodygyroscope-energy-x"                 
[441] "frequencybodygyroscope-energy-y"                 
[442] "frequencybodygyroscope-energy-z"                 
[443] "frequencybodygyroscope-iqr-x"                    
[444] "frequencybodygyroscope-iqr-y"                    
[445] "frequencybodygyroscope-iqr-z"                    
[446] "frequencybodygyroscope-entropy-x"                
[447] "frequencybodygyroscope-entropy-y"                
[448] "frequencybodygyroscope-entropy-z"                
[449] "frequencybodygyroscope-maxinds-x"                
[450] "frequencybodygyroscope-maxinds-y"                
[451] "frequencybodygyroscope-maxinds-z"                
[452] "frequencybodygyroscope-meanfreq-x"               
[453] "frequencybodygyroscope-meanfreq-y"               
[454] "frequencybodygyroscope-meanfreq-z"               
[455] "frequencybodygyroscope-skewness-x"               
[456] "frequencybodygyroscope-kurtosis-x"               
[457] "frequencybodygyroscope-skewness-y"               
[458] "frequencybodygyroscope-kurtosis-y"               
[459] "frequencybodygyroscope-skewness-z"               
[460] "frequencybodygyroscope-kurtosis-z"               
[461] "frequencybodygyroscope-bandsenergy-1,8"          
[462] "frequencybodygyroscope-bandsenergy-9,16"         
[463] "frequencybodygyroscope-bandsenergy-17,24"        
[464] "frequencybodygyroscope-bandsenergy-25,32"        
[465] "frequencybodygyroscope-bandsenergy-33,40"        
[466] "frequencybodygyroscope-bandsenergy-41,48"        
[467] "frequencybodygyroscope-bandsenergy-49,56"        
[468] "frequencybodygyroscope-bandsenergy-57,64"        
[469] "frequencybodygyroscope-bandsenergy-1,16"         
[470] "frequencybodygyroscope-bandsenergy-17,32"        
[471] "frequencybodygyroscope-bandsenergy-33,48"        
[472] "frequencybodygyroscope-bandsenergy-49,64"        
[473] "frequencybodygyroscope-bandsenergy-1,24"         
[474] "frequencybodygyroscope-bandsenergy-25,48"        
[475] "frequencybodygyroscope-bandsenergy-1,8"          
[476] "frequencybodygyroscope-bandsenergy-9,16"         
[477] "frequencybodygyroscope-bandsenergy-17,24"        
[478] "frequencybodygyroscope-bandsenergy-25,32"        
[479] "frequencybodygyroscope-bandsenergy-33,40"        
[480] "frequencybodygyroscope-bandsenergy-41,48"        
[481] "frequencybodygyroscope-bandsenergy-49,56"        
[482] "frequencybodygyroscope-bandsenergy-57,64"        
[483] "frequencybodygyroscope-bandsenergy-1,16"         
[484] "frequencybodygyroscope-bandsenergy-17,32"        
[485] "frequencybodygyroscope-bandsenergy-33,48"        
[486] "frequencybodygyroscope-bandsenergy-49,64"        
[487] "frequencybodygyroscope-bandsenergy-1,24"         
[488] "frequencybodygyroscope-bandsenergy-25,48"        
[489] "frequencybodygyroscope-bandsenergy-1,8"          
[490] "frequencybodygyroscope-bandsenergy-9,16"         
[491] "frequencybodygyroscope-bandsenergy-17,24"        
[492] "frequencybodygyroscope-bandsenergy-25,32"        
[493] "frequencybodygyroscope-bandsenergy-33,40"        
[494] "frequencybodygyroscope-bandsenergy-41,48"        
[495] "frequencybodygyroscope-bandsenergy-49,56"        
[496] "frequencybodygyroscope-bandsenergy-57,64"        
[497] "frequencybodygyroscope-bandsenergy-1,16"         
[498] "frequencybodygyroscope-bandsenergy-17,32"        
[499] "frequencybodygyroscope-bandsenergy-33,48"        
[500] "frequencybodygyroscope-bandsenergy-49,64"        
[501] "frequencybodygyroscope-bandsenergy-1,24"         
[502] "frequencybodygyroscope-bandsenergy-25,48"        
[503] "frequencybodyaccelerometermagnitude-mean"        
[504] "frequencybodyaccelerometermagnitude-std"         
[505] "frequencybodyaccelerometermagnitude-mad"         
[506] "frequencybodyaccelerometermagnitude-max"         
[507] "frequencybodyaccelerometermagnitude-min"         
[508] "frequencybodyaccelerometermagnitude-sma"         
[509] "frequencybodyaccelerometermagnitude-energy"      
[510] "frequencybodyaccelerometermagnitude-iqr"         
[511] "frequencybodyaccelerometermagnitude-entropy"     
[512] "frequencybodyaccelerometermagnitude-maxinds"     
[513] "frequencybodyaccelerometermagnitude-meanfreq"    
[514] "frequencybodyaccelerometermagnitude-skewness"    
[515] "frequencybodyaccelerometermagnitude-kurtosis"    
[516] "frequencybodyaccelerometerjerkmagnitude-mean"    
[517] "frequencybodyaccelerometerjerkmagnitude-std"     
[518] "frequencybodyaccelerometerjerkmagnitude-mad"     
[519] "frequencybodyaccelerometerjerkmagnitude-max"     
[520] "frequencybodyaccelerometerjerkmagnitude-min"     
[521] "frequencybodyaccelerometerjerkmagnitude-sma"     
[522] "frequencybodyaccelerometerjerkmagnitude-energy"  
[523] "frequencybodyaccelerometerjerkmagnitude-iqr"     
[524] "frequencybodyaccelerometerjerkmagnitude-entropy" 
[525] "frequencybodyaccelerometerjerkmagnitude-maxinds" 
[526] "frequencybodyaccelerometerjerkmagnitude-meanfreq"
[527] "frequencybodyaccelerometerjerkmagnitude-skewness"
[528] "frequencybodyaccelerometerjerkmagnitude-kurtosis"
[529] "frequencybodygyroscopemagnitude-mean"            
[530] "frequencybodygyroscopemagnitude-std"             
[531] "frequencybodygyroscopemagnitude-mad"             
[532] "frequencybodygyroscopemagnitude-max"             
[533] "frequencybodygyroscopemagnitude-min"             
[534] "frequencybodygyroscopemagnitude-sma"             
[535] "frequencybodygyroscopemagnitude-energy"          
[536] "frequencybodygyroscopemagnitude-iqr"             
[537] "frequencybodygyroscopemagnitude-entropy"         
[538] "frequencybodygyroscopemagnitude-maxinds"         
[539] "frequencybodygyroscopemagnitude-meanfreq"        
[540] "frequencybodygyroscopemagnitude-skewness"        
[541] "frequencybodygyroscopemagnitude-kurtosis"        
[542] "frequencybodygyroscopejerkmagnitude-mean"        
[543] "frequencybodygyroscopejerkmagnitude-std"         
[544] "frequencybodygyroscopejerkmagnitude-mad"         
[545] "frequencybodygyroscopejerkmagnitude-max"         
[546] "frequencybodygyroscopejerkmagnitude-min"         
[547] "frequencybodygyroscopejerkmagnitude-sma"         
[548] "frequencybodygyroscopejerkmagnitude-energy"      
[549] "frequencybodygyroscopejerkmagnitude-iqr"         
[550] "frequencybodygyroscopejerkmagnitude-entropy"     
[551] "frequencybodygyroscopejerkmagnitude-maxinds"     
[552] "frequencybodygyroscopejerkmagnitude-meanfreq"    
[553] "frequencybodygyroscopejerkmagnitude-skewness"    
[554] "frequencybodygyroscopejerkmagnitude-kurtosis"    
[555] "angle(tbodyaccelerometermean,gravity)"           
[556] "angle(tbodyaccelerometerjerkmean),gravitymean)"  
[557] "angle(tbodygyroscopemean,gravitymean)"           
[558] "angle(tbodygyroscopejerkmean,gravitymean)"       
[559] "angle(x,gravitymean)"                            
[560] "angle(y,gravitymean)"                            
[561] "angle(z,gravitymean)"                            
[562] "subject"                                         
[563] "activity"     

##Varibles in tidy_data_for_mean_standard_devation.txt

 [1] "timebodyaccelerometer-mean-x"                
 [2] "timebodyaccelerometer-mean-y"                
 [3] "timebodyaccelerometer-mean-z"                
 [4] "timebodyaccelerometer-std-x"                 
 [5] "timebodyaccelerometer-std-y"                 
 [6] "timebodyaccelerometer-std-z"                 
 [7] "timegravityaccelerometer-mean-x"             
 [8] "timegravityaccelerometer-mean-y"             
 [9] "timegravityaccelerometer-mean-z"             
[10] "timegravityaccelerometer-std-x"              
[11] "timegravityaccelerometer-std-y"              
[12] "timegravityaccelerometer-std-z"              
[13] "timebodyaccelerometerjerk-mean-x"            
[14] "timebodyaccelerometerjerk-mean-y"            
[15] "timebodyaccelerometerjerk-mean-z"            
[16] "timebodyaccelerometerjerk-std-x"             
[17] "timebodyaccelerometerjerk-std-y"             
[18] "timebodyaccelerometerjerk-std-z"             
[19] "timebodygyroscope-mean-x"                    
[20] "timebodygyroscope-mean-y"                    
[21] "timebodygyroscope-mean-z"                    
[22] "timebodygyroscope-std-x"                     
[23] "timebodygyroscope-std-y"                     
[24] "timebodygyroscope-std-z"                     
[25] "timebodygyroscopejerk-mean-x"                
[26] "timebodygyroscopejerk-mean-y"                
[27] "timebodygyroscopejerk-mean-z"                
[28] "timebodygyroscopejerk-std-x"                 
[29] "timebodygyroscopejerk-std-y"                 
[30] "timebodygyroscopejerk-std-z"                 
[31] "timebodyaccelerometermagnitude-mean"         
[32] "timebodyaccelerometermagnitude-std"          
[33] "timegravityaccelerometermagnitude-mean"      
[34] "timegravityaccelerometermagnitude-std"       
[35] "timebodyaccelerometerjerkmagnitude-mean"     
[36] "timebodyaccelerometerjerkmagnitude-std"      
[37] "timebodygyroscopemagnitude-mean"             
[38] "timebodygyroscopemagnitude-std"              
[39] "timebodygyroscopejerkmagnitude-mean"         
[40] "timebodygyroscopejerkmagnitude-std"          
[41] "frequencybodyaccelerometer-mean-x"           
[42] "frequencybodyaccelerometer-mean-y"           
[43] "frequencybodyaccelerometer-mean-z"           
[44] "frequencybodyaccelerometer-std-x"            
[45] "frequencybodyaccelerometer-std-y"            
[46] "frequencybodyaccelerometer-std-z"            
[47] "frequencybodyaccelerometerjerk-mean-x"       
[48] "frequencybodyaccelerometerjerk-mean-y"       
[49] "frequencybodyaccelerometerjerk-mean-z"       
[50] "frequencybodyaccelerometerjerk-std-x"        
[51] "frequencybodyaccelerometerjerk-std-y"        
[52] "frequencybodyaccelerometerjerk-std-z"        
[53] "frequencybodygyroscope-mean-x"               
[54] "frequencybodygyroscope-mean-y"               
[55] "frequencybodygyroscope-mean-z"               
[56] "frequencybodygyroscope-std-x"                
[57] "frequencybodygyroscope-std-y"                
[58] "frequencybodygyroscope-std-z"                
[59] "frequencybodyaccelerometermagnitude-mean"    
[60] "frequencybodyaccelerometermagnitude-std"     
[61] "frequencybodyaccelerometerjerkmagnitude-mean"
[62] "frequencybodyaccelerometerjerkmagnitude-std" 
[63] "frequencybodygyroscopemagnitude-mean"        
[64] "frequencybodygyroscopemagnitude-std"         
[65] "frequencybodygyroscopejerkmagnitude-mean"    
[66] "frequencybodygyroscopejerkmagnitude-std"     
[67] "subject"                                     
[68] "activity"

##Varibles in tidy_data_for_avrage.txt
 [1] "subject"                                     
 [2] "activity"                                    
 [3] "timebodyaccelerometer-mean-x"                
 [4] "timebodyaccelerometer-mean-y"                
 [5] "timebodyaccelerometer-mean-z"                
 [6] "timebodyaccelerometer-std-x"                 
 [7] "timebodyaccelerometer-std-y"                 
 [8] "timebodyaccelerometer-std-z"                 
 [9] "timegravityaccelerometer-mean-x"             
[10] "timegravityaccelerometer-mean-y"             
[11] "timegravityaccelerometer-mean-z"             
[12] "timegravityaccelerometer-std-x"              
[13] "timegravityaccelerometer-std-y"              
[14] "timegravityaccelerometer-std-z"              
[15] "timebodyaccelerometerjerk-mean-x"            
[16] "timebodyaccelerometerjerk-mean-y"            
[17] "timebodyaccelerometerjerk-mean-z"            
[18] "timebodyaccelerometerjerk-std-x"             
[19] "timebodyaccelerometerjerk-std-y"             
[20] "timebodyaccelerometerjerk-std-z"             
[21] "timebodygyroscope-mean-x"                    
[22] "timebodygyroscope-mean-y"                    
[23] "timebodygyroscope-mean-z"                    
[24] "timebodygyroscope-std-x"                     
[25] "timebodygyroscope-std-y"                     
[26] "timebodygyroscope-std-z"                     
[27] "timebodygyroscopejerk-mean-x"                
[28] "timebodygyroscopejerk-mean-y"                
[29] "timebodygyroscopejerk-mean-z"                
[30] "timebodygyroscopejerk-std-x"                 
[31] "timebodygyroscopejerk-std-y"                 
[32] "timebodygyroscopejerk-std-z"                 
[33] "timebodyaccelerometermagnitude-mean"         
[34] "timebodyaccelerometermagnitude-std"          
[35] "timegravityaccelerometermagnitude-mean"      
[36] "timegravityaccelerometermagnitude-std"       
[37] "timebodyaccelerometerjerkmagnitude-mean"     
[38] "timebodyaccelerometerjerkmagnitude-std"      
[39] "timebodygyroscopemagnitude-mean"             
[40] "timebodygyroscopemagnitude-std"              
[41] "timebodygyroscopejerkmagnitude-mean"         
[42] "timebodygyroscopejerkmagnitude-std"          
[43] "frequencybodyaccelerometer-mean-x"           
[44] "frequencybodyaccelerometer-mean-y"           
[45] "frequencybodyaccelerometer-mean-z"           
[46] "frequencybodyaccelerometer-std-x"            
[47] "frequencybodyaccelerometer-std-y"            
[48] "frequencybodyaccelerometer-std-z"            
[49] "frequencybodyaccelerometerjerk-mean-x"       
[50] "frequencybodyaccelerometerjerk-mean-y"       
[51] "frequencybodyaccelerometerjerk-mean-z"       
[52] "frequencybodyaccelerometerjerk-std-x"        
[53] "frequencybodyaccelerometerjerk-std-y"        
[54] "frequencybodyaccelerometerjerk-std-z"        
[55] "frequencybodygyroscope-mean-x"               
[56] "frequencybodygyroscope-mean-y"               
[57] "frequencybodygyroscope-mean-z"               
[58] "frequencybodygyroscope-std-x"                
[59] "frequencybodygyroscope-std-y"                
[60] "frequencybodygyroscope-std-z"                
[61] "frequencybodyaccelerometermagnitude-mean"    
[62] "frequencybodyaccelerometermagnitude-std"     
[63] "frequencybodyaccelerometerjerkmagnitude-mean"
[64] "frequencybodyaccelerometerjerkmagnitude-std" 
[65] "frequencybodygyroscopemagnitude-mean"        
[66] "frequencybodygyroscopemagnitude-std"         
[67] "frequencybodygyroscopejerkmagnitude-mean"    
[68] "frequencybodygyroscopejerkmagnitude-std"  