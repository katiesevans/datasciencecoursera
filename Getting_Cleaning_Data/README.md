# README

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R does the following:

* Load the datasets from the UCI HAR Dataset folder
* Combine all the datasets to create one large dataframe with useful labels
* Extracts only the measurements indicating `mean` or `standard deviation` and creates a new dataset
* Creates a final dataset that averages each of these columns for each subject and activity combination.
