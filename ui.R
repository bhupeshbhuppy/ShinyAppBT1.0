#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# Dev: Bhupesh Joshi Date:06/03/2017  

library(shiny)
library(RODBC)

shinyUI(fluidPage(
  
  titlePanel("Benchmark Tool"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", "Date range:", start = "2001-01-01",
                     end   = "2017-01-01"),
      htmlOutput("selectUI"),
      textInput("RSSDID","RSSD ID:"),
      radioButtons("criteria", "Criteria of Selection of Bank",
                         c("Rank" = "rank", "Range" = "range", 
                           "Asset Size" = "size"), inline = TRUE),
    
        conditionalPanel(
        condition = "input.criteria == 'rank'",
        textInput("rankRange", "Rank")
    ),
    conditionalPanel(
      condition = "input.criteria == 'range'",
      textInput("perRange", "Range(%)")
    ),
    conditionalPanel(
      condition = "input.criteria == 'size'",
      textInput("assetSizeMin", "Minimum Asset Size (in Bl.)"),
      textInput("assetSizeMax", "Maximum Asset Size (in Bl.)")
    )
    ),
    mainPanel(
      dataTableOutput("view")
      
    ) 
    )
  )
)
