# Data Quality Notes

## Overview

The AIHW emergency department dataset contains several reporting and data-quality considerations that need to be taken into account during analysis.

These notes document how missing, suppressed and unavailable values were handled, as well as several reporting changes that may affect comparisons across hospitals and financial years.

## Suppressed Small Counts

Values reported as `<5` were treated as suppressed values rather than zero.

These records were kept as missing numeric values and flagged separately so that suppressed counts could be distinguished from genuine zero values.

## Publication Status Codes

The source data includes publication-status values such as:

- `-` – no patients were reported for the indicator in that time period
- `NP` – the reported data did not meet the criteria required to calculate the indicator
- `NP†` – the result could not be accurately calculated because more than 10% of presentations had missing or invalid time data

These values were retained as status fields rather than converted to numeric values.

## Caution Flags

Some reported values are marked with `*`, indicating that they should be interpreted with caution because 5–10% of presentations had missing or invalid time data.

These caution flags were preserved during data cleaning so that potentially less reliable results could still be identified.

## Changing Reporting Coverage

Not all hospitals are included in every financial year.

A missing hospital record therefore does not necessarily mean that the hospital recorded zero ED presentations.

Historical comparisons should be interpreted with care because reporting coverage may change over time.

## Historical Reporting Changes

Several changes in reporting should be considered when comparing results across financial years:

- Australian Capital Territory data for 2015–16 were not available for publication. At hospital and Local Hospital Network level, ACT data are also excluded for years before 2015–16.
- From 2019–20 onwards, the classification of admitted patients in Tasmanian hospitals changed. Results based on admission status before and after this change may therefore not be directly comparable.
- From 2023–24 onwards, invalid records were excluded from the `Number of presentations` field in the time-in-ED data. Invalid records include records with a negative length of stay or missing presentation or departure date/time information.

## Overlapping Reporting Levels

The dataset contains multiple reporting levels:

- Hospital
- Local Hospital Network
- State
- National

These reporting levels represent overlapping aggregates and should not be added together.

Analysis should therefore be performed within the appropriate reporting level.

## Peer-Group Benchmark Availability

Peer-group benchmarks are not available for every hospital, measure or financial year.

Hospitals without a valid peer benchmark were kept in the dataset, while the benchmark value remained missing.

Peer benchmarks are also not applicable to some higher reporting levels such as State and National records.

## Different Table Grains

The source tables are reported at different levels of detail.

For example:

- presentation and seen-on-time data are reported by triage category
- within-four-hours and time-in-ED data are reported by patient cohort

These differences need to be considered when combining or comparing measures across tables.

Measures from different source tables should only be compared when their reporting level, financial year and relevant cohort or category are aligned.

## Missing Values

Missing numeric values were not automatically treated as zero.

Depending on the source field, a missing value may represent:

- suppressed data
- an unpublished result
- a measure that could not be calculated
- an unavailable peer benchmark
- a reporting unit that was not included in that financial year

Keeping these values separate from genuine zero values helps avoid misleading calculations.

## Validation Checks

The cleaned and modelled datasets were checked for:

- expected row counts
- duplicate records
- missing or unavailable values
- valid foreign-key relationships
- absence of orphaned dimension keys
- percentage values within expected ranges
- consistency between median and P90 time-in-ED measures
- availability and validity of peer-group information

For time-in-ED data, the P90 value was also checked to ensure it was greater than or equal to the median value.

These checks were used to confirm that the cleaned datasets and dimensional model were suitable for SQL analysis and Power BI reporting.