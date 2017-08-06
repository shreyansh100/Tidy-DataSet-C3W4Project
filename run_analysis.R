working_dir <- getwd()
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, file.path(working_dir,"datasetfiles.zip")
unzip("datasetfiles.zip")
library(data.table)
activity_label <- fread(file.path(working_dir,"UCI HAR Dataset/activity_labels.txt"),col.names = c("ClassLabels","ActivityName"))
features <- fread(file.path(working_dir,"UCI HAR Dataset/features.txt"),col.names = c("id","FeatureNames"))
features_required <- grep("mean|std",features[,FeatureNames])
measurement <- features[features_required,FeatureNames]
measurement <- gsub('[()]','',measurement)
trainDS <- fread(file.path(working_dir,"UCI HAR Dataset/train/X_train.txt"))[,features_required,with = F]
setnames(trainDS,colnames(trainDS),measurement)
train_labels <- fread(file.path(working_dir,"UCI HAR Dataset/train/y_train.txt"),col.names = "Activity")
train_subjects <- fread(file.path(working_dir,"UCI HAR Dataset/train/subject_train.txt"),col.names = "Subject")
trainDS <- cbind(train_subjects,train_labels,trainDS)
testDS <- fread(file.path(working_dir,"UCI HAR Dataset/test/X_test.txt"))[,features_required,with = F]
setnames(testDS,colnames(testDS),measurement)
test_labels <- fread(file.path(working_dir,"UCI HAR Dataset/test/y_test.txt"),col.names = "Activity")
test_subjects <-  fread(file.path(working_dir,"UCI HAR Dataset/test/subject_test.txt"),col.names = "Subject")
testDS <- cbind(test_subjects,test_labels,testDS)
combinedDS <- rbind(trainDS,testDS)
combinedDS[["Activity"]] <- factor(combinedDS[,Activity],levels = activity_label[["ClassLabels"]],labels = activity_label[["ActivityName"]])
combinedDS[["Subject"]] <- as.factor(combinedDS[,Subject])
combinedDS2 <- combinedDS
combinedDS2 <- melt(combinedDS2, id.vars = c("Subject","Activity"))
combinedDS2 <- dcast(combinedDS2, Subject + Activity ~ variable,mean)
write.table(combinedDS2,file = "TidyDataset.txt",row.name = FALSE)
