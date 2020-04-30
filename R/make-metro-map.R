library(tidyverse)
library(sf)

ny_map <- st_read("../nyc_maps/ny_map/tl_2016_36_cousub.shp", stringsAsFactors = FALSE)

ny_map <- ny_map %>%
  filter(COUNTYFP %in% c("027", "059", "071", "079", "087", "111", "119", "061", "081", "005", "085", "047", 
                         "103"))

nj_map <- st_read("../nyc_maps/nj_map/tl_2016_34_cousub.shp", stringsAsFactors = FALSE)

nj_map <- nj_map %>%
  filter(COUNTYFP %in% c("003", "013", "017", "019", "021", "023", "025", "027", "029", "031", "035", "037", "039"))

ct_map <- st_read("../nyc_maps/ct_map/tl_2016_09_cousub.shp", stringsAsFactors = FALSE)

ct_map <- ct_map %>%
  filter(COUNTYFP %in% c("001", "005", "009"))

pa_map <- st_read("../nyc_maps/pa_map/tl_2016_42_cousub.shp", stringsAsFactors = FALSE)

pa_map <- pa_map %>%
  filter(COUNTYFP %in% c("103"))

ny_metro_map <- rbind(nj_map, ny_map)

ny_metro_map <- rbind(ny_metro_map, pa_map)

ny_metro_map <- rbind(ny_metro_map, ct_map)

st_write(ny_metro_map, "../nyc_maps/ny_metro_map/ny_metro_map.shp", layer = "ny_metro.shp", driver = "ESRI Shapefile", delete_dsn=TRUE)

ny_borough_map <- ny_map %>%
  filter(COUNTYFP %in% c("005", "047", "061", "081", "085"))

ny_borough_map <- ny_borough_map %>%
  rename(county = NAME)

ny_borough_map <- ny_borough_map %>%
  mutate(county = case_when(
    county == "Brooklyn" ~ "Kings",
    county == "Staten Island" ~ "Richmond",
    county == "Manhattan" ~ "New York",
    TRUE ~ county))

st_write(ny_borough_map, "../nyc_maps/ny_borough_map/ny_borough_map.shp", layer = "ny_borough.shp", driver = "ESRI Shapefile", delete_dsn=TRUE)

