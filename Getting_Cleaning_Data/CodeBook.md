# Code Book

This is a code book that describes the variables, data, and transformations or work to clean the data

# Variables
* `subject_train`- original dataframe that contains the training subjects
* `xtrain`- original dataframe that contains the training set
* `ytrain`- original dataframe that contains the training labels
* `subject_test`- original dataframe that contains the testing subjects
* `xtest`- original dataframe that contains the testing set
* `ytest`- original dataframe that contains the testing labels
* `features`- original dataframe that provides a list of all features
* `activity`- original dataframe that links the class labels with their activity name

* `x`- combines xtest and xtrain datasets
* `y`- combines ytest and ytrain datasets
* `y_activity`- adds activity labels to y
* `y_subjects`- add subject number to y
* `complete_df`- combines all datasets in to one large full dataset
* `features_wanted`- list of all features representing mean or std
* `non_duplicated_data`- gets rid of duplicated columns in the complete_df
* `meanstd`- tidy dataset containing only features of mean/std
* `average_df`- tidy dataset with average of each mean/std feature for each subject and activity group.
