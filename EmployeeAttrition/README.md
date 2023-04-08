# Introduction

This report summarizes the findings of an analysis on employee attrition
and monthly income prediction. The analysis focuses on the following
topics:

-   How to deal with noisy data with unbalanced Attrition responses --
    Stratified Sampling
-   Top 5 Factors to Predict Attrition
-   Comparison of Models
    -   KNN Model
    -   Naive Bayes Model
-   Predicting Monthly Income
-   Linear Regression Model

# Stratified Sampling

During the Exploratory Data Analysis phase of our investigation, we
determined there were several issues with the noise of the provided
dataset. There were far more employees which had not experienced
Attrition than those who had. This fact grievously affected our
sensitivity and specificity rates, and yielded poorer models overall.

To deal with the unbalanced Attrition responses, we have used stratified
sampling to create a more balanced dataset for model training. The
stratified sampling ensures that we have a more equal representation of
both "Yes" and "No" Attrition responses in our training data. This helps
to improve the model's performance when dealing with an unbalanced
dataset.

# Top 5 Factors to Predict Attrition

Although it was difficult to see visually, we were able to rely on an
external package called Infotheo, which we used to perform a Mutual
Information assessment on columns and their relationship with Attrition.
This Mutual Information checks for shared sets, and compares the
difference between joint distributions and marginal distributions for
each column when compared with Attrition.

Based on this analysis, we were able to determine the first several
factors were:

-   MonthlyRate

-   MonthlyIncome

-   DailyRate

-   HourlyRate

-   Age

-   TotalWorkingYears

-   Overtime

Since several of these broke into Pay Rates, we determined to label this
group as Pay Rates, and consider our top 3 factors to determine
Attrition:

-   Monthly Income

-   Pay Rate

-   Age

# Attrition Predictive Models

From here, we wanted to determine the accuracy, specificity and
sensitivity for which we could predict an employee's likely Attrition.
These factors would help determine our discrete predictions for future
employees.

## K-Nearest Neighbors

For the K-Nearest Neighbors approach, we were able to achieve an
accuracy of 64%, with a sensitivity of 64.5% and a specificity of 62.9%.

## Naïve-Bayes

Using a Naïve-Bayes approach, we were able to achieve an accuracy of
63%, with a sensitivity of 60.1% and a specificity of 76.4%. However,
since the K-Nearest Neighbors approach achieved a higher overall
accuracy, we determined to primarily use this one for the remainder of
our investigations.

# Monthly Income Linear Regression

Since Monthly Income was identified as a primary predictor for employee
attrition, we wanted to determine if we could predict an employee's
monthly income as a response to the various other data collected on the
employee. Using a simple linear regression, we were able to achieve an
Root Mean Square Error (RMSE) of \$3,911. This means that, on average,
the predicted salaries by the model deviate from the actual salaries by
approximately \$3,911.

Although the top 3 factors associated with Monthly Income were Pay Rate
and Age, we found better results from using alternative variables (Age,
Daily Rate, Years At Company) in our model:

$MonthlyIncome = {-3.16}e3 + (1.998e2)Age + (6.93e{-2})DailyRate + (3.08e2)YearsAtCompany$

# External Resources

-   <a href="https://dhlaurel.shinyapps.io/EmployeeSalaryAttrition/">RShiny
    App</a>
-   Video Presentation
