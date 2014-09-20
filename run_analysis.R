##Read in all the bloody files
subject_train <- read.csv("subject_train.txt",header=FALSE,sep=" ",stringsAsFactors=FALSE)
x_train <- read.table("X_train.txt",header=FALSE,stringsAsFactors=FALSE)
y_train <- read.csv("y_train.txt",header=FALSE,sep=" ",stringsAsFactors=FALSE)
subject_test <- read.csv("subject_test.txt",header=FALSE,sep=" ",stringsAsFactors=FALSE)
x_test <- read.table("X_test.txt",header=FALSE,stringsAsFactors=FALSE)
y_test <- read.csv("y_test.txt",header=FALSE,sep=" ",stringsAsFactors=FALSE)
##features
features <- read.table("features.txt",header=FALSE,stringsAsFactors=FALSE)
##labels
labels <- read.table("activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)

##then name the columns - nice and neat
colnames(x_test) <- features[,2]
colnames(x_train) <- features[,2]
colnames(subject_train) <- "Subject"
colnames(subject_test) <- "Subject"
colnames(y_train) <- "Activity_Code"
colnames(y_test) <- "Activity_Code"
colnames(labels) <- c("Activity_Code","Activity_Label")

##these are the X (feature) columns we want to keep 
columns_to_keep <- c(grep("mean",features$V2),grep("std",features$V2))

##Strip out unwanted columns
x_test <- x_test[,columns_to_keep]
x_train <- x_train[,columns_to_keep]


##combine features,subject and activity code
DataTest <- cbind(subject_test,x_test,y_test) 
DataTrain <- cbind(subject_train,x_train,y_train) 

##Add test and train datasets together
DataSet <- rbind(DataTest,DataTrain)

##add activity labels -- Merge messes with order, so do this AFTER combining data sets
DataSet <- merge(DataSet,labels,by="Activity_Code")

##Now creates a second, independent tidy data set with the average of each variable for each activity and each subject."
## Going with long and skinny
## these are the columns that will be cast as variables
measure_vars <- colnames(DataSet)
measure_vars <- measure_vars[3:80]
molten <- melt(DataSet,id=c("Activity_Code","Subject","Activity_Label"))
tidy_data <- test <- ddply(molten,.(Activity_Code,Subject,Activity_Label,variable),
          summarize,mean.activity=mean(value))

