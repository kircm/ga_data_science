
#Linear regression

academic_salaries <- read.table('http://data.princeton.edu/wws509/datasets/salary.dat', header=T)
head(academic_salaries)
summary(academic_salaries)

# Linear regression with three variables
Y ~ X1 + X2 + X3

# We can combine two variables to form an additional one, because we may think that the combination has value
Y ~ X1 + X2 + X3 + X1:X3
# (It can be added after defining Y ~ X1 + X2 + X3 )

# Compact syntax for adding X1, X3 and their combination
Y ~ X1 * X3

# To represent a new variable as a multiplication of two other variables:
Y ~ I(X1 * X3)
# To represent a new variable as an addition of two other variables:
Y ~ I(X1 + X3)

#We create the model (learn from the data)
model1 <- lm( sl ~ sx, data=academic_salaries)

#To display the model
summary(model1)

#Plotting the error
plot(academic_salaries$sl - predict(model1))

# Showing the predictions
predicted <- predict(model1)
head(predicted)

#New model, adding the degree attribute (dg)
model2 <- lm( sl ~ sx + dg, data=academic_salaries)
summary(model2)

#New model, adding the rest of the attributes
model3 <- lm( sl ~ sx + dg + rk + yd + yr, data=academic_salaries)
summary(model3)

#To check correlation of variables visually
plot(academic_salaries)

#Mathematical Correlation function:
?cor



# Normalization 

setwd('~/general_assembly/data_science/data/20130612/baseball/')

players <- read.csv('Master.csv')
batting <- read.csv('Batting.csv')
salary <- read.csv('Salaries.csv')

# Players data can be merged with batting data to have all the data for each player (biographic + batting stats for each year)
# The default behaviour for merge is equivalent to an INNER JOIN in SQL
# To simulate an OUTER JOIN:
players_batting <- merge(players, batting, all.x = T, all.y = T) 

# Let's join the batting stats and the salaries
batting_salary <- merge(batting, salary)
# And add the players master data
data <- merge(players, batting_salary)
# ( This is called denormalization, which produces redundant data )
str(data)

# We apply linear regression based on the year of the salary (not a very good variable, but as an example)
model <- lm(salary ~ yearID, data = data)
summary(model)

# The results are not good. The years are really categories rather than continous values. To tell R to treat them as categories:
model <- lm(salary ~ as.factor(yearID), data = data)

#In the summary output, the Intercept seems to be 1985 and the rest are relative to it (how many $ of increase/decrease relative to 1985)
summary(model)

# Adding home-runs as variable
model <- lm(salary ~ as.factor(yearID) + HR, data = data)
summary(model)


# Adding RBI
model <- lm(salary ~ as.factor(yearID) + HR + RBI, data = data)
summary(model)

# Some problems with LR:
# - What variables are related to each other?
# - What if the relationship is not linear? (some variable increases and then starts decreasing based on other variables)



