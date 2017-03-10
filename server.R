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
constructQuery<-function(parm){
  query<-paste("SELECT * FROM XYZ")
  return(parm)
}
onload_data<-read.delim(file = "C:\\Users\\c-BhupeshJ\\Downloads\\FFIEC CDR Call Bulk All Schedules 12312016\\FFIEC CDR Call Bulk POR 12312016.txt", sep = "\t", header = TRUE)
field_val<- colnames(onload_data)
##Converting to JSON for front end object
#library(jsonlite)
#var_json<-toJSON(onload_data)



shinyServer(function(input, output) {
        
        output$view <- renderDataTable(
        onload_data, options = list(pageLength = 5, autoWidth = TRUE, searching = TRUE)
      )
        output$selectUI <- renderUI({ 
          selectInput("field","Select Field of Extraction:", 
                      field_val, multiple = TRUE, selectize = TRUE)
        })
      input$date_range[0]        
        
})

