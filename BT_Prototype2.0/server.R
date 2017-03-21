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
         
#           trace1 = {
#             x: onload_data$Average.Assets..in.Mn..
#             y: onload_data$Net.Income..in.Mn..
#             mode: 'markers'
#             marker: {
#               color: 'rgb(164, 194, 244)'
#               size: 12
#               line: {
#                 color: 'white'
#                 width: 0.5
#               }
#             }
#             text: ~paste("Name: ", onload_data$Name, 
#                           '$<br>RSSD ID:', onload_data$ID.RSSD)
#             type: 'scatter'
#           };
#           
#           layout = {
#             title: 'Income vs Assets for all the banks'
#             xaxis: {
#               title: 'Average Assets (in Mn.) '
#               showgrid: false
#               zeroline: false
#             }
#             yaxis: {
#               title: 'Net Income (in Mn.)'
#               showline: false
#             }
#           }; 
#           
#           p<-plot_ly(trace1, layout);
          
          p <- plot_ly(data = onload_data, 
                       type="scatter",
                       mode= 'marker',
                       color = I("blue"),
                       x = onload_data$Average.Assets..in.Mn..,
                       y= onload_data$Net.Income..in.Mn..,
                       text = ~paste("Name: ", onload_data$Name, 
                                     '$<br>RSSD ID:', onload_data$ID.RSSD),
                       sizemode= 'area',
                       size= onload_data$Net.Income..in.Mn..)
         
          
          
          
          p %>%add_markers(sizemode= 'area',
                        size= onload_data$Average.Assets..in.Mn..,
                        sizeref= 2)
            layout(p,                       
              title = "Income VS Assets for major banks", 
              xaxis = list(title = "Average Assets (in Mn.) ",
                showgrid = T),
              yaxis = list(title = "Net Income (in Mn.)"),
              data = onload_data,
              #margin= {t: 20},
              hovermode= 'closest'
            )
         
          
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
          shinyjs::toggleState(id = "submit_form1", condition = mandatoryFilled)

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
        })
     ######################### first submit button #####################
        
        
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

