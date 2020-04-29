project-ggsquad.html: project-ggsquad.Rmd data/all_health_facilities.csv data/states_pop.csv data/Total Medicaid.csv data/TM with USA.csv
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


# For New York metro area analysis/shiny app
medicare_ny.csv: medicare.csv label-ny-metro-area.R
	Rscript label-ny-metro-area.R

medicare_by_county.csv: county_indicators.csv medicare_ny.csv
	Rscript medicare-by-county.R

county_indicators.csv: Unemployment.csv PovertyEstimates.csv PopulationEstimates.csv ny-county-level-stats.R
	Rscript ny-county-level-stats.R

medicare.csv: raw/medicare.csv parse_medicare.R medicare-cleanup.R label-ny-metro-area.R
	Rscript parse_medicare.R
	Rscript medicare-cleanup.R
	Rscript label-ny-metro-area.R
	
ny_borough_map: make-metro-map.R

ny_metro_map: make-metro-map.R

make-metro-map: ny_map, nj_map, ct_map, pa_map

# Clean file
.PHONY: clean_html
clean_html:
	rm project-ggsquad.html
