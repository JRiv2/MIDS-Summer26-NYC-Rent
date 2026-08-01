# Data

This project downloads the original source data and creates all analysis-ready variables through scripts in `src/data/`.

## Directory roles

- `raw/`: Files downloaded directly from the original publishers. Do not edit these files manually.
- `interim/`: Cleaned versions of each individual source, before sources are joined.
- `processed/`: The joined dataset used for exploration and the prepared dataset used for modeling.
- `external/`: Supporting third-party data that are not part of the primary processing pipeline.

CSV files under `data/` are ignored by Git. The scripts, source URLs, and cleaning rules are version-controlled so another person can reconstruct the data.

## Primary sources

### Rental listings

- Publisher: FirstMover Open Data Project
- Source page: <https://www.firstmovernyc.com/open-data>
- File: May 2026 monthly listings
- Unit of observation: A rental listing when it first appeared on the market
- Downloaded file: `raw/firstmover_listings_2026_05.csv`

The listing price is an advertised asking rent, not a signed lease rent. The source records the listing when it first appears and does not incorporate later price or status changes.

### Subway stations

- Publisher: Metropolitan Transportation Authority via New York Open Data
- Dataset page: <https://data.ny.gov/Transportation/MTA-Subway-Stations/39hk-dx4f>
- Unit of observation: An MTA station
- Downloaded file: `raw/mta_subway_stations.csv`

Station coordinates represent station centroids. Consequently, the derived distance is straight-line distance to a station centroid, not walking distance, travel time, or distance to the nearest entrance.

The MTA dataset is a current dataset and may be revised after an analysis is first run. Rerunning the download script may therefore update the station file and change a small number of nearest-station assignments.

## Distance calculation

The pipeline calculates the straight-line distance from each rental listing to each subway-station centroid with the Haversine formula:

$$
a = \sin^2\left(\frac{\Delta\phi}{2}\right) + \cos(\phi_1)\cos(\phi_2)\sin^2\left(\frac{\Delta\lambda}{2}\right)
$$

$$
d = 2R\operatorname{atan2}\left(\sqrt{a}, \sqrt{1-a}\right)
$$

In this formula, $\phi_1$ is the rental latitude, $\phi_2$ is the station latitude, $\Delta\phi$ is the difference in latitude, $\Delta\lambda$ is the difference in longitude, and $R$ is the Earth's approximate radius of 6,371,000 meters. All latitude and longitude values are converted from degrees to radians before the formula is applied. For each rental, the station with the smallest resulting value of $d$ is selected as the nearest station.

## Pipeline

Run the complete pipeline from the repository root:

```r
source("src/data/run_data_pipeline.R")
```

The stages are:

1. `00_download_raw_data.R`: download the two original source files.
2. `01_clean_rentals.R`: retain the five NYC boroughs and select and rename listing variables.
3. `02_clean_subway_stations.R`: select station identifiers, names, and centroid coordinates.
4. `03_build_analysis_data.R`: assign each listing to its nearest station using Haversine distance and create a reproducible exploration/confirmation split.
5. `04_prepare_modeling_data.R`: apply modeling-data rules and create modeling features while preserving the existing split.

`processed/nyc_rent_transit.csv` contains the joined rental and transit data. The EDA notebook uses its exploration rows to choose cleaning and modeling rules.

The pipeline then applies the current rules to all rows and creates `processed/nyc_rent_transit_modeling.csv` for modeling. Stage 04 can be updated as additional decisions are made.

## Cleaning and operationalization decisions

- Keep only `Bronx`, `Brooklyn`, `Manhattan`, `Queens`, and `Staten Island`.
- Calculate straight-line distances with the Haversine formula and an Earth radius of 6,371,000 meters.
- Use a fixed random seed to assign 30% of records to exploration and 70% to confirmation. Modeling decisions should be made with the exploration sample; final reported estimates should be recalculated on the confirmation sample.
- Treat zero square footage and zero net-effective rent as missing in the modeling dataset because neither is a possible observed value.
- Keep one row per listing URL and one row per borough, street, and unit combination.
