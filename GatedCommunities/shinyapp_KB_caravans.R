df = read.csv2("/home/data.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)
head(df)
sapply(df, class)
df$lat<- as.numeric(as.character(df$lat))
df$long<- as.numeric(as.character(df$long))
df$ID <- seq.int(nrow(df))

namesuk <- read.csv("/home/Index_of_Place_Names_in_Great_Britain_July_2016.csv")[ ,c('lad15cd', 'lad15nm')]
head(namesuk)
names(namesuk)[1]<-"laua"
df2 <- merge(df, namesuk, by='laua', all.x=TRUE)
head(df2)

df2 <-df2[!duplicated(df2$ID), ]


library(leaflet)
library(shiny)
library(shinydashboard)


shinyApp(
  ui = dashboardPage(
    dashboardHeader(title = "Caravans in A"),
    dashboardSidebar("Side panel will contain a drop down menu to choose the area as well as a section of analysis e.g. charts", br(), br(),
                     "Will check different side panel options"
                     #selectInput("property", "Property type:",
                     #            list("Caravan" = c("Residential caravan" = "res_caravan", 
                     #                 "Holiday caravan" = "hol_caravan"), 
                     #                 "Gated community" = "gated")),
                     ),
    dashboardBody(box(title = "Map", status = "primary", solidHeader = TRUE,
                      collapsible = TRUE, leafletOutput("MapPlot1", width = "100%", height = 800)),
                  box(title = "Inputs", status = "warning", collapsible = TRUE, solidHeader = TRUE, plotOutput(outputId = "distPlot"),  sliderInput("slider", "Slider input:", 1, 100, 50)),
                  box(valueBox(10 * 2, "Percent in area", icon = icon("percent")),
                  valueBox(10 * 2, "Proprty type", icon = icon("home")), valueBox(10 * 2, "Average price", icon = icon("line-chart")))
                  
                  
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
           main = "Histogram of price- test to see if I could add plot here")
      
    })
  },
  options = list(height = 600)
)