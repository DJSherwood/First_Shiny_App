library(shiny)
library(ggplot2)

## https://data.austintexas.gov/dataset/2011-Animal-Intake-Report-Cats-and-Dogs-Exclusivel/wrwk-skv6

shinyServer(function(input, output) {
        
        filedata <- read.csv(paste0(getwd(),"/clean_animal_data.csv"),
                             sep=",",header=TRUE,strip.white=TRUE)
        

        usedata <- reactive({
                filedata[,c(input$factor,input$numeric)]
        })
        

        output$DensityPlot <- renderPlot({
                thedata <<- usedata()
                
                ggplot(data=thedata, aes(x=thedata[,2])) + 
                        geom_density(aes(fill=thedata[,1]),alpha=0.5,size=1) +
                        xlab(as.character(input$numeric)) + 
                        ylab(as.character("Density")) + 
                        scale_fill_discrete(guide=guide_legend(title="Factor"))
        })
        
        output$BoxPlot <- renderPlot({
                thedata <<- usedata()
                
                ggplot(data=thedata, aes(x=thedata[,1], y=thedata[,2])) + 
                        geom_boxplot(aes(fill=thedata[,1]),alpha=0.7,size=1) +
                        xlab(as.character(input$factor)) + 
                        ylab(as.character(input$numeric)) + 
                        scale_fill_discrete(guide=guide_legend(title="Factor"))
                        
        })

        output$anovaout <- renderTable({
                # Create ANOVA model object        
                s1 <- summary.lm(aov(thedata[,input$numeric]~thedata[,input$factor]))
                
                ## Create character string for rows names
                rnames <- c("Intercept",
                            levels(thedata[,input$factor])[2:length(levels(thedata[,input$factor]))])
                
                ## Produce Table 
                s2 <- data.frame(s1$coefficients, 
                                 row.names=rnames)
                
                ## Rename Columns
                names(s2) <- attr(s1$coefficients, "dimnames", exact=TRUE)[[2]]
                s2
                                       })
                
        
})
