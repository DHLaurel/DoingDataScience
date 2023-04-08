#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Load the dataset
employee_data <- read.csv("./CaseStudy2-data.csv", header = TRUE)

# Define server logic required to draw a histogram
function(input, output, session) {
  # Create scatter plot with regression line
  output$scatter_plot <- renderPlot({
    if (input$y_var == "Attrition"){
      ggplot(employee_data, aes_string(x = input$x_var, y = input$y_var)) + 
        geom_boxplot()
    }
    else{
      ggplot(employee_data, aes_string(x = input$x_var, y = input$y_var)) +
        geom_point() +
        geom_smooth(method = tolower(input$r_meth), )
    }
  })
  
}
