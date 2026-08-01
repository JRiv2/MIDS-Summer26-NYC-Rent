# Prepare the joined data for modeling.

library(dplyr)

input_path <- file.path("data", "processed", "nyc_rent_transit.csv")
output_path <- file.path("data", "processed", "nyc_rent_transit_modeling.csv")

analysis_data <- read.csv(
  input_path,
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE
)

# Apply new cleaning rules surfaced in EDA, add new variables.
modeling_data <- analysis_data |>
  # Treat impossible zero values as missing
  mutate(
    sqft = na_if(sqft, 0),
    net_effective_rent = na_if(net_effective_rent, 0)
  ) |>
  # Keep one copy of each repeated listing URL
  distinct(listing_url, .keep_all = TRUE) |>
  # Keep one listing per apartment
  distinct(borough, street, unit, .keep_all = TRUE) |>
  # Create variables that may be useful in the models
  mutate(
    distance_to_subway_miles = round(distance_to_subway_m / 1609.344, 4),
    log_monthly_rent = log(monthly_rent),
    log_distance_m = log(distance_to_subway_m)
  )

write.csv(modeling_data, output_path, row.names = FALSE)
message("Wrote ", nrow(modeling_data), " rows to ", output_path)
