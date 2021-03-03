b <- read.csv("~/src/generations/bnl.csv")
# dont forget to install babynames package first 
library(babynames)

bryn <- babynames[(babynames$name == "Bryn")&(babynames$sex == "M"),] # all rows that match that selection, all columns
plot(bryn$n ~ bryn$year)
(Bryn <- subset(babynames, babynames$name == "Bryn"))
Bryn_sub <- subset(Bryn, Bryn$sex == "M")

plot(Bryn_sub$n ~ Bryn_sub$year, ylab = "n", xlab = "year", main = "babies named bryn")

sub_year <- babynames[babynames$year==1991,]
sub_year[order(-sub_year$n),]

my_vec <- c("q", 5, TRUE)

(raster1 <- matrix( data = c(1,0,0,1), nrow = 4, ncol = 2))
(raster2 <- matrix(data = c(0, 1, 1, 1), nrow = 4, ncol = 2))

####Data structures examples #####
city <- c("Chicago", "Des Moines", "Duluth", "Fargo")
state <- c("IL", "IA", "MN", "ND")
latitude <- c(41.5,41.35,46.49,46.52)
longitude <- c(87.37,93.37,92.5,96.48)
cities_df <- data.frame(city,state,latitude,longitude)

names(cities_df) <- c("City_name", "State", "Lat", "Lon")

new_list <- list(my_vec, cities_df)

nums <- c(1, 13, 45, 6.7)

logicals <- c(TRUE, FALSE, TRUE, TRUE)

strings <- c("this", "is", "a", "vector", "of", "strings")

my_list <- list(nums, logicals, strings)

#example with factors

landcover_type <- c("forest", "edge", "forest", "water", "swamp", "water")

landcover_type <- factor(landcover_type)
landcover_type <- levels(landcover_type)[1:3] <- "land"
landcover_type <- levels(landcover_type)[4] <- "water"



