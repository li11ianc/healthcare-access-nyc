library(shiny)
library(tidyverse)
library(shinythemes)

# Make custom theme for plots
theme_custom <- function() {
    theme_light() +
        theme(plot.title = element_text(color = "white", size = 24, face = "bold", hjust = .5),
              plot.subtitle = element_text(color = "white", size = 15, hjust = .5),
              axis.title.x = element_text(color = "white", size = 15, face = "bold"),
              axis.title.y = element_text(color = "white", size = 15, face = "bold"),
              axis.text.x = element_text(color = "white", size = 15, face = "bold"),
              axis.text.y = element_text(color = "white"),
              axis.ticks = element_blank(),
              legend.title = element_text(color = "white", size = 11, face = "bold"),
              panel.background = element_rect(fill = "#4A5D6D", color = "#4A5D6D"),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_rect(fill = "#4A5D6D", color = "#4A5D6D"),
              legend.background = element_rect(fill="#4A5D6D",size=0.5, linetype="solid"),
              legend.text = element_text(color = "white"))
}

ui <- fluidPage(theme = shinytheme("cyborg"),
                navbarPage(title = "NYC Healthcare Access",
                           tabPanel("Quality Explorer",
                                    sidebarLayout(
                                        sidebarPanel(
                                            h2("How does quality of healthcare vary across the New York City Metropolitan Area?"),
                                            h4("Examine where patient needs are and are not being met"),
                                            selectInput(inputId = "select_metric",
                                                               label   = "Select a healthcare quality metric:",
                                                               choices = list("Timeliness of Care" = "timeliness_of_care_national_comparison",
                                                                              "Effectiveness of Care" = "effectiveness_of_care_national_comparison",
                                                                              "Patient Experience" = "patient_experience_national_comparison",
                                                                              "Readmission" = "readmission_national_comparison",
                                                                              "Safety of Care" = "safety_of_care_national_comparison",
                                                                              "Mortality" = "mortality_national_comparison",
                                                                              "Overall Rating" = "hospital_overall_rating"
                                                                              ),
                                                               selected = "Overall Rating"),
                                            br(),
                                            hr(),
                                            h2("What does access look like in specific regions"),
                                            h4("Explore summaries by county"),
                                            
                                        ))
                           ),
                           tabPanel("About",
                                    column(width = 2),
                                    column(width = 8,
                                           h1("Introduction"))
                           )
                )
)


server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
