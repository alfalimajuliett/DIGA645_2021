#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(readr)
library(shiny)
library(dplyr)
library(rgdal)
library(raster)
library(leaflet)
library(dismo)
library(maptools)
library(sp)
library(rgdal)
library(shinycssloaders)
library(shinythemes)
library(mapview)
#library(rsconnect)

#rsconnect::deployApp('.')

#shinyio might need to know, the png output depends on webshot::install_phantomjs()
webshot::install_phantomjs()


ui <- fluidPage(
  #hide the errors from the ui
  theme = shinytheme("sandstone"),
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  titlePanel("Climate Match"),
  tags$h4("Model the potential distribution of a non-native species in a novel area based on the climate in its home region."),
  tags$p("A climate-envelope model,", tags$a("Bioclim", href = "https://www.rdocumentation.org/packages/dismo/versions/1.1-4/topics/bioclim"), ", will take a set of location points and intersect them with raster layers of climatic data. The climate variables are used to interpolate one raster surface with an index of similarity to median values of the point dataset for the specified climate variables."),
  tags$br(),
  tags$li("First, select the climate variables to include in match. Raster layers for the seleced variables will be pulled from the", tags$a("Worldclim", href = "http://www.worldclim.org/bioclim"), "website."),
  tags$p(),
  tags$li("Then upload a CSV file containing the location points for your species with a column named", tags$b("decimalLatitude"), "containing the latitude values and a column named", tags$b("decimalLongitude"), "containing the longitude values."),
  tags$br(),
  sidebarLayout(
    sidebarPanel(
      
      checkboxGroupInput("variable", "Variables to include in match (choose at least two):",
                         c("Annual mean temp" = 1,
                           "Mean diurnal range" = 2,
                           "Isothermality" = 3,
                           "Temperature seasonality" = 4,
                           "Max temp in warmest month" = 5,
                           "Min temp of coldest month" = 6,
                           "Temperature annual range" = 7,
                           "Mean temp of wettest quarter" = 8,
                           "Mean temp of driest quarter" = 9,
                           "Mean temp warmest quarter" = 10,
                           "Mean temp of coldest quarter" = 11,
                           "Annual precipitation" = 12,
                           "Precip in wettest month" = 13,
                           "Precip of driest month" = 14,
                           "Precipitation seasonality" = 15,
                           "Precip of wettest quarter" = 16,
                           "Precip of driest quarter" = 17,
                           "Precip of warmest quarter" = 18,
                           "Precip of coldest quarter" = 19
                           )
                         )
     ),
    mainPanel(
      fluidRow(
        column(6, 
         fileInput("file1", "Choose location lat/lon CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
        )),
        column(6,
               tags$br(),
               #downloadButton("downloadExtract", "extract point values"),
          
               downloadButton("downloadMap", "download .png of map")
               )),
     
      
     # actionButton("plot","plot"),
     # plotOutput("Test") %>% withSpinner(color="#0dc5c1"),
     tabsetPanel(
      tabPanel("map", leafletOutput("locs") %>% withSpinner(color="#2d5986")),
      tabPanel("location points", tableOutput("table.output"))
     )
    )
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  mydata <- reactive({ #waiting for user to give file
    
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    locs <- read.csv(inFile$datapath)
    
    return(locs)
  })
  
  output$table.output <- renderTable({
    mydata()
  })
  my_map <- reactive({
    locs <- mydata() # a simple data frame with coordinates
    #coordinates(locs) <- c("decimalLongitude", "decimalLatitude") 
    #beetle icon, want to include other icon options later
    beetle <- makeIcon(
      iconUrl = "https://image.flaticon.com/icons/png/512/355/355673.png",
      iconWidth = 20, iconHeight = 26)
    #leaflet() %>% 
     # addProviderTiles(providers$CartoDB.Positron) %>% 
      #addMarkers(lat=locs$decimalLatitude, lng=locs$decimalLongitude, icon = beetle)
    #get climate data
    biocc <- getData("worldclim", var = 'bio', res = 10, 
                     lon = (locs$decimalLongitude), lat = (locs$decimalLatitude))
    #inputs <- c(as.numeric(input$variable))
    ccVariables <- biocc[[as.numeric(input$variable)]]
    print(input$variable)#c(6,15,3)
    cConstrict <- data.frame(longitude =locs$decimalLongitude, latitude = locs$decimalLatitude)
    ccExtract <- extract(biocc, cConstrict)
    ccMatch <- bioclim(ccVariables, cConstrict)
    
    #may set different extents later
    #world_extent <- extent(-180, 180, -90, 90)
    
    ccP <- predict(ccVariables, ccMatch) #, extent = world_extent
    ccP[ccP == 0] <- NA
    #color pal
    pal <- colorNumeric(c("transparent", "#FFBB33", "#008055"), values(ccP),
                        na.color = "transparent")
    
  leaflet() %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      setView(lat = 35, lng = -35, zoom = 2) %>% #center on Atlantic
      addMarkers(lat=locs$decimalLatitude, lng=locs$decimalLongitude, icon = beetle,
                 popup=paste(locs$decimalLatitude, locs$decimalLongitude))%>%
      addRasterImage(ccP, colors = pal, opacity = 0.6) %>%
      addLegend(pal = pal, position = "bottomleft", values = values(ccP),
                title = "Climate match index")
  })
   output$locs <- renderLeaflet({
     
    my_map()
    
  })
  #download .png of map
  output$downloadMap <- downloadHandler(
    filename = "matchMap.png",
    content = function(filename) {
      mapshot(my_map(), file = filename, remove_url = FALSE)
      
    }
  )
  
   #output$downloadExtract <- downloadHandler(
   #  filename = "extract.csv",
  # content = function(filename) {
    #  write.csv(ccExtract, filename, row.names = FALSE)
      
   # }
  #)
}

# Run the application 
shinyApp(ui = ui, server = server)

