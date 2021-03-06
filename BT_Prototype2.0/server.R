#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(zoo)
library(shinyBS)
library(dygraphs)


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

##table and scatter plot data
onload_data<-read.csv(file = "asset_ranking_1.csv", header = TRUE)
field_val<- colnames(onload_data)

###Macro economic indicators data

indicators<-read.csv(file = "Book4.csv", header = TRUE)
time<-ts(as.yearqtr(indicators$Time, format = "Q%q %Y" ))
heading = "Select button to view graph"
indicator_names<-colnames(indicators)
style_sample<- c("default", "primary", "success", 
                 "info", "warning","danger")


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

shinyServer(function(input, output, session) {
  ##output table for the main panel on page load
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
  
  ## Scatter Plot for the main panel on page load 
  
  output$plotlyView<- renderPlotly({   
    p <- plot_ly(data = onload_data, 
                 type="scatter",
                 mode= 'marker',
                 color = I(onload_data$Average.Assets..in.Mn..),
                 opacity = 0.8,
                 x = onload_data$Average.Assets..in.Mn..,
                 y= onload_data$Net.Income..in.Mn..,
                 text = ~paste("Name: ", onload_data$Name, 
                               '$<br>RSSD ID:', onload_data$ID.RSSD),
                 sizemode= 'area',
                 size= onload_data$Net.Income..in.Mn..)
    layout(p,                       
           title = "Income VS Assets for major banks", 
           xaxis = list(title = "Average Assets (in Mn.) ",
                        showgrid = T),
           yaxis = list(title = "Net Income (in Mn.)"),
           data = onload_data,
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
    shinyjs::toggleState(id = "submit_form1", condition = 
                           mandatoryFilled)
    
    
    ########## next page Macro Indicators Graphs ####
    output$heading<-renderText("Trends in various Various
                                   MacroEconomic Indicators")
    
    output$bsButtonUI <- renderUI({
      lapply(2:length(indicator_names), function(i) {
        bsButton(indicator_names[i], "",
                 type= "toggle", style = sample(style_sample,1))
      })
    })
    observeEvent(input[[indicator_names[2]]],{
      op_df<-data.frame(time=ts(as.yearqtr(indicators$Time,format 
                                           = "Q%q %Y")))
      #op_df[[indicator_names[2]]]<-indicators[[indicator_names[2]]]
      for(i in 2:length(indicator_names)){
        if(!is.null(input[[indicator_names[i]]]) 
           && input[[indicator_names[i]]] == TRUE){
          op_df[[indicator_names[i]]]<-indicators[[indicator_names[i]]]
        }
      }
      output$dyplot<-renderDygraph(dygraph(op_df,
                                           xlab = "Year", 
                                           ylab = "Growth Rate"))
    })    
    
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

