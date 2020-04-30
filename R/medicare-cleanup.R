library(tidyverse)

medicare <- read_csv("../data/medicare.csv")

medicare <- medicare %>%
  mutate(
    hospital_overall_rating = case_when(
      hospital_overall_rating == "Not Available" ~ as.numeric(NA),
      TRUE ~ as.numeric(hospital_overall_rating)),
    mortality_national_comparison = case_when(
      mortality_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ mortality_national_comparison),
    safety_of_care_national_comparison = case_when(
      safety_of_care_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ safety_of_care_national_comparison),
    readmission_national_comparison = case_when(
      readmission_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ readmission_national_comparison),
    patient_experience_national_comparison = case_when(
      patient_experience_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ patient_experience_national_comparison),
    effectiveness_of_care_national_comparison = case_when(
      effectiveness_of_care_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ effectiveness_of_care_national_comparison),
    timeliness_of_care_national_comparison = case_when(
      timeliness_of_care_national_comparison == "Not Available" ~ as.character(NA),
      TRUE ~ timeliness_of_care_national_comparison))

medicare <- medicare %>%
  mutate(
    hospital_overall_rating = as.factor(hospital_overall_rating),
    mortality_national_comparison = as.factor(mortality_national_comparison),
    safety_of_care_national_comparison = as.factor(safety_of_care_national_comparison),
    readmission_national_comparison = as.factor(readmission_national_comparison),
    patient_experience_national_comparison = as.factor(patient_experience_national_comparison),
    effectiveness_of_care_national_comparison = as.factor(effectiveness_of_care_national_comparison))


medicare <- medicare %>%
  mutate(
    mortality_national_comparison = fct_relevel(mortality_national_comparison,
                                                            c("Below the national average", 
                                                              "Same as the national average", 
                                                              "Above the national average")),
    safety_of_care_national_comparison = fct_relevel(safety_of_care_national_comparison,
                                                         c("Below the national average", 
                                                           "Same as the national average", 
                                                           "Above the national average")),
    readmission_national_comparison = fct_relevel(readmission_national_comparison,
                                                         c("Below the national average", 
                                                           "Same as the national average", 
                                                           "Above the national average")),
    patient_experience_national_comparison = fct_relevel(patient_experience_national_comparison,
                                                         c("Below the national average", 
                                                           "Same as the national average", 
                                                           "Above the national average")),
    effectiveness_of_care_national_comparison = fct_relevel(effectiveness_of_care_national_comparison,
                                                            c("Below the national average", 
                                                              "Same as the national average", 
                                                              "Above the national average")),
    timeliness_of_care_national_comparison = fct_relevel(timeliness_of_care_national_comparison,
                                                         c("Below the national average", 
                                                           "Same as the national average", 
                                                           "Above the national average")))
medicare <- medicare %>%
  mutate(emergency_services = case_when(
    emergency_services == "FALSE" ~ "No",
    emergency_services == "TRUE" ~ "Yes"
  ))

medicare <- medicare %>%
  select(-id, -meets_criteria_for_meaningful_use_of_eh_rs, -hospital_overall_rating_footnote, 
         -mortality_national_comparison_footnote, -safety_of_care_national_comparison_footnote, 
         -readmission_national_comparison_footnote, -patient_experience_national_comparison_footnote, 
         -effectiveness_of_care_national_comparison_footnote, -timeliness_of_care_national_comparison_footnote, 
         -efficient_use_of_medical_imaging_national_comparison_footnote)

write.csv(medicare, "../data/medicare.csv")
