library(reshape2)
#Extracts only th measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
meanstd <- grep("mean|std",features[,2])
measurements <- features[meanstd,2]
measurements <- gsub("[()]","",measurements)

#Merges the training and the test sets to create one data set
X_train <- read.table("train/X_train.txt")[meanstd]
Y_train <- read.table("train/Y_train.txt")
subject_train <- read.table("train/subject_train.txt")
train <- cbind(subject_train,Y_train,X_train)

X_test <- read.table("test/X_test.txt")[meanstd]
Y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
test <- cbind(subject_test,Y_test,X_test)
combine <- rbind(train, test)

# Appropriately label the data set with descriptive activity names
colnames(combine) <- c("subject","activity",measurements)

#Uses descriptive activity names to name the activities in the data set
activity <- read.table("activity_labels.txt")
combine$activity <- factor(combine$activity, levels = activity[,1],labels = activity[,2])

#Create a second, independent tidy data set with the average of each variable for each activity and each subject.
combine1 <- melt(combine, id = c("subject","activity"))
combine2 <- dcast(combine1, subject + activity ~ variable, mean)

write.table(combine2, "tidy.txt",row.names = FALSE)
