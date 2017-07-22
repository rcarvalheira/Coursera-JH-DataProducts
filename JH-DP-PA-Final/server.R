#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)



shinyServer(function(input, output) {
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

    
  output$distPlot <- renderPlot({
      
      # get the range for the x and y axis 

      timesSelected <- input$teams
      ntimesSelected <- length(input$teams)
      
      #Build the plot
      plot(cb16N$Round,cb16N$Position,ylim=c(ntimes,1), xlim=c(xrange[1],xrange[2]+3.5), type = "n"
           ,xlab = "Round", ylab="Position")

      
      # add lines 
      for (i in 1:ntimesSelected) { 
          time <- subset(cb16N, Times == timesSelected[i]) 
          lines(time$Round, time$Position, type="l", lwd=1.5,
                lty=times$linetype[times$times==timesSelected[i]]
                , col=times$colors[times$times==timesSelected[i]]) 
      }
      #add a legend
      legend(x = xrange[2]+0.5,y = yrange[1], legend = timesSelected, cex=0.8
             ,col=times$colors[times$times==timesSelected]
             ,lty=times$linetype[times$times==timesSelected]
             ,title="Team Positions over Rounds")
        }
      , height = 450)
  
  
  output$mytable = renderDataTable({
      times[times$times==input$teams,c("times","finalPos")]
  })
  output$table <- renderTable(times[times$times==input$teams,])
 
    output$firsts <- renderText({
        nrow(cb16N[cb16N$Position==1 & cb16N$Times==input$oneTeam,])
    })
    output$bPos <- renderText({
        min(cb16N[cb16N$Times==input$oneTeam,"Position"])
    })
    output$wPos <- renderText({
        max(cb16N[cb16N$Times==input$oneTeam, "Position"])
    })

})
    
