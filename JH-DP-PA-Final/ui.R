#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)

cb16 <- read.csv("campeonatoBrasileiro2016.csv", sep = "," )
names(cb16) <- gsub("X","",names(cb16))
cb16N <- cb16 %>% gather(Round, Position, -Times)
cb16N$Round <- as.numeric(cb16N$Round)
xrange <- range(cb16N$Round) 
yrange <- range(cb16N$Position) 
times <- cb16N[cb16N$Round==xrange[2],]
ntimes <- length(unique(cb16N$Times))
colors <- rainbow(ntimes) 
linetype <- c(1:ntimes)
times <- data.frame(times=times$Times,colors=colors,linetype=linetype, finalPos=times$Position)


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
            selectInput("oneTeam","Know more about one team",choices = times, selected = times$times),
            h5("How many rounds on first place:",textOutput("firsts")),
            h5("Best Position:", textOutput("bPos")),
            h5("Worst Position:", textOutput("wPos"))
      )
  ),
  fluidRow(column(12,a("Go to the gitHub and learn how to used this app"
, href="https://github.com/rcarvalheira/Coursera-JH-DataProducts/tree/master/JH-DP-PA-Final")))
))
