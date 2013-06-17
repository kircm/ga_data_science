# ==============================================================================
# General Assembly - Data Science - Homework assignement #1
# Author: Marc Kirchner    Date: 2013 06 16
# Visualize some data with R
#
# The data chosen for visualization is economic and social indicators 
# for the last 5 years of available data for the country of Brazil.
# More specifically, we want to compare the evolution of an indicator
# of economic globalization (KOF) with an indicator of income distribution
# across the country (Gini). The purpose is to have a visualization of both 
# indicators over time to see if they may correlate, meaning, test the
# theory that globalization in the last years may be one cause of 
# the improvement of the living conditions in Brazil. 
#
# The Gini coefficient is interpreted as "the lower the better", meaning, 
# a Gini coefficient of zero indicates perfect equality of income distribution. 
# The KOF coefficient of a country increases as the economic globalization 
# of that country increases (international trade grows)
#
#
# Data sources:
# -------------
# Gini data: Wold Bank
# http://api.worldbank.org/datafiles/SI.POV.GINI_Indicator_MetaData_en_EXCEL.xls
#
# Economic globalization data: KOF (Swiss Economic Institute)
# http://globalization.kof.ethz.ch/query/
# (the site requires the submission of a query to retrieve the data of interest) 
# ==============================================================================


#Path in my local file system
#setwd('~/general_assembly/data_science/git/kircm/ga_data_science/hw1')


# ----------------------------------------------------------------
# First data collection: Gini index for Brazil in the last 5 years
# ----------------------------------------------------------------

# Read the Gini for all countries for all years
gini_data <- read.csv('SI.POV.GINI_Indicator_MetaData_en_EXCEL.csv', as.is=TRUE)

#Structure of the Gini data
str(gini_data)
names(gini_data)

# Listing country name column values
gini_data$Country.Name

# Show the gini data for Brazil
gini_data[gini_data$Country.Name=='Brazil',]

# We don't have data for 2010, 2011, 2012. We limit the experiment to the last 5 years with data (2005-2009)
brazil_gini_2005_2009 <- gini_data[gini_data$Country.Name=='Brazil',c('Country.Name','X2005','X2006','X2007','X2008','X2009')]

#Spotchecking the data: Brazil has a gini index of 54.7 for 2009 according to 
#the World Bank Gini Index shown in wikipedia
#source: http://en.wikipedia.org/wiki/List_of_countries_by_income_equality
#Our data file contains 54.69 --> good!
brazil_gini_2005_2009[,'X2009']

#A quick line plot of the Gini data for our period
plot(c('2005':'2009'), brazil_gini_2005_2009[1,2:6], type='l', xlab='Years', ylab='Gini')


# ----------------------------------------------------------------------------------------------------------------
# Second data collection: Economic globalization index for Brazil during the same years of the collected Gini data
# ----------------------------------------------------------------------------------------------------------------
# Read the KOF data previously queried and downloaded from the World Bank website
brazil_kof_data <- read.csv('kof_econ_brazil_2000_2010.csv', as.is=TRUE)

#Structure of the KOF data
str(brazil_kof_data)
names(brazil_kof_data)

#In this case we trust the data because we extracted it directly from the institution that generates it 
#Which is the Swiss Economic Institute (KOF)

#We filter the data to match the 2005-2009 period
brazil_kof_2005_2009 <- brazil_kof_data[,c('country.name', 'X2005','X2006','X2007','X2008','X2009')]

#Renaming the country name column
names(brazil_kof_2005_2009)[names(brazil_kof_2005_2009)=="country.name"] <- "Country.Name"

#A quick line plot of the KOF data for our period
plot(c('2005':'2009'), brazil_kof_2005_2009[1,2:6], type='l', xlab='Years', ylab='KOF')


# ----------------------------------------------------------------------------------------------------------------
# Overplotting the data with ggplot2
# ----------------------------------------------------------------------------------------------------------------
#Set row names to indicate the type of the data
rownames(brazil_gini_2005_2009) <- 'Gini'
rownames(brazil_kof_2005_2009) <- 'Kof'
#Add column to indicate the type of the data
#This is to use the column in the melt operation below (I couldn't find a way to use row names in melt)
brazil_gini_2005_2009['Data.Type'] <- 'Gini'
brazil_kof_2005_2009['Data.Type'] <- 'Kof'

#Bind the data by row
brazil_2005_2009 <- rbind(brazil_gini_2005_2009, brazil_kof_2005_2009)

#Melt all the data
library(reshape)
brazil_2005_2009_m <- melt(brazil_2005_2009, id.vars=c('Data.Type', 'Country.Name'))

#Plotting all the data
library(ggplot2)
p <- ggplot(data=brazil_2005_2009_m, aes(x=variable, y=value, group=Data.Type, colour=Data.Type))
p <- p + geom_line() + geom_point() 
p <- p + xlab('Year') + ggtitle('Brazil: Economic globalization index (Kof) vs Gini Index (2005 - 2009)')

p


# ==============================================================================
# Conclusion:
# It seems that economic globalization may not be the main cause for the 
# Gini coefficient improvement. We can see that during the 2008 global recession
# international trade in Brazil was significantly reduced, but the Gini coefficent 
# progression was unaffected. 
# 
# However, it could be that the Gini coefficient takes much more time change its
# course when economic globalization decreases.   
# ==============================================================================

