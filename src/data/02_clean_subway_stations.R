# Prepare the subway stations before combining them with rental data.

library(dplyr)

input_path <- file.path("data", "raw", "mta_subway_stations.csv")
output_path <- file.path("data", "interim", "mta_subway_stations_clean.csv")

stations_raw <- read.csv(
  input_path,
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Keep the station columns that are useful for this project.
station_columns <- c(
  "GTFS Stop ID", "Station ID", "Complex ID", "Stop Name", "Borough",
  "Daytime Routes", "Structure", "GTFS Latitude", "GTFS Longitude"
)

stations_clean <- stations_raw |>
  select(all_of(station_columns)) |>
  rename(
    gtfs_stop_id = `GTFS Stop ID`,
    station_id = `Station ID`,
    complex_id = `Complex ID`,
    station_name = `Stop Name`,
    station_borough = Borough,
    daytime_routes = `Daytime Routes`,
    station_structure = Structure,
    station_latitude = `GTFS Latitude`,
    station_longitude = `GTFS Longitude`
  ) |>
  # Remove stations without latitude and longitude
  filter(!is.na(station_latitude), !is.na(station_longitude))

# Save the cleaned station data for the later joining step.
write.csv(stations_clean, output_path, row.names = FALSE)
message("Wrote ", nrow(stations_clean), " stations to ", output_path)
