##getting the data
working_dir <- getwd()
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, file.path(working_dir,"datasetfiles.zip")
unzip("datasetfiles.zip")

##loading the activity labels and features into a vriable
library(data.table)
activity_label <- fread(file.path(working_dir,"UCI HAR Dataset/activity_labels.txt"),col.names = c("ClassLabels","ActivityName"))
features <- fread(file.path(working_dir,"UCI HAR Dataset/features.txt"),col.names = c("id","FeatureNames"))

##taking only features with mean and standard deviations
features_required <- grep("mean|std",features[,FeatureNames])
measurement <- features[features_required,FeatureNames]
measurement <- gsub('[()]','',measurement)

## Now loading the Trainig Dataset
trainDS <- fread(file.path(working_dir,"UCI HAR Dataset/train/X_train.txt"))[,features_required,with = F]

##now setting the coluumn names
setnames(trainDS,colnames(trainDS),measurement)
train_labels <- fread(file.path(working_dir,"UCI HAR Dataset/train/y_train.txt"),col.names = "Activity")
train_subjects <- fread(file.path(working_dir,"UCI HAR Dataset/train/subject_train.txt"),col.names = "Subject")

##now binding all the train dataset together
trainDS <- cbind(train_subjects,train_labels,trainDS)

## Now loading the Test Dataset in a similar fashion
testDS <- fread(file.path(working_dir,"UCI HAR Dataset/test/X_test.txt"))[,features_required,with = F]
setnames(testDS,colnames(testDS),measurement)
test_labels <- fread(file.path(working_dir,"UCI HAR Dataset/test/y_test.txt"),col.names = "Activity")
test_subjects <-  fread(file.path(working_dir,"UCI HAR Dataset/test/subject_test.txt"),col.names = "Subject")

##now binding all the Test Dataset together
testDS <- cbind(test_subjects,test_labels,testDS)

## Now combinig both the train and test datasets
combinedDS <- rbind(trainDS,testDS)
combinedDS[["Activity"]] <- factor(combinedDS[,Activity],levels = activity_label[["ClassLabels"]],labels = activity_label[["ActivityName"]])
combinedDS[["Subject"]] <- as.factor(combinedDS[,Subject])

##cpoying the data into new variable
combinedDS2 <- combinedDS

##now first melting the data and then getting the means of each subject and each activity
combinedDS2 <- melt(combinedDS2, id.vars = c("Subject","Activity"))
combinedDS2 <- dcast(combinedDS2, Subject + Activity ~ variable,mean)

## Creating a Tidy Dataset in CSV format
fwrite(combinedDS2,file = "TidyDataset.csv",quote = F)