
#Formatting input data
d <- data.frame(a=c("1,000", "2,000"))
class(d)
class(d$a)

#We want to sum the numbers and get 3000
sum(c(as.numeric(d$a)))
#as.numeric parses them as 1 and 2 (not 1000 and 2000)

#We substitute commas for empty string
d$a <- as.numeric(gsub(",","",d$a))
#Now the sum adds to 3000
sum(d$a)

#Other related functions
?strsplit
?paste

#User defined functions
#Example, euclidian distance between two points a and b
dis <- function(a,b) {
  return(sqrt(sum((a-b)^2)))
}

# Testing the function (distance should be 5)
dis(c(0,3),c(4,0))


#
# Linear regression
#

#Get the data and merge it
setwd('~/general_assembly/data_science/data/20130612/baseball/')

master <- read.csv('Master.csv')
batting <- read.csv('Batting.csv')
salary <- read.csv('Salaries.csv')

batting_salary <- merge(batting, salary)
data <- merge(master, batting_salary)

nrow(data)

#Filtering data
model.data <- data[,c("HR","RBI","R","G","SB","salary","height","weight","yearID")]
head(model.data)

#Use complete cases to filter the rows that are not complete
model.data <- model.data[complete.cases(model.data),]
head(model.data)

#Linear regression model
model <- lm(salary ~ HR + RBI, data=model.data)
summary(model)

#Training and test data
training <- model.data[model.data$yearID == 2011, ]
test <- model.data[model.data$yearID == 2012, ]

nrow(training)
nrow(test)

#Define mean Square Error function
mse <- function(x, y) {
  mean( (x-y)^2 )
}

#Define mean Absolute Error function
mae <- function(x, y) {
  mean( abs(x-y) )
}

#(The mean square error penalizes the higher errors)

#Let's run the model
model <- lm(salary ~ HR + RBI, data=training)
summary(model)
test.predict <- predict(model, test)

head(test.predict)

plot(test.predict, test$salary)

#Mean absolute error on predictions
mae(test.predict, test$salary)
hist(test$salary)

#We add more variables to model
model <- lm(salary ~ HR + RBI + R + G, data=training)
test.predict <- predict(model, test)
mae(test.predict, test$salary)
#MAE has decreased but its still high

#Looking at hist(test$salary) we see that there are many salaries on the lower range and a long tail
#We want to have data better distributed across the test cases
#We can apply transformations to the data so that it looks closer to a normal distribution
hist(log(test$salary))

#Let's use the log transformation in our model
model <- lm(log(salary) ~ HR + RBI + R + G, data=training)
test.predict <- predict(model, test)
#When evaluating the error, we need to "de-transform" the predictions
mae(exp(test.predict), test$salary)

#Let's try to see if having played > 50 games is relevant
model.data$Games50 <- (model.data$G > 50)
head(model.data)



#If we add correlated polynomial variables (G square)
model <- lm(salary ~ HR + RBI + R + G + G^2, data=training)
test.predict <- predict(model, test)
mae(test.predict, test$salary)

#Regularization
install.packages("glmnet")
library('glmnet')

#Use regularization when training
model.reg <- glmnet(as.matrix(training[,c('HR','RBI')]), as.matrix(training$salary))
#See the default lamda
summary(model.reg)

#Specifying the lambda
test.reg <- predict(model.reg, as.matrix(test[,c('HR','RBI')]), s=0.01)
head(test.reg)

#To optimize the lambda chosen:
#Applying cross validation
model.reg <- cv.glmnet(as.matrix(training[,c('HR','RBI')]), as.matrix(training$salary))
summary(model.reg)
test.reg <- predict(model.reg, as.matrix(test[,c('HR','RBI')]), s=model.reg$lambda.min)

head(test.reg)


