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
fluidPage(

    # Application title
    titlePanel("Predicting Attrition and Monthly Income"),

    
    
    # Sidebar panel
    sidebarPanel(
      
      # Select dependent variable
      selectInput("y_var", "Select dependent variable:",
                  choices = c("MonthlyIncome", "Attrition")),
      
      # Select independent variable
      radioButtons("x_var", "Select independent variable:",
                   choices = c("YearsAtCompany", "Age", "DailyRate")),
      
      # Select dependent variable
      radioButtons("r_meth", "Select regression method:",
                  choices = c("LM", "Loess")),
      
    ),
    
    # Main panel
    mainPanel(
      
      # Display scatter plot with regression line
      plotOutput("scatter_plot")
      
    )
    
)
