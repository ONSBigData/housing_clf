df = read.csv2("/home/data.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)
df$lat<- as.numeric(as.character(df$lat))
df$long<- as.numeric(as.character(df$long))
df$ID <- seq.int(nrow(df))

dfa = read.csv2("/home/data.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)[ ,c('description', 'laua', 'lat', 'long')]

dfa$lat<- as.numeric(as.character(dfa$lat))
dfa$long<- as.numeric(as.character(dfa$long))
namesuk <- read.csv("/home/data.csv")[ ,c('lad15cd', 'lad15nm')]
namesuk <-namesuk[!duplicated(namesuk$lad15nm), ]
names(namesuk)[1]<-"laua"
df2 <- merge(dfa, namesuk, by='laua', all.x=TRUE)
df2$caravan <- ifelse(grepl("caravan", df2$description, ignore.case = T),1,0)

test <-aggregate(caravan ~ lad15nm, df2, sum)

overview <-df2[!duplicated(df2$laua),]
overview <- merge(overview, test, by='lad15nm', all.x=TRUE)
overview <-subset(overview, select = -c(description, caravan.x) )
names(overview)[5]<-"caravan"
overview




library(shinydashboard)
library(shiny)

sidebar <- dashboardSidebar(width=200,
                            sidebarMenu( id="sidebar",
                                         menuItem("Overview", icon = icon("table"), tabName = "dashboard"),
                                         
                                         menuItem("Uni Variate", icon = icon("line-chart"), tabName = "Uni"),
                                         div(
                                           selectInput("LA",label=h5("Select Local Authority"),"")
                                         )
                            )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName="dashboard", 
            box( title="Map",solidHeader = TRUE, width="100%", height=800,leafletOutput("MapPlot1")
            )
    ),
    tabItem(tabName = "Uni",
            box(title="Plot", solidHeader = TRUE, plotOutput(outputId = "distPlot"), leafletOutput("MapPlot2"))
    )
  )
)

server <- function(input, output,session) {
  
  LA <- overview$lad15nm
  
  output$MapPlot1 <- renderLeaflet({
    leaflet() %>% 
      #addProviderTiles("CartoDB.DarkMatter") %>% 
      addTiles() %>%
      setView(lng = -1, lat = 54.3555, zoom = 5)
  })
  
  observe({
    caravanIcons <- makeIcon("/home/image.png", iconWidth = 14, iconHeight =22)
    leafletProxy("MapPlot1") %>% clearMarkers() %>% 
      addMarkers(lng = overview$long, # we feed the longitude coordinates 
                 lat = overview$lat,
                 popup = paste("LA:", overview$lad15nm, "<br>
                                   ", "Number of caravan:", overview$caravan),
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
}

shinyApp(dashboardPage(dashboardHeader(title= "Caravans in A"), sidebar, body), server = server)


