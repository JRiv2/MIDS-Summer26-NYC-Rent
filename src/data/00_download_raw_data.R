# Download the original rental and subway data.

# Download the May 2026 rental listings
download.file(
  url = "https://raw.githubusercontent.com/benfwalla/firstmover-open-data-project/main/public/data/2026-05.csv",
  destfile = file.path("data", "raw", "firstmover_listings_2026_05.csv"),
  mode = "wb"
)

# Download the MTA subway station list
download.file(
  url = "https://data.ny.gov/api/v3/views/39hk-dx4f/export.csv?accessType=DOWNLOAD",
  destfile = file.path("data", "raw", "mta_subway_stations.csv"),
  mode = "wb"
)
