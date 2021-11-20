library(leaflet)
library(timevis)
library(DT)

ui <- shinyUI(
    fluidPage(
        titlePanel("Global Biodiversity Information Facility"),
        sidebarLayout(
            sidebarPanel(
                id = "sidebar",
                selectizeInput(inputId = "speciesSelector",
                               label = "Choose species by either Scientific or Vernacular Name
                               to be presented on the map and the timeline:",
                               choices = NULL),
                br(),
                orderedSpeciesUI("orderedSpecies")
            ),
            mainPanel(
                leafletOutput("map"),
                timevisOutput("timePlot")
            )
        ),
        tags$head(tags$style(
            HTML('
            #sidebar {background-color: #FFFFFF;}
            ')
        ))
    )
)
