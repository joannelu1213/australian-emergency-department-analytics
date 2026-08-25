# Data Dictionary

## Overview

This data dictionary describes the dimension and fact tables used in the Australian Emergency Department Analytics project.

The final analytical model contains five dimension tables and four fact tables. The model was created in Python and loaded into PostgreSQL for SQL analysis and Power BI reporting.

## Dimension Tables

### `reporting_unit_dim`

Stores information about each reporting unit included in the dataset.

| Column | Data Type | Description |
|---|---|---|
| `reporting_unit_key` | INTEGER | Unique surrogate key for each reporting unit |
| `reporting_unit` | VARCHAR | Name of the hospital or reporting unit |
| `reporting_unit_type` | VARCHAR | Reporting level, such as Hospital, Local Hospital Network, State or National |
| `state` | VARCHAR | Australian state or territory associated with the reporting unit |

The combination of `reporting_unit` and `reporting_unit_type` is unique.

---

### `financial_year_dim`

Stores the financial years included in the analysis.

| Column | Data Type | Description |
|---|---|---|
| `financial_year_key` | INTEGER | Unique surrogate key for each financial year |
| `financial_year` | VARCHAR | Financial year label, such as `2024–25` |
| `start_year` | INTEGER | First calendar year of the financial year |
| `end_year` | INTEGER | Second calendar year of the financial year |

`end_year` is always one year after `start_year`.

---

### `triage_category_dim`

Stores the emergency department triage categories used in the presentation and seen-on-time datasets.

| Column | Data Type | Description |
|---|---|---|
| `triage_category_key` | INTEGER | Unique surrogate key for each triage category |
| `triage_category` | VARCHAR | Name of the triage category |
| `triage_order` | INTEGER | Numerical order used to display triage categories by clinical urgency |

The triage order is:

1. Resuscitation
2. Emergency
3. Urgent
4. Semi-Urgent
5. Non-Urgent

---

### `patient_cohort_dim`

Stores patient cohorts used in the within-four-hours and time-in-ED datasets.

| Column | Data Type | Description |
|---|---|---|
| `patient_cohort_key` | INTEGER | Unique surrogate key for each patient cohort |
| `patient_cohort` | VARCHAR | Name of the patient cohort |
| `cohort_type` | VARCHAR | Grouping of the cohort |
| `cohort_order` | INTEGER | Numerical order used for displaying patient cohorts |

Patient cohorts include:

- All patients
- Resuscitation
- Emergency
- Urgent
- Semi-Urgent
- Non-Urgent
- Subsequently admitted patients
- Not subsequently admitted patients

---

### `peer_group_dim`

Stores the AIHW peer-group classifications used for hospital benchmarking.

| Column | Data Type | Description |
|---|---|---|
| `peer_group_key` | INTEGER | Unique surrogate key for each peer group |
| `peer_group` | VARCHAR | AIHW peer-group classification |

Peer-group keys may be missing from fact tables when peer benchmarking is not applicable.

---

## Fact Tables

### `presentations_fact`

Stores emergency department presentation volumes.

**Grain:** one record per reporting unit, financial year and triage category.

| Column | Data Type | Description |
|---|---|---|
| `reporting_unit_key` | INTEGER | Foreign key to `reporting_unit_dim` |
| `financial_year_key` | INTEGER | Foreign key to `financial_year_dim` |
| `triage_category_key` | INTEGER | Foreign key to `triage_category_dim` |
| `number_of_presentations` | NUMERIC | Number of emergency department presentations |
| `small_count_flag` | BOOLEAN | Indicates whether the original presentation count was suppressed because it was less than 5 |

The composite primary key is:

`reporting_unit_key + financial_year_key + triage_category_key`

---

### `seen_on_time_fact`

Stores the percentage of patients seen within the recommended timeframe for their triage category.

**Grain:** one record per reporting unit, financial year and triage category.

| Column | Data Type | Description |
|---|---|---|
| `reporting_unit_key` | INTEGER | Foreign key to `reporting_unit_dim` |
| `financial_year_key` | INTEGER | Foreign key to `financial_year_dim` |
| `triage_category_key` | INTEGER | Foreign key to `triage_category_dim` |
| `peer_group_key` | INTEGER | Foreign key to `peer_group_dim`; may be NULL when peer benchmarking is not applicable |
| `number_of_presentations` | NUMERIC | Number of ED presentations for the reporting unit, year and triage category |
| `percentage_seen_on_time` | NUMERIC | Proportion of patients seen within the recommended triage timeframe |
| `peer_group_average` | NUMERIC | Average seen-on-time performance for the relevant peer group |
| `small_count_flag` | BOOLEAN | Indicates whether the presentation count was suppressed because it was less than 5 |
| `seen_on_time_caution_flag` | BOOLEAN | Indicates whether the seen-on-time result was marked with a source caution flag |
| `seen_on_time_status` | VARCHAR | Publication or availability status of the seen-on-time measure |
| `peer_group_status` | VARCHAR | Indicates whether peer-group benchmarking is available, unavailable or not applicable |

The composite primary key is:

`reporting_unit_key + financial_year_key + triage_category_key`

---

### `within_4_hrs_fact`

Stores the percentage of patients who departed the emergency department within four hours.

**Grain:** one record per reporting unit, financial year and patient cohort.

| Column | Data Type | Description |
|---|---|---|
| `reporting_unit_key` | INTEGER | Foreign key to `reporting_unit_dim` |
| `financial_year_key` | INTEGER | Foreign key to `financial_year_dim` |
| `patient_cohort_key` | INTEGER | Foreign key to `patient_cohort_dim` |
| `peer_group_key` | INTEGER | Foreign key to `peer_group_dim`; may be NULL when peer benchmarking is not applicable |
| `number_of_presentations` | NUMERIC | Number of ED presentations for the reporting unit, year and patient cohort |
| `percentage_within_4hrs` | NUMERIC | Proportion of patients who departed the ED within four hours |
| `peer_group_average` | NUMERIC | Average within-four-hours performance for the relevant peer group |
| `small_count_flag` | BOOLEAN | Indicates whether the presentation count was suppressed because it was less than 5 |
| `within_4hrs_caution_flag` | BOOLEAN | Indicates whether the within-four-hours result was marked with a source caution flag |
| `within_4hrs_status` | VARCHAR | Publication or availability status of the within-four-hours measure |
| `peer_group_status` | VARCHAR | Indicates whether peer-group benchmarking is available, unavailable or not applicable |

The composite primary key is:

`reporting_unit_key + financial_year_key + patient_cohort_key`

---

### `time_in_ed_fact`

Stores median and 90th percentile time spent in the emergency department.

**Grain:** one record per reporting unit, financial year and patient cohort.

| Column | Data Type | Description |
|---|---|---|
| `reporting_unit_key` | INTEGER | Foreign key to `reporting_unit_dim` |
| `financial_year_key` | INTEGER | Foreign key to `financial_year_dim` |
| `patient_cohort_key` | INTEGER | Foreign key to `patient_cohort_dim` |
| `peer_group_key` | INTEGER | Foreign key to `peer_group_dim`; may be NULL when peer benchmarking is not applicable |
| `number_of_presentations` | NUMERIC | Number of ED presentations for the reporting unit, year and patient cohort |
| `median_time_minutes` | NUMERIC | Median time spent in the ED, expressed in minutes |
| `p90_time_minutes` | NUMERIC | Time in minutes by which 90% of patients had departed the ED |
| `peer_group_average_90_minutes` | NUMERIC | Peer-group average for the P90 time-in-ED measure, expressed in minutes |
| `small_count_flag` | BOOLEAN | Indicates whether the presentation count was suppressed because it was less than 5 |
| `median_time_caution_flag` | BOOLEAN | Indicates whether the median time result was marked with a source caution flag |
| `p90_time_caution_flag` | BOOLEAN | Indicates whether the P90 result was marked with a source caution flag |
| `median_time_status` | VARCHAR | Publication or availability status of the median time measure |
| `p90_time_status` | VARCHAR | Publication or availability status of the P90 time measure |
| `peer_group_status` | VARCHAR | Indicates the availability or applicability of peer-group benchmarking. |

The composite primary key is:

`reporting_unit_key + financial_year_key + patient_cohort_key`

---

## Common Flags and Status Fields

### `small_count_flag`

Indicates whether the original number of presentations was reported as `<5`.

- `TRUE` – the source count was suppressed
- `FALSE` – the count was not suppressed

Suppressed counts are kept as missing numeric values rather than converted to zero.

### Caution Flags

The following fields store caution information from the AIHW source:

- `seen_on_time_caution_flag`
- `within_4hrs_caution_flag`
- `median_time_caution_flag`
- `p90_time_caution_flag`

A value of `TRUE` indicates that the source result was marked with `*`, meaning 5–10% of presentations had missing or invalid time data and the result should be interpreted with caution.

### Measure Status Fields

The following fields preserve publication and availability information:

- `seen_on_time_status`
- `within_4hrs_status`
- `median_time_status`
- `p90_time_status`

Source status values may include:

- `-` – no patients were reported for the indicator in that time period
- `NP` – the reported data did not meet the criteria required to calculate the indicator
- `NP†` – the result could not be accurately calculated because more than 10% of presentations had missing or invalid time data

### `peer_group_status`

Indicates whether peer-group benchmarking is applicable or available for a record.

For records where peer benchmarking is not applicable, `peer_group_key` is left NULL rather than assigning an artificial peer group.