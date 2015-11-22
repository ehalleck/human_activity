# This R-script is part of a coursera course. 
# We have been given data collected from smart phones and
# have been given a series of tasks to create a tidy data set
# where the test and training data have been merged.
# First read in all the data files needed:
activity_labels=read.table("activity_labels.txt")
features=read.table("features.txt")
subject_train=read.table("train/subject_train.txt")
subject_test=read.table("test/subject_test.txt")
X_train=read.table("train/X_train.txt")
X_test=read.table("test/X_test.txt")
y_train=read.table("train/y_train.txt")
y_test=read.table("test/y_test.txt")
# Next, merge vertically the training and test data 
# for the subject, X and y variables, respectively:
subject=rbind(subject_train,subject_test)
X=rbind(X_train,X_test)
y=rbind(y_train,y_test)
# as a preliminary to creating one large data frame,
# add labels for subject,  y "activity" and X (using "features" file)
names(subject)<-"subject"
names(y)<-"activity"
names(X)<-features[,2]
# now identify the columns that contain "mean" and "std"
meancols=grep("*-mean()+",features[,2])
stdcols=grep("*-std()+",features[,2])
cols=union(meancols,stdcols)
# and subset the "X" data frame
X=X[,cols]
# merge the subject, y (activity) and X data_frames
unify=cbind(subject,y,X)
# finally we create the summary data frame using dplyr
library(dplyr)
# we filter the data for each subject and activity
# and each time, find the mean for the data using colMeans
summary=data.frame(matrix(ncol = 81, nrow = 0))
for (i in 1:30){
  tmp=filter(unify,subject==i)
  for (j in 1:6){
    stmp=filter(tmp,activity==j)
    summary=rbind(summary,colMeans(stmp))
    }
}
names(summary)=names(unify)
write.table(summary,"summary.txt",row.name=FALSE)