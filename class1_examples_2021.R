
#examples from class 1: March 2 2021
#open a new R script (File > New file > New R script) and copy and paste this code into the text editor window

#example of pulling in a csv file with a relative path name 
b <- read.csv("~/src/generations/bnl.csv") #THIS WILL ONLY WORK ON MY COMPUTER
#A windows absolute file path might look like this 
w <- read.csv("C:\Windows\My_data\bnl.csv") #JUST AN EXAMPLE, CODE WONT WORK 

#I recommend trying to import a csv from the file on your computer 
#either through the 'files' navigation tab on the right, or by clicking File > Import dataset > text
#try some of the functions we discussed in class on your dataset like below
min(b$Seeds) #min number of seeds
max(b$Weevils) #max number of weevil population


#I mispoke when I said you can read in the csv text raw with read.csv(), 
#that is read_csv that allows you to do that, a function in the tidyverse that we will use in the next class
#It is just a beefed up version of read.csv


# dont forget to install babynames package first using install.packages("babynames")
library(babynames) #calling in a package that contains the dataset babynames

(?(babynames)) #info on the dataset
str(babynames) #structure of the dataset
head(babynames, 10)# get first 10 lines
tail(babynames, 3) #last 3 lines


bryn <- babynames[(babynames$name == "Bryn")&(babynames$sex == "M"),] # all rows that match that name and are labeled M for sex, all columns
plot(bryn$n ~ bryn$year) #plot takes a formula y data by x data
(Bryn <- subset(babynames, babynames$name == "Bryn")) #subset out this name
Bryn_sub <- subset(Bryn, Bryn$sex == "M") #subset of subset for males

plot(Bryn_sub$n ~ Bryn_sub$year, ylab = "n", xlab = "year", main = "babies named bryn")

sub_year <- babynames[babynames$year==1991,] #all columns for rows where year is 1991 

#get the most popular names of 1991
sub_year[order(-sub_year$n),] #arrange rows in the above subset in descending order for all columns based on number the name occurs
#we will see an easier way to do this next class with the dplyr package 

my_vec <- c("q", 5, TRUE) #R will coerce all the elements to string type

#the matrix function builds a two dimensional table where all elements are of the same type
(raster1 <- matrix( data = c(1,0,0,1), nrow = 4, ncol = 2))
(raster2 <- matrix(data = c(0, 1, 1, 1), nrow = 4, ncol = 2))

#some raster algebra!
raster1 + raster2
raster1 + raster2

####Data structures examples #####

#making some vectors and assigning them each a variable name
#these names will become the names of our columns
city <- c("Chicago", "Des Moines", "Duluth", "Fargo")
state <- c("IL", "IA", "MN", "ND")
latitude <- c(41.5,41.35,46.49,46.52)
longitude <- c(87.37,93.37,92.5,96.48)

#data.frame "glues" the vectors together, each their own column
cities_df <- data.frame(city,state,latitude,longitude)

names(cities_df) <- c("City_name", "State", "Lat", "Lon") #renaming the headers of the columns

#indexing the dataframe
cities_df[3,] #row three elements for each column (Duluth info)
cities_df[,3] #all elements in the rows for the third column (just the latitudes)
cities_df[,3:4] #just the lat/lons
cities_df[,,] #all columns, all rows

cities_df$City_name #accessing a column by name

new_list <- list(my_vec, cities_df)
#double brackets to get to an item's position in the list, single brackets to pull out elements from that item
new_list[[2]][3,2] #try to guess what this will get you before running it!

nums <- c(1, 13, 45, 6.7)
logicals <- c(TRUE, FALSE, TRUE, TRUE)
strings <- c("this", "is", "a", "vector", "of", "strings")

#A list is an ordered container of data structures that can be of different types
my_list <- list(nums, logicals, strings)

#example with factors

landcover_type <- c("forest", "edge", "forest", "water", "swamp", "water")

landcover_type <- factor(landcover_type) #sorts covers into categories

#sorting into two levels, land and water. I don't usually have to work with levels, but it could happen
levels(landcover_type) <- c("land","water") #oh geez, I was getting too fancy with my subsetting, this was all I needed to do



