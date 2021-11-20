server <- shinyServer(function(input, output, session) {
    
    vOccurencePoland <- fread("./occurencePoland.csv")
    
    updateSelectizeInput(session,
                         inputId = "speciesSelector",
                         choices = sort(c(unique(vOccurencePoland[, scientificName]),
                                          unique(vOccurencePoland[vernacularName != "",
                                                                  vernacularName]))),
                         server = TRUE)
    
    vSelectedData <- reactive({
        vOccurencePoland[scientificName == input$speciesSelector |
                             vernacularName == input$speciesSelector,]
    })
    
    output$map <- renderLeaflet({
        req(input$speciesSelector)
        leaflet(vSelectedData()) %>% addTiles() %>% 
            addMarkers(lng = ~longitudeDecimal,
                       lat = ~latitudeDecimal,
                       popup = ~paste(gsub("Poland - ", "", locality), eventDate, sep = "<br/>"))
    })
    
    output$timePlot <- renderTimevis({
        req(input$speciesSelector)
        vSelectedDataDate <- data.frame(
            content = vSelectedData()[, eventDate],
            start = as.Date(vSelectedData()[, eventDate], format = "%d.%m.%Y"))
        timevis(vSelectedDataDate, options = list(showCurrentTime = FALSE))
    })
    
    orderedSpecies("orderedSpecies")
    
})