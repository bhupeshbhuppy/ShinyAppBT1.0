#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# Dev: Bhupesh Joshi Date:06/03/2017  

library(shiny)
#library(RODBC)
library(shinyjs)
library(plotly)
library(shinythemes)
library(shinyBS)
##mandatory fields
mandatory_fields<-c("date_range","RSSDID","criteria","dynamic")
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}
appCSS <- ".mandatory_star { color: red; }"

##UI starts here
shinyUI(fluidPage(
  theme = shinytheme("paper"),
  shinyjs::useShinyjs(),
  shinyjs::inlineCSS(appCSS),
  
  titlePanel("Benchmark Tool"),
  sidebarLayout(
    sidebarPanel(
      
      ############################## Form 1 First form ####################
      
      div(
        id = "form",
        dateRangeInput("date_range", 
                       labelMandatory("Date range:"), start = "2001-01-01",
                       end   = "2017-01-01" ),
        htmlOutput("selectUI"),
        textInput("RSSDID",labelMandatory("RSSD ID:")),
        radioButtons("criteria", 
                     labelMandatory("Criteria of Selection of Bank"),
                     c("Rank" = "rank", "Range" = "range", 
                       "Asset Size" = "size"), inline = TRUE),
        
        conditionalPanel(
          condition = "input.criteria == 'rank'",
          textInput("rankRange", labelMandatory("Rank"))
        ),
        conditionalPanel(
          condition = "input.criteria == 'range'",
          textInput("perRange", labelMandatory("Range(%)"))
        ),
        conditionalPanel(
          condition = "input.criteria == 'size'",
          textInput("assetSizeMin", 
                    labelMandatory("Minimum Asset Size (in Bl.)")),
          textInput("assetSizeMax", 
                    labelMandatory("Maximum Asset Size (in Bl.)"))
        ),
        
        actionButton("submit_form1", "Submit", class = "btn-primary")
      ),
      
      ########################## Form 2 (second form) ####################
      
      shinyjs::hidden(
        div(id="modeoneInput",
            radioButtons("seasonal", 
                         labelMandatory("Input data for Modelling"),
                         c("Deseasonalized" = "deseasonalized", 
                           "Standardized" = "standardized"), inline = TRUE) 
            ,
            radioButtons("stationarity", labelMandatory("Stationarity"),
                         c("ADF" = "adf", "KPSS" = "kpss", "PP"="pp")
                         , inline = TRUE) 
            ,
            radioButtons("correlation", labelMandatory("Correlation"),
                         c("Pearson" = "pearson", "Kendall" = "kendall",
                           "Spearman"="spearman"), inline = FALSE) 
            ,
            sliderInput("corrVar", "Number of variables from correlation
                        output", min = 0,max = 100,value = 20),
            # sliderInput("noModels", "Number of Models required",
            #             min = 0,max = 100,value = 20),
            # sliderInput("noVar", "Number of variables in final models", 
            #             min = 0,max = 100,value = 20),
            # sliderInput("noVarARIMA", "Number of variables for ARIMA",
            #             min = 0,max = 100,value = 20),
            downloadButton("download", label = "Download Report")
            )
      )
    ),
    
    mainPanel(
      div(id = "onloaddata", 
          tabsetPanel(
            tabPanel("Table View", dataTableOutput("view")),
            tabPanel("Scatter Plot", plotlyOutput("plotlyView"))
          )
      ),
      shinyjs::hidden(
        div(id = "queryOutput",
            h4("Trends in various Various Macro Economic Indicators"
               ,align = "center"),
            textOutput("heading2"),
            dygraphOutput("dyplot"),
            uiOutput("bsButtonUI"),
            uiOutput("bstipUI"),
            bsButton("go_button", "Go!",
                     type= "toggle", style = "success", align = "right")
            
            
        )
      ),
      shinyjs::hidden(
        div(id = "model", 
            textOutput("model")
        )
      )
    )
  )
  #shinythemes::themeSelector()
)
)