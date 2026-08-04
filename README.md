# NYC Rent and Subway Proximity

Our DATASCI 203 final project uses May 2026 NYC rental listings and MTA subway-station data to study the descriptive relationship between advertised monthly rent and straight-line distance to the nearest subway station.

## Assignment

The assignment prompt is available in [`prompt/assignment.qmd`](prompt/assignment.qmd) and [`prompt/assignment.pdf`](prompt/assignment.pdf).

The original course-template README is preserved in [`TEMPLATE_README.md`](TEMPLATE_README.md).

## Setup

This project uses R 4.6.0. The first time you use the project, restore the provided R environment:

```r
renv::restore()
```

## Reproducing the data

Run the complete data pipeline from the project root:

```r
source("src/data/run_data_pipeline.R")
```

The pipeline downloads the original FirstMover rental listings and MTA station data, cleans each source separately, and produces two processed files:

```text
data/processed/nyc_rent_transit.csv
data/processed/nyc_rent_transit_modeling.csv
```

`nyc_rent_transit.csv` contains the joined rental and transit data used for exploration, while `nyc_rent_transit_modeling.csv` applies the cleaning decisions and derived variables used for modeling.

See [`data/README.md`](data/README.md) for the data sources, directory roles, cleaning decisions, derived variables, and exploration/confirmation split.

## Project directories

```text
├── LICENSE
├── README.md                         <- Project overview and setup instructions
├── TEMPLATE_README.md                <- Original course-template README
├── data
│   ├── README.md                     <- Data sources and processing decisions
│   ├── raw                           <- Files downloaded from the original sources
│   ├── interim                       <- Each source after initial cleaning
│   ├── processed                     <- Joined and modeling-ready datasets
│   └── external                      <- Supporting third-party data
├── notebooks
│   ├── 01_eda.Rmd                    <- Exploratory analysis
│   └── 02_model_exploration.Rmd      <- Regression model exploration and results
├── peer_review                       <- Individual peer-evaluation template
├── prompt                            <- Assignment prompt and references
├── reports                           <- Final report source and rendered output
├── src
│   ├── README.md                     <- Source-code documentation
│   └── data                          <- Data pipeline scripts
├── renv                              <- Project environment files
├── renv.lock                         <- Recorded R package versions
└── lab_2.Rproj                       <- R project file
```
