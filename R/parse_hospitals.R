library(tidyverse)

hospitals <- read.csv("data/raw/Hospitals.csv")

hospitals_clean <- hospitals %>%
  janitor::clean_names(case = "snake") %>%
  select(-x, -y, -zip4, -objectid, -countyfips, -val_method, -state_id, -st_fips, -ttl_staff) %>%
  rename(lat = latitude, long = longitude) %>%
  mutate(name = str_to_title(name), 
         address = str_to_title(address), 
         city = str_to_title(city),
         type = str_to_title(type), 
         status = str_to_lower(status), 
         county = str_to_title(county),
         naics_desc = str_to_title(naics_desc),
         owner = str_to_title(owner),
         population = case_when(
           population == -999 ~ as.integer(NA),
           TRUE ~ population), 
         alt_name = case_when(
           alt_name == "NOT AVAILABLE" ~ as.character(NA),
           TRUE ~ str_to_lower(alt_name)),
         beds = case_when(
           beds == -999 ~ as.integer(NA),
           TRUE ~ beds), 
         trauma = as.character(trauma),
         trauma = case_when(
           trauma == "NOT AVAILABLE" ~ as.character(NA),
           TRUE ~ trauma),
         overall_type = "hospital"
  )

write_csv(hospitals_clean, "data/hospitals.csv")
