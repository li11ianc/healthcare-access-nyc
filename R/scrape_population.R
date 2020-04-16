library(tidyverse)
library(rvest)
library(stringr)

url <- "https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population"

# scrape state names
states <- read_html(url) %>%
  html_nodes(css = "td+ td .flagicon+ a") %>%
  html_text()

# convert to abbreviations
states_abb <- state.abb[match(states,state.name)]
states_abb[50] <- "DC"
states_abb[31] <- "PR"
 
# scarpe population
states_pop <- read_html(url) %>%
  html_nodes(css = "td:nth-child(5)") %>% 
  html_text()

# format population
states_pop <- population[1:56] %>% 
  str_remove("\\n") %>% 
  str_remove("\\[\\d*\\]") %>% 
  str_replace_all(",", "") %>% 
  as.numeric()

states_pop <- data.frame(states, states_abb, states_pop)

write_csv(states_pop, "data/states_pop.csv")
write_csv(states_pop, "facilities_finder/data/states_pop.csv")

