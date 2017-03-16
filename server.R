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
library(plotly)




##Fetching data from DB
field_val<-c("Email","Name of Person","Area Code",
             "Fax Number", "Legal Name")
parm<-0
getData<-function(parm){
  query<-"This page contains the default output model output.
  Other models output will be presented on the basis of selection 
  on the side panel"
  return(query)
}
onload_data<-read.csv(file = "C:\\Users\\c-BhupeshJ\\Documents\\BT_Prototype2.0\\asset_ranking_1.csv", header = TRUE)
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
        onload_data, options = list(pageLength = 10, autoWidth = TRUE,
                                    searching = TRUE)
      )
        ##part of the form
        output$selectUI <- renderUI({ 
          selectInput("dynamic",
                      labelMandatory("Select Field of Extraction:"), 
                      field_val, multiple = TRUE)
        })
        plotOnloadData<-plot_ly(data = onload_data)
        output$plotlyView<- renderPlotly({
          
          p <- plot_ly(data = onload_data, 
                       x = onload_data$Average.Assets..in.Mn..,
                       y= onload_data$Net.Income..in.Mn..,
                       text = ~paste("Name: ", onload_data$Name, 
                                     '$<br>RSSD ID:', onload_data$ID.RSSD))
         
          
          
          
           # %>% add_markers()
          # %>%
          # 
          #   layout(p,                        # all of layout's properties: /r/reference/#layout
          #     title = "Income VS Assets", # layout's title: /r/reference/#layout-title
          #     xaxis = list(           # layout's xaxis is a named list. List of valid keys: /r/reference/#layout-xaxis
          #       title = "Average Assets (in Mn.) ",      # xaxis's title: /r/reference/#layout-xaxis-title
          #       showgrid = F),       # xaxis's showgrid: /r/reference/#layout-xaxis-showgrid
          #     yaxis = list(           # layout's yaxis is a named list. List of valid keys: /r/reference/#layout-yaxis
          #       title = "Net Income (in Mn.)")     # yaxis's title: /r/reference/#layout-yaxis-title
          #   , data = onload_data)
          # add_scattergeo(p, xaxis= "Average Assets (in Mn.)",
          #                yaxis="Net Income (in Mn.)")
          
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
     ######################### first submit button #####################
        observeEvent(input$submit_form1,{
         queryParm<-list(input$date_range,input$dynamic, 
                         input$RSSDID, input$criteria, input$rankRange, 
                         input$perRange, input$assetSizeMin, 
                         input$assetSizeMax)     
         output$data<-renderText(getData(queryParm))
         shinyjs::reset("form")
         shinyjs::hide("form")
         shinyjs::hide("onloaddata")
         shinyjs::show("modeoneInput")
         shinyjs::show("queryOutput")
        })
        
      ######################### Second submit button #####################
        # observeEvent(input$submit_form1,{
        #   queryParm<-list(input$date_range,input$dynamic, 
        #input$RSSDID, input$criteria, input$rankRange, input$perRange, 
        #input$assetSizeMin, input$assetSizeMax)     
        #   output$model<-renderText("Model and Result")
        #   shinyjs::reset("form")
        #   shinyjs::hide("form")
        #   shinyjs::hide("onloaddata")
        #   shinyjs::hide("queryOutput")
        #   shinyjs::hide("modeoneInput")
        #   #shinyjs::show("modeoneInput")
        #   shinyjs::show("model")
        # })
        
        
})

