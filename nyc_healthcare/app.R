library(shiny)
library(tidyverse)
library(shinythemes)
library(sf)
library(ggplot2)
library(cowplot)


medicare_ny <- read_csv("data/medicare_ny.csv")
medicare_ny_map <- medicare_ny %>%
  filter(!is.na(lat), !is.na(long))
ny_metro_map <- st_read("data/ny_metro_map/ny_metro_map.shp", stringsAsFactors = FALSE)
ny_borough_map <- st_read("data/ny_borough_map/ny_borough_map.shp", stringsAsFactors = FALSE)
medicare_by_county <- read_csv("data/medicare_by_county.csv")
cols <- c("Below the national average" = "red", "Above the national average" = "#0A97F0", "Same as the national average" = "#B8DAEF")
medicare_borough <- medicare_ny %>%  
  filter(county %in% c("Bronx", "New York", "Queens", "Kings", "Richmond"))
medicare_borough_map <- medicare_borough %>%
  filter(!is.na(lat), !is.na(long))
datamap <- right_join(medicare_by_county, ny_borough_map, by = "county")


# Make custom theme for plots
theme_custom <- function() {
  theme_light() +
    theme(plot.title = element_text(color = "white", size = 20, face = "bold", hjust = .5),
          plot.subtitle = element_text(color = "white", size = 14, hjust = .5),
          plot.caption = element_text(color = "white", hjust = .5),
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
                navbarPage(title = "Healthcare Access in NYC",
                           tabPanel("Geographic Explorer",
                                    sidebarLayout(
                                      sidebarPanel(
                                        width = 4,
                                        h3("How does quality of healthcare vary geographically in New York City?"),
                                        h5("Among Medicare providers"),
                                        radioButtons(inputId = "select_metric",
                                                     label   = "Select a healthcare quality metric:",
                                                     choices = list("Timeliness of Care" = "timeliness_of_care_national_comparison",
                                                                    "Effectiveness of Care" = "effectiveness_of_care_national_comparison",
                                                                    "Patient Experience" = "patient_experience_national_comparison",
                                                                    "Readmission" = "readmission_national_comparison",
                                                                    "Safety of Care" = "safety_of_care_national_comparison",
                                                                    "Mortality" = "mortality_national_comparison"
                                                     ),
                                                     selected = "timeliness_of_care_national_comparison"),
                                        br(),
                                        hr(),
                                        br(),
                                        h5("Select a county of interest"),
                                        selectInput(inputId = "select_metric_county", 
                                                       label = "County",
                                                       choices = unique(sort(medicare_ny$county)),
                                                       selected = "Bronx"),
                                        p("Note: Each of the five boroughs of NYC are counties unto themselves -- Queens County, Bronx County, Richmond County (known as Staten Island), New York County (known as Manhattan), and Kings County (known as Brooklyn).")
                                        
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
                                      
                                    ))
                           ),
                           tabPanel("Socioeconomic Lens",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h3("How does quality of healthcare access intersect with socioeconomic indicators?"),
                                        br(),
                                        br(),
                                        fluidRow(
                                          column(width = 6,
                                            radioButtons(inputId = "select_metric_ses",
                                                         label   = "Select a healthcare quality metric:",
                                                         choices = list("Timeliness of Care" = "timeliness_of_care_national_comparison",
                                                                        "Effectiveness of Care" = "effectiveness_of_care_national_comparison",
                                                                        "Patient Experience" = "patient_experience_national_comparison",
                                                                        "Readmission" = "readmission_national_comparison",
                                                                        "Safety of Care" = "safety_of_care_national_comparison",
                                                                        "Mortality" = "mortality_national_comparison"
                                                         ),
                                                         selected = "effectiveness_of_care_national_comparison")),
                                          column(width = 6,
                                              radioButtons(inputId = "select_demog_ses",
                                                           label   = "Select a socioeconomic metric:",
                                                           choices = list("Poverty" = "percent_in_poverty_2018",
                                                                          "Unemployment" = "percent_unemployed_in_2017",
                                                                          "Median Household Income" = "median_household_income_2018",
                                                                          "Population" = "population_in_2018"
                                                           ),
                                                           selected = "percent_in_poverty_2018")
                                              )),
                                        br(),
                                        hr(),
                                        br(),
                                        br(),
                                        br(),
                                        br(),
                                        h3("How do individual counties fare?"),
                                        br(),
                                        h5("Select a county of interest"),
                                        selectInput(inputId = "select_county_ses", 
                                                    label = "County",
                                                    choices = unique(sort(medicare_ny$county)),
                                                    selected = "Bronx"),
                                        p("Note: Each of the five boroughs of NYC are counties unto themselves -- Queens County, Bronx County, Richmond County (known as Staten Island), New York County (known as Manhattan), and Kings County (known as Brooklyn).")
                                        ),
                                      mainPanel(
                                        plotOutput(outputId = "ses_borough_map",
                                                   width = "759px",
                                                   height = "530px"),
                                        br(),
                                        br(),
                                        plotOutput(outputId = "county_score_plot",
                                                   width = "760px",
                                                   height = "400px"),
                                        fluidRow(
                                          br(),
                                          hr(),
                                          br(),
                                          column(width = 5,
                                          h2(textOutput(outputId = "county_name")),
                                          h4("Healthcare Quality Indicators"),
                                          plotOutput(outputId = "ratings_legend",
                                                     width = "270px",
                                                     height = "84px"),
                                          br(),
                                          br(),
                                          textOutput(outputId = "county_hospital_rating"),
                                          tags$head(tags$style("#county_hospital_rating{color: white;
                                                              font-size: 24px;
                                                              font-style: italic;}")),
                                          br(),
                                          br()),
                                          column(width = 5,
                                                 br(),
                                                 br(),
                                                 br(),
                                                 br(),
                                                 h4("Socioeconomic Indicators"),
                                                 textOutput(outputId = "county_ses_text1"),
                                                 tags$head(tags$style("#county_ses_text1{color: white;
                                                              font-size: 20px;
                                                              font-style: italic;}")),
                                                 textOutput(outputId = "county_ses_text2"),
                                                 tags$head(tags$style("#county_ses_text2{color: white;
                                                              font-size: 20px;
                                                              font-style: italic;}")),
                                                 textOutput(outputId = "county_ses_text3"),
                                                 tags$head(tags$style("#county_ses_text3{color: white;
                                                              font-size: 20px;
                                                              font-style: italic;}")),
                                                 textOutput(outputId = "county_ses_text4"),
                                                 tags$head(tags$style("#county_ses_text4{color: white;
                                                              font-size: 20px;
                                                              font-style: italic;}")),
                                                 br(),
                                                 br(),
                                                 tags$head()),
                                          br(),
                                          br()
                                        ),
                                        fluidRow(column(width = 3,
                                                        plotOutput(outputId = "timeliness_indicator",
                                                                   width = "250px",
                                                                   height = "250px"),
                                                        br(),
                                                        br(),
                                                        plotOutput(outputId = "safety_indicator",
                                                                   width = "250px",
                                                                   height = "250px")),
                                                 column(width = 1),
                                                 column(width = 3,
                                                        plotOutput(outputId = "effectiveness_indicator",
                                                                   width = "250px",
                                                                   height = "250px"),
                                                        br(),
                                                        br(),
                                                        plotOutput(outputId = "readmission_indicator",
                                                                   width = "250px",
                                                                   height = "250px")),
                                                 column(width = 1),
                                                 column(width = 3,
                                                        plotOutput(outputId = "experience_indicator",
                                                                   width = "250px",
                                                                   height = "250px"),
                                                        br(),
                                                        br(),
                                                        plotOutput(outputId = "mortality_indicator",
                                                                   width = "250px",
                                                                   height = "250px"))),
                                        br(),
                                        br()
                                      )
                                    ),
                           ),
                           tabPanel("Understanding Hospital Rating",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h3("What factors affect an overall hospital rating in the NY metropolitan area?"),
                                        br(),
                                        hr(),
                                        br(),
                                        plotOutput(outputId = "hospital_rating_barplot_metro"),
                                        br(),
                                        plotOutput(outputId = "hospital_rating_barplot_borough"),
                                        br()
                                      ),
                                      mainPanel(
                                        br(),
                                        br(),
                                        h2("Modeling Hospital Rating: Multiple Linear Regression"),
                                        br(),
                                        h6("We employed backwards selection using AIC (Akaike Information Criterion) to create a linear model which explains variation in average overall hospital rating for counties in the New York metropolitan area using other hospital metrics. This model may shed light on which specific healthcare quality metrics are most significant and why -- which factors are pulling down or lifting up Medicare-provider hospitals in the New York Area, and by how much?"),
                                        br(),
                                        br(),
                                        h3("Final Model"),
                                        h5("R-squared: .87"),
                                        hr(),
                                        br(),
                                        column(width = 4,
                                               h4("Overall Hospital Rating =")),
                                        column(width = 8,
                                               h4("3.3627190 - 0.40(Timeliness Score) + 0.73(Effectiveness Score) + 1.13(Safety Score) + 0.88(Mortality Score) + 1.27(Experience Score) - 0.58(Readmissions below the national average)")
                                        ),
                                        br(),
                                        hr(),
                                        p("*Scores were calculated by assigning a value of +1 for 'above the national average', 0 for 'same as the national average', and -1 for 'below the national average' to each hospital within a county and taking the mean of those scores."),
                                        br(),
                                        h6("This model demonstrates the importance of safety of care and patient experience in determining overall hospital rating. It is interesting to notice that for each increase of one point in timeliness score, the model predicts an average decrease of 0.40 in overall hospital rating. It also reveals that a simple comparison of readmission (above/below/same as national average) is more significant in explaining overall hospital score, rather than a the continuous readmission score values."),
                                        br()
                                      )
                                    )
                           ),
                           tabPanel("About",
                                    column(width = 2),
                                    column(width = 8,
                                           h2("Quality of Health Care Access in New York City"),
                                           h4("How To"),
                                           p("You can use this shiny app to explore quality of care offered at Medicare-providing hospitals throughout the New York City Metropolitan Area."),
                                           p("The 'Geographic Explorer' section provides a broad view of the discrepancies in care quality across the metro area. It reveals, among other things, that nearly all New York's Medicare hospitals lag behind the nation in providing timely care - they are also lacking in the ability to provide a positive patient experience and see high readmission rates. Generally, hospitals in the five New York City boroughs rank below the metro area as a whole. As a county to note, the Bronx tends to also perform significantly worse than both the city and the metro area."),
                                           p("The 'Socioeconomic Lens' section specifically facilitates examination of the intersection of socioeconomic indicators with healthcare quality at the county-level. It also provides a look into the values of specific healthcare quality indicators at the county level for quick comparisons - note, for example, the stark contrast in indicators between the Bronx and Litchfield County or Morris County. However, even counties which appear to exceed national averages for most quality metrics receive poor ratings for timeliness of care."),
                                           p("The 'Understanding Hospital Rating' section includes a linear model to better explain which specific hospital quality metrics are most important in determining a hospital's overall score."),
                                           h4("Notes"),
                                           p("This shiny app relies on several demographic and Medicare datasets which were collected over a period of a few years -- poverty and median household income measurements were taken in 2018, county population is estimated as of 2018, and unemployment data was collected in 2017."),
                                           p("This app incoporates many county-level summaries of hospital data. For each county-level summary, quality metrics were calculated by averaging values for each hospital within the county. Health metric 'scores' were calculated by assigning a value of +1 for 'above the national average', 0 for 'same as the national average', and -1 for 'below the national average' to each hospital within a county and taking the mean of those scores. In that case, values of NA were assigned a score of 0 in order to have no effect on the score. However, in the case of overall hospital ratings, all NA values were filtered before calculating averages because assigning a 0 or 2.5 could negatively or positively influence the overall hospital rating for a county."),
                                           h3("References"),
                                           p("Data.Medicare.gov, a federal government website managed by the Centers for Medicare & Medicaid Services"),
                                           p("https://data.medicare.gov/Hospital-Compare/Hospital-General-Information/xubh-q36u"),
                                           p("United States Department of Agriculture Economic Research Service: County-Level Data Sets"),
                                           p("https://www.ers.usda.gov/data-products/county-level-data-sets/"),
                                           br())
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
    paste0(input$select_county_ses, " County")
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
  
  output$county_hospital_rating <- renderText({
    paste0("Average hospital rating: ", 
           round(subset(medicare_by_county, county == input$select_county_ses)$hospital_overall_rating, 2))
  })
  
  # Indicator Plots
  
  output$timeliness_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_county_ses)$timeliness_of_care == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$timeliness_of_care == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$timeliness_of_care == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_county_ses)$timeliness_of_care)) {
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
  
  output$effectiveness_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_county_ses)$effectiveness_of_care == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$effectiveness_of_care == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$effectiveness_of_care == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_county_ses)$effectiveness_of_care)) {
      sqcolor <- "#7B7C7C"
    }
    
    ggplot() +
      labs(tag = str_to_title(str_replace_all("effectiveness_of_care", "_", " "))) +
      theme_custom() +
      theme(
        plot.tag.position = c(0.5, 0.5),
        plot.tag = element_text(color = "white", size = 22, face = "bold"),
        plot.background = element_rect(fill = sqcolor, color = sqcolor),
        panel.background = element_rect(fill = sqcolor, color = sqcolor)
      )
    
  })
  
  output$experience_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_county_ses)$patient_experience == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$patient_experience == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$patient_experience == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_county_ses)$patient_experience)) {
      sqcolor <- "#7B7C7C"
    }
    
    ggplot() +
      labs(tag = str_to_title(str_replace_all("patient_experience", "_", " "))) +
      theme_custom() +
      theme(
        plot.tag.position = c(0.5, 0.5),
        plot.tag = element_text(color = "white", size = 22, face = "bold"),
        plot.background = element_rect(fill = sqcolor, color = sqcolor),
        panel.background = element_rect(fill = sqcolor, color = sqcolor)
      )
    
  })
  
  output$safety_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_county_ses)$safety_of_care == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$safety_of_care == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$safety_of_care == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_county_ses)$safety_of_care)) {
      sqcolor <- "#7B7C7C"
    }
    
    ggplot() +
      labs(tag = str_to_title(str_replace_all("safety_of_care", "_", " "))) +
      theme_custom() +
      theme(
        plot.tag.position = c(0.5, 0.5),
        plot.tag = element_text(color = "white", size = 22, face = "bold"),
        plot.background = element_rect(fill = sqcolor, color = sqcolor),
        panel.background = element_rect(fill = sqcolor, color = sqcolor)
      )
    
  })
  
  output$readmission_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_county_ses)$readmission == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$readmission == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$readmission == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_county_ses)$readmission)) {
      sqcolor <- "#7B7C7C"
    }
    
    ggplot() +
      labs(tag = str_to_title(str_replace_all("readmission", "_", " "))) +
      theme_custom() +
      theme(
        plot.tag.position = c(0.5, 0.5),
        plot.tag = element_text(color = "white", size = 22, face = "bold"),
        plot.background = element_rect(fill = sqcolor, color = sqcolor),
        panel.background = element_rect(fill = sqcolor, color = sqcolor)
      )
    
  })
  
  output$mortality_indicator <- renderPlot({
    if (subset(medicare_by_county, county == input$select_county_ses)$mortality == "Below the national average") {
      sqcolor <- "red"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$mortality == "Above the national average") {
      sqcolor <- "#0A97F0"
    } else if (subset(medicare_by_county, county == input$select_county_ses)$mortality == "Same as the national average") {
      sqcolor <- "#B8DAEF"
    } else if (is.na(subset(medicare_by_county, county == input$select_county_ses)$mortality)) {
      sqcolor <- "#7B7C7C"
    }
    
    ggplot() +
      labs(tag = str_to_title(str_replace_all("mortality", "_", " "))) +
      theme_custom() +
      theme(
        plot.tag.position = c(0.5, 0.5),
        plot.tag = element_text(color = "white", size = 22, face = "bold"),
        plot.background = element_rect(fill = sqcolor, color = sqcolor),
        panel.background = element_rect(fill = sqcolor, color = sqcolor)
      )
    
  })
  
  output$ses_borough_map <- renderPlot ({
    
    ggplot() +
      geom_sf(data = datamap, aes(geometry = geometry, fill = get(input$select_demog_ses)), color="white") +
      geom_point(data = subset(medicare_borough_map, 
                               get(input$select_metric_ses) == "Same as the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric_ses)), 
                 alpha = .8, size = 4) +
      geom_point(data = subset(medicare_borough_map, 
                               get(input$select_metric_ses) == "Above the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric_ses)), 
                 alpha = .7, size = 4) +
      geom_point(data = subset(medicare_borough_map, 
                               get(input$select_metric_ses) == "Below the national average"),
                 aes(x = long, y = lat, color = get(input$select_metric_ses)), 
                 alpha = .7, size = 4) +
      geom_point(data = subset(medicare_borough_map, 
                               is.na(get(input$select_metric_ses))),
                 aes(x = long, y = lat, color = get(input$select_metric_ses)), 
                 alpha = .7, size = 4) +
      scale_color_manual(values = cols, na.value = "#7B7C7C") +
      scale_fill_gradient(low = "#FCF3DD", high = "#FCB60B") +
      coord_sf() +
      theme_custom() +
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank()) +
      labs(title = paste0(str_to_title(str_replace_all(str_remove(input$select_metric_ses, "_national_comparison"), "_", " ")), 
                    " for Medicare Providers"),
           subtitle = "in New York City",
           color = str_to_title(str_replace_all(str_remove(input$select_metric_ses, "_national_comparison"), "_", " ")), 
           fill = str_to_title(str_replace_all(input$select_demog_ses, "_", " ")),
           caption = "*Hospitals without ratings available shown in grey")
  })
  
  output$county_score_plot <- renderPlot ({
    if (input$select_metric_ses == "timeliness_of_care_national_comparison") {
      score_var <- "timeliness_score"
    } else if (input$select_metric_ses == "effectiveness_of_care_national_comparison") {
      score_var <- "effectiveness_score"
    } else if (input$select_metric_ses == "readmission_national_comparison") {
      score_var <- "readmission_score"
    } else if (input$select_metric_ses == "safety_of_care_national_comparison") {
      score_var <- "safety_score"
    } else if (input$select_metric_ses == "mortality_national_comparison") {
      score_var <- "mortality_score"
    } else if (input$select_metric_ses == "hospital_overall_rating") {
      score_var <- "hospital_overall_rating"
    }
    
    ggplot(datamap, aes(x = county, y = get(score_var), fill = get(input$select_demog_ses))) +
      geom_bar(stat = "identity") +
      scale_fill_gradient(low = "#FCF3DD", high = "#FCB60B") +
      theme_custom() +
      labs(title = paste0("Average Hospital ", str_to_title(str_replace_all(score_var, "_", " "))), 
           fill = str_to_title(str_replace_all(input$select_demog_ses, "_", " ")),
           x = "County",
           y = str_to_title(str_replace_all(score_var, "_", " ")))
      
  })
  
  output$county_ses_text1 <- renderText ({
    paste0("Population: ", subset(medicare_by_county, county == input$select_county_ses)$population_in_2018)
  })
  
  output$county_ses_text2 <- renderText ({
    paste0("Poverty Rate: ", subset(medicare_by_county, county == input$select_county_ses)$percent_in_poverty_2018, "%")
  })
  
  output$county_ses_text3 <- renderText ({ 
    paste0("Unemployment Rate: ", subset(medicare_by_county, county == input$select_county_ses)$percent_unemployed_in_2017, "%")
  })
  
  output$county_ses_text4 <- renderText ({
    paste0("Median Household Income: $", subset(medicare_by_county, county == input$select_county_ses)$median_household_income_2018)
  })
  
  output$hospital_rating_barplot_metro <- renderPlot({
    
    medicare_ny %>%
      ggplot(aes(x = hospital_overall_rating)) +
      scale_fill_manual(values = cols, na.value = "#7B7C7C") +
      geom_bar() +
      labs(x = "Hospital's Overall Rating",
           y = "Number of Medicare hospital providers",
           title = "Hospital Ratings in NYC Metro Area")+
      theme_custom() +
      theme(legend.position = "none")
  })
  
  output$hospital_rating_barplot_borough <- renderPlot({
    
    medicare_borough %>%
      ggplot(aes(x = hospital_overall_rating)) +
      scale_fill_manual(values = cols, na.value = "#7B7C7C") +
      geom_bar() +
      labs(x = "Hospital's Overall Rating",
           y = "Number of Medicare hospital providers",
           title = "Hospital Ratings in NYC")+
      theme_custom() +
      theme(legend.position = "none")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
