
# Copy relevant data files into Shiny app data directory

file.copy("../data/ny_specific/medicare_ny.csv", "../nyc_healthcare/data", overwrite = TRUE)
file.copy("../data/ny_specific/medicare_by_county.csv", "../nyc_healthcare/data", overwrite = TRUE)

# NY borough map files

file.copy("../nyc_maps/ny_borough_map/ny_borough_map.shx", "../nyc_healthcare/data/ny_borough_map", overwrite = TRUE)
file.copy("../nyc_maps/ny_borough_map/ny_borough_map.shp", "../nyc_healthcare/data/ny_borough_map", overwrite = TRUE)
file.copy("../nyc_maps/ny_borough_map/ny_borough_map.prj", "../nyc_healthcare/data/ny_borough_map", overwrite = TRUE)
file.copy("../nyc_maps/ny_borough_map/ny_borough_map.dbf", "../nyc_healthcare/data/ny_borough_map", overwrite = TRUE)

# NY metro area map files

file.copy("../nyc_maps/ny_metro_map/ny_metro_map.shx", "../nyc_healthcare/data/ny_metro_map", overwrite = TRUE)
file.copy("../nyc_maps/ny_metro_map/ny_metro_map.shp", "../nyc_healthcare/data/ny_metro_map", overwrite = TRUE)
file.copy("../nyc_maps/ny_metro_map/ny_metro_map.prj", "../nyc_healthcare/data/ny_metro_map", overwrite = TRUE)
file.copy("../nyc_maps/ny_metro_map/ny_metro_map.dbf", "../nyc_healthcare/data/ny_metro_map", overwrite = TRUE)