# Logistic_Regression_of_Breast_Cancer_Data

This project has two logistic regression models: one with all attributes and one with five attributes. The reason the second model is tested because some attributes are dependent upon one another. The data can be downloaded from https://www.kaggle.com/uciml/breast-cancer-wisconsin-data and saved as data.csv. Upon downloading and renaming the file, execute the following line to convert the diagnosis response to a binary format:

python text_read.py

From there, run either R scripts using the following command to execute the model:

Rscript [File].R

You will notice that the DIC for the logistic_regression_all_attributes.R model outputs a NaN in the penalty. This is probably because of the dependencies between attribute. However, this is not the case for the second model called logistic_regression_selected_attributes.R. The classification success rate for both models is roughly 0.95. 
