# ALS_progression_prediction
## Introduction
Amyotrophic Lateral Sclerosis (ALS) is a kind of disease that involves the death and degeneration of the nerve cells in the brain and spinal cord. Prognosis of ALS is heterogeneous. So progression prediction allows significant contribution for patient care. This Dream sub challenge is to fit the model developed using 0-3 months clinical trial dataset to 3-12 months progression and the broader ALS population. We cannot get access to broader ALS data, just focused on the 1st task.
<br>
## Methods
We applied random forest, GBM models. Prediction of 3-12 months ALS slope performed better of random forest than gbm, with around RMSE 0.094 and 0.043 for cluster1 and cluster2. (R studio)
<br>
## Directory usage
machine learning project 2018 Fall
<br>
R codes are included in 2 RMarkdown files
<br>
PROACT is the  Amyotrophic Lateral Sclerosis clinical trials data directory
<br>
Results and cvs are in files directory
<br>
## Data preprocessing
PROACT dataset has 13 csv files, which contains from over 10,000 ALS patients from 23 completed clinical trials. What we need is the trial information taken between 0-3 months, then select significant features that contribute to ALS progression, resulting in good prediction for 3-12 months ALS progression. Final dataset after processing contains 3637 patients and 50 features, saved as ALS_Slope_FINAL3.csv in directory "files".
<br>
**Process rules**
>1. Filter PROACT data whose delta is less than 91 for each csv file
>2. Remove variables that have more than 75% missing values
>3. Computed the mean for variables that have multiple values for the same patient (e.g. glucose level at different time points)
>4. Impute missing data using the Multivariate Imputation by Chained Equations (MICE) via cart method in the mice library
>5. Only keep ALSFRS_Total, not ALSFRS_R_Total. ALSFRS_Total and ALSFRS_Delta were used to calculate the ALSFRS_Slope
<br>
**References:**
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5099532/pdf/ACN3-3-866.pdf
