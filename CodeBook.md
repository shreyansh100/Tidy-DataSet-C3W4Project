working_dir - It has the path of the working directory.

fileurl - It contains the links from where the dataset to be downloaded.

datasetfiles.zip - It is the name of the dataset that is downloaded.

activity_label dataset has all the activity with their labels
a. ClassLabels - contains labels 
b. ActivityName - contains activity name for respective ClassLabels

features dataset has list of all features
a. id - contains id
b. FeatureNames - contains feature names respective id.

feature_required - It has the index of all features with only mean and standard deviations.

measurement - It has the data for all the feature names with only mean and standard deviations.

trainDS - It is the training dataset having values which corressponds to mean and standard deviation.

train_Labels - It has labels and corresponding to each labels, the activity name is present in activity_label dataset.

train_sibjects - It has the subject id for respective subjects.

testDS - It is the test dataset having values which corressponds to mean and standard deviation.

test_labels - It has labels and corresponding to each labels, the activity name is present in activity_label dataset.

test_labels - It has the subject id for respective subjects.

combinedDS - It has the combined dataset of trainDS and testDS
In combinedDS, I then introduced factor for "Activity" and "Subjects" to make the dataset more clear and understandable

Now, I then copied the whole dataset to another variable combinedDS2 just to be sure that while calculating the mean, nothing will happen to the main dataset

combinedDS2 - it has the same data as that of combinedDS

Then the melting function is applied to the combinedDS2 to melt the data set with respect to the Subject and Activity columns to make the data more tidy.

Finally the dcast function is used to calculate the mean of the of each variable for each activity and each subject

In the end, the tidy data has been written to the file TidyDataset.csv 
