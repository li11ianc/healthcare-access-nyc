project-ggsquad.html: project-ggsquad.Rmd data/all_health_facilities.csv data/states_pop.csv data/Total Medicaid.csv data/TM with USA.csv nyc_healthcare/app.R
    Rscript -e "library(rmarkdown);render('project-ggsquad.Rmd')"

# For disparities in the US analysis
data/all_health_facilities.csv: R/data-acquisition.R
	cd R; Rscript data-acquisition.R
	
R/data-acquisition.R: data/hospitals.csv data/pharmacies.csv data/nursing_homes.csv data/urgent_care.csv
	cd R; Rscript data-acquisition.R
	
data/hospitals.csv: data/raw/Hospitals.csv R/parse_hospitals.R
	cd R; Rscript parse_hospitals.R

data/pharmacies.csv: data/raw/facility.csv R/parse_pharmacies.R
	cd R; Rscript parse_pharmacies.R

data/nursing_homes.csv: data/raw/Nursing_Homes.csv R/parse_nursing_homes.R
	cd R; Rscript parse_nursing_homes.R

data/urgent_care.csv: data/raw/Urgent_Care_Facilities.csv R/parse_urgent_care.R
	cd R; Rscript parse_urgent_care.R

data/states_pop.csv: R/scrape_population.R
	cd R; Rscript scrape_population.R


# For New York metro area analysis and Shiny app
nyc_healthcare/app.R: R/copy_files_nyc_shinyapp.R data/ny_specific/medicare_ny.csv data/ny_specific/medicare_by_county.csv nyc_maps/ny_metro_map/ny_metro_map.shp nyc_maps/ny_borough_map/ny_borough_map.shp    
	Rscript R/copy_files_nyc_shinyapp.R
	
R/copy_files_nyc_shinyapp.R: data/ny_specific/medicare_ny.csv data/ny_specific/medicare_by_county.csv nyc_maps/ny_metro_map/ny_metro_map.shp nyc_maps/ny_borough_map/ny_borough_map.shp
	Rscript R/copy_files_nyc_shinyapp.R

data/ny_specific/medicare_ny.csv: data/medicare.csv R/label-ny-metro-area.R
	cd R; Rscript label-ny-metro-area.R

R/label-ny-metro-area.R: data/medicare.csv data/uscities.csv
	cd R; Rscript label-ny-metro-area.R
	
data/medicare.csv: data/raw/medicare.csv R/parse_medicare.R
	cd R; Rscript parse_medicare.R

data/ny_specific/medicare_by_county.csv: R/medicare-by-county.R data/ny_specific/medicare_ny.csv data/ny_specific/county-level/county_indicators.csv
	cd R; Rscript medicare-by-county.R
	
R/medicare-by-county.R: data/ny_specific/medicare_ny.csv data/ny_specific/county-level/county_indicators.csv
	cd R; Rscript medicare-by-county.R

data/ny_specific/county-level/county_indicators.csv: R/ny-county-level-stats.R data/ny_specific/county-level/PopulationEstimates.csv data/ny_specific/county-level/PovertyEstimates.csv data/ny_specific/county-level/Unemployment.csv 
	cd R; Rscript ny-county-level-stats.R

R/ny-county-level-stats.R: data/ny_specific/county-level/PopulationEstimates.csv data/ny_specific/county-level/PovertyEstimates.csv data/ny_specific/county-level/Unemployment.csv 
	cd R; Rscript ny-county-level-stats.R

medicare.csv: data/raw/medicare.csv R/parse_medicare.R R/medicare-cleanup.R
	cd R; Rscript parse_medicare.R; Rscript medicare-cleanup.R
	
R/medicare-cleanup.R: data/raw/medicare.csv
	cd R; Rscript medicare-cleanup.R

nyc_maps/ny_metro_map/ny_metro_map.shp: R/make-metro-map.R
	cd R; Rscript make-metro-map.R

nyc_maps/ny_borough_map/ny_borough_map.shp: R/make-metro-map.R
	cd R; Rscript make-metro-map.R

make-metro-map: nyc_maps/ny_map/tl_2016_36_cousub.shp nyc_maps/nj_map/tl_2016_34_cousub.shp nyc_maps/ct_map/tl_2016_09_cousub.shp nyc_maps/pa_map/tl_2016_42_cousub.shp
	cd R; Rscript make-metro-map.R

# Clean file
.PHONY: clean_html
clean_html:
	rm project-ggsquad.html
