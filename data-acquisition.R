ipps <- read.csv("data/raw/Inpatient_Prospective_Payment_System__2017.csv")

hospitals <- read.csv("data/hospitals.csv")
pharmacies <- read.csv("data/pharmacies.csv")
nursing <- read.csv("data/nursing.csv")
urgent_care <- read.csv("data/urgent_care.csv")
medicare <- read.csv("data/medicare.csv")

all_facilities <- bind_rows(hospitals, pharmacies, nursing, urgent_care, medicare)

write_csv(all_facilities, "data/all_health_facilities.csv")
