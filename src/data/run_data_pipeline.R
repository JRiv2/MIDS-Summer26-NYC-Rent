# Run the complete data pipeline from the repository root.

pipeline_scripts <- c(
  "00_download_raw_data.R",
  "01_clean_rentals.R",
  "02_clean_subway_stations.R",
  "03_build_analysis_data.R"
)

for (script_name in pipeline_scripts) {
  script_path <- file.path("src", "data", script_name)
  message("\n--- Running ", script_path, " ---")
  source(script_path, local = new.env(parent = globalenv()))
}

message("\nData pipeline completed successfully.")
