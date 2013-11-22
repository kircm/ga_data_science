setwd('~/general_assembly/data_science/538model/data/')


census1 <- read.csv('census_data_2000.csv', as.is=TRUE)
census2 <- read.csv('census_demographics.csv', as.is=TRUE)

str(census1)
str(census2)

names(census1)
names(census2)

intersect(names(census1), names(census2))
setdiff(names(census1), names(census2))

names(census1)=="State"

names(census1)[names(census1)=="State"] <- "state"

census1$state

