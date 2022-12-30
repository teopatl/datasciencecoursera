library(dplyr)
library(data.table)

features_path <- "./UCI HAR Dataset/features.txt"
activities_path <- "./UCI HAR Dataset/activity_labels.txt"
X_test_path <- "./UCI HAR Dataset/test/X_test.txt"
y_test_path <- "./UCI HAR Dataset/test/y_test.txt"
subj_test_path <- "./UCI HAR Dataset/test/subject_test.txt"
X_train_path <- "./UCI HAR Dataset/train/X_train.txt"
y_train_path <- "./UCI HAR Dataset/train/y_train.txt"
subj_train_path <- "./UCI HAR Dataset/train/subject_train.txt"
subj_test_path <- "./UCI HAR Dataset/test/subject_test.txt"


x_test_tbl <- tbl_df(read.table(X_test_path))
y_test <- tbl_df(read.table(y_test_path))
x_train_tbl <- tbl_df(read.table(X_train_path))
y_train <- tbl_df(read.table(y_train_path))
features <- read.table(features_path)
activities <- read.table(activities_path)
subj_train <- read.table(subj_train_path)
subj_test <- read.table(subj_test_path)

subj <- rbind(subj_train,subj_test)

X_tbl <- rbind(x_train_tbl,x_test_tbl)
colnames(X_tbl) <- features[,2]
X_pruned_names <- names(X_tbl) %>% grep(pattern="mean|std", value=TRUE)
X_mean_std <- select(X_tbl, X_pruned_names)

y_tbl <- rbind(y_train,y_test)
y_labeled <- c(1:nrow(y_tbl))
for(i in 1:nrow(y_tbl)){
  key <- y_tbl[[i,1]]
  val <- activities[[key,2]]
  y_labeled[[i]] <- val
}
complete_tbl <- cbind(subj,y_labeled,X_mean_std)
colnames(complete_tbl)[colnames(complete_tbl) %in% c("V1","y_labeled")]<-c("Subject","Actvity")