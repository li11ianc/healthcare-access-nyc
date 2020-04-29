project-ggsquad.html: project-ggsquad.Rmd
    Rscript -e "library(rmarkdown);render('project-ggsquad.Rmd')"

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
