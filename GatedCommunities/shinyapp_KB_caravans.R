df = read.csv2("/home/data.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)
head(df)
sapply(df, class)
df$lat<- as.numeric(as.character(df$lat))
df$long<- as.numeric(as.character(df$long))

library(leaflet)
library(shiny)


shinyApp(
  ui = fluidPage(
    titlePanel("Caravans in A"),
    
    sidebarLayout(
       # Show a plot of the generated distribution
      mainPanel(
        leafletOutput("MapPlot1", width = "100%", height = 800)
      ),
      # Sidebar with a slider input
      sidebarPanel(
        "Side panel will contain a drop down menu to choose the area as well as a section of analysis e.g. charts", 
        "Will check different side panel",
        plotOutput(outputId = "distPlot")
      ),
    
      
    )
  ),
  
  server = function(input, output) {
    
    output$MapPlot1 <- renderLeaflet({
      leaflet() %>% 
        #addProviderTiles("CartoDB.DarkMatter") %>% 
        addTiles() %>%
        setView(lng = -1, lat = 54.3555, zoom = 5)
    })
    
    observe({
      caravanIcons <- makeIcon("/home/image.png", iconWidth = 14, iconHeight =22)
      leafletProxy("MapPlot1") %>% clearMarkers() %>% 
        addMarkers(lng = df$long, # we feed the longitude coordinates 
                       lat = df$lat,
                       popup = paste("Property:", df$property_type, "<br>
                                   ", "Price:", df$price, "<br>
                                   ", "Num floors:", df$num_floors), 
                       clusterOptions = markerClusterOptions(),
                       icon=caravanIcons)
    })
    output$distPlot <- renderPlot({
      
      x    <- df$price
      bins <- seq(min(x), max(x), length.out = 3)
      
      hist(x, breaks = bins, col = "#75AADB", border = "white",
           xlab = "test",
           main = "Histogram of price- just test to see if i could add plot here")
      
    })
  },
  options = list(height = 600)
)