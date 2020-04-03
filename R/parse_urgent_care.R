library(tidyverse)

urgent_care <- read.csv("data/raw/Urgent_Care_Facilities.csv")

urgent_care_clean <- urgent_care %>%
  janitor::clean_names(case = "snake") %>%
  select(-objectid, -zipp4, -fips, -directions, -contdate, -conthow, -geodate, 
         -geohow, -hsipthemes, -geolinkid) %>%
  rename(lat = y, long = x, naics_desc = naicsdescr, naics_code = naicscode) %>%
  unite(address, c(address, address2), sep = ", ") %>%
  mutate(name = str_to_title(name),
         address = str_to_title(address), 
         city = str_to_title(city),
         county = str_to_title(county),
         naics_desc = str_to_title(naics_desc),
         overall_type = "urgent care"
  )

write_csv(urgent_care_clean, "data/urgent_care.csv")
