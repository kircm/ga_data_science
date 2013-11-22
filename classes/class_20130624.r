# -----------------------
# HW2 R notes from Aaron
# -----------------------

#Define mean Absolute Error function
mae <- function(x, y) {
  mean( abs(x-y) )
}

setwd('~/general_assembly/data_science/git/cloned/arahuja/GADS4/data/kaggle_salary')

alltrain <- read.csv('train.csv')
set.seed(42)

# 90% 10% split  (we test on fold #3 only (out of 10))
alltrain$fold <- sample(1:10, nrow(alltrain), replace=TRUE)
train <- subset(alltrain, fold != 3)
test <- subset(alltrain, fold == 3)

# Stupid model: 0 prediction all the time. What's the error?
mae(0, train$SalaryNormalized)
# It's close to the mean of all the salaries

# How does the data look?
hist(train$SalaryNormalized)
hist(test$SalaryNormalized)
hist(alltrain$SalaryNormalized)

#Dumb model - only one coefficient, the intercept, fixed to 1 
model <- lm(SalaryNormalized ~ 1, data=train)
summary(model)
# The estimate will be always the mean
mean(train$SalaryNormalized)

#Training Error:
mae(fitted(model), train$SalaryNormalized) 
# The training error approaches zero the more we fit our model to the training set (we could be over-fitting if it's too low)
# Approach: compare training error with test error
# In this dumb model all the predictions are the mean salary

#Test set error: 
#It's higher than training error, it has more data
mae(predict(model, test), test$SalaryNormalized) 


# How consistent is the error across folds?
error_from_fold <- function(n) {
  model <- lm(SalaryNormalized ~ 1, data=subset(alltrain, fold != n))
  test <- subset(alltrain, fold == n)
  error <- mae(predict(model, test), test$SalaryNormalized)
  return(error)
}

#Error when using fold 3
error_from_fold(3)
#Error when using fold 4
error_from_fold(4)

#all the folds at once
sapply(1:10, error_from_fold)
#the mean of all the errors
mean(sapply(1:10, error_from_fold))



# When the exercise is done, make preductions on the actual test data and submit
realtest <- read.csv("test.csv")
finalmodel <- lm(SalaryNormalized ~ 1, data=train)
predictions <- predict(finalmodel, realtest)
submission <- data.frame(Id=realtest$Id, Salary=predictions)
write.csv(submission, file = "submission.csv")


#Dealing with glmnet
library(glmnet)
model <- cv.glmnet(matrix(train$ContractType, matrix(train$SalaryNormalized)))
# FAIL

# You have to do:
model <- cv.glmnet(model.matrix(~train$ContractType), matrix(train$SalaryNormalized))
# The cross validation happening here is not the one we want to do  in the exercise (in order to validate model on different trainig/test sets)
as.vector(predict(model, model.matrix(~test$ContractType), s="lambda.min"))
                   
# What's the MAE now
mae(as.vector(predict(model, model.matrix(~test$ContractType), s="lambda.min")), test$SalaryNormalized)


# Let's transform to make the salaries look more as a normal distribution 
# (using the dummy model as an example)
hist(train$SalaryNormalized)  # Doesn't look very normal
hist(log(train$SalaryNormalized))  # Looks more normmal
# We apply log() to the salaries when training
model <- lm(log(SalaryNormalized) ~ 1, data=train)
# We do the inverse of log when evaluation the error against the salaries
# Training error
mae(exp(fitted(model)), train$SalaryNormalized)
# Test error
mae(exp(predict(model, test)), test$SalaryNormalized)


# -----------------------
# Aaron: Report generation
# -----------------------
install.packages('knitr')
library(knitr)
(create a markdown R file)



# ----------
# Aaron
# Logistic regression
# odds ratio
# ---------
data(iris)
iris$sep <- factor(ifelse(iris$Sepal.Length > 6, "big", "small"))
iris$pet <- factor(ifelse(iris$Petal.Length > 4, "long", "short"))
(counts <- with(iris, table(sep, pet)))

#logistic regression model
model <- glm(pet ~ sep, data=iris, family=binomial)
coef(model)

# So what are we modeling? What are the predictions we get back?

# log odds
(logodds <- predict(model)[49:52])
# probability
(probs <- predict(model, type="response")[49:52])
# log odds relation to probability
exp(logodds) / (1 + exp(logodds))
# And this is the probability we mean:
prop.table(counts, 1)

# In a simple case, the logistic regression gives us the same probabilities that we calculated
# In logistic regression, we get the log odds
# The coefficient are the log od the odd ratios

# could do odds if we wanted to:
exp(logodds)
# and it corresponds to our probabilities like it should
probs / (1 - probs)

# What about the coefficients on the model?
coef(model)

# log odds ratio
coef(model)
# odds ratio
exp(coef(model))

# This is what the coefficients are (for this simple case):
# log odds ratio for short petals given small sepals
with(iris, log(((sum(pet=="short" & sep=="small") / sum(sep=="small")) /
                  (1 - sum(pet=="short" & sep=="small") / sum(sep=="small"))) /
                 ((sum(pet=="short" & sep=="big") / sum(sep=="big")) /
                    (1 - sum(pet=="short" & sep=="big") / sum(sep=="big")))))



# ----------------------
# Arun - logistic regression
# ----------------------

#Logistic regression
# Classification of beers
beer <- read.csv('http://www-958.ibm.com/software/analytics/manyeyes/datasets/af-er-beer-dataset/versions/1.txt', header=TRUE, sep='\t')

# Assign 'good' label
#Beer is good when WR falls in the top quantile (4.36)
beer$good <- beer$WR > 4.36

# Features
beer$IPA <- grepl("IPA", beer$Type)
beer$Stout <- grepl("Stout", beer$Type)
beer$Pilsner <- grepl("Pilsner", beer$Type)
beer$Lager <- grepl("Lager", beer$Type)
beer$Ale <- grepl("Ale", beer$Type)
beer$Belgian <- grepl("Belgian", beer$Type)

train.idx <- sample(1: nrow(beer), .7*nrow(beer))
training <- beer[train.idx,]
test <- beer[-train.idx,]


#We use glm to build the model
model <- glm(good ~ IPA + Stout + Lager + Belgian + Pilsner, data=training, family='binomial')
summary(model)

#Making predictions using the test set
test.predict <- predict(model, test, type='response')
head(test.predict)
#It shows the probability of each element in the test set of being "good" beer (we have 75 beer types used as test elements) 

#Making predictions using a threshold of 50% 
test.labels <- test.predict > 0.5
head(test.labels)

#Library ROCR - accuracy
install.packages('ROCR')
library('ROCR')

pred <- prediction(test.predict, test$good)
perf <- performance(pred, measure='acc')
plot(perf)


#How good is the classifier classifying beers when using different thresholds to separate good vs bad
#Performace tells how accurate it is but doesn't give details about what situations is the classifier doing better
#Better measure: precision
#what's the risk of positive predictions when the outcome should be negative?
#what's the risk of negative predictions when the outcome should be positive?

# positive predictive value
perf <- performance(pred, measure='ppv') #Precision
plot(perf)

# false negative rate
perf <- performance(pred, measure='fnr')
plot(perf)

#More info:
?performance

# Recall
perf <- performance(pred, measure='rec') 
plot(perf)
# True positive rate - 

# Do we care more about positive rate or negative rate? Precision vs Recall
perf <- performance(pred, measure='f')
plot(perf)


# Show the cutoff that would separate good precision/bad recall  from  bad precision/good recall
perf <- performance(pred, measure='auc')
perf

# Output
#Slot "y.values":
#  [[1]]
#[1] 0.5631818



