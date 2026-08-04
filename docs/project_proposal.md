## Project Overview

This project will analyse public emergency department data to understand patterns in demand and service performance across Australian public hospitals.

The aim is to develop an end-to-end analytics solution using Python, SQL and Power BI. The project will transform multi-table public data into a structured analytical model and an interactive dashboard that supports healthcare service planning, performance monitoring and further investigation.

The initial project will focus on descriptive and diagnostic analytics. A forecasting or machine-learning extension may be considered later if the available data supports a meaningful and methodologically appropriate predictive question.

## Problem Statement

Emergency departments operate under changing levels of demand while being expected to provide timely care across different levels of clinical urgency.

Healthcare managers and planning teams need to understand how emergency department presentations and performance measures change across time, states, hospitals, triage categories and patient cohorts. Without a clear analytical view, it may be difficult to identify demand growth, changes in waiting-time performance and reporting units that require closer investigation.

This project will use Australian public emergency department data to examine demand and service-performance patterns and communicate the findings through an interactive dashboard.

## Target Users

- Emergency department and hospital service managers
- Healthcare operations and planning teams
- Health performance and data analysts
- Government and public health decision-makers

The dashboard should help users identify changes in demand, compare performance across reporting levels and investigate areas where service outcomes differ over time or from comparable peer groups.

## Project Objective

To develop a reproducible emergency department analytics solution that transforms public data into clear and responsible insights about demand and service performance across Australian public hospitals.

### Data Source

The project will initially use:

- AIHW emergency department data extract
- ABS population estimates, where compatible, to calculate population-adjusted demand measures
- Hospital, geographic or peer-group reference data, where required and available

The final supporting datasets will be confirmed after assessing their definitions, geographic coverage and compatibility with the AIHW extract.

## Analytical Questions (initial)

1. How have emergency department presentations changed over time nationally and across states and territories?
2. How does demand vary across hospitals, reporting units and triage categories?
3. How have key service-performance measures changed over time?
4. Which reporting units perform above or below comparable peer-group results?
5. Is growth in emergency department demand associated with changes in waiting-time or time-in-ED performance?
6. How do population-adjusted presentation rates differ across jurisdictions, where compatible population data is available?
7. Which reporting units or performance measures may require closer operational investigation?

The final analytical questions will be refined after data profiling and validation.

## Proposed Performance Measures

The project may examine:

- Total emergency department presentations
- Year-over-year change in presentations
- Presentations by triage category
- Presentations per 1,000 residents
- Percentage of patients seen within recommended timeframes
- Percentage of emergency department visits completed within four hours
- Median time spent in the emergency department
- 90th-percentile time spent in the emergency department
- Difference from state or peer-group performance
- Change in performance over time

The final measures will depend on the definitions, completeness and compatibility of the available data.

## Proposed Technical Workflow

AIHW emergency department extract
+
ABS population estimates
+
Hospital and geographic reference data
↓
Python extraction, cleaning, harmonisation and validation
↓
SQL dimensional model and analytical views
↓
Exploratory and diagnostic analysis
↓
Power BI dashboard and data storytelling
↓
GitHub documentation and portfolio case study

## Expected Deliverables

The project will produce:

- A reproducible Python data-processing pipeline
- A cleaned and documented analytical dataset
- A SQL dimensional model
- SQL analytical queries and views
- A Power BI dashboard
- A data dictionary
- Data-quality and methodology documentation
- A public GitHub repository
- A portfolio case study
- An optional predictive extension, if justified by the data

## Project Boundaries

The project will:

- Use only public or appropriately licensed data
- Avoid personally identifiable information
- Focus on emergency department demand and service performance rather than clinical diagnosis
- Treat associations as associations and avoid unsupported causal conclusions
- Avoid making unsupported medical, staffing or hospital-management recommendations
- Account for differences in reporting level, peer group, data coverage and suppressed values
- Clearly document assumptions, exclusions and limitations

The project will not assume that differences in reported performance are caused solely by demand. Factors such as staffing, capacity, case complexity, local service models and data coverage may not be available in the selected datasets.

## Success Criteria

The project will be considered successful when:

- The complete workflow can be reproduced from the raw data
- The analytical model clearly separates national, state, peer-group and hospital-level records
- The analysis answers a focused set of emergency department questions
- Python and SQL are used meaningfully rather than artificially
- Data-quality issues and suppressed values are handled consistently
- Population-adjusted measures are calculated only when compatible denominator data is available
- The dashboard is understandable to a non-technical user
- Comparisons are made responsibly and supported by appropriate context
- Findings are supported by evidence
- Limitations and assumptions are clearly explained
- The repository is professional and easy to navigate
