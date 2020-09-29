#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(patchwork)
library(shiny)

#setup 
#A=Ainitial e-ln(2)*age/halflife
n <- 80
step <- 200
mx <- 50000
nstep <- mx%/%step
A = 1 * exp(-log(2)*step/5568)

decay <- matrix(runif(n ^ 2 * nstep), ncol = nstep) < A 
notdecayed <- rbind(TRUE, apply(decay, 1, cumall)) %>% t() %>%  as.vector()
c14_sim <- tibble(
    notdecayed = notdecayed, 
    time = rep(seq(0, mx, step), each = n ^ 2), 
    row = rep(rep(1:n, each = n), times = nstep + 1), 
    col = rep(rep(1:n, times = n), times = nstep + 1)
) 


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Radiocarbon decay"),

    inputPanel(
        
        sliderInput("years", label = "Years",
                    min = 0, max = mx, value = 0, step = step, width = "100%")
    ),

        # Show a plots
        mainPanel(
           plotOutput("plot")
        )
    )


# Define server logic
server <- function(input, output) {
    output$plot <- renderPlot({
        
        sim <- c14_sim %>%
            filter(time == input$years, notdecayed) %>% 
            ggplot(aes(x = col, y = row)) +
            geom_point(colour = scales::muted("red"), show.legend = FALSE) +
            scale_x_continuous(limits = c(0, n), expand = c(0.02, 0)) +
            scale_y_continuous(limits = c(0, n), expand = c(0.02, 0)) +
            theme_minimal() +
            theme(axis.text = element_blank(), 
                  axis.title = element_blank())

        activity <- c14_sim %>% 
            filter(time <= input$years) %>% 
            group_by(time) %>% 
            summarise(activity = mean(notdecayed)) %>% 
            ggplot(aes(x = time, y = activity)) +
            geom_line() +
            xlim(0, mx) + 
            ylim(0, 1) +
            labs(x = "Years", y = "Proportion Modern Activity") + 
            theme_bw(base_size = 16)
        sim + activity
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
