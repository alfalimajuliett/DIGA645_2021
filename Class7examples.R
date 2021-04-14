library(dplyr)
library(leaflet)
library(raster)
library(dismo)
library(rgeos)
library(rgdal)


#from https://rstudio.github.io/leaflet/markers.html

#creating an interactive leaflet map with the view centered on Minneapolis
m <- leaflet() %>% setView(lng = -93.2581, lat = 44.9866, zoom = 11)#change to 13
m %>% addTiles()

#you can add different basemaps using this function
m %>% addProviderTiles(providers$Stamen.Toner)

m %>% addProviderTiles(providers$CartoDB.Positron) #Dark Matter

m %>% addProviderTiles(providers$Esri.NatGeoWorldMap) 

#I registered online with Thunderforest and got an API key for this provider
m %>% addProviderTiles(providers$Thunderforest.TransportDark, options =  providerTileOptions(apikey='65177fe16fab4d0c8c1303460af2abab'))

#Checking the weather!
leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 4) %>%
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )

#making a custom icon for the ppoint markers on the map with an image found online
treeIcon <- icons(
  iconUrl = "https://images.vexels.com/media/users/3/127601/isolated/preview/4874bc2389e71df4c479ad933b12226a-elliptical-tree-icon-by-vexels.png",
  iconWidth = 30, iconHeight = 46)
  #iconAnchorX = 11, iconAnchorY = 47) # anchor defaults to center

m %>% addProviderTiles(providers$CartoDB.Voyager) %>%
                      addMarkers(lat= 44.957657, lng = -93.266152, icon = treeIcon, popup="A tree!")

#reading in mn counties shapefile with rgdal, this is a different data structure then the map_data counties used with ggplot
#It is a SpatialPolygonsDataFrame 
mn <- readOGR(dsn = "~/Desktop/Rclass/shp_bdry_counties_in_minnesota/mn_county_boundaries.shp", layer = "mn_county_boundaries")
plot(mn)

#you need to transform your shapefiles to the projection used with the leaflet maps
mn <- spTransform(mn, CRS("+proj=longlat +ellps=GRS80"))
mn_map<- leaflet(mn) %>% addTiles() %>%
  addPolygons(color = "purple", weight = 3, smoothFactor = 1, popup = mn$CTY_NAME)
  

#from https://pakillo.github.io/R-GIS-tutorial/#projectionraster
#using the gbif API to pull species locations 
Cc <- gbif("Ceutorhynchus", "constrictus") 
locs <- subset(Cc, select = c("country", "lat", "lon"))
head(locs)  # a simple data frame with coordinates
locs <- subset(locs, locs$lat < 90) #discard errors
coordinates(locs) <- c("lon", "lat")  # set spatial coordinates
plot(locs)

#geting Emerald Ash Borer
Ap <- gbif("Agrilus", "planipennis") #Agrilus planipennis
Aplocs <- subset(Ap, select = c("country", "lat", "lon"))
head(Aplocs)  # a simple data frame with coordinates
Aplocs <- subset(Aplocs, Aplocs$lat < 90) #discard errors

#adding EAB points to the MN map
mn_map %>% addCircleMarkers(lat=Aplocs$lat, lng=Aplocs$lon, radius = 4, color = "purple")

#Don't need this part, but just to show
crs.geo <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")  # geographical, datum WGS84
proj4string(locs) <- crs.geo  # define projection system of our data
summary(locs)

Cc_map <- leaflet() %>% addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addMarkers(lat = locs$lat, lng = locs$lon)

#adding circles and a pop-up
my_map <- leaflet() %>% addTiles() %>%
  addCircleMarkers(lat=locs$lat, lng=locs$lon, radius = 4, color = "purple",
                   popup=paste("C. constrictus at", locs$lat, locs$lon))
my_map

###getting climate data###

#the raster package can pull world rasters of climate data from the wordclim dataset
Cc_clim <- getData("worldclim", var='bio', res=10, # res=0.5
                lon = (locs$lon), lat= (locs$lat))
#subseting the rasters from the stack that I want 
clim_vars <- Cc_clim[[c(3,6)]] #c(6, 15, 3) 

#extracting the climate values where the C. constrictus locations intersect the raster grid
ccExtract <- extract(Cc_clim, locs) #getting all bioclim variables for points

#bioclim is a climate similarity model provided by the dismo package
ccMatch <- bioclim(clim_vars, locs)

#comparing the climate values of the C. constrictus locations to the global grid
cc_bioclim <- predict(clim_vars,ccMatch)

#mapping a raster with leaflet
cc_map <- leaflet() %>% addTiles()
cc_map %>% 
  addRasterImage(cc_bioclim, opacity = 0.3)

#get elevation data
elevation <- getData("alt", country = "CH")
elevation2 <- getData("alt", country = "DE")
plot(elevation)
plot(elevation2)
plot(elevation)

#the raster package provides raster analysis tools
x <- terrain(elevation, opt = c("slope", "aspect"), unit = "degrees")
plot(x)


#Spatial Union with rgeos 
ramsey <- subset(mn, mn$CTY_NAME == "Ramsey")
henn <- subset(mn, mn$CTY_NAME == "Hennepin")
plot(ramsey)
plot(henn)
Un <- gUnion(ramsey, henn) #Spatial Union of the two adjacent counties
plot(Un)
#I should have done a demo of writeOGR for the Invasive species dataset
#and required it for the subset of the species selected to save time! A note for the next class.
writeOGR(obj=ramsey, dsn="~/Desktop/Rclass/shp_bdry_counties_in_minnesota/", layer="ramsey_again", driver="ESRI Shapefile")
