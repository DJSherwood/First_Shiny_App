library(shiny)
library(ggplot2)

shinyUI(fluidPage(
        
        # Application title
        titlePanel("2011 Animal Intake Report - City of Austin"),
        
        plotOutput("DensityPlot"),
        
        fluidRow(

                column(2, offset=1,
                        selectInput("factor","Choose Factor",
                                    choices = c("Animal.Type","Sex","Intake.Type","Intake.Condition")),
                        selectInput("numeric","Choose Numeric",
                                    choices = c("Week.Number","Age"))
                ),
                
                column(5,
                       plotOutput("BoxPlot")
                ),
                
                column(4,
                       tableOutput("anovaout")
                )

        )
))
