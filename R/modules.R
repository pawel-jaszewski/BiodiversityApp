orderedSpecies <- function(id){
  moduleServer(
    id,
    function(input, output, session) {
      vOccurencePoland <- fread("./occurencePoland.csv")
      vSpeciesOrdered <- reactive({
        vSpeciesOrdered <- vOccurencePoland[get(input$scientificOrVernacularName) != "", .(Count = .N),
                         by = get(input$scientificOrVernacularName)
                         ][order(Count, decreasing = TRUE)]
        setnames(vSpeciesOrdered, c(input$scientificOrVernacularName, "Count"))
      })
      output$orderedSpeciesTable <- renderDataTable({
        datatable(vSpeciesOrdered(),
                  caption = HTML("<p style='color:black'><b>Species sorted by the number of
                                 occurences</b></p>")
                  )
      })
    }
  )
}

orderedSpeciesUI <- function(id){
  tagList(
    selectInput(inputId = NS(id, "scientificOrVernacularName"),
                label = "Choose which type of the name you want to display in the below table:",
                choices = list("Scientific Name" = "scientificName",
                               "Vernacular Name" = "vernacularName")),
    dataTableOutput(NS(id, "orderedSpeciesTable"))
  )
}
