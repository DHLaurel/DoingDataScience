library(ggplot2)
library(caret)
library(class)
library(e1071) # NaiveBayes


set.seed(9)

data = read.csv("./CaseStudy2-data.csv")
data[data$Over18 == "Y",]
employee_data = data
employee_data$Attrition = as.factor(employee_data$Attrition)


# Single Greatest predictor -- MonthlyIncome
ggplot(employee_data, aes(x = MonthlyIncome, fill = Attrition)) +
  geom_density(position = "jitter", alpha = 0.6)




# Stratified Sampling -- there are way too many False values
# load required libraries
library(dplyr)
library(tidyr)

# create a new column with strata based on "Attrition" values
employee_data <- employee_data %>%
  mutate(strata = ifelse(Attrition == "Yes", "Yes", "No"))

# create a table to check the frequency of each stratum
table(employee_data$strata)

# take a random sample of 100 observations from each stratum
sample_data <- employee_data %>%
  group_by(strata) %>%
  sample_n(size = 80)

# remove the strata column from the sample dataset
sample_data <- sample_data %>%
  select(-strata)

employee_data <- employee_data %>%
  select(-strata)


#ggplot(employee_data, aes(x = "", y = Attrition, fill = Attrition )) +
#  geom_col() +
#  coord_polar(theta="y")

ggplot(sample_data, aes(x = "", y = Attrition, fill = Attrition )) +
  geom_col() +
  coord_polar(theta="y")



# Potential predictors
## Strong: 
### TotalWorkingYears yy
### OverTime yy
### StockOptionLevel yy
### DistanceFromHome yy
### NumCompaniesWorked yy
### YearsAtCompany y
### YearsInCurrentRole y 
### JobSatisfaction y
### EnvironmentSatisfaction y
### MonthlyIncome y
### YearsWithCurrManager y

#### For the rates, you would assume a greater correlation with monthly income, but this doesn't appear to be the case
#### Perhaps this data is incorrect
### DailyRate yy
### MonthlyRate y
### HourlyRate y --interesting density graph



## Medium:
### PercentSalaryHike
### TrainingTimesLastYear
### WorkLifeBalance


## Weak:
### YearsSinceLastPromotion



### Gender



# Useless data
## Over18
## EmployeeCount
## EmployeeNumber
## StandardHours
## 

formulate <- function(test_column, prediction_columns)
{
  f_str <- paste(test_column, " ~ ")
  for (i in 1:length(prediction_columns))
  {
    if (i == length(prediction_columns)){
      f_str <- paste(f_str, prediction_columns[i])
    }
    else{
      f_str <- paste(f_str, prediction_columns[i], " + ")
    }
  }
  as.formula(f_str)
}



# trainIndex <- createDataPartition(sample_data$Attrition, p = 0.7, 
#                                   list = FALSE, times = 1)
training_set <- sample_data
testing_set <- employee_data
# testing_set <- sample_data[-trainIndex, ]


prediction_columns <- c("TotalWorkingYears", "DistanceFromHome", "StockOptionLevel", "NumCompaniesWorked", "YearsAtCompany", "YearsInCurrentRole", "JobSatisfaction", "TrainingTimesLastYear")
# prediction_formula <- formulate("Attrition", prediction_columns)
prediction_formula <- as.formula("Attrition~.")


k <- 5
predicted_attrition <- knn(training_set[, prediction_columns], 
                           testing_set[, prediction_columns], 
                           training_set$Attrition, k)


confusionMatrix(predicted_attrition, testing_set$Attrition)


# Perform Naive Bayes analysis
nb_model <- naiveBayes(prediction_formula, data = training_set)
predicted_attrition <- predict(nb_model, newdata = testing_set[, prediction_columns])

# Evaluate the accuracy of the model
confusionMatrix(predicted_attrition, testing_set$Attrition)


##----------##


# Determine the three predictive variables
library(infotheo)

# create a formula for the outcome variable and predictor variables
formula <- as.formula("Attrition ~ .")

# create a training dataset and testing dataset
trainIndex <- createDataPartition(employee_data$Attrition, p = 0.7, list = FALSE)
training_set <- data[trainIndex, ]
test_set <- data[-trainIndex, ]

# calculate mutual information for each predictor variable
mi <- apply(training_set[, -which(names(training_set) == "Attrition")], 2, function(x) infotheo::mutinformation(x, training_set$Attrition))

# select the top three variables based on mutual information -- Top 3: MonthlyIncome, MonthlyRate, DailyRate
top_three_vars <- names(sort(mi, decreasing = TRUE))
top_three_vars








##----------------##

# Monthly Income Linear Regression
# Determine likely factors to predict MonthlyIncome
mi2 <- apply(employee_data[, -which(names(employee_dat) == "MonthlyIncome")], 2, function(x) infotheo::mutinformation(x, employee_data$MonthlyIncome))
names(sort(mi2, decreasing = TRUE))


# load required libraries
library(dplyr)
library(ggplot2)
library(Metrics)

# create a training dataset and testing dataset
set.seed(123)
# trainIndex <- createDataPartition(employee_data$YearsAtCompany, p = 0.7, list = FALSE)
lm_train <- employee_data[trainIndex, ]
lm_test <- employee_data[-trainIndex, ]

# fit a linear regression lm_model with MonthlyIncome as the predictor variable
lm_model <- lm(MonthlyIncome ~ Age + DailyRate + YearsAtCompany, data = lm_train)

# calculate the predictions for the testing set
predictions <- predict(lm_model, newdata = lm_test)

# calculate the RMSE
rmse <- rmse(predictions, lm_test$MonthlyIncome)

# view the RMSE
rmse

ggplot(employee_data, aes(x = Age, y = MonthlyIncome)) +
  geom_point() +
  geom_abline(slope= 2.0, intercept = 0, col="cyan", se = TRUE)
  # geom_smooth(method = "lm", se = FALSE, formula = y ~ 5 + x * 2.0 )

##-----------------##

# Generate Prediction Files

# Attrition Prediction
attr_pred_dat = read.csv('./CaseStudy2CompSet No Attrition.csv')
pred_test_set <- attr_pred_dat
predicted_attrition2 <- knn(training_set[, prediction_columns], 
                            pred_test_set[, prediction_columns], 
                            training_set$Attrition, k)
attr_pred_out = attr_pred_dat
attr_pred_out$Attrition = predicted_attrition2


inc_pred_dat = read.csv('./CaseStudy2CompSet No Salary.csv')
pred_test_set <- inc_pred_dat
predicted_inc <- predict(lm_model, pred_test_set)

inc_pred_out = inc_pred_dat
inc_pred_out$MonthlyIncome = as.numeric(predicted_inc)

ggplot(inc_pred_out, aes(x=Age, y=DailyRate)) +
  geom_point(position="jitter") + 
  geom_smooth(method="lm")


write.csv(attr_pred_out, file="./Case2PredictionsLaurel Attrition.csv", row.names = FALSE)
write.csv(inc_pred_out, file="./Case2PredictionsLaurel Salary.csv", row.names = FALSE)

##-----------------##

