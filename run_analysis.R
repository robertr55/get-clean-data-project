## reminders
## setwd("~/Coursera/3-Getting and Cleaning Data/Project")
## library(dplyr)
## library(tidyr)

run_analysis <- function() {
    ## setup
    setwd("~/Coursera/3-Getting and Cleaning Data/Project")
    library(dplyr)
  
    ## read the data files from the UCI Dataset
    features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE)
    activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)
    test_x <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
    test_y <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
    test_s <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
    train_x <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
    train_y <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
    train_s <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

    ## combine and merge test/train subjects/activities/time-frequency variables
    test <- cbind(test_s,test_y,test_x)
    train <- cbind(train_s,train_y,train_x)
    total <- rbind(test,train)
        
    ## use make.names to strip out invalid chars in features (like the "()'s")
    ## substitute Time for t, and Frequency for f in column names
    ## substitute 1 "." for the 3 "..." that make.names uses instead of "()"
    ## assign new column names to merged data set columns ("total")
    colname1 <- c("subject", "activity")
    colname2 <- make.names(features[,2])
    colname_all <- c(colname1, colname2)
    colname_all <- gsub("fBody","FrequencyBody",colname_all)
    colname_all <- gsub("tBody","TimeBody",colname_all)
    colname_all <- gsub("tGravity","TimeGravity",colname_all)
    colname_all <- gsub("\\.\\.\\.","\\.",colname_all)
    colname_all <- gsub("\\.\\.","",colname_all)
    colnames(total)=colname_all
    
    ## substitute activity codes with activity names 
    tmp <- match(total[,2],activities[,1])
    total[,2] <- activities[tmp,2]
    
    ## extract only columns with "mean" or "std" in column name, plus Subject & Activity
    colname_match <- c("subject","activity","mean","std")
    total_ms <- total[,grep(paste(colname_match,collapse="|"),names(total))]
    
    ## sort smaller mean/std dataframe by subject, activity
    total_ms <- total_ms[order(total_ms$subject,total_ms$activity),]
    
    ## summarize by subject and activity, calculate mean for each variable
    final <- total_ms %>% group_by(subject,activity) %>% summarise_each(funs(mean))
    
    write.table(final,"./ProjectTidyDataset.txt",row.name=FALSE)
}