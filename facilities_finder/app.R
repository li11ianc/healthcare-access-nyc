library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)

# paths for publishing
#map_master <- read.csv("data/map_master.rds")
# paths for running locally
facilities <- read.csv("../data/all_health_facilities.csv") %>% filter(overall_type %in% c("hospital", "nursing home"))

# Define UI for application that draws a histogram
ui <- navbarPage(theme = shinytheme("sandstone"), "US Healthcare Facilities",
                 
                 ### ABOUT ###
                 tabPanel("About",
                          h4("This ShinyApp is a simple one-stop shop for finding healthcare facilities in your area.
                             \nLook up information by the type of facility you are looking for - whether that is a hospital, a nursing home, or both - and
                              the specific location. Let's dive in!")),
                 
                 ### HOSPITAL FINDER ###
                 tabPanel("Finder",
                          
                          # Title ----
                          titlePanel("Where can I find a healthcare facility?"),
                          
                          # Sidebar layout with a input and output definitions ----
                          sidebarLayout(
                              
                              # Sidebar panel for inputs ----
                              sidebarPanel(
                                  
                                  # Input: type ----
                                  checkboxGroupInput("type", label = h3("Facility type"), 
                                                    choices = list("Hospitals" = "hospital", "Nursing homes" = "nursing home"),
                                                    selected = "hospital"),
                                  
                                  # Input: state ----
                                  selectizeInput(inputId = "state", label = h3("State"),
                                                 choices = unique(sort(facilities$state)),
                                                 options = list(
                                                     placeholder = 'Select or type in an option',
                                                     onInitialize = I('function() { this.setValue(""); }'))),
                                  
                                  # Input: county ----
                                  selectizeInput(inputId = "county",
                                                 label = h3("County"),
                                                 choices = NULL,
                                                 options = list(
                                                     placeholder = 'Select or type in an option',
                                                     onInitialize = I('function() { this.setValue(""); }'))),
                                  
                                  # Input: city ----
                                  selectizeInput(inputId = "city",
                                                 label = h3("City"),
                                                 choices = NULL,
                                                 options = list(
                                                     placeholder = 'Select or type in an option',
                                                     onInitialize = I('function() { this.setValue(""); }'))),
                                  
                                  # Action button ----
                                  actionButton("GetTable", "Go")
                              ),
                              
                              # Main panel for output ----
                              mainPanel(
                                  # Output: Table ----
                                  dataTableOutput("table"),
                                  p("*At this time, website information is not available for nursing homes."))
                              
                              
                          ) # close sidebar layout
                          
                          )
                 
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # update county input choices
    observeEvent(input$state,{
        updateSelectizeInput(session, 'county',
                             choices = sort(unique(facilities$county[facilities$state==input$state])))
    })
    
    # update city input choices
    observeEvent(input$county,{
        updateSelectizeInput(session, 'city',
                          choices = sort(unique(facilities$city[facilities$state==input$state & facilities$county==input$county])))
    }) 
    
    # get table data
    table_data <- eventReactive(input$GetTable, {
        validate(
            need(input$type != "",
                 "Please specify at least one facility type")
        )
        
        validate(
            need(input$state != "" & input$county != "" & input$city != "",
                 "Please specify the state, county and city that you are interested in")
        )
        
        facilities %>% 
            filter(overall_type %in% input$type) %>% 
            filter(state == input$state, county == input$county, city == input$city) %>% 
            select(name, address, city, state, type, website, telephone) %>% 
            rename(Name = name, Address = address, City = city, State = state, 
                   Type = type, Website = website, Telephone = telephone)
    })
    
    output$table <- DT::renderDataTable(
        table_data()
        )
}

# Run the application 
shinyApp(ui = ui, server = server)
