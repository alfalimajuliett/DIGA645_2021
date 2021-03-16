library(leaflet) #don't forget to install leaflet if you run this 

gm_df <- read.csv("~/Desktop/Rclass/gm_monitoring.csv") #download csv and put in your own file path

#leaflet sets up a blank zoom-able map, I add new objects to the map with the pipe 
mon_map <- leaflet() %>% addProviderTiles(providers$CartoDB) %>% #add a basemap
  addMarkers(lat = gm_df$Latitude, lng = gm_df$Longitude, #add marker lat lons 
             label=gm_df$Point_IDs, 
             labelOptions = labelOptions(noHide = T)) #label with point IDs

for(row in seq(1, nrow(gm_df),2)){ #for each row in gm_df sequence each row for the length of gm_df, by every 2 rows (they are paired A & B)
  lonAB <- gm_df[c(row, (row+1)),5] #a variable containing the paired rows each iteration of the loop with the lon data, column 5
  latAB <- gm_df[c(row, (row+1)),4] #lat data column
  mon_map <- mon_map %>% addPolylines(data = gm_df, #add lines between the pairs of points (rows) to the map
                                        lng = lonAB,
                                        lat = latAB)
}

