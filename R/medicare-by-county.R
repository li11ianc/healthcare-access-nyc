library(tidyverse)

medicare_ny <- read_csv("../data/ny_specific/medicare_ny.csv")
ny_demog <- read_csv("../data/ny_specific/county-level/county_indicators.csv")

medicare_sum <- medicare_ny %>%
  mutate(
    mortality_national_comparison = case_when(
      mortality_national_comparison == "Same as the national average" ~ 0,
      mortality_national_comparison == "Below the national average" ~ -1,
      mortality_national_comparison == "Above the national average" ~ 1,
      is.na(mortality_national_comparison) ~ 0),
    safety_of_care_national_comparison = case_when(
      safety_of_care_national_comparison == "Same as the national average" ~ 0,
      safety_of_care_national_comparison == "Below the national average" ~ -1,
      safety_of_care_national_comparison == "Above the national average" ~ 1,
      is.na(safety_of_care_national_comparison) ~ 0),
    readmission_national_comparison = case_when(
      readmission_national_comparison == "Same as the national average" ~ 0,
      readmission_national_comparison == "Below the national average" ~ -1,
      readmission_national_comparison == "Above the national average" ~ 1,
      is.na(readmission_national_comparison) ~ 0),
    patient_experience_national_comparison = case_when(
      patient_experience_national_comparison == "Same as the national average" ~ 0,
      patient_experience_national_comparison == "Below the national average" ~ -1,
      patient_experience_national_comparison == "Above the national average" ~ 1,
      is.na(patient_experience_national_comparison) ~ 0),
    effectiveness_of_care_national_comparison = case_when(
      effectiveness_of_care_national_comparison == "Same as the national average" ~ 0,
      effectiveness_of_care_national_comparison == "Below the national average" ~ -1,
      effectiveness_of_care_national_comparison == "Above the national average" ~ 1,
      is.na(effectiveness_of_care_national_comparison) ~ 0),
    timeliness_of_care_national_comparison = case_when(
      timeliness_of_care_national_comparison == "Same as the national average" ~ 0,
      timeliness_of_care_national_comparison == "Below the national average" ~ -1,
      timeliness_of_care_national_comparison == "Above the national average" ~ 1,
      is.na(timeliness_of_care_national_comparison) ~ 0))

ny_counties <- medicare_sum %>%
  group_by(county) %>%
  summarise(timeliness_score = sum(timeliness_of_care_national_comparison)/n(),
            effectiveness_score = sum(effectiveness_of_care_national_comparison)/n(),
            safety_score = sum(safety_of_care_national_comparison)/n(),
            mortality_score = sum(mortality_national_comparison)/n(),
            readmission_score = sum(readmission_national_comparison)/n(),
            experience_score = sum(patient_experience_national_comparison)/n())

hospital_ratings <- subset(medicare_sum, !is.na(hospital_overall_rating)) %>%
  group_by(county) %>%
  summarize(hospital_overall_rating = sum(as.numeric(hospital_overall_rating))/n())

ny_counties <- ny_counties %>%
  mutate(
    timeliness_of_care = case_when(
    timeliness_score < 0 ~ "Below the national average",
    timeliness_score > 0 ~ "Above the national average",
    round(timeliness_score, 2) == 0 ~ "Same as the national average"
    ),
    effectiveness_of_care = case_when(
      effectiveness_score < 0 ~ "Below the national average",
      effectiveness_score > 0 ~ "Above the national average",
      round(effectiveness_score, 2) == 0 ~ "Same as the national average"
    ),
    safety_of_care = case_when(
      safety_score < 0 ~ "Below the national average",
      safety_score > 0 ~ "Above the national average",
      round(safety_score, 2) == 0 ~ "Same as the national average"
    ),
    mortality = case_when(
      mortality_score < 0 ~ "Below the national average",
      mortality_score > 0 ~ "Above the national average",
      round(mortality_score, 2) == 0 ~ "Same as the national average"
    ),
    readmission = case_when(
      readmission_score < 0 ~ "Below the national average",
      readmission_score > 0 ~ "Above the national average",
      round(readmission_score, 2) == 0 ~ "Same as the national average"
    ),
    patient_experience = case_when(
      experience_score < 0 ~ "Below the national average",
      experience_score > 0 ~ "Above the national average",
      round(experience_score, 2) == 0 ~ "Same as the national average"
    )
  )


medicare_by_county <- left_join(ny_counties, hospital_ratings, by = "county")

medicare_by_county <- left_join(medicare_by_county, ny_demog, by = "county")

write_csv(medicare_by_county, "../data/ny_specific/medicare_by_county.csv")
