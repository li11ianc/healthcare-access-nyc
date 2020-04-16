hospitals <- read.csv("data/hospitals.csv")
pharmacies <- read.csv("data/pharmacies.csv")
nursing <- read.csv("data/nursing_homes.csv")
urgent_care <- read.csv("data/urgent_care.csv")
medicare <- read.csv("data/medicare.csv")

all_facilities <- bind_rows(hospitals, pharmacies, nursing, urgent_care, medicare)

write_csv(all_facilities, "data/all_health_facilities.csv")
