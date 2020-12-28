library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- " https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

datasetFolder <- "UCI HAR Dataset"

# Load activity labels + features

# Load activity labels
labels <- read.table(paste(datasetFolder,"/activity_labels.txt",sep=""))
# Load features
features <- read.table(paste(datasetFolder,"/features.txt",sep=""))

#### Extract and rename mean and standard deviation
# Search inside features any feature which has 'mean' or 'std' in its label (column 2) 
featuresMeanAndStdList <- grep(".*mean.*|.*std.*", features[,2])
features <- features[featuresMeanAndStdList,2]

#### Load the datasets


# Load the training set
trainSet <- read.table(paste(datasetFolder,"/train/X_train.txt",sep=""))
trainSet <- train[featuresMeanAndStdList]


# Load the test set
testSet <- read.table(paste(datasetFolder,"/test/X_test.txt",sep=""))
testSet <- testSet[featuresMeanAndStdList]

# Load the training labels
trainLabels <- read.table(paste(datasetFolder,"/train/y_train.txt",sep=""))


# Load the test labels
testLabels <- read.table(paste(datasetFolder,"/test/y_test.txt",sep=""))

# Load the training subjects
trainSubjects <- read.table(paste(datasetFolder,"/train/subject_train.txt",sep=""))


# Load the test subjects
testSubjects <- read.table(paste(datasetFolder,"/test/subject_test.txt",sep=""))

# Links the subjects with the respective activity label and the training set
train <- cbind(trainSubjects, trainLabels, trainSet)


# Links the subjects with the respective activity label and the test set
test <- cbind(testSubjects, testLabels, testSet)

#### (Item 1)
# merge datasets and add labels
dataset <- rbind(train, test)
# (Item 4)
colnames(dataset) <- c("Subject", "Activity", features)

#### (Item 3)
# turn activities & subjects into factors
dataset$Activity <- factor(dataset$Activity, levels = labels[,1], labels = labels[,2])
# turn subjects into factors in order to use the aggregate function
dataset$Subject <- factor(dataset$Subject)

#### new dataset (Item 5)
# Aggregate the mean value for each variable by its pair of subject and activity
library(stats)

means <- aggregate(as.matrix(dataset[,features]) ~ Subject + Activity, data = dataset, FUN= "mean" )
write.table(means, "tidydataset.txt", row.names = FALSE, quote = FALSE)