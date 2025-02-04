library(tidyverse)

hospitals <- read.csv("../data/hospitals.csv")
pharmacies <- read.csv("../data/pharmacies.csv")
nursing <- read.csv("../data/nursing_homes.csv")
urgent_care <- read.csv("../data/urgent_care.csv")


all_health_facilities <- dplyr::bind_rows(hospitals, pharmacies, nursing, urgent_care)
write.csv(all_health_facilities, "../data/all_health_facilities.csv")
write.csv(all_health_facilities, "../facilities_finder/data/all_health_facilities.csv")
