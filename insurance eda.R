library(tidyverse)

insurance <- read.csv("data/states.csv")

insurance$Uninsured.Rate..2010. <- as.numeric(str_replace_all(insurance$Uninsured.Rate..2010., "%", ""))

insurance$Uninsured.Rate..2015. <- as.numeric(str_replace_all(insurance$Uninsured.Rate..2015., "%", ""))


ggplot(data = insurance, mapping = aes(x = Uninsured.Rate..2010., y = Uninsured.Rate..2015.)) +
  geom_point() +
  labs(x = "Insurance Rate in 2010", y = "Insurance Rate in 2015", 
       title = "Changes in Health Insurance Rates before and after the Affordable Care Act")

medicaid_clean <- insurance %>%
  filter(State.Medicaid.Expansion..2016. == TRUE | State.Medicaid.Expansion..2016. == FALSE)

ggplot(data = medicaid_clean, mapping = aes(x = State.Medicaid.Expansion..2016., y = Medicaid.Enrollment.Change..2013.2016.)) +
  geom_boxplot() +
  ylim(-4000, 4500000) +
  labs(x = "Did the state expand funding for Medicaid in 2016?", y = "Medicaid Enrollment Change between 2013 and 2016")
  
  
  