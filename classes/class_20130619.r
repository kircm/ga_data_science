#Probability
plot(dunif, c(-1,1))
plot(dnorm, c(-1,1))


#Logistic regression
# Classification of beers
beer <- read.csv('http://www-958.ibm.com/software/analytics/manyeyes/datasets/af-er-beer-dataset/versions/1.txt', header=TRUE, sep='\t')
head(beer)

#Assign good/bad labels
summary(beer$WR)

#Beer is good when WR falls in the top quantile (4.36)
beer$good <- beer$WR > 4.36
head(beer)

#Extract training set by creating an index with random variables pointing to our rows
train.idx <- sample(1: nrow(beer), .7*nrow(beer))
head(train.idx)
training <- beer[train.idx,]

#We create columns for several beer types. Those values are to be used as variables for our model
#We are extracting variables from the "Type" original column, to simplify the model
beer$IPA <- grepl("IPA", beer$Type)
beer$Stout <- grepl("Stout", beer$Type)
beer$Pilsner <- grepl("Pilsner", beer$Type)
beer$Lager <- grepl("Lager", beer$Type)
beer$Ale <- grepl("Ale", beer$Type)
beer$Belgian <- grepl("Belgian", beer$Type)

head(beer)

#Rebuild the traininig set with that information
training <- beer[train.idx,]
head(training)

#Now use the rest of the data as a test set
test <- beer[-train.idx,]
nrow(test)  #75 beers to be used to test

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

# How accurate were those predictions on the test set?
# We write accuracy function
accuracy <- function(x,y) {
  sum(x==y) / length(x)
}
#We check accuracy
accuracy(test.labels, test$good)

#How better is it to just say all the beers are bad?
accuracy(FALSE, test$good)
52/75
#Better than our model

#We have to use a different way to measure accuracy
#Library ROCR
#install.packages('ROCR')
library('ROCR')

pred <- prediction(test.predict, test$good)

summary(pred)


