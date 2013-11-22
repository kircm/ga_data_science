#
# Notes about hw2
#

setwd('~/general_assembly/data_science/git/cloned/arahuja/GADS4/data/kaggle_salary')


#Read in separate train and test files
train <- read.csv("train.csv")
test <- read.csv("test.csv")

#Combine them for the columns we want to use as predictors in our model
all <- rbind(train[, "Category", drop=F], test[, "Category", drop=F])

# Explicitly construct all the dummy columns for the Category variable
allx <- model.matrix(~Category, data=all)

#Split out the training and test data, adding in the response variable
trainer <- cbind(as.data.frame(allx[1:10000,]), train[,"SalaryNormalized"])
tester <- cbind(as.data.frame(allx[10001:15000,]), data.frame(SalaryNormalized=NA))


# Now we can train and predict our model, and we have no NA predictions
model <- lm(SalaryNormalized ~ . -1, data=trainer)
pred <- predict(model, tester)

