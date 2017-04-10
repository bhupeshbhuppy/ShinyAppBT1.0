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
onload_data<-read.csv(file = "asset_ranking_1.csv", header = TRUE,
                      check.names=FALSE)
field_val<- colnames(onload_data)

###Macro economic indicators data

indicators<-read.csv(file = "Book4.csv", header = TRUE, check.names=FALSE)
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
                 color = I(onload_data[,3]),
                 opacity = 0.8,
                 x = onload_data[,3],
                 y= onload_data[,4],
                 text = ~paste("Name: ", onload_data[,2], 
                               '$<br>RSSD ID:', onload_data[,1]),
                 sizemode= 'area',
                 size= onload_data[,4])
    layout(p,                       
           title = "Income VS Assets for major banks", 
           xaxis = list(title = "Average Assets (in Mn.) ",
                        showgrid = T),
           yaxis = list(title = "Net Income (in Mn.)"),
           data = onload_data,
           hovermode= 'closest'
    )
  })
  ####################### first submit button #####################
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
  
  ########## Macro Indicators Graphs ###############################
  
  
  output$bsButtonUI <- renderUI({
    lapply(2:length(indicator_names), function(i) {
      tipify(bsButton(paste0("button_",i), "",
                      type= "toggle", style = sample(style_sample,1)),
             indicator_names[i])
      
    })
  })
  observeEvent(input$go_button,{
    op_df<-data.frame(time=ts(as.yearqtr(indicators$Time,format 
                                         = "Q%q %Y")))
    for(i in 2:length(indicator_names)){
      if(!is.null(input[[paste0("button_",i)]]) 
         && input[[paste0("button_",i)]] == TRUE){
        op_df[[indicator_names[i]]]<-indicators[[indicator_names[i]]]
      }
    }
    output$dyplot<-renderDygraph(dygraph(op_df,
                                         xlab = "Year", 
                                         ylab = "Growth Rate"))
    #output$heading1<- renderText(input)
  })
  
  
  
  
  
  
  
  
  
  
  #output$heading1<- renderText(input)
  #})
  
  
  
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
