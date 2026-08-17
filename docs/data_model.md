# Data Model

## Purpose and Business Questions

The data model is designed to support analysis of emergency department demand and service performance across Australian public hospitals and other reporting levels.

The model should support questions such as:

- How have emergency department presentations changed over time?
- How does demand vary across states, reporting units and triage categories?
- How have waiting-time and time-in-ED performance measures changed over time?
- How do reporting units compare with their peer-group benchmarks?
- Is increasing demand associated with changes in service performance?



## Source Tables and Grain

### Summary

The cleaned dataset contains four analytical tables derived from the AIHW emergency department data extract. Each table represents a different emergency department performance measure and has a specific analytical gain.

Because the tables contain measures at different levels of detail, they are modelled separately rather than combined into a single fact table.

### Reporting levels

The source data contains multiple reporting-unit level:
- Hospital
- Local Hospital Network
- State
- National

These levels contain overlapping aggregates and must not be summed together. 
For example, national presentation counts already include activity represented at state and hospital levels. The reporting-unit type must therefore be retained and used as a filtering dimension.


| Source table | Grain | Main measures |
|---|---|---|
| `patients_seen_on_time_clean` | One reporting unit x reporting unit type x financial year x triage category | Number of presentations, percentage seen on time, peer-group average |
| `time_in_ed_within_4hrs_clean` | One reporting unit x reporting unit type x financial year x patient cohort | Number of presentations, percentage departing ED within 4 hours, peer-group average |
| `time_in_ed_clean` | One reporting unit x reporting unit type x financial year x patient cohort | Number of presentations, median time in ED, 90th-percentile time in ED, peer-group average |
| `presentations_clean` | One reporting unit x reporting unit type x financial year x triage category | Number of presentations |

### `presentations_clean`

**Grain:**
One row represents one reporting unit x reporting unit type x financial year x triage category

**Dimension:**
- Reporting unit
- Reporting unit type
- State
- Financial year
- Triage category

**Measures:**
- Number of presentations

**Data-quality / status fields:**
- `small_count_flag` indicates that the original presentation count was suppressed as `<5`

**Notes:**
- Reporting units exist at Hospital, Local Hospital Network, State and National levels.
- Reporting levels contain overlapping aggregates and should not be summed together 
- A value of `0` represents an explicitly reported zero, while records flagged by `small_count_flag` represent suppressed counts below 5.


### `patients_seen_on_time_clean`

**Grain:**
One row represents one reporting unit x reporting unit type x financial year x triage category

**Dimensions:**
- Reporting unit
- Reporting unit type 
- State
- Peer group 
- Financial year
- Triage category

**Measures:**
- Number of presentations
- Percentage of patients seen on time
- Peer-group average

**Data-quality / status fields:**
- `small_count_flag` indicates that the presentation count was suppressed as `<5`
- `seen_on_time_caution_flag` indicates that 5–10% of presentations had missing or invalid time data
- `seen_on_time_status` preserves whether the indicator was reported, not calculable, or affected by substantial missing/invalid time data
- `peer_group_status` indicates whether a peer-group benchmark is available, not applicable, or the reporting unit is unpeered

**Notes:**
- Peer-group averages are not applicable to National and Local Hospital Network reporting levels.
- Some hospital reporting units are classified as unpeered and therefore do not have a numeric peer-group benchmark.


### `time_in_ed_within_4hrs_clean`

**Grain:**  
One row represents one reporting unit × reporting unit type × financial year × patient cohort.

**Dimensions:**
- Reporting unit
- Reporting unit type
- State
- Peer group
- Financial year
- Patient cohort

**Measures:**
- Number of presentations
- Percentage of patients departing ED within 4 hours
- Peer-group average

**Data-quality / status fields:**
- `small_count_flag` indicates that the presentation count was suppressed as `<5`.
- `within_4hrs_caution_flag` indicates that the within-4-hours measure should be interpreted with caution because 5–10% of presentations had missing or invalid time data.
- `within_4hrs_status` records whether the indicator was reported, had no patients reported, did not meet calculation criteria, or had more than 10% missing/invalid time data.
- `peer_group_status` indicates whether a peer-group benchmark is available (`peered`), unavailable because the reporting unit is unpeered (`not_peered`), or not applicable to that reporting level (`not_applicable`).

**Notes:**
- Patient cohorts include overall patients, triage categories and admission-status groups.
- Historical changes in reporting definitions may affect comparability for some jurisdictions and years.



### `time_in_ed_clean`

**Grain:**  
One row represents one reporting unit × reporting unit type × financial year × patient cohort.

**Dimensions:**
- Reporting unit
- Reporting unit type
- State
- Peer group
- Financial year
- Patient cohort

**Measures:**
- Median time in ED (`median_time_minutes`)
- 90th-percentile time in ED (`p90_time_minutes`)
- Peer-group 90th-percentile average (`peer_group_average_90_minutes`)
- Number of presentations (`number_of_presentations`)

**Data-quality / status fields:**
- `small_count_flag` indicates that the original number of presentations was suppressed as `<5`.
- `median_time_caution_flag` indicates that the median-time measure should be interpreted with caution because 5–10% of presentations had missing or invalid time data.
- `p90_time_caution_flag` indicates that the 90th-percentile time measure should be interpreted with caution because 5–10% of presentations had missing or invalid time data.
- `median_time_status` records whether the median-time indicator was reported, had no patients reported, did not meet calculation criteria, or had more than 10% missing/invalid time data.
- `p90_time_status` records the equivalent publication status for the 90th-percentile time measure.
- `peer_group_status` indicates whether a peer-group benchmark is available (`peered`), unavailable because the reporting unit is unpeered (`not_peered`), or not applicable to that reporting level (`not_applicable`).

**Notes:**
- Duration measures are stored as numeric minutes for analysis.
- Original formatted duration strings are retained in the cleaned dataset for traceability.
- The 90th-percentile time should generally be greater than or equal to the median time.



## Modelling Constraints and Data Considerations

### Suppressed counts (`<5`)

Some presentation counts are suppressed as `<5` to protect small-count information.

These values are not equivalent to zero and should not be treated as exact numeric counts. In the cleaned data, suppressed values are represented as missing numeric values together with a `small_count_flag`.

### Publication-status codes (`NP`, `NP†`, `-`) 

Some performance indicators are not reported as numeric values.

- `NP` indicates that the reported data did not meet the criteria required to calculate the indicator.
- `NP†` indicates that the indicator could not be accurately calculated because more than 10% of presentations had missing or invalid time data.
- `-` indicates that no patients were reported for the indicator in that time period. 

These values are retained through dedicated status fields rather than treated as ordinary missing values.

### Peer-group applicability 

Peer-group benchmarks are not available for every reporting unit.

Hospital reporting units may have a numeric peer-group benchmark or may be classified as unpeered. Peer-group averages are not applicable to some higher reporting levels, such as Local Hospital Network and National records. 

The `peer_group_status` field distinguishes between:

- `peered` 
- `not_peered`
- `not_applicable`  

### Reporting-unit aggregation levels

The data contains reporting units at multiple levels:

- Hospital
- Local Hospital Network
- State
- National 

These levels contain overlapping aggregates and must not be summed together. Analysis should explicitly filter or separate reporting-unit types to avoid double counting. 

### Financial-year granularity 

The dataset is reported by financial year rather than calendar year.

Financial-year labels such as `2023–24` should be modelled with an explicit ordering field, such as `start_year`, to support correct sorting and time-series analysis.  

### Changes in reporting coverage over time

The number of reporting units included in the dataset changes across financial years. 

As a result, increases or decreases in aggregated hospital-level activity may partly reflect changes in reporting coverage rather than changes in underlying demand. 

Longitudinal hospital-level comparisons should therefore consider whether the same reporting units are present across the periods being compared.

### Historical comparability

Some states, territories and measures are affected by changes in reporting definitions or data availability across years. 

These changes should be considered when interpreting trends, particularly for admission-status and time-in-ED measures.



## Proposed Model

Because the source tables contain measures at different grains, they are retained as separate fact tables rather than combined into a single table. Shared descriptive attributes are represented as dimension tables so they reused consistently across the model.

A dimensional model is also proposed, which is used to organise the cleaned emergency department data for analytical querying and Power BI reporting. 

### Proposed Fact Tables

Fact tables contains measurements, foreign keys to dimension, and observation-level flags/status fields.

**`presentations_fact`** 
Foreign key to dimension:

`reporting_unit_key`
`financial_year_key`
`triage_category_key`

Numerical measure: 

`number_of_presentations`

Data-quality flags: 

`small_count_flag`

**`seen_on_time_fact`** 

Foreign key to dimension:

`reporting_unit_key`
`financial_year_key`
`triage_category_key`
`peer_group_key`

Numerical measure: 

`number_of_presentations`
`percentage_seen_on_time`
`peer_group_average`

Data-quality flags: 

`small_count_flag`
`seen_on_time_caution_flag`

Publication/status fields: 

`seen_on_time_status`
`peer_group_status`

**`within_4_hrs_fact`**

Foreign keys to dimension:

`reporting_unit_key`
`financial_year_key`
`patient_cohort_key`
`peer_group_key`

Numerical measures:

`number_of_presentations`
`percentage_within_4hrs`
`peer_group_average`

Data-quality flags:

`small_count_flag`
`within_4hrs_caution_flag`

Publication/status fields: 

`within_4hrs_status`
`peer_group_status`

**`time_in_ed_fact`**
Foreign key to dimension:

`reporting_unit_key`
`financial_year_key`
`patient_cohort_key`
`peer_group_key`

Numerical measures:

`number_of_presentations`
`median_time_minutes`
`p90_time_minutes`
`peer_group_average_90_minutes`

Data-quality flags:

`small_count_flag`
`median_time_caution_flag`
`p90_time_caution_flag`

Publication/status fields: 

`median_time_status`
`p90_time_status`
`peer_group_status`



### Proposed Dimension Tables

Dimension tables contain descriptive attributes used to filter, group, label and sort the fact-table measures.

**`reporting_unit_dim`**

Primary key:

`reporting_unit_key`

Descriptive attributes:

`reporting_unit`  
`reporting_unit_type`  
`state`

**Design note:**  
Each combination of `reporting_unit` and `reporting_unit_type` maps to a single state across the cleaned source tables. Therefore, `state` is treated as a descriptive attribute rather than part of the natural key.

**`financial_year_dim`**

Primary key:

`financial_year_key`

Descriptive attributes:

`financial_year`  
`start_year`  
`end_year`

**`triage_category_dim`**

Primary key:

`triage_category_key`

Descriptive attributes:

`triage_category`  
`triage_order`

**`patient_cohort_dim`**

Primary key:

`patient_cohort_key`

Descriptive attributes:

`patient_cohort`  
`cohort_type`

**`peer_group_dim`**

Primary key:

`peer_group_key`

Descriptive attributes:

`peer_group`



## Data Model Diagram (ER Diagram)

Referred to `docs/proposed_data_model.png`

## Relationships and Cardinality

The dimensional model uses one-to-many relationships from dimension tables to fact tables.

- `reporting_unit_dim` has a one-to-many relationship with all four fact tables.
- `financial_year_dim` has a one-to-many relationship with all four fact tables.
- `triage_category_dim` has a one-to-many relationship with `presentations_fact` and `seen_on_time_fact`.
- `patient_cohort_dim` has a one-to-many relationship with `within_4_hrs_fact` and `time_in_ed_fact`.
- `peer_group_dim` has a one-to-many relationship with `seen_on_time_fact`, `within_4_hrs_fact`, and `time_in_ed_fact`.

Each fact record references one corresponding dimension record through a foreign key, while each dimension record may be associated with many fact records.

Fact tables are not directly related to one another; shared analysis is performed through the common dimension tables.


## Design Decisions 

### Separate fact tables for different measures

The source tables contain measures at different analytical grains. Combining them into a single fact table could introduce duplicated values and ambiguous relationships. Separate fact tables are therefore retained for presentations, seen-on-time performance, within-four-hours performance and time-in-ED measures.

### Surrogate keys for dimensions

Each dimension uses an integer surrogate key, such as `reporting_unit_key` or `financial_year_key`, as its primary key. These keys provide stable and compact relationships between dimension and fact tables while keeping descriptive attributes separate from the analytical measures.

### Reporting-unit attributes stored in a dimension

`reporting_unit`, `reporting_unit_type` and `state` are stored in `reporting_unit_dim` rather than repeated in each fact table. This reduces duplication and ensures consistent filtering across the model.

### Numeric representation of time measures

Time-in-ED measures are stored as numeric minutes in the fact table. Numeric values support aggregation, comparison and Power BI calculations more effectively than formatted text such as `2 hrs 58 mins`.

The original formatted duration strings remain available in the cleaned interim data for traceability.

### Preservation of data-quality and publication-status fields

Suppression flags, caution flags and publication-status fields are retained in the fact tables because they describe the reliability and availability of individual observations.

These fields allow analytical outputs to distinguish between valid reported values, suppressed values, unavailable indicators and values requiring cautious interpretation.

### Shared dimensions across fact tables

Common dimensions such as reporting unit and financial year are shared across multiple fact tables. This provides consistent filtering and grouping while avoiding direct relationships between fact tables.


## Future Extension

The current dimensional model focuses on the core AIHW emergency department datasets. Future extensions may include additional reference and population data to support broader analysis.

Potential extensions include:

- **Population data integration:** incorporate ABS population estimates to calculate population-adjusted emergency department presentation rates, such as presentations per 1,000 people.
- **Geographic enrichment:** add hospital location, postcode, remoteness or regional information to support geographic comparisons and mapping.
- **Hospital reference data:**  enrich `reporting_unit_dim` with additional hospital attributes where reliable reference data is available.
- **Additional time attributes:**  extend `financial_year_dim` with fields that support easier chronological sorting and period comparisons.
- **Analytical SQL views:**  create reusable views for trends, peer-group comparisons, year-on-year changes and reporting-level filtering.
- **Power BI semantic model:** use the dimensional schema as the basis for measures, slicers and dashboard reporting.
- **Forecasting or predictive analysis:** consider demand forecasting only if the data quality, coverage and analytical purpose justify it.