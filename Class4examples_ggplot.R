library(ggplot2)
library(palmerpenguins)
library(dplyr)
library(maps)
library(mapdata)
library(rgdal)

#class 4 examples, plotting Palmer Penguins and mapping US states and cities with ggplot2

summary(penguins)
penguinsh <- head(penguins)
p_table <- knitr::kable(penguinsh, caption = "example of penguin data")
p_table #using the kable function from within knitr to render as a table, this is a preview to making an Rmd document in class 5

#from https://education.rstudio.com/blog/2020/07/palmerpenguins-cran/
#let's plot the relationship between bill length and and flipper length
p_vis <- ggplot(data=penguins,aes(x=bill_length_mm, y=flipper_length_mm, color = species)) + 
  geom_point() + 
  theme_minimal() + 
  labs(title = "length of bills and flippers", subtitle = "Palmer Penguins!", x="bill", y="flipper")  
p_vis

#filtering the observations for male and female penguins
m_pen <- penguins %>% filter(sex=='male')
f_pen <- penguins %>% filter(sex == 'female')

ggplot()+ #you can leave the arguments to the ggplot function blank if you plan to add geoms that refer to different data sources
  geom_point(data = m_pen, aes(x=bill_length_mm, y = bill_depth_mm, shape = species), color="yellow")+
  geom_point(data = f_pen, aes(x=bill_length_mm, y = bill_depth_mm, shape = species), color="purple")

p_vis + 
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) #centering the title

p_vis + 
  geom_smooth(se = TRUE) #linear fit, with confidence intervals on

p_vis + 
  facet_wrap(~species) #creates individual plot windows by species

ggplot(data=penguins,aes(x=species, y=body_mass_g,color=species)) + 
  geom_violin() + #change to geom_boxplot for regular box plot, I forgot to show this one in class
  theme_minimal() +
  theme(legend.position="none")

#histogram
ggplot(data=penguins,aes(x=flipper_length_mm,fill=species)) + geom_histogram() + facet_wrap(~species)

#density plots
ggplot(data=penguins,aes(x=body_mass_g,color=species)) + 
  geom_density() +
  theme_dark()

#shows how the points are clustered in the variable space of flipper length by body mass
dens_plot <- ggplot(data=penguins,aes(x=body_mass_g,y=flipper_length_mm,color=species)) +
  geom_density2d()
dens_plot


########  Making Maps with ggplot!   ########

usa <- map_data("usa") # bringing in US spatial data from map_data package
usa

ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + #group = group is important to get the geometries of the objects in usa to know where they are relative to each other
  coord_fixed(1.3) #this makes the plot less stretched out 

us_fill <- ggplot() + 
  geom_polygon(data = usa, aes(x=long, y = lat, group = group), fill = "green", color = "blue") + #fill for inside the polygon, color for outline
  coord_fixed(1.3)
us_fill

data("us.cities")#from the maps package

us_fill + 
  geom_point(data = us.cities, aes(x = long, y = lat), color = "black", size = 2)

mn_cities <- us.cities %>% filter(country.etc=="MN")

states <- map_data("state")
ggplot(data = states) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
  coord_fixed(1.3) +
  guides(fill=FALSE)  # do this to leave off the color legend

my_states <- subset(states, region %in% c("minnesota", "illinois", "iowa","pennsylvania", "indiana")) #subsetting states I've lived in

#notice that you can invoke a blank ggplot() and add layers that map to separate data 
ggplot() + 
  geom_polygon(data = my_states, aes(x=long,y=lat, group = group), fill = "pink", color = "black")+
  geom_point(data = mn_cities, aes(x = long, y = lat), color = "black", size = 2)

#Getting started on assignment 3
#the readOGR function is in rgdal. It may take a while to read this in, there are a lot of points and it is a wide dataset
invasive_ob <- readOGR("~/Desktop/Rclass/invasive_spp/terrestrial_invasive_species_observations_pt.shp", layer = "terrestrial_invasive_species_observations_pt")
invasive_df <- as.data.frame(invasive_ob)
Ct <- subset(invasive_df, invasive_df$commonname == "Canada thistle")
Gm <- subset(invasive_df, invasive_df$scientific == "Alliaria petiolata")
Tv <- subset(invasive_df, invasive_df$scientific == "Tanacetum vulgare")
Cv <- subset(invasive_df, invasive_df$scientific == "Cirsium vulgare")

