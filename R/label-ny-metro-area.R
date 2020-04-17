library(tidyverse)

facilities <- read.csv("data/all_health_facilities.csv")
inpatients <- read.csv("data/medicare_inpatients.csv")
medicare <- read_csv("data/medicare.csv")
us_cities <- read_csv("data/uscities.csv")

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
      city == "New York" ~ "Y",
      TRUE ~ "N"
    ))
  return (df)
}

facilities <- label_ny_metro(facilities)
medicare <- label_ny_metro(medicare)

us_cities <- us_cities %>%
  rename(state = state_id, county = county_name)

us_cities <- label_ny_metro(us_cities)

inpatients <- full_join(inpatients, us_cities, by = c("city", "state"))

facilities_ny <- facilities %>%
  filter(ny_metro == "Y")

medicare_ny <- medicare %>%
  filter(ny_metro == "Y")

inpatients_ny <- inpatients %>%
  filter(ny_metro == "Y")

write.csv(facilities, "data/all_health_facilities.csv")
write.csv(medicare, "data/medicare.csv")
write.csv(inpatients, "data/medicare_inpatients.csv")

write.csv(facilities_ny, "data/ny_specific/all_health_facilities_ny.csv")
write.csv(medicare_ny, "data/ny_specific/medicare_ny.csv")
write.csv(inpatients_ny, "data/ny_specific/medicare_inpatients_ny.csv")