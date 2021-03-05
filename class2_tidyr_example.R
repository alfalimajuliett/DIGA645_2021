library(dplyr)
library(readr)
library(tidyr)
library(stringr)

#writing in raw csv data, no need for separate file
weevils <- read_csv("Jar_number,eggs_laid,female1,female2,male
                    406,6,2.89/1.87,2.61/1.93,2.48/1.81
                    412,8,2.83/1.67,2.55/1.54,2.84/1.64
                    85,7,2.67/1.46,2.78/1.56,2.76/1.56
                    162,7,2.9/1.68,2.97/1.65,2.93/1.56
                    471,2,2.59/1.6,2.94/1.65,2.79/1.58
                    210,6,2.95/1.61,2.53/1.47,2.7/1.4")

#using tidyr separate function to break female1, female2, and male length/width
# into two new columns using / as the separator string
f1 <- separate(weevils, female1, c("female1_length", "female1_width"), sep = "/")
f2 <- separate(f1, female2, c("female2_length", "female2_width"), sep= "/")
weevils2 <- separate(f2, male, c("male_length", "male_width"), sep = "/")

#gathering the female 1, female 2, and male length columns into just two columns using sex as the key, and
#length as the value for that key. We do the same with the width columns
weevil_length_gather <- gather(weevils2, female1_length, female2_length, male_length, key = "sex", value = "length")
weevil_width_gather <- gather(weevils2, female1_width, female2_width, male_width, key = "sex", value = "width")

#Now we join the two gathers from above together on thier shared 'sex' column
#We use the select function from dplyr to get the variables on the left side of the table
#and the right side, which is just width in this case. 
wl <- weevil_length_gather %>% select(Jar_number, eggs_laid, sex, length)
wr <- weevil_width_gather %>% select(width)

#join the left and right side as a tibble
w_join <- as_tibble(c(wl, wr))

#We use stringr function str_replace to make the values in 'sex' either "f" or "m"
#we combine this with dplyr function mutate to assign these new strings to the 'sex' column
tidy_weevils <- w_join %>% 
  mutate(sex = str_replace(sex, "female1_length", "f")) %>%
  mutate(sex = str_replace(sex, "female2_length", "f")) %>%
  mutate(sex = str_replace(sex, "male_length", "m"))

#taking a look by jar number
tidy_weevils %>% arrange(Jar_number)

#renaming the columns
names(tidy_weevils) <- c("jar_num", "eggs_laid_per_jar", "sex", "length", "width")

#writing a new csv with the completed tidy data
write_csv(tidy_weevils, "~/Desktop/Rclass/tidy_weevils.csv")
