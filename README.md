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

The pipeline downloads the original FirstMover rental listings and MTA station data, cleans each source separately, and produces the canonical analysis file:

```text
data/processed/nyc_rent_transit.csv
```

See [`data/README.md`](data/README.md) for the data sources, directory roles, cleaning decisions, derived variables, and exploration/confirmation split.

## Project directories

- `data/`: Raw, interim, and processed data files
- `notebooks/`: Exploratory analysis and model development
- `peer_review/`: Individual peer-evaluation template
- `prompt/`: Assignment prompt and references
- `references/`: Data dictionaries and supporting materials
- `reports/`: Final report source and rendered output
- `src/`: Reusable source code, including the data pipeline
