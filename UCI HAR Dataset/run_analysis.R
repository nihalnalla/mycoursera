rm(list = ls())
library(dplyr)
getwd()
directory=c("C:/Users/Nihal/Documents/R/coursera/cleaning data assign/UCI HAR Dataset")

##reading data
X_train<-read.table(paste(directory,"train/X_train.txt", sep="/"))
X_test<-read.table(paste(directory,"test/X_test.txt",sep="/"))
y_train<-read.table(paste(directory,"train/y_train.txt", sep="/"))
y_test<-read.table(paste(directory,"test/y_test.txt",sep="/"))
sub_train<-read.table(paste(directory,"train/subject_train.txt", sep="/"))
sub_test<-read.table(paste(directory,"test/subject_test.txt",sep="/"))

##merging data
X_data<-rbind(X_train,X_test)
y_data<-rbind(y_train,y_test)
sub_data<-rbind(sub_train,sub_test)



## reading features
features<-read.table(paste(directory,"features.txt",sep = "/"))

## reading activity labels
activities<-read.table(paste(directory,"activity_labels.txt",sep = "/"))

##selecting mean and std from all features
selected_var <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_data <- X_data[,selected_var[,1]]

##making col names
names=list()
for (x in 1:nrow(selected_var)) {
      names<-cbind(names,as.character(selected_var[x,2]))
      
}

colnames(X_data)=names
colnames(y_data)=c("Activity")
colnames(sub_data)=c("Subject")

##merging complete data
total<-cbind(y_data,X_data)
total<-cbind(sub_data,total)


##converting activities
activity_names<-list()
for (row in 1:nrow(activities)) {
      activity_names<-cbind(activity_names,as.character(activities[row,2]))
}
## setting respective activity names
as.factor(total[,2])
total[,2] <- factor(total[,2], labels =activity_names)


## creating tidy data set

total_mean <- total %>% 
      group_by(Subject,Activity) %>%
      summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)












