# Source Code

## Data pipeline

The data pipeline is stored in `src/data/` and runs in the following order:

1. `00_download_raw_data.R`
2. `01_clean_rentals.R`
3. `02_clean_subway_stations.R`
4. `03_build_analysis_data.R`
5. `04_prepare_modeling_data.R`

Run all five stages from the project root with:

```r
source("src/data/run_data_pipeline.R")
```

EDA in `notebooks/01_eda.Rmd` is used to choose cleaning and modeling-sample rules. Those decisions belong in `04_prepare_modeling_data.R` along with modeling-specific feature engineering. The script currently creates `data/processed/nyc_rent_transit_modeling.csv` and can be updated as additional decisions are made.

See [`../data/README.md`](../data/README.md) for source information, cleaning decisions, derived variables, and the exploration/confirmation workflow.

The original course-template README for this folder is preserved in [`TEMPLATE_README.md`](TEMPLATE_README.md).
