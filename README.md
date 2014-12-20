Robert Ross README.md for Course Project

I think everyone should know most of the stuff related to this project, but here's my take on it, and what my run_analysis.R script does. 

PREPARATION
The zip file containing the raw data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and then unzipped into a folder called "UCI HAR Dataset". 

STEPS IN run_analysis.R FILE

SHORT VERSION:
- read in data files
- merge the test and training data together into a single data frame
- convert feature/variable names to be clearer and easier to read than the original ones 
- assign these better names as data frame column names 
- substitute descriptive names for activity values (sitting, walking, etc.)
- extract all columns with "mean" or "std" in feature description, plus the subject and activity codes
- sort/order the reduced dataset by subject number and activity
- summarise by calculating the mean of each variable for each subject and activity
- write out the final tidy data set with 180 rows of 81 columns

LONG VERSION:
First, the files I'm reading in are:
1-"features.txt" = contains 561 entries that describe the measurement values in the X_test/train files. 
  Contains values like [1 tBodyAcc-mean()-X, 2 tBodyAcc-mean()-Y, 3 tBodyAcc-mean()-Z, ...]
2-"activity_labels.txt" = contains 6 entries describing the type of activity [1 WALKING, 2 WALKING_UPSTAIRS,
  3 WALKING_DOWNSTAIRS, 4 SITTING, 5 STANDING, 6 LAYING]
3-"y_test.txt" = contains 2947 activity codes (values 1-6) for the test subjects
4-"y_train.txt" = contains 7352 activity codes (values 1-6) for the training subjects
5-"subject_test.txt" = contains 2947 subject codes (values 1-30) for the test subjects
6-"subject_train.txt" = contains 7352 subject codes (values 1-30) for the training subjects
7-"X_test.txt" = contains 2947 vectors with 561-feature values of time and frequency domain variables (as described in the "features_info.txt" file) for the test subjects
8-"X_train.txt" = contains 7352 vectors with 561-feature values of time and frequency domain variables (as described in the "features_info.txt" file) for the training subjects

Next, I use cbind to combine the test subject codes, activity codes, and feature values. I do the same with the training datasets, and finally use rbind to combine the resulting test and training dataframes.

Next, I try to set up the column names to be easier to read and more descriptive.
- the subject code column is called "subject"
- the activity code column is called "activity"
- the remaining 561 column names are taken initially from the "features.txt" file, with the following modifications:
  - I use make.names to strip out invalid chars in features (like the "()'s")
  - I substitute Time for t and Frequency for f
    tBody --> TimeBody
	fBody --> FrequencyBody
	tGravity --> TimeGravity
  - I substitute 1 "." for the 3 "..." that make.names used to replace "()" 

Next, I assign these new column names to the merged data set columns

Next, I take the activity codes (1-6) and replace them with the character values (walking, sitting, etc.)

Next, I extract only those columns with "mean" or "std" in their names (and also the subject and activity columns) into a separate dataframe.

Next, I sort this smaller dataframe by subject, and activity.

Next, I summarize this dataframe by subject and activity, using the summarise_each function to calculate the mean of each variable. This results in the final dataframe containing the tidy data set of 180 rows of 81 variables (30 subjects * 6 activities). 

Finally - I write this dataframe to a file "ProjectTidyDataset.txt"
