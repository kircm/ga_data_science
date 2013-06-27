# ==============================================================================
# General Assembly - Data Science - Homework assignement #2
# Author: Marc Kirchner    Date: 2013 06 23
# 
# Regression assignment: predict salaries based on job descriptions
# Note: I had problems with memory allocation and processing power 
# when trying to use files bigger than train.csv. Example: when
# merging with the location tree. Even with that file I had to trim down 
# the data a bit to avoid memory allocation problems when using glmnet. 
# ==============================================================================
#Define mean Absolute Error function
mae <- function(x, y) {
  mean( abs(x-y) )
}

setwd('~/general_assembly/data_science/git/cloned/arahuja/GADS4/data/kaggle_salary')
salaries <- read.csv('train.csv', header=TRUE)
#names(salaries)
#head(salaries)


#We add columns for specific words showing in some of the original columns
salaries$LondonInDescription <- grepl("London", salaries$FullDescription)
salaries$CompetitiveInDescription <- grepl("Competitive", salaries$FullDescription)
salaries$BenefitsInDescription <- grepl("Benefits", salaries$FullDescription)

#For memory reasons I decided to drop some of the original columns. In a real scenario I would dedicate 
#more time and resources to try to extract as many features as possible from the data
salaries <- subset(salaries, select = -c(FullDescription, SalaryRaw, LocationRaw, Title, Company, SourceName))

# --------------------------------------------
# 1 - Split the data into training and test sets
# --------------------------------------------
train.idx <- sample(1: nrow(salaries), .7*nrow(salaries))
training <- salaries[train.idx,]
test <- salaries[-train.idx,]

# ----------------------------------------
# 2 - Build simple linear regression model
# ----------------------------------------
#Define simple model and test it
model <- lm(SalaryNormalized ~  Category + ContractType + ContractTime + LondonInDescription + CompetitiveInDescription + BenefitsInDescription, data=training)
test.predict <- predict(model, test)

summary(model)
mae(test.predict, test$SalaryNormalized)
#For this model we get
# ~0.21    R Squared
# ~10200   MAE


# --------------------------------------------
# 3 - Build model with cross validation: cv.lm
# --------------------------------------------
#install.packages('DAAG')
#library('DAAG')
#model.cv <- cv.lm(df=training, form.lm = formula(model), m=4)
#How to calculate MAE?



# ---------------------------
# 4 - Merge Location_Tree.csv
# ---------------------------
location.tree <- read.csv('~/general_assembly/data_science/git/kircm/ga_data_science/hw2/Location_Tree2.csv', header=FALSE)

# Merge the data
salaries_location <- merge(salaries, location.tree, by.x="LocationNormalized", by.y="V3")

# Model
train.idx <- sample(1: nrow(salaries_location), .7*nrow(salaries_location))
training_merged <- salaries_location[train.idx,]
test_merged <- salaries_location[-train.idx,]

model_merged <- lm(SalaryNormalized ~  Category + ContractTime +  Category + ContractType + ContractTime + LondonInDescription + CompetitiveInDescription + BenefitsInDescription + V2, data=training_merged)
test.predict <- predict(model_merged, test_merged)

summary(model_merged)
mae(test.predict, test_merged$SalaryNormalized)
#For this model we get
# ~0.25  R Squared
# ~9500    MAE


# ---------------------------
# 5 - Use glmnet
# Note: I had to remove some features to avoid memory allocation problems
# I couldn't use the merged data either
# ---------------------------
#library(glmnet)
#model <- cv.glmnet(model.matrix(~training$Category:training$ContractTime:training$Category:training$ContractType:training$ContractTime:training$LondonInDescription), matrix(training$SalaryNormalized))
#test.predict <- as.vector(predict(model, model.matrix(~test$Category:test$ContractTime:test$Category:test$ContractType:test$ContractTime:test$LondonInDescription), s="lambda.min"))
#mae(test.predict, test$SalaryNormalized)
#For this model we get
# ~10000    MAE



# ------------------
# Output predictions
# ------------------
# When the exercise is done, make preductions on the actual test data and submit
realtest <- read.csv("test.csv")

#Some category values are present in the realtest but missing in the small training file
for (j in c("Category")) {
  i = which( !(realtest[[j]] %in% levels(training[[j]])))
  realtest[i,j] <- NA
}

#Add the extra columns we created in training
realtest$LondonInDescription <- grepl("London", realtest$FullDescription)
realtest$CompetitiveInDescription <- grepl("Competitive", realtest$FullDescription)
realtest$BenefitsInDescription <- grepl("Benefits", realtest$FullDescription)

#Make the predictions
predictions <- predict(model, realtest)

#Submission 
submission <- data.frame(Id=realtest$Id, Salary=predictions)
write.csv(submission, file = "~/general_assembly/data_science/git/kircm/ga_data_science/hw2/submission.csv")

