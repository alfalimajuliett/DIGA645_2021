library(babynames)
library(purrr)
library(dplyr)
library(knitr)

# run bNames for a random sample of the 500 most popular baby names for a given year
# run name_popularity_predict to forecast the popularity of a specified name (as a string) into 2025
# run beefed_up_bNames to predict the change in popularity by 2025 for a random sample of popular names for a given year

bNames <- function(year, n, pf = 0.5){
  #babynames dataset has records from 1880 to 2017
  if (year %in% babynames$year){
  
    n_female <- pf*n
    n_male <- (1-pf)*n
    
    names_for_year <- babynames[year == babynames$year ,]
    most_popular <- names_for_year %>% arrange(desc(n)) #arranging most popular names first
    popular_subset <- head(most_popular, 500) #getting 500 most popular
    male_subset <- popular_subset[popular_subset$sex == "M" ,]
    female_subset <- popular_subset[popular_subset$sex =="F" ,]
    
    #Sample of female names and sample of male names with size set the their proportions and weighted by their popularity
    fsamp <- sample(female_subset$name, size = n_female, replace = FALSE, prob = female_subset$prop) #can set FALSE to TRUE if duplicates are not desired
    msamp <- sample(male_subset$name, size = n_male, replace = FALSE, prob = male_subset$prop)
    
    bsamp <- c(fsamp, msamp) #random sample of male and female names with respect to the given proportion
    shuffle_bsamp <- sample(bsamp) #I did not want them in a particular order, apparently sample is equivelent to shuffle.
    
    return(shuffle_bsamp)
  
  }else{
    warning("Valid year not given")
  }
}

#function to take a name, plot its popularity by year, and predict its proportion up to 2025
name_popularity_predict <- function(givenName){
  if (givenName %in% babynames$name){ 
    name_sub <- subset(babynames, babynames$name == givenName) #select for entries where the name equals given name
    if (sum(name_sub$sex == "F") > sum(name_sub$sex == "M")){ #nested condition to set sex if the given name is mostly female
      sex = "F"
    }else{
      sex = "M" #given name is mostly male
    }
    
    f_sub <- name_sub[name_sub$sex == sex ,] #subset the original subset by sex
    proportion <- f_sub$prop
    Year <- f_sub$year
    plot(proportion~Year)
    fit <- lm(proportion~poly(Year, degree = 3, raw = TRUE)) #fitting the lm for prop v. year
    yrng <-  seq(1880,2025)
    lines(yrng, predict(fit, data.frame(Year=yrng)))
    
    return(paste("the name", givenName, "will change in popularity by", predict(fit, data.frame(Year=2025))*100, "percent by 2025")) #getting the intercept for 2025
 
  }else{
    warning("Not a name in database")
  }
}

#beefed_up_bNames will take the same parameters, call bNames, and map the popularity predictor function to the resulting vector of nNames
beefed_up_bNames <- function(year, n, pf = 0.5){
  result_bNames <- bNames(year, n, pf)
  map(result_bNames, name_popularity_predict)
}

