library(babynames)
library(dplyr)
#getting the most popular baby names in 1990 using dplyr functions
pop_names <- babynames %>% 
  filter(year == 1990) %>%
    group_by(name) %>%
      summarize(n = sum(n)) %>%
        arrange(desc(n))
  
head(pop_names, 5)
