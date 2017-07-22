#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Brazilian National Soccer Championship 2016"),
  
  plotOutput("distPlot"),
  hr(),
  
  fluidRow(
      column(3,
            selectInput("teams","Choose teams for the plot",choices = times$times, selected = times$times, multiple = TRUE)
      ),
      column(4,dataTableOutput('mytable')),
      column(4, offset = 1,
            selectInput("oneTeam","Know more about one team",choices = times$times, selected = times$times),
            h5("How many rounds on first place:",textOutput("firsts")),
            h5("Best Position:", textOutput("bPos")),
            h5("Worst Position:", textOutput("wPos"))
      )
  )
))
