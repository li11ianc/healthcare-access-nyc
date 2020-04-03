library(tidyverse)

nursing <- read.csv("data/raw/Nursing_Homes.csv")

nursing_clean <- nursing %>%
  janitor::clean_names(case = "snake") %>%
  select(-x, -y, -zip4, -objectid, -countyfips, -val_method, -website) %>%
  rename(lat = latitude, long = longitude, owner = ownership) %>%
  mutate(name = str_to_title(name), 
         address = str_to_title(address), 
         city = str_to_title(city),
         type = str_to_title(type), 
         status = str_to_lower(status), 
         county = str_to_title(county),
         naics_desc = str_to_title(naics_desc),
         owner = str_to_title(owner),
         sourcetype = str_to_title(sourcetype),
         population = case_when(
           population == -999 ~ as.integer(NA),
           TRUE ~ population),
         tot_res = case_when(
           tot_res == -999 ~ as.integer(NA),
           TRUE ~ tot_res),
         tot_staff = case_when(
           tot_staff == -999 ~ as.integer(NA),
           TRUE ~ tot_staff),
         beds = case_when(
           beds == -999 ~ as.integer(NA),
           TRUE ~ beds),
         excess_bed = case_when(
           excess_bed == -999 ~ as.integer(NA),
           TRUE ~ excess_bed),
         medicaidid = as.character(medicaidid),
         medicareid = as.character(medicareid),
         state_lic = as.character(state_lic),
         medicaidid = case_when(
           medicaidid == "NOT AVAILABLE" ~ as.character(NA),
           TRUE ~ medicaidid),
         medicareid = case_when(
           medicareid == "NOT AVAILABLE" ~ as.character(NA),
           TRUE ~ medicareid),
         state_lic = case_when(
           state_lic == "NOT AVAILABLE" ~ as.character(NA),
           TRUE ~ state_lic),
         overall_type = "nursing home"
  )

write_csv(nursing_clean, "data/nursing_homes.csv")
