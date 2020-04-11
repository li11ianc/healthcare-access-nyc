---
title: "Project EDA"
author: "Lilly Clark, Thea Dowrich, Daisy Fang"
date: "04-10-20"
output: 
  html_document:
    code_folding: hide
    keep_md: yes
    theme: spacelab
    toc: yes
    toc_float: yes
---




```r
library(tidyverse)
```

```
## ── Attaching packages ────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.0     ✓ purrr   0.3.3
## ✓ tibble  3.0.0     ✓ dplyr   0.8.5
## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
```

```
## ── Conflicts ───────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(tidyverse)
library(maps)
```

```
## 
## Attaching package: 'maps'
```

```
## The following object is masked from 'package:purrr':
## 
##     map
```

```r
library(viridis)
```

```
## Loading required package: viridisLite
```

```r
library(patchwork)
```


```r
facilities <- read.csv("data/all_health_facilities.csv")
insurance <- read.csv("data/insurance.csv")
inpatients <- read_csv("data/medicare_inpatients.csv")
```

```
## Parsed with column specification:
## cols(
##   drg_definition = col_character(),
##   id = col_double(),
##   name = col_character(),
##   address = col_character(),
##   city = col_character(),
##   state = col_character(),
##   zip = col_double(),
##   hospital_referral_region_hrr_description = col_character(),
##   total_discharges = col_double(),
##   average_covered_charges = col_double(),
##   average_total_payments = col_double(),
##   average_medicare_payments = col_double()
## )
```

```r
medicare <- read_csv("data/medicare.csv")
```

```
## Parsed with column specification:
## cols(
##   .default = col_character(),
##   zip = col_double(),
##   emergency_services = col_logical(),
##   meets_criteria_for_meaningful_use_of_eh_rs = col_logical(),
##   hospital_overall_rating_footnote = col_double(),
##   mortality_national_comparison_footnote = col_double(),
##   safety_of_care_national_comparison_footnote = col_double(),
##   readmission_national_comparison_footnote = col_double(),
##   patient_experience_national_comparison_footnote = col_double(),
##   effectiveness_of_care_national_comparison_footnote = col_double(),
##   timeliness_of_care_national_comparison_footnote = col_double(),
##   efficient_use_of_medical_imaging_national_comparison_footnote = col_double(),
##   long = col_double(),
##   lat = col_double()
## )
```

```
## See spec(...) for full column specifications.
```

## Inpatient Data 
From data.cms.gov: The Inpatient Utilization and Payment Public Use File (Inpatient PUF) provides information on inpatient discharges for Medicare fee-for-service beneficiaries. The Inpatient PUF includes information on utilization, payment (total payment and Medicare payment), and hospital-specific charges for the more than 3,000 U.S. hospitals that receive Medicare Inpatient Prospective Payment System (IPPS) payments. The PUF is organized by hospital and Medicare Severity Diagnosis Related Group (MS-DRG) and covers Fiscal Year (FY) 2017. MS-DRGs included in the PUF represent more than 7 million discharges or 75 percent of total Medicare IPPS discharges.


```r
inpatients <- inpatients %>%
  mutate(state = as.factor(state),
         drg = as.factor(str_extract(drg_definition, "\\d{3}")),
         drg_definition = as.factor(str_remove(drg_definition, "\\d{3} - ")),
         average_outofpocket = average_total_payments - average_medicare_payments,
         city = as.factor(city))
```


```r
medi <- left_join(inpatients, medicare, by = "name")
medi_filt <- medi %>%
  filter(!is.na(id.y))
```


```r
cities <- medi_filt %>%
  group_by(city.x, ) %>%
  summarize(mean = mean(average_outofpocket)) %>%
  arrange(desc(mean))

cities_loc <- medi_filt %>%
  select(city.x, state.x, long, lat)

cities <- left_join(cities, cities_loc, by = "city.x") %>%
  mutate(mean = round(mean, 2))
```


```r
inpatients %>%
  group_by(drg_definition) %>%
  summarize(mean_outofpocket_costs = mean(average_outofpocket)) %>%
  arrange(desc(mean_outofpocket_costs)) %>%
  head(10)
```

```
## # A tibble: 10 x 2
##    drg_definition                                           mean_outofpocket_co…
##    <fct>                                                                   <dbl>
##  1 Simultaneous Pancreas/Kidney Transplant                                35594.
##  2 Heart Transplant Or Implant Of Heart Assist System W Mcc               31741.
##  3 Liver Transplant W Mcc Or Intestinal Transplant                        28727.
##  4 Lung Transplant                                                        26213.
##  5 Allogeneic Bone Marrow Transplant                                      22189.
##  6 Liver Transplant W/O Mcc                                               19497.
##  7 Interstitial Lung Disease W/O Cc/Mcc                                   17716.
##  8 Dental & Oral Diseases W Mcc                                           16886.
##  9 Ecmo Or Trach W Mv >96 Hrs Or Pdx Exc Face, Mouth & Nec…               14077.
## 10 Intracranial Vascular Procedures W Pdx Hemorrhage W Mcc                13764.
```


```r
medicare_ratings <- medicare %>%
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
```


```r
us_map <- map_data("state")
```


```r
cols <- c("Below the national average" = "red", "Above the national average" = "#0A97F0", "Same as the national average" = "black")
```


```r
medicare_locations_plot <- medicare %>%
  filter(state != "HI", state != "AK", long > -140, lat > 22) %>%
  ggplot() +
  geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#9EA5A9", fill = "#CED5DA") +
  geom_point(aes(x = long, y = lat), alpha = .2) +
  coord_map() +
  theme_void() +
  theme(plot.caption = element_text(hjust = .5)) +
  labs(title = "Locations of Medicare Providers", subtitle = "Medicare providers are spread thin in some Midwestern states.")
```


```r
medicare_ratings_map1 <- medicare_ratings %>%
    filter(state != "HI", state != "AK", long > -140, lat > 22,
         !is.na(effectiveness_of_care_national_comparison))

effectiveness_plot <- medicare_ratings_map1 %>%
  ggplot() +
  geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#9EA5A9", fill = "#CED5DA") +
  geom_point(data = subset(medicare_ratings_map1, 
                           effectiveness_of_care_national_comparison == "Same as the national average"),
             aes(x = long, y = lat, color = effectiveness_of_care_national_comparison), 
             alpha = .2) +
  geom_point(data = subset(medicare_ratings_map1, 
                           effectiveness_of_care_national_comparison == "Above the national average"),
             aes(x = long, y = lat, color = effectiveness_of_care_national_comparison), 
             alpha = .6) +
  geom_point(data = subset(medicare_ratings_map1, 
                           effectiveness_of_care_national_comparison == "Below the national average"),
             aes(x = long, y = lat, color = effectiveness_of_care_national_comparison), 
             alpha = .4) +
  scale_color_manual(values = cols) +
  coord_map() +
  theme_void() +
  theme(plot.caption = element_text(hjust = .5)) +
  labs(title = "National Comparison of Effectiveness of Care for Medicare Providers", 
       subtitle = "Apparent clusters of ineffective providers in New York and Chicago areas.",
       color = "Effectiveness of care")
```


```r
medicare_ratings_map2 <- medicare_ratings %>%
    filter(state != "HI", state != "AK", long > -140, lat > 22,
         !is.na(timeliness_of_care_national_comparison))

timeliness_plot <- medicare_ratings_map2 %>%
  ggplot() +
  geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#9EA5A9", fill = "#CED5DA") +
  geom_point(data = subset(medicare_ratings_map2, 
                           timeliness_of_care_national_comparison == "Same as the national average"),
             aes(x = long, y = lat, color = timeliness_of_care_national_comparison), 
             alpha = .2) +
  geom_point(data = subset(medicare_ratings_map2, 
                           timeliness_of_care_national_comparison == "Above the national average"),
             aes(x = long, y = lat, color = timeliness_of_care_national_comparison), 
             alpha = .6) +
  geom_point(data = subset(medicare_ratings_map2, 
                           timeliness_of_care_national_comparison == "Below the national average"),
             aes(x = long, y = lat, color = timeliness_of_care_national_comparison), 
             alpha = .4) +
  scale_color_manual(values = cols) +
  coord_map() +
  theme_void() +
  theme(plot.caption = element_text(hjust = .5)) +
  labs(title = "National Comparison of Timeliness of Care for Medicare Providers", 
       subtitle = "Timeliness suffers in East Coast and California cities.",
       color = "Timeliness of care")
```


```r
medicare_locations_plot / effectiveness_plot / timeliness_plot +
  plot_layout(widths = 5, heights = 20)
```

![](project-ggsquad_files/figure-html/unnamed-chunk-11-1.png)<!-- -->


```r
cities %>%
  arrange(mean) %>%
  filter(state.x != "HI", state.x != "AK", long > -140) %>%
  ggplot() +
  geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#9EA5A9", fill = "#CED5DA") +
  geom_point(aes(x = long, y = lat, color = mean, size = mean), alpha = .2) +
  coord_map() +
  scale_size_continuous(range=c(.1,5), guide = FALSE) +
  scale_color_viridis(trans="log") +
  theme_void() +
  theme(plot.caption = element_text(hjust = .5)) +
  labs(title = "Costs Not Covered By Medicare for Inpatient Procedures", color = "Mean out-of-pocket costs ($)", subtitle = "in 2017", caption = "Average personal costs for procedures signicantly higher in some California and East Coast cities.")
```

![](project-ggsquad_files/figure-html/unnamed-chunk-12-1.png)<!-- -->





## Insurance

```r
insurance$uninsured_rate_2010 <- as.numeric(str_replace_all(insurance$uninsured_rate_2010, "%", ""))

insurance$uninsured_raate_2015 <- as.numeric(str_replace_all(insurance$uninsured_rate_2015, "%", ""))


ggplot(data = insurance, mapping = aes(x = uninsured_rate_2010, y = uninsured_rate_2015)) +
  geom_point() +
  labs(x = "Insurance Rate in 2010", y = "Insurance Rate in 2015", 
       title = "Changes in Health Insurance Rates before and after the Affordable Care Act")
```

![](project-ggsquad_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

```r
medicaid_clean <- insurance %>%
  filter(state_medicaid_expansion_2016 == TRUE | state_medicaid_expansion_2016 == FALSE)

ggplot(data = medicaid_clean, mapping = aes(x = state_medicaid_expansion_2016, y = medicaid_enrollment_change_2013_2016)) +
  geom_boxplot() +
  ylim(-4000, 4500000) +
  labs(x = "Did the state expand funding for Medicaid in 2016?", y = "Medicaid Enrollment Change between 2013 and 2016")
```

```
## Warning: Removed 2 rows containing non-finite values (stat_boxplot).
```

![](project-ggsquad_files/figure-html/unnamed-chunk-13-2.png)<!-- -->

