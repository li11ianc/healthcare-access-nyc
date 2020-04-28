library(shiny)
library(tidyverse)
library(shinythemes)
library(sf)
library(ggplot2)
library(DT)


#inpatients_ny <- read.csv("../data/ny_specific/medicare_inpatients_ny.csv")
medicare_ny <- read_csv("../data/ny_specific/medicare_ny.csv")
medicare_ny_map <- medicare_ny %>%
  filter(!is.na(lat), !is.na(long))
ny_metro_map <- st_read("../nyc_maps/ny_metro_map/ny_metro_map.shp", stringsAsFactors = FALSE)
ny_borough_map <- st_read("../nyc_maps/ny_borough_map/ny_borough_map.shp", stringsAsFactors = FALSE)
medicare_by_county <- read_csv("../data/ny_specific/medicare_by_county.csv")
cols <- c("Below the national average" = "red", "Above the national average" = "#0A97F0", "Same as the national average" = "#B8DAEF")
medicare_borough <- medicare_ny %>%  
  filter(county %in% c("Bronx", "New York", "Queens", "Kings", "Richmond"))
medicare_borough_map <- medicare_borough %>%
  filter(!is.na(lat), !is.na(long))


# Make custom theme for plots
theme_custom <- function() {
  theme_light() +
    theme(plot.title = element_text(color = "white", size = 20, face = "bold", hjust = .5),
          plot.subtitle = element_text(color = "white", size = 14, hjust = .5),
          axis.title.x = element_text(color = "white", size = 14, face = "bold"),
          axis.title.y = element_text(color = "white", size = 13),
          axis.text.x = element_text(color = "white", size = 12),
          axis.text.y = element_text(color = "white"),
          axis.ticks = element_blank(),
          legend.title = element_text(color = "white", size = 10, face = "bold"),
          panel.background = element_rect(fill = "#292929", color = "#292929"),
          panel.border=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_rect(fill = "#292929", color = "#292929"),
          legend.background = element_rect(fill="#292929", size = 0.5, linetype="solid"),
          legend.text = element_text(color = "white"))
}

ui <- fluidPage(theme = shinytheme("cyborg"),
                navbarPage(title = "NYC Healthcare Access",
                           tabPanel("Quality Explorer",
                                    sidebarLayout(
                                      sidebarPanel(
                                        width = 4,
                                        h3("How does quality of healthcare vary geographically in New York City?"),
                                        h5("Examine where patient needs are and are not being met"),
                                        radioButtons(inputId = "select_metric",
                                                     label   = "Select a healthcare quality metric:",
                                                     choices = list("Timeliness of Care" = "timeliness_of_care_national_comparison",
                                                                    "Effectiveness of Care" = "effectiveness_of_care_national_comparison",
                                                                    "Patient Experience" = "patient_experience_national_comparison",
                                                                    "Readmission" = "readmission_national_comparison",
                                                                    "Safety of Care" = "safety_of_care_national_comparison",
                                                                    "Mortality" = "mortality_national_comparison",
                                                                    "Overall Rating" = "hospital_overall_rating"
                                                     ),
                                                     selected = "Timeliness of Care"),
                                        br(),
                                        hr(),
                                        br(),
                                        h5("Select a county of interest"),
                                        selectizeInput(inputId = "select_metric_county", 
                                                       label = "County",
                                                       choices = unique(sort(medicare_ny$county)),
                                                       options = list(
                                                         placeholder = 'Select or type in an option',
                                                         onInitialize = I('function() { this.setValue(""); }')),
                                                       selected = "Bronx")
                                        
                                      ),
                                      mainPanel(fluidRow(
                                        column(width = 5,
                                               plotOutput(outputId = "rating_barplot",
                                                          width = "430px",
                                                          height = "450px"),
                                               br(),
                                               br(),
                                               br(),
                                               plotOutput(outputId = "borough_rating_map",
                                                          width = "413px",
                                                          height = "465px")
                                        ),
                                        column(width = 1),
                                        column(width = 6,
                                               plotOutput(outputId = "metro_rating_map",
                                                          width = "509px",
                                                          height = "550px"),
                                               br(),
                                               br(),
                                               p(
                                                 textOutput(outputId = "ny_metric_text1", inline = TRUE),
                                                 textOutput(outputId = "ny_metric_text2", inline = TRUE),
                                                 br(),
                                                 br(),
                                                 textOutput(outputId = "ny_borough_metric_text1", inline = TRUE),
                                                 textOutput(outputId = "ny_borough_metric_text2", inline = TRUE),
                                                 br(),
                                                 br(),
                                                 textOutput(outputId = "ny_county_metric_text1", inline = TRUE),
                                                 textOutput(outputId = "ny_county_metric_text2", inline = TRUE)
                                               ),
                                               tags$head(tags$style("#ny_metric_text1{color: red;
                                                              font-size: 28px;
                                                              font-style: bold;}",
                                                                    "#ny_metric_text2{color: white;
                                                              font-size: 18px;}",
                                                                    "#ny_borough_metric_text1{color: red;
                                                              font-size: 28px;
                                                              font-style: bold;}",
                                                                    "#ny_borough_metric_text2{color: white;
                                                              font-size: 18px;}",
                                                                    "#ny_county_metric_text1{color: red;
                                                              font-size: 28px;
                                                              font-style: bold;}",
                                                                    "#ny_county_metric_text2{color: white;
                                                              font-size: 18px;}"))
                                        )
                                      ),
                                      fluidRow(
                                        br(),
                                        br(),
                                        h2(textOutput(outputId = "county_name")),
                                        h4("Healthcare Quality Indicators"),
                                        plotOutput(outputId = "ratings_legend",
                                                   width = "270px",
                                                   height = "84px"),
                                        br(),
                                        br()
                                      ),
                                      fluidRow(column(width = 3,
                                                      plotOutput(outputId = "timeliness_indicator",
                                                                 width = "250px",
                                                                 height = "250px"),
                                                      br(),
                                                      br(),
                                                      plotOutput(outputId = "safety_indicator")),
                                               column(width = 1),
                                               column(width = 3,
                                                      plotOutput(outputId = "effectiveness_indicator"),
                                                      br(),
                                                      br(),
                                                      plotOutput(outputId = "readmission_indicator")),
                                               column(width = 1),
                                               column(width = 3,
                                                      plotOutput(outputId = "experience_indicator"),
                                                      br(),
                                                      br(),
                                                      plotOutput(outputId = "mortality_indicator"))),
                                      br(),
                                      br()
                                    ))
                           ),
                           tabPanel("County Level",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h3("What does access look like in specific regions"),
                                        h5("Explore quality of care summaries by county"),
                                        selectizeInput(inputId = "select_county", 
                                                       label = "County",
                                                       choices = unique(sort(medicare_ny$county)),
                                                       options = list(
                                                         placeholder = 'Select or type in an option',
                                                         onInitialize = I('function() { this.setValue(""); }')),
                                                       selected = "Bronx")
                                      ),
                                      mainPanel(
                                        fluidRow(
                                          dataTableOutput(outputId = "county_ratings"),
                                          style = "background-color: #4CAF50;color: white;"
                                        )
                                      )
                                    )
                           ),
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
      scale_fill_manual(values = cols, na.value = "#7B7C7C") +
      geom_bar() +
      scale_x_discrete(labels=c("Above the national average" = "Above", "Below the national average" = "Below",
                                "Same as the national average" = "Same")) +
      labs(x = paste0(str_to_title(str_replace_all(str_remove(input$select_metric, 
                                                              "_national_comparison"), "_", " ")), 
                      " Compared to the National Average"),
           y = "Number of Medicare hospital providers",
           title = paste0(str_to_title(str_replace_all(str_remove(input$select_metric, 
                                                                  "_national_comparison"), "_", " ")), 
                          " in NYC Metro Area"))+
      theme_custom() +
      theme(legend.position = "none")
  })
  
  output$metro_rating_map <- renderPlot({
    
    medicare_ny_map %>%
      ggplot() +
      geom_sf(data = ny_metro_map, aes(geometry = geometry),
              color="#E6E7E7", fill = "#F5F6F6") +
      geom_point(data = subset(medicare_ny_map, 
                               get(input$select_metric) == "Same as the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .8) +
      geom_point(data = subset(medicare_ny_map, 
                               get(input$select_metric) == "Above the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .7) +
      geom_point(data = subset(medicare_ny_map, 
                               get(input$select_metric) == "Below the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .7) +
      geom_point(data = subset(medicare_ny_map, 
                               is.na(get(input$select_metric))),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .7) +
      scale_color_manual(values = cols, na.value = "#7B7C7C") +
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
    
    medicare_borough_map %>%
      ggplot() +
      geom_sf(data = ny_borough_map, aes(geometry = geometry),
              color="#E6E7E7", fill = "#F5F6F6") +
      geom_point(data = subset(medicare_borough_map, 
                               get(input$select_metric) == "Same as the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .9) +
      geom_point(data = subset(medicare_borough_map, 
                               get(input$select_metric) == "Above the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .9) +
      geom_point(data = subset(medicare_borough_map, 
                               get(input$select_metric) == "Below the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .9) +
      geom_point(data = subset(medicare_borough_map, 
                               is.na(get(input$select_metric))),
                 aes(x = long, y = lat, color = get(input$select_metric)), 
                 alpha = .9) +
      scale_color_manual(values = cols, na.value = "#7B7C7C") +
      coord_sf() +
      theme_custom() +
      theme(plot.title = element_text(color = "white", size = 18, face = "bold", hjust = .5),
            plot.subtitle = element_text(color = "white", size = 12, hjust = .5),
            plot.caption = element_text(hjust = .5),
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
  
  output$ny_metric_text1 <- renderText({
    
    percent_metric <- (nrow(subset(medicare_ny, get(input$select_metric) == "Below the national average"))
                       / nrow(medicare_ny) * 100)
    
    paste0(round(percent_metric, 2), "%")
    
  })
  
  output$ny_metric_text2 <- renderText({
    paste0(" of Medicare provider hospitals in the New York City metropolitan area rank below the national average for ",
           str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " "), ".")
    
  })
  
  output$ny_borough_metric_text1 <- renderText({
    
    percent_metric <- (nrow(subset(medicare_borough, get(input$select_metric) == "Below the national average"))
                       / nrow(medicare_borough) * 100)
    
    paste0(round(percent_metric, 2), "%")
    
  })
  
  output$ny_borough_metric_text2 <- renderText({
    paste0(" of Medicare provider hospitals in the boroughs of New York City rank below the national average for ",
           str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " "), ".")
    
  })
  
  output$ny_county_metric_text1 <- renderText({
    
    percent_metric <- (nrow(subset(subset(medicare_ny, county == input$select_metric_county), 
                                   get(input$select_metric) == "Below the national average"))
                       / nrow(subset(medicare_ny, county == input$select_metric_county)) * 100)
    
    paste0(round(percent_metric, 2), "%")
    
  })
  
  output$ny_county_metric_text2 <- renderText({
    paste0(" of Medicare provider hospitals in ", input$select_metric_county, " County rank below the national average for ",
           str_replace_all(str_remove(input$select_metric, "_national_comparison"), "_", " "), ".")
    
  })
  
  output$county_name <- renderText({
    paste0(input$select_metric_county, " County")
  })
  
  output$ratings_legend <- renderPlot({
    
    ratings <- medicare_ny %>%
      ggplot(aes(x = effectiveness_of_care_national_comparison, 
                 fill = effectiveness_of_care_national_comparison)) +
      scale_fill_manual(values = cols, na.value = "#7B7C7C") +
      geom_bar() +
      theme_custom() +
      theme(legend.title = element_blank(),
            legend.text = element_text(color = "white", size = 18),
            legend.background = element_rect(fill = "black"))
    
    legend <- get_legend(ratings)
    ggdraw(legend)
    
  })
  
  # Indicator Plots
  plot_sq_county <- eventReactive(input$select_metric_county, {
    function(factor){
      if (subset(medicare_by_county, county == input$select_metric_county)[[factor]] == "Below the national average") {
        sqcolor <- "red"
      } else if (subset(medicare_by_county, county == input$select_metric_county)[[factor]] == "Above the national average") {
        sqcolor <- "#0A97F0"
      } else if (subset(medicare_by_county, county == input$select_metric_county)[[factor]] == "Same as the national average") {
        sqcolor <- "#B8DAEF"
      } else if (is.na(subset(medicare_by_county, county == input$select_metric_county)[[factor]])) {
        sqcolor <- "#7B7C7C"
      }
      
      sq <- ggplot() +
        labs(tag = str_to_title(str_replace_all(factor, "_", " "))) +
        theme_custom() +
        theme(
          plot.tag.position = c(0.5, 0.5),
          plot.tag = element_text(color = "white", size = 40, face = "bold"),
          plot.background = element_blank(),
          panel.background = element_rect(fill = sqcolor, color = "white")
        )
      
      return (sq)
    }
  })
  
  output$timeliness_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_metric_county)$timeliness_of_care == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_metric_county)$timeliness_of_care == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_metric_county)$timeliness_of_care == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_metric_county)$timeliness_of_care)) {
      sqcolor <- "#7B7C7C"
    }
    
    ggplot() +
      labs(tag = str_to_title(str_replace_all("timeliness_of_care", "_", " "))) +
      theme_custom() +
      theme(
        plot.tag.position = c(0.5, 0.5),
        plot.tag = element_text(color = "white", size = 22, face = "bold"),
        plot.background = element_rect(fill = sqcolor, color = sqcolor),
        panel.background = element_rect(fill = sqcolor, color = sqcolor)
      )
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
