library(shiny)
library(shinythemes)
library(DT)

# paths for publishing
#map_master <- read.csv("data/map_master.rds")
# paths for running locally
facilities <- read.csv("data/all_health_facilities.csv")

# Define UI for application that draws a histogram
ui <- navbarPage(theme = shinytheme("sandstone"), "US Healthcare Facilities",
                 
                 ### ABOUT ###
                 tabPanel("About",
                          ),
                 
                 ### HOSPITAL FINDER ###
                 tabPanel("Finder",
                          
                          # Title ----
                          titlePanel("Where are hospitals and pharmacies in my county?"),
                          
                          # Description ----
                          p(),
                          
                          # Sidebar layout with a input and output definitions ----
                          sidebarLayout(
                              
                              # Sidebar pannel for inputs ----
                              sidebarPanel(
                                  
                                  # Input: type of facilities ----
                                  
                                  # Input: state ----
                                  
                                  # Input: county ----
                              )
                              
                          )
                          ),
                 


    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
