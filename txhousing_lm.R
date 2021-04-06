library(ggplot2)
library(dplyr)

data(txhousing)

#converting the year and month column into a single date
#the paste function will glue the arguments given to it together, the day doesn't matter, so I gave it 01
txhousing$date <- as.Date(paste(txhousing$year, txhousing$month, '01', sep='-'))

#Using square bracket subsetting again since Jake tends to use this style in his demos
#Abilene was the first city I saw in the dataset
abilene_housing <- txhousing[txhousing$city == 'Abilene',]

#some scatter plots to explore the data
ggplot(abilene_housing, aes(x=year, y=median)) + 
  geom_point()

ggplot(abilene_housing, aes(x=month, y=median)) + 
  geom_point()

ggplot(abilene_housing, aes(x=date, y=median)) + 
  geom_point()

#line plot 
ggplot(abilene_housing, aes(x=date, y=median)) + 
  geom_line()

#checking the correlation value between date and median home value in Abilene
cor(as.numeric(abilene_housing$date), abilene_housing$median)

#view the line plot for each city by color
ggplot(txhousing, aes(x=date, y=median, color=city)) + 
  geom_line() + theme(legend.position = "none")

#facet wrap by city so we can see each one
ggplot(txhousing, aes(x=date, y=median, color=city)) + 
  facet_wrap(~city) + 
  geom_line() + 
  theme(legend.position = "none")

# a linear model of median (y) by date 
m <- lm(abilene_housing$median ~ abilene_housing$date)

m
summary(m) #summary of fit

ggplot(abilene_housing, aes(x=date, y=median)) + 
  geom_line() + 
  geom_line(aes(y=predict(m)), color='blue') #we use the predict function to model the linear fit

#can fit a sin line equation, this doesn't do much 
m <- lm(abilene_housing$median ~ abilene_housing$date + sin(abilene_housing$month))

m
summary(m)

ggplot(abilene_housing, aes(x=date, y=median)) + 
  geom_line() + 
  geom_line(aes(y=predict(m)), color = 'green')

# you can fit a polynomial line in the equation for x
#poly takes the x data and the degree of the polynomial, here it is two
# I am factoring in the city to the the fit of the line by multiplying by the city column
m <- lm(txhousing$median ~ poly(as.numeric(txhousing$date), 2) *txhousing$city + sin(txhousing$month) + txhousing$city)
m
summary(m)
anova(m)

#using dplyr to get just the date city and month column
newdata <- txhousing %>% select(date, city, month) 

#predicting the relationship between date and median for each city
ggplot(txhousing, aes(x=date, y=median)) + 
  facet_wrap(~city) + 
  geom_line(aes(color=city)) + 
  geom_line(aes(y=predict(m, newdata))) + 
  theme(legend.position = "none")

