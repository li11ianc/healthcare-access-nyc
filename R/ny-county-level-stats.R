library(tidyverse)

population <- read_csv("data/ny_specific/county-level/PopulationEstimates.csv")
poverty <- read_csv("data/ny_specific/county-level/PovertyEstimates.csv")
unemployment <- read_csv("data/ny_specific/county-level/Unemployment.csv")

label_ny_metro <- function(df) {
  df <- df %>%
    mutate(ny_metro = case_when(
      county == "Bergen" & state == "NJ" ~ "Y",
      county == "Dutchess" & state == "NY" ~ "Y",
      county == "Essex" & state == "NJ" ~ "Y",
      county == "Fairfield" & state == "CT" ~ "Y",
      county == "Hudson" & state == "NJ" ~ "Y",
      county == "Hunterdon" & state == "NJ" ~ "Y",
      county == "Litchfield" & state == "CT" ~ "Y",
      county == "Mercer" & state == "NJ" ~ "Y",
      county == "Middlesx" & state == "NJ" ~ "Y",
      county == "Monmouth" & state == "NJ" ~ "Y",
      county == "Morris" & state == "NJ" ~ "Y",
      county == "Nassau" & state == "NY" ~ "Y",
      county == "New Haven" & state == "CT" ~ "Y",
      county == "Ocean" & state == "NJ" ~ "Y",
      county == "Orange" & state == "NY" ~ "Y",
      county == "Passaic" & state == "NJ" ~ "Y",
      county == "Pike" & state == "PA" ~ "Y",
      county == "Putnam" & state == "NY" ~ "Y",
      county == "Rockland" & state == "NY" ~ "Y",
      county == "Somerset" & state == "NJ" ~ "Y",
      county == "Suffolk" & state == "NY" ~ "Y",
      county == "Sussex" & state == "NJ" ~ "Y",
      county == "Ulster" & state == "NY" ~ "Y",
      county == "Union" & state == "NJ" ~ "Y",
      county == "New York" & state == "NY" ~ "Y",
      county == "Queens" & state == "NY" ~ "Y",
      county == "Richmond" & state == "NY" ~ "Y",
      county == "Kings" & state == "NY" ~ "Y",
      county == "Bronx" & state == "NY" ~ "Y",
      TRUE ~ "N"
    ))
  return (df)
}

# Clean population data

population <- population %>%
  janitor::clean_names() %>%
  select(state, area_name, pop_estimate_2018)

population_clean <- population %>%
  filter(str_detect(area_name, "County")) %>%
  mutate(area_name = str_remove(area_name, " County")) %>%
  rename(county = area_name)

population_clean <- label_ny_metro(population_clean) %>%
  filter(ny_metro == "Y") %>%
  select(-ny_metro)

# Clean poverty data

poverty <- poverty %>%
  janitor::clean_names() %>%
  select(stabr, area_name, povall_2018)

poverty_clean <- poverty %>%
  filter(str_detect(area_name, "County")) %>%
  mutate(area_name = str_remove(area_name, " County")) %>%
  rename(county = area_name, state = stabr)

poverty_clean <- label_ny_metro(poverty_clean) %>%
  filter(ny_metro == "Y") %>%
  select(-ny_metro)

# Clean unemployment data

unemployment <- unemployment %>%
  janitor::clean_names() %>%
  select(state, area_name, employed_2017, unemployed_2017, unemployment_rate_2017)

unemployment_clean <- unemployment %>%
  filter(str_detect(area_name, "County")) %>%
  mutate(area_name = str_remove(area_name, " County"),
         area_name = str_remove(area_name, ", \\w*")) %>%
  rename(county = area_name)

unemployment_clean <- label_ny_metro(unemployment_clean) %>%
  filter(ny_metro == "Y") %>%
  select(-ny_metro)

ny_demog <- full_join(population_clean, poverty_clean, by = c("state", "county"))

ny_demog <- full_join(ny_demog, unemployment_clean, by = c("state", "county")) 

ny_demog <- ny_demog %>%
  select(-ny_metro, -fips)

write_csv(ny_demog, "data/ny_specific/county-level/county_indicators.csv")
