library(ggplot2)
library(caret)
library(class)
library(e1071) # NaiveBayes



# data = read.csv(file.choose())
data[data$Over18 == "Y",]
employee_data = data
employee_data$Attrition = as.factor(employee_data$Attrition)
employee_data$Education = as.factor(employee_data$Education)
employee_data$MaritalStatus = as.factor(employee_data$MaritalStatus)
employee_data$JobSatisfaction = as.factor(employee_data$JobSatisfaction)
employee_data$BusinessTravel = as.factor(employee_data$BusinessTravel)
employee_data$Department = as.factor(employee_data$Department)
employee_data$EducationField = as.factor(employee_data$EducationField)
employee_data$EnvironmentSatisfaction = as.factor(employee_data$EnvironmentSatisfaction)
employee_data$Gender = as.factor(employee_data$Gender)
employee_data$JobInvolvement = as.factor(employee_data$JobInvolvement)
employee_data$OverTime = as.factor(employee_data$OverTime)
employee_data$NumCompaniesWorked = as.factor(employee_data$NumCompaniesWorked)
employee_data$PerformanceRating = as.factor(employee_data$PerformanceRating)
employee_data$RelationshipSatisfaction = as.factor(employee_data$RelationshipSatisfaction)
employee_data$StandardHours = as.factor(employee_data$StandardHours)
employee_data$StockOptionLevel = as.factor(employee_data$StockOptionLevel)
employee_data$TrainingTimesLastYear = as.factor(employee_data$TrainingTimesLastYear)
employee_data$WorkLifeBalance = as.factor(employee_data$WorkLifeBalance)
levels(employee_data$Attrition)
levels(employee_data$MaritalStatus)

ggplot(employee_data, aes(x = YearsSinceLastPromotion, fill = Attrition)) +
  geom_density(position = "jitter", alpha = 0.6)


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

trainIndex <- createDataPartition(employee_data$Attrition, p = 0.7, 
                                  list = FALSE, times = 1)
training_set <- employee_data[trainIndex, ]
testing_set <- employee_data[-trainIndex, ]


k <- 5
predicted_attrition <- knn(training_set[, c("Education", "HourlyRate")], 
                           testing_set[, c("Education", "HourlyRate")], 
                           training_set$Attrition, k)


# Evaluate the accuracy of the model
confusion_matrix <- table(predicted_attrition, testing_set$Attrition)
accuracy <- sum(diag(confusion_matrix))/sum(confusion_matrix)

# Print the results
print(confusion_matrix)
print(paste0("Accuracy: ", round(accuracy, 4)))

confusionMatrix(predicted_attrition, testing_set$Attrition)


# Perform Naive Bayes analysis
nb_model <- naiveBayes(Attrition ~ Education + HourlyRate, data = training_set)
predicted_attrition <- predict(nb_model, newdata = testing_set[, c("Education", "HourlyRate")])

# Evaluate the accuracy of the model
confusionMatrix(predicted_attrition, testing_set$Attrition)

