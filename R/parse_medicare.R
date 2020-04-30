library(tidyverse)

medicare <- read.csv("../data/raw/medicare.csv")

medicare_clean <- medicare %>%
  janitor::clean_names(case = "snake") %>%
  rename(id = facility_id, name = facility_name, zip = zip_code, county = county_name,
         telephone = phone_number, type = hospital_type, owner = hospital_ownership) %>%
  mutate(name = str_to_title(name),
         address = str_to_title(address),
         city = str_to_title(city), 
         county = str_to_title(county),
         location = str_remove(location, "POINT \\("),
         location = str_remove(location, "\\)"),
         overall_type = "medicare") %>%
  separate(location, c("long", "lat"), " ")

write_csv(medicare_clean, "../data/medicare.csv")
