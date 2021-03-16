library(dplyr)
library(babynames)
#Class 2 examples

#the dataframe we created from the first class
city <- c("Chicago", "Des Moines", "Duluth", "Fargo")
state <- c("IL", "IA", "MN","ND" )
latitude <- c(41.5, 41.35, 46.49, 46.52)
longitude <- c(87.37, 93.37, 92.5, 96.48)
cities_df <- data.frame(city, state, latitude, longitude)

names(cities_df) <- c("City_name", "Sate", "Lat", "Lon")

my_list <- list(names = city, city_info = cities_df)


#example of creating a list that holds vectors of multiple types.
#lists can also hold data frames alongside vecotrs or a matrix, etc
nums <- c(1, 13, 45, 6.7)

logicals <- c(TRUE, FALSE, TRUE, TRUE)

strings <- c("this", "is", "a", "vector", "of", "strings")

#creating a list with the list function
another_list <- list(nums, logicals, strings)

#an example of creating factors for categorical landcover data
landcover_type <- c("forest", "edge", "forest", "water", "swamp", "water")

factor(landcover_type)

#multiply two matrices together. Similar to AND raster operation 
raster1 <- matrix( data = c(1,0,0,1), nrow = 4, ncol = 2)
raster2 <- matrix(data = c(0, 1, 1, 1), nrow = 4, ncol = 2)
raster1 * raster2

#A for loop in R, more verbose than other options

#creating an empty vector to populate with the loop
char_count <- c()

for(i in 1:length(city)){
  char_count[i] <- nchar(city[i]) # i is just a placeholder variable for whatever element we are on
}

#acomplishing the same task as the for loop with a pipe
city %>% nchar

#with vector operation
char_count <- nchar(city)

#with lapply, sapply, and vapply
lapply(city, nchar)
chars <- sapply(city, nchar)

vapply(city, nchar, length(city))

# a user defined function that sums three arguments
#and throws a message in the console as a side effect
add_stuff <- function(x, y, z = 1){
  my_output <- x + y + z
  message(paste("the sum of", x, y, z, "is", my_output))
  return(x+y+z)
}

#example of an annonymous function call
(function(vec) print(paste("the cities_df contains location info for", vec)))(city)

#recreating the abs() function with conditional control flow
abs_value <- function(num){
  if(num < 0){
    -num
  }
  else{
    num
  }
}

#A user defined function that takes a name (as a string) checks 'if' that name is in babynames
#if it is, create a subset of that name and plot its popularity by year
#if the name is not in babynames (else), send a message. 
name_pop_predict <- function(givenName){
  if(givenName %in% babynames$name){
    name_sub <- subset(babynames, babynames$name == givenName)
    plot(name_sub$n ~ name_sub$year)
  }else{
    message("that is not a name in the dataset")
  }
  
}
  



