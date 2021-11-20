library(testthat)
source("./server.R")
source("./R/modules.R")

testServer(server, {
  session$setInputs(speciesSelector = "Abies alba")
  expect_equal(nrow(vSelectedData()), 1)
  session$setInputs(speciesSelector = "Accipiter gentilis")
  expect_equal(nrow(vSelectedData()), 8)
})

testServer(orderedSpecies, {
  session$setInputs(scientificOrVernacularName = "scientificName")
  expect_equal(nrow(vSpeciesOrdered()), 1848)
  session$setInputs(scientificOrVernacularName = "vernacularName")
  expect_equal(nrow(vSpeciesOrdered()), 1497)
})
