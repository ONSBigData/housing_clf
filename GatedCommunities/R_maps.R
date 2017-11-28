library(leaflet)

df = read.csv2("/home/caravan.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)
#leaflet(df) %>% addTiles() %>% addCircles()
head(df)
sapply(df, class)
df$lat<- as.numeric(as.character(df$lat))
df$long<- as.numeric(as.character(df$long))

m <- leaflet()
m <- addTiles(m)

caravanIcons <- makeIcon("/home/mobile_home.png", iconWidth = 14, iconHeight =22)
m = addMarkers(m, 
                     lng = df$long, # we feed the longitude coordinates 
                     lat = df$lat,
                     popup = paste("Property:", df$property_type, "<br>
                                   ", "Price:", df$price, "<br>
                                   ", "Num floors:", df$num_floors), 
                     icon=caravanIcons)
m



df2 = read.csv2("/home/gated.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)
#leaflet(df) %>% addTiles() %>% addCircles()
head(df)
sapply(df2, class)
df2$lat<- as.numeric(as.character(df2$lat))
df2$long<- as.numeric(as.character(df2$long))

m <- leaflet()
m <- addTiles(m)
m = addCircleMarkers(m, 
                     lng = df2$long, # we feed the longitude coordinates 
                     lat = df2$lat,
                     popup = df$pred_prob, 
                     radius = 2, 
                     stroke = FALSE, 
                     fillOpacity = 0.75)
m


df3 = read.csv2("/home/LR_clf_pred.csv", sep=",", stringsAsFactors=FALSE, header = TRUE)
#leaflet(df) %>% addTiles() %>% addCircles()
head(df3)
sapply(df3, class)
df3$lat<- as.numeric(as.character(df2$lat))
df3$long<- as.numeric(as.character(df2$long))

m <- leaflet()
m <- addTiles(m)
m = addCircleMarkers(m, 
                     lng = df2$long, # we feed the longitude coordinates 
                     lat = df2$lat,
                     popup = df$pred_prob, 
                     radius = 2, 
                     stroke = FALSE, 
                     fillOpacity = 0.75)
m


