library(tidyverse)

pharmacies <- read.csv("data/raw/facility.csv")

pharmacies_clean <- pharmacies %>%
  janitor::clean_names(case = "snake") %>%
  separate(col = calc_location, into = c("lat", "long"), sep = ",") %>%
  mutate(name = as.character(name), 
         lat = as.numeric(lat), 
         long = as.numeric(long), 
         address = as.character(address),
         name = str_to_lower(name),
         address = str_to_title(address),
         city = str_to_title(city)) %>%
  select(-icon, -formated_phone)

write_csv(pharmacies_clean, "data/pharmacies.csv")