# ==============================================================================
# General Assembly - Data Science - Homework assignement #2
# Author: Marc Kirchner    Date: 2013 06 23
# 
# Regression assignment: predict salaries based on job descriptions
#
# Note: I couldn't use the big files for training. My computer was taking too 
# long to even load the CSVs.
# As an exercise, I just used the small training data set. 
# I selected a limited number of features to test the different outputs. 
# I joined the location tree and also selected a limited number of locations 
# to be used as features to improve the model. 
# So I don't submit predictions, just the R code I've been using. 
# ==============================================================================

setwd('~/general_assembly/data_science/git/cloned/arahuja/GADS4/data/kaggle_salary')

# --------------------------------------------
# 1 - Split the data into training and test sets
# --------------------------------------------
salaries <- read.csv('train.csv', header=TRUE)
#names(salaries)

#Generate random index
train.idx <- sample(1: nrow(salaries), .7*nrow(salaries))

#Extract features from the raw data
#We have 28 different job categories exist in the data
unique(salaries$Category)

#Create a feature for some categories
salaries$Engineering <- grepl("Engineering", salaries$Category)
salaries$Accounting <- grepl("Accounting", salaries$Category)
salaries$IT <- grepl("IT", salaries$Category)
salaries$Hospitality <- grepl("Hospitality", salaries$Category)
salaries$Graduate <- grepl("Graduate", salaries$Category)
#Permanent Contract?
salaries$Permanent <- salaries$ContractTime == 'permanent'
#Location is in London?
salaries$London <- grepl("London", salaries$LocationRaw) 

#Training / Test sets
training <- salaries[train.idx,]
test <- salaries[-train.idx,]

# ----------------------------------------
# 2 - Build simple linear regression model
# ----------------------------------------
#Define mean Absolute Error function
mae <- function(x, y) {
  mean( abs(x-y) )
}

#Define simple model and test it
model <- lm(SalaryNormalized ~  Engineering + Accounting + IT + Hospitality + Graduate + Permanent + London, data=training)
test.predict <- predict(model, test)

summary(model)
mae(test.predict, test$SalaryNormalized)
#For this model we get
# ~0.174  R Squared
# ~10235   MAE


# --------------------------------------------
# 3 - Build model with cross validation: cv.lm
# --------------------------------------------
install.packages('DAAG')
library('DAAG')
model.cv <- cv.lm(df=training, form.lm = formula(model), m=4)
#How to calculate MAE?



# ---------------------------
# 4 - Merge Location_Tree.csv
# ---------------------------
location.tree <- read.csv('~/general_assembly/data_science/git/kircm/ga_data_science/hw2/Location_Tree2.csv', header=FALSE)
salaries_location <- merge(salaries, location.tree, by.x="LocationNormalized", by.y="V3")

unique(salaries_location$V2)

salaries_location$Engineering <- grepl("Engineering", salaries_location$Category)
salaries_location$Accounting <- grepl("Accounting", salaries_location$Category)
salaries_location$IT <- grepl("IT", salaries_location$Category)
salaries_location$Hospitality <- grepl("Hospitality", salaries_location$Category)
salaries_location$Graduate <- grepl("Graduate", salaries_location$Category)
#Permanent Contract?
salaries_location$Permanent <- salaries_location$ContractTime == 'permanent'
#Location is in London?
salaries_location$London <- salaries_location$V2 == 'London'
#Location is in Scotland?
salaries_location$Scotland <- salaries_location$V2 == 'Scotland'

#Location is in Northern Ireland?
salaries_location$NorthernIreland <- salaries_location$V2 == 'Northern Ireland'
#Location is in South East England ?
salaries_location$SouthEastEngland  <- salaries_location$V2 == 'South East England'

train.idx <- sample(1: nrow(salaries_location), .7*nrow(salaries_location))
training <- salaries_location[train.idx,]
test <- salaries_location[-train.idx,]

model <- lm(SalaryNormalized ~  Engineering + Accounting + IT + Hospitality + Graduate + Permanent + London + Scotland + NorthernIreland + SouthEastEngland, data=training)
test.predict <- predict(model, test)

summary(model)
mae(test.predict, test$SalaryNormalized)
#For this model we get
# ~0.176  R Squared
# ~9956    MAE



