setwd('~/general_assembly/data_science/538model/data/')

census1 <- read.csv('census_data_2000.csv', as.is=TRUE)
census2 <- read.csv('census_demographics.csv', as.is=TRUE)

census1$state

sum(census1$older_pop)
sum(census2$older_pop)

sum(census1$vote_pop)
sum(census2$vote_pop)


# We want to merge the data
head(census2$state)
head(census1$state)
# The states in each files are formatted differently (Propercase vs Upper case)

# We transform one data structure:
census1$state <- toupper(census1$state)
head(census1$state)

census <- merge(census1, census2, by='state')

#If we want tot specify the suffixes for the merged columns:
census <- merge(census1, census2, by='state', suffixes=c('cen1', 'cen2'))

# First row first columns
census[1,1]

#First column
census[,1]
#By column name
census[,'state']
#List of columns
census1[,c('state', 'vote_pop')]
#Get the columns using the names of another data frame
census2 <- census2[,names(census1)]

#Now we have the columns in the same order in cesus1 and census2
#We can bind the rows of both data frames: create a new frame appending the rows from census2 after the rows of census1
censusAll <- rbind(census1, census2)

#We can bind the columns of both data frames
censusAll <- cbind(census1, census2)
#Difference with merge: merge makes sure that the merged columns match on some value

#To order columns
order(census1$state)

#Install package
install.packages("reshape")
library(reshape)

#To flatten the data we use rbind to have all the rows in one variable and we "melt" the data
census1$year <- 2000
census2$year <- 2012
censusAll <- rbind(census1, census2)
molten <- melt(censusAll, id.vars=c('state','year'))

#Graphics
library(ggplot2)
plot(census1$vote_pop ~ census1$average_income)
#Histogram
hist(census1$vote_pop)
#To get help for command:
?hist

#Using ggplot for displaying histogram
ggplot(data=census1) + aes(x=vote_pop) + geom_histogram()

#Using ggplot for displaying a scatter plot
ggplot(data=census1) + aes(x=vote_pop) + aes(y=older_pop) + geom_point()

#Similar to histogram but drawing a function
ggplot(data=census1) + aes(x=vote_pop) + geom_density()

#From wiki 1
p <- ggplot(data=census1, aes(x=state, y=vote_pop))
p + geom_bar(aes(fill=per_vote), stat="identity") + coord_flip() + scale_x_discrete(limits=census1$state[order(census1$vote_pop)]) + theme_classic() + theme(legend.position="none")

#From wiki 2
install.packages('maps')
library(maps)
states <- map_data('state')
census <- census1
census$region <- tolower(census$state)
statecensus <- merge(states, census[, c("region", "per_older")])
ggplot(data=statecensus, aes(x=long, y=lat, group=group, fill=per_older)) + geom_polygon()


# Machine Learning
# ----------------
# Classification Example
iris
head(iris)
summary(iris$Species)

x1 <- iris[1,]
x2 <- iris[2,]

#remove labels (5th column)
x1 <- x1[, c(1,2,3,4)]
x2 <- x2[, c(1,2,3,4)]

#Euclidian distance (doesn't give much info)
sqrt(sum((x1 - x2)^2))

#Classification with knn
library('class')
knn

#data
data <- iris
N <- nrow(data)

train.pct <- .7 #set train/test split at 70%
train.index <- sample(1:N,  train.pct * N)  #randomly sample indices for your training set

#extract training data
train.data <- data[train.index, ] #separate out those indices to your traing set

#extract test data
test.data <- data[-train.index, ] #everything else goes to your test set
test.labels <- test.data$Species

#TRAIN YOUR MODEL (k = 3, but you could set it as anything)
test.predict <- knn( train = train.data[,c(1,2,3,4)] , test = test.data[,c(1,2,3,4)], cl = train.data$Species, k = 3)

#PRINT CONFUSION MATRIX
print(table(test.data$Species, test.labels))

#OUTPUT ACCURACY
sum ( test.data$Species != test.labels ) / nrow(test.data)
