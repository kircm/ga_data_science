#
# Notes about hw2
#
#Define mean Absolute Error function
mae <- function(x, y) {
  mean( abs(x-y) )
}

setwd('~/general_assembly/data_science/git/cloned/arahuja/GADS4/data/kaggle_salary')
salaries <- read.csv('train.csv', header=TRUE)

#Training / Test sets
train.idx <- sample(1: nrow(salaries), .7*nrow(salaries))
training <- salaries[train.idx,]
test <- salaries[-train.idx,]

#Using simple lm - automatically converting category columns into Boolean columns (n-1 columns)
model <- lm(SalaryNormalized ~ Category + ContractTime, data=training)
test.predict <- predict(model, test)
summary(model)
mae(test.predict, test$SalaryNormalized)

#Using glmnet with feature interactions
library(glmnet)
model <- cv.glmnet(model.matrix(~training$ContractType:training$Category), matrix(training$SalaryNormalized))
mae(as.vector(predict(model, model.matrix(~test$ContractType:test$Category), s="lambda.min")), test$SalaryNormalized)


# ---------------------------------------------------------
# Arun's class
# ---------------------------------------------------------

# Naive Bayes
# -----------

beer <- read.csv('http://www-958.ibm.com/software/analytics/manyeyes/datasets/af-er-beer-dataset/versions/1.txt', header=TRUE, sep='\t')
beer$good <- beer$WR > 4.36
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

# Using naive Bayes:
install.packages("e1071")
library('e1071')

?naiveBayes

# Training model
model <- naiveBayes(good ~ IPA + Stout + Lager + Belgian + Pilsner, data=training)
model
summary(beer$good)

# Testing
?predict.naiveBayes
predict(model, test, type="")

