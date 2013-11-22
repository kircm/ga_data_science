
library(ggplot2)

plot_hotel_freq <- function(df, title) {
  hotel_frequencies_table = table(df$hotel_id)  
  hotel_frequencies_df = as.data.frame(hotel_frequencies_table)
  colnames(hotel_frequencies_df)[1] <- "Hotels"  
  pl <- ggplot(hotel_frequencies_df, aes(Hotels, Freq))
  pl <- pl + geom_point(aes(size=3))
  pl <- pl + ggtitle(title)
  pl <- pl + theme(axis.text.x=element_blank(), legend.position="none", plot.title=element_text(lineheight=.8, face="bold"))
  pl
}

plot_user_adv_purch_range_freq <- function(df, title) {    
  uapr_frequencies_table = table(df$advance_purchase_range_type)  
  uapr_frequencies_df = as.data.frame(uapr_frequencies_table)  
  colnames(uapr_frequencies_df)[1] <- 'Aprt'
  pl <- ggplot(uapr_frequencies_df, aes(Aprt, Freq))
  pl <- pl + geom_bar(stat='bin', fill="grey")
  pl <- pl + ggtitle(title)
  pl <- pl + theme(axis.title.x=element_blank(), legend.position="none", plot.title=element_text(lineheight=.8, face="bold"))  
  pl  
}


setwd('~/general_assembly/data_science/project')
all_data <- read.csv('all_data.csv')
all_data$hotel_id <- as.factor(all_data$hotel_id)
all_data$is_weekday <- as.factor(all_data$hotel_id)
all_data$star_rating <- as.factor(all_data$star_rating)
all_data$ad_copy_includes_promotion <- as.factor(all_data$ad_copy_includes_promotion)
all_data$ad_copy_includes_discount <- as.factor(all_data$ad_copy_includes_discount)
all_data$ad_copy_includes_free <- as.factor(all_data$ad_copy_includes_free)
all_data$was_clicked <- as.factor(all_data$was_clicked)

all_data$advance_purchase_range_type <- factor(
      all_data$advance_purchase_range_type, 
      levels=c('WEEKDAY_TRAVEL_LESS_THAN_OR_EQUAL_TO_21_DAYS', 'WEEKDAY_TRAVEL_GREATER_THAN_21_DAYS', 'WEEKEND_TRAVEL_LESS_THAN_OR_EQUAL_TO_21_DAYS', 'WEEKEND_TRAVEL_GREATER_THAN_21_DAYS', 'DATELESS'), 
      labels=c("WkD < 21", "WkD > 21", "WkE < 21", "WkE > 21", "None"))


str(all_data)

examples_with_click <- all_data[all_data$was_clicked==1,]
table(examples_with_click$hotel_id)

examples_with_no_click <- all_data[all_data$was_clicked==0,]
table(examples_with_no_click$hotel_id)

summary(examples_with_click$click_actual_cpc)


plot_hotel_freq(all_data, 'Impressions per Hotel')
plot_hotel_freq(examples_with_click, 'Clicks per Hotel')

plot_user_adv_purch_range_freq(all_data, 'Advance Purchase Type')




predictions <- read.csv('predictions.csv')
names(predictions)
summary(predictions$click_proba)

pl <- ggplot(predictions, aes(x=click_proba))
pl <- pl + geom_density()
pl <- pl + ggtitle("Probability density in click predictions")
#pl <- pl + geom_histogram()
#pl <- pl + ggtitle("Histogram of click probabilities")
pl <- pl + theme(axis.title.x=element_blank(), legend.position="none", plot.title=element_text(lineheight=.8, face="bold"))
pl





pl2 <- ggplot(predictions, aes(x=click_proba))
pl2 <- pl2 + geom_density()
pl2 <- pl2 + coord_cartesian(xlim=c(0.15, 0.35), ylim=c(0,2)) 
pl2 <- pl2 + ggtitle("Probability density in click predictions (Zoom)")
pl2 <- pl2 + theme(axis.title.x=element_blank(), legend.position="none", plot.title=element_text(lineheight=.8, face="bold"))
pl2



