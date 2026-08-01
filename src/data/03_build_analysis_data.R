# Combine rentals and stations into the final dataset used for analysis.

library(dplyr)

rentals_path <- file.path(
  "data", "interim", "firstmover_listings_nyc_clean.csv"
)
stations_path <- file.path(
  "data", "interim", "mta_subway_stations_clean.csv"
)
output_path <- file.path(
  "data", "processed", "nyc_rent_transit.csv"
)

rentals <- read.csv(
  rentals_path,
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE
)
stations <- read.csv(
  stations_path,
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE
)

#' Calculate distance between geographic coordinates using the Haversine formula
#'
#' Takes listing and station coordinates and returns their straight-line
#' distance in meters.
haversine_distance_m <- function(
  rental_lat,
  rental_lon,
  station_lat,
  station_lon
) {
  earth_radius_m <- 6371000
  radians <- pi / 180

  latitude_1 <- rental_lat * radians
  latitude_2 <- station_lat * radians
  latitude_delta <- (station_lat - rental_lat) * radians
  longitude_delta <- (station_lon - rental_lon) * radians

  haversine_component <-
    sin(latitude_delta / 2)^2 +
    cos(latitude_1) * cos(latitude_2) * sin(longitude_delta / 2)^2

  earth_radius_m * 2 * atan2(
    sqrt(haversine_component),
    sqrt(1 - haversine_component)
  )
}

# Create empty columns to store each rental's closest station and its distance
nearest_station_row <- integer(nrow(rentals))
nearest_station_distance_m <- numeric(nrow(rentals))

# Compare each listing with every station and keep the closest station
for (listing_row in seq_len(nrow(rentals))) {
  candidate_distances <- haversine_distance_m(
    rental_lat = rentals$latitude[listing_row],
    rental_lon = rentals$longitude[listing_row],
    station_lat = stations$station_latitude,
    station_lon = stations$station_longitude
  )

  nearest_station_row[listing_row] <- which.min(candidate_distances)
  nearest_station_distance_m[listing_row] <- min(candidate_distances)
}

# Select the closest station row for each rental
nearest_stations <- stations |>
  slice(nearest_station_row)

# Add the closest station and its distance to each rental listing
analysis_data <- rentals |>
  mutate(
    nearest_subway_station = nearest_stations$station_name,
    nearest_station_gtfs_id = nearest_stations$gtfs_stop_id,
    station_latitude = nearest_stations$station_latitude,
    station_longitude = nearest_stations$station_longitude,
    distance_to_subway_m = round(nearest_station_distance_m, 2)
  )

# Assign 30% of data to the Exploration set and 70% to the Confirmation set
set.seed(203)
exploration_rows <- sample(
  seq_len(nrow(analysis_data)),
  size = floor(0.30 * nrow(analysis_data)),
  replace = FALSE
)
analysis_data <- analysis_data |>
  mutate(
    analysis_split = if_else(
      row_number() %in% exploration_rows,
      "exploration",
      "confirmation"
    )
  )

# Save the completed dataset
write.csv(analysis_data, output_path, row.names = FALSE)
message("Wrote ", nrow(analysis_data), " listing-station rows to ", output_path)
