library(tidyverse)

ipps <- read_csv("data/raw/Inpatient_Prospective_Payment_System__2017.csv")

ipps_clean <- ipps %>%
  janitor::clean_names(case = "snake") %>%
  rename(id = provider_id, name = provider_name, address = provider_street_address,
         city = provider_city, state = provider_state, zip = provider_zip_code) %>%
  mutate(drg_definition = str_to_title(drg_definition),
         name = str_to_title(name),
         city = str_to_title(city)
         )

write_csv(ipps_clean, "data/medicare_inpatients.csv")
