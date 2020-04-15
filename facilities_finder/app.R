library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)

# paths for publishing
#map_master <- read.csv("data/map_master.rds")
# paths for running locally
facilities <- read.csv("../data/all_health_facilities.csv")

state_names <- unique(facilities$state)
city_names <- unique(facilities$city)

# Define UI for application that draws a histogram
ui <- navbarPage(theme = shinytheme("sandstone"), "US Healthcare Facilities",
                 
                 ### ABOUT ###
                 tabPanel("About",
                          ),
                 
                 ### HOSPITAL FINDER ###
                 tabPanel("Finder",
                          
                          # Title ----
                          titlePanel("Where can I find a hospital?"),
                          
                          # Description ----
                          p("This application helps you find the hospitals in any city, providing additional helpful information
                            such as location, number and website link."),
                          
                          # Sidebar layout with a input and output definitions ----
                          sidebarLayout(
                              
                              # Sidebar panel for inputs ----
                              sidebarPanel(
                
                                  # Input: state ----
                                  selectizeInput(inputId = "state", label = h3("State"),
                                                 choices = state_names,
                                                 options = list(
                                                     placeholder = 'Select or type in an option',
                                                     onInitialize = I('function() { this.setValue(""); }'))),
                                  
                                  # Input: county ----
                                  selectizeInput(inputId = "city",
                                                 label = h3("City"),
                                                 choices = state_names,
                                                 options = list(
                                                     placeholder = 'Select or type in an option',
                                                     onInitialize = I('function() { this.setValue(""); }')))
                              ),
                              
                              # Main panel for output ----
                              mainPanel(
                                  # Output: Table ----
                                  dataTableOutput("table")
                              )
                              
                          )
                          
                          )
                 
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$table <- DT::renderDataTable(
        facilities %>% 
            select(name, address, city, state, type, website, telephone) #%>% 
            #rename(State = state, Population = TotalPop)
        )
}

# Run the application 
shinyApp(ui = ui, server = server)
