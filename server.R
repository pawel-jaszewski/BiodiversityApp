library(shiny)
library(data.table)
library(leaflet)
library(timevis)
library(DT)

server <- shinyServer(function(input, output, session) {
    
    vOccurencePoland <- fread("./occurencePoland.csv")
    vMultimediaPoland <- fread("./multimediaPoland.csv")
    
    updateSelectizeInput(
       session,
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
    
    output$photos <- renderUI({
      req(input$speciesSelector)
      fluidRow(
        lapply(unique(vMultimediaPoland[CoreId %in% vSelectedData()$id, CoreId]),
               function(x){
                 column(
                   width = 3,
                   HTML(paste(vSelectedData()[id == x, eventDate],
                              paste0("<img src='",
                                     vMultimediaPoland[CoreId == x, accessURI],
                                     "', width = '200', height = '200'>"),
                              sep = "<br/>")
                  )
                )
              }
        )
      )
    })
    
    orderedSpecies("orderedSpecies")
    
})