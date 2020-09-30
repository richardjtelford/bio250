#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Effect of contamination"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        mainPanel(
            numericInput("trueAge", "True Age, yr BP", 0),
            numericInput("contamAge", "Age of contamination, yr BP", 0),
            numericInput("contamPerc", "Percent contamination", 0)
            ),

        # Show a plot of the generated distribution
        mainPanel(
            h4("True Activity"),
            textOutput("trueActivity"),
            h4("Measured Activity"),
            textOutput("measuredActivity"),
            h4("Apparent Age yr BP"),
            textOutput("apparentAge"), 
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    halflife <- 5730
    process <- reactive({
      out <- list()
      out$trueAct <- exp(-log(2)*input$trueAge/halflife)
      out$contamAct <- exp(-log(2)*input$contamAge/halflife) 
      out$measuredAct <- out$trueAct * (1 - input$contamPerc / 100) + out$contamAct * input$contamPerc / 100
      out
    })

    output$trueActivity <- renderText(
        paste(signif(process()$trueAct * 100, 2), "% modern")
    ) 

    output$measuredActivity <- renderText(
        paste(signif(process()$measuredAct * 100, 2), "% modern")
    ) 
    
    output$apparentAge <- renderText({
       
      apparentAge <-  -log(process()$measuredAct) * halflife/log(2)
      apparentAge <- round(apparentAge)
      paste(apparentAge, ", yr BP")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
