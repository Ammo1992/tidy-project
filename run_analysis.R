# Libraries used

library(zip) #for unzipping the zip file

library(MASS)

library(reshape2)#for melting of data

library(reshape)#for recasting of data

#Downloading the file and unzipping it 

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url,destfile = "data.zip")

unzip("data.zip")

#Loading the required data into R environment

activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt") # the 6 actvity labels

features<-read.table("./UCI HAR Dataset/features.txt") # the total list of all the variables

featuresIndex<-grepl(".*mean.*|.*std.*",features$V2) # extracting indices of the features containing only mean and std 

features<-features[featuresIndex,] # filtering the required variables from the above index

features$V2<-as.character(features$V2) # important conversion for adding column names in the final data -allData


# Loading test data

testData<-read.table("./UCI HAR Dataset/test/X_test.txt") #the test data

testData<-testData[,featuresIndex] #filtering the required variables(columns)

testLabels<-read.table("./UCI HAR Dataset/test/y_test.txt") #the activity table for the test data

testSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt") #the subject for the test data

testData<-cbind(testSubject,testLabels,testData) #binding the above columns


#training data

trainData<-read.table("./UCI HAR Dataset/train/X_train.txt")

trainData<-trainData[,featuresIndex] #filtering the required variables(columns)

trainLabels<-read.table("./UCI HAR Dataset/train/y_train.txt") #the activity table for the training data

trainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt") #the subject for the training data

trainData<-cbind(trainSubject,trainLabels,trainData) #binding the above columns


allData<-rbind(trainData,testData) #creating the complete dataset by row binding test and training data

colnames(allData)<-c("subject","activity",features$V2) #assigning proper column names

remove(activityLabels,testData,testLabels,testSubject,trainData,trainLabels,trainSubject,features) #removing the now waste data

#activity wise mean for each subject and activity

meltData<-melt(allData, id=c("subject","activity"))#melting the data based on subject and activity

castData<-cast(meltData,subject+activity~variable,mean)#casting the melted data by taking mean of the data based on subject and activity

#mean for each subject

meltData1<-melt(allData, id=c("subject"))#melting the data based on subject

castData1<-cast(meltData1,subject~variable,mean)#casting the melted data by taking mean of the data subject wise

write.table(allData, file = "tidyData.txt", row.names = FALSE)
