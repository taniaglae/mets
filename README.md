# Machine and Deep Learning Applied to PredictMetabolic Syndrome without a Blood Screening

## Authors: Guadalupe O. Gutiérrez-Esparza, Tania A. Ramírez-delReal, Mireya Martínez García, Oscar Infante Vázquez, Maite Vallejo, José Hernández-Torruco 

## MetS

This work aims to identify the most relevant features to propose a risk predictor for the early detection of people with MetS (metabolic syndrome) through machine learning algorithms and deep learning.

There are two files with example data for women and men; when the experiment proposes a complete dataset, a merge of both is needed.

The code in METS_DL.ipynb is set to train the proposed deep learning model for each *.csv.

The code has three different selections for each experiment; with the features selected by Pearson Coefficient (features_PCC), Random Forest(features_RF), and importance in each category (features_category), it is crucial to passing this variable to experiment.  

The variable SM_ATPIII indicates the existence of metabolic syndrome, and it is the target value to predict.
