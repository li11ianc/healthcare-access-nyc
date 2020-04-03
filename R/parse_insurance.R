library(tidyverse)

insurance <- read.csv("data/raw/states.csv")

insurance_clean <- insurance %>%
  janitor::clean_names(case = "snake")

write_csv(insurance, "data/insurance.csv")
