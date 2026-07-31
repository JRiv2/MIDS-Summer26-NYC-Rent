# Prepare the rental listings data

library(dplyr)

input_path <- file.path("data", "raw", "firstmover_listings_2026_05.csv")
output_path <- file.path("data", "interim", "firstmover_listings_nyc_clean.csv")

rentals_raw <- read.csv(
  input_path,
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Keep the source columns that are useful for this project.
analysis_columns <- c(
  "id", "created_at_utc", "available_date", "street", "unit",
  "neighborhood", "borough", "zip_code", "state", "latitude", "longitude",
  "building_type", "bedrooms", "bathrooms", "half_baths", "sqft", "price",
  "net_effective_price", "furnished", "is_new_development", "lease_months",
  "months_free", "no_fee", "source_group", "source_type", "url"
)

nyc_boroughs <- c(
  "Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island"
)

# Keep listings in the five NYC boroughs and retain useful analysis fields.
rentals_nyc <- rentals_raw |>
  filter(borough %in% nyc_boroughs) |>
  select(all_of(analysis_columns)) |>
  rename(
    listing_id = id,
    monthly_rent = price,
    net_effective_rent = net_effective_price,
    listing_url = url
  )

# Save the cleaned rental data for the later joining step.
write.csv(rentals_nyc, output_path, row.names = FALSE)

message(
  "Wrote ", nrow(rentals_nyc), " NYC listings to ", output_path,
  ". Filtered ", nrow(rentals_raw) - nrow(rentals_nyc),
  " rows outside the five NYC boroughs."
)
