#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
#library(devtools)
#library(DT)
## COnnecting DB




##Fetching data from DB
field_val<-c("Email","Name of Person","Area Code","Fax Number", "Legal Name")
parm<-0
getData<-function(parm){
  query<-"This page contains the default output model output. Other models output will be presented on the basis of selection on the side panel"
  return(query)
}
onload_data<-read.delim(file = "C:\\Users\\c-BhupeshJ\\Downloads\\FFIEC CDR Call Bulk All Schedules 12312016\\FFIEC CDR Call Bulk POR 12312016.txt", sep = "\t", header = TRUE)
field_val<- colnames(onload_data)

##Defining mandatory fields
shinyjs::useShinyjs()
fieldsMandatory<-c("RSSDID","criteria","dynamic")

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}
appCSS <- ".mandatory_star { color: red; }"



shinyServer(function(input, output) {
        ##output for the main panel in page load
        output$view <- renderDataTable(
        onload_data, options = list(pageLength = 5, autoWidth = TRUE, searching = TRUE)
      )
        ##part of the form
        output$selectUI <- renderUI({ 
          selectInput("dynamic",labelMandatory("Select Field of Extraction:"), 
                      field_val, multiple = TRUE)
        })
        
        ##for submit button
        observe({
          # check if all mandatory fields have a value
          mandatoryFilled <-
            vapply(fieldsMandatory,
                   function(x) {
                     !is.null(input[[x]]) && input[[x]] != ""
                   },
                   logical(1))
          mandatoryFilled <- all(mandatoryFilled)
          
          # enable/disable the submit button
          shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
        })
     
        observeEvent(input$submit,{
         queryParm<-list(input$date_range,input$dynamic, input$RSSDID, input$criteria, input$rankRange, input$perRange, input$assetSizeMin, input$assetSizeMax)     
         output$data<-renderText(getData(queryParm))
         shinyjs::reset("form")
         shinyjs::hide("form")
         shinyjs::hide("onloaddata")
         shinyjs::show("modeoneInput")
         shinyjs::show("queryOutput")
         }
        )
})

