library(shiny)
library(tidyverse)
library(shinythemes)
library(sf)
library(ggplot2)
library(DT)

#inpatients_ny <- read.csv("../data/ny_specific/medicare_inpatients_ny.csv")
medicare_ny <- read_csv("../data/ny_specific/medicare_ny.csv")
ny_metro_map <- st_read("../nyc_maps/ny_metro_map/ny_metro_map.shp", stringsAsFactors = FALSE)
ny_borough_map <- st_read("../nyc_maps/ny_borough_map/ny_borough_map.shp", stringsAsFactors = FALSE)
medicare_by_county <- read_csv("../data/ny_specific/medicare_by_county.csv")
cols <- c("Below the national average" = "red", "Above the national average" = "#0A97F0", "Same as the national average" = "black")


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
              panel.background = element_rect(fill = "#292929", color = "#292929"),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_rect(fill = "#292929", color = "#292929"),
              legend.background = element_rect(fill="#292929",size=0.5, linetype="solid"),
              legend.text = element_text(color = "white"))
}

ui <- fluidPage(theme = shinytheme("cyborg"),
                navbarPage(title = "NYC Healthcare Access",
                           tabPanel("Quality Explorer",
                                    sidebarLayout(
                                        sidebarPanel(
                                            h3("How does quality of healthcare vary across the New York City Metropolitan Area?"),
                                            h5("Examine where patient needs are and are not being met"),
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
                                            h3("What does access look like in specific regions"),
                                            h5("Explore quality of care summaries by county"),
                                            selectizeInput(inputId = "select_county", 
                                                           label = "County",
                                                           choices = unique(sort(medicare_ny$county)),
                                                           options = list(
                                                             placeholder = 'Select or type in an option',
                                                             onInitialize = I('function() { this.setValue(""); }')))
                                        ),
                                        mainPanel(fluidRow(
                                          column(width = 5,
                                            plotOutput(outputId = "rating_barplot")
                                            ),
                                          column(width = 8,
                                                 plotOutput(outputId = "metro_rating_map")
                                          )
                                          ),
                                          fluidRow(
                                            column(width = 9,
                                                   plotOutput(outputId = "borough_rating_map")
                                          ),
                                          dataTableOutput(outputId = "county_ratings")
                                          )
                                        )
                                        )),
                           tabPanel("About",
                                    column(width = 2),
                                    column(width = 8,
                                           h1("Introduction"))
                           )
                )
)


server <- function(input, output) {
  
  output$rating_barplot <- renderPlot({
    
    medicare_ny %>%
      ggplot(aes(x = get(input$select_metric), 
                 fill = get(input$select_metric))) +
      scale_fill_manual(values = cols, na.value = "grey") +
      geom_bar() +
      labs(x = paste0(str_to_title(str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " ")), " Compared to the National Average"),
           y = "Number of hospitals",
           title = "Whoops")+
           theme_custom() +
           theme(legend.position = "none")
  })
  
  output$metro_rating_map <- renderPlot({
    
    medicare_ny %>%
      ggplot() +
      geom_sf(data = ny_metro_map, aes(geometry = geometry),
              color="#9EA5A9", fill = "#CED5DA") +
      geom_point(data = subset(medicare_ny, 
                               get(input$select_metric) == "Same as the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .4) +
      geom_point(data = subset(medicare_ny, 
                               get(input$select_metric) == "Above the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .4) +
      geom_point(data = subset(medicare_ny, 
                               get(input$select_metric) == "Below the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .4) +
      scale_color_manual(values = cols, na.value = "grey") +
      coord_sf() +
      theme_custom() +
      theme(plot.caption = element_text(hjust = .5),
            legend.position = "none",
            axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank()) +
      labs(title = paste0(str_to_title(str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " ")), " For Medicare Providers"),
           subtitle = "In the New York City Metropolitan Area",
           color = str_to_title(str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " ")))
  })
  
  output$borough_rating_map <- renderPlot({
    
    medicare_borough <- medicare_ny %>%  
      filter(county %in% c("Bronx", "New York", "Queens", "Kings", "Richmond"))
    
    medicare_borough %>%
      ggplot() +
      geom_sf(data = ny_borough_map, aes(geometry = geometry),
              color="#9EA5A9", fill = "#CED5DA") +
      geom_point(data = subset(medicare_borough, 
                               get(input$select_metric) == "Same as the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .4) +
      geom_point(data = subset(medicare_borough, 
                               get(input$select_metric) == "Above the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .4) +
      geom_point(data = subset(medicare_borough, 
                               get(input$select_metric) == "Below the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .4) +
      scale_color_manual(values = cols, na.value = "grey") +
      coord_sf() +
      theme_custom() +
      theme(plot.caption = element_text(hjust = .5),
            legend.position = "none",
            axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank()) +
      labs(title = paste0(str_to_title(str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " ")), " For Medicare Providers"),
           subtitle = "In the Boroughs of New York City",
           color = str_to_title(str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " ")))
    
    
  })
  
  output$county_ratings <- renderDataTable ({
    
    medicare_by_county %>%
      filter(county == input$select_county)
    
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
