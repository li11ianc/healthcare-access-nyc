library(tidyverse)

medicare <- read_csv("data/medicare.csv")

medicare <- medicare %>%
  mutate(
    effectiveness_of_care_national_comparison = case_when(
      effectiveness_of_care_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ effectiveness_of_care_national_comparison),
    timeliness_of_care_national_comparison = case_when(
      timeliness_of_care_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ timeliness_of_care_national_comparison),
    timeliness_of_care_national_comparison = as.factor(timeliness_of_care_national_comparison),
    effectiveness_of_care_national_comparison = as.factor(effectiveness_of_care_national_comparison),
    effectiveness_of_care_national_comparison = fct_relevel(effectiveness_of_care_national_comparison,
                                                            c("Below the national average", 
                                                              "Same as the national average", 
                                                              "Above the national average")),
    timeliness_of_care_national_comparison = fct_relevel(timeliness_of_care_national_comparison,
                                                         c("Below the national average", 
                                                           "Same as the national average", 
                                                           "Above the national average"))
  )

write.csv(medicare, "data/medicare.csv")