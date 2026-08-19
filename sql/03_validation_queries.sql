--  Check row counts

SELECT COUNT(*) AS reporting_unit_dim_rows
FROM reporting_unit_dim;

SELECT COUNT(*) AS financial_year_dim_rows
FROM financial_year_dim;

SELECT COUNT(*) AS triage_category_dim_rows
FROM triage_category_dim;

SELECT COUNT(*) AS patient_cohort_dim_rows
FROM patient_cohort_dim;

SELECT COUNT(*) AS peer_group_dim_rows
FROM peer_group_dim;

SELECT COUNT(*) AS presentations_fact_rows
FROM presentations_fact;

SELECT COUNT(*) AS seen_on_time_fact_rows
FROM seen_on_time_fact;

SELECT COUNT(*) AS within_4_hrs_fact_rows
FROM within_4_hrs_fact;

SELECT COUNT(*) AS time_in_ed_fact_rows
FROM time_in_ed_fact;


-- Check referential integrity

-- presentations_fact -> reporting_unit_dim

SELECT COUNT(*) AS orphan_reporting_units
FROM presentations_fact f
LEFT JOIN reporting_unit_dim d
    ON f.reporting_unit_key = d.reporting_unit_key
WHERE d.reporting_unit_key IS NULL;

-- presentations_fact -> financial_year_dim
SELECT COUNT(*) AS orphan_financial_years
FROM presentations_fact f
LEFT JOIN financial_year_dim d
    ON f.financial_year_key = d.financial_year_key
WHERE d.financial_year_key IS NULL;


-- presentations_fact -> triage_category_dim
SELECT COUNT(*) AS orphan_triage_categories
FROM presentations_fact f
LEFT JOIN triage_category_dim d
    ON f.triage_category_key = d.triage_category_key
WHERE d.triage_category_key IS NULL;


-- seen_on_time_fact -> reporting_unit_dim
SELECT COUNT(*) AS orphan_reporting_units
FROM seen_on_time_fact f
LEFT JOIN reporting_unit_dim d
    ON f.reporting_unit_key = d.reporting_unit_key
WHERE d.reporting_unit_key IS NULL;


-- seen_on_time_fact -> financial_year_dim
SELECT COUNT(*) AS orphan_financial_years
FROM seen_on_time_fact f
LEFT JOIN financial_year_dim d
    ON f.financial_year_key = d.financial_year_key
WHERE d.financial_year_key IS NULL;

-- seen_on_time_fact -> triage_category_dim
SELECT COUNT(*) AS orphan_triage_categories
FROM seen_on_time_fact f
LEFT JOIN triage_category_dim d
    ON f.triage_category_key = d.triage_category_key
WHERE d.triage_category_key IS NULL;

-- seen_on_time_fact -> peer_group_dim
SELECT COUNT(*) AS orphan_peer_groups
FROM seen_on_time_fact f
LEFT JOIN peer_group_dim d
    ON f.peer_group_key = d.peer_group_key
WHERE f.peer_group_key IS NOT NULL
  AND d.peer_group_key IS NULL;


-- within_4_hrs_fact -> reporting_unit_dim
SELECT COUNT(*) AS orphan_reporting_units
FROM within_4_hrs_fact f
LEFT JOIN reporting_unit_dim d
    ON f.reporting_unit_key = d.reporting_unit_key
WHERE d.reporting_unit_key IS NULL;


-- within_4_hrs_fact -> financial_year_dim
SELECT COUNT(*) AS orphan_financial_years
FROM within_4_hrs_fact f
LEFT JOIN financial_year_dim d
    ON f.financial_year_key = d.financial_year_key
WHERE d.financial_year_key IS NULL;

-- within_4_hrs_fact -> patient_cohort_dim
SELECT COUNT(*) AS orphan_patient_cohorts
FROM within_4_hrs_fact f
LEFT JOIN patient_cohort_dim d
    ON f.patient_cohort_key = d.patient_cohort_key
WHERE d.patient_cohort_key IS NULL;


-- within_4_hrs_fact -> peer_group_dim
SELECT COUNT(*) AS orphan_peer_groups
FROM within_4_hrs_fact f
LEFT JOIN peer_group_dim d
    ON f.peer_group_key = d.peer_group_key
WHERE f.peer_group_key IS NOT NULL
  AND d.peer_group_key IS NULL;


-- time_in_ed_fact -> reporting_unit_dim
SELECT COUNT(*) AS orphan_reporting_units
FROM time_in_ed_fact f
LEFT JOIN reporting_unit_dim d
    ON f.reporting_unit_key = d.reporting_unit_key
WHERE d.reporting_unit_key IS NULL;


-- time_in_ed_fact -> financial_year_dim
SELECT COUNT(*) AS orphan_financial_years
FROM time_in_ed_fact f
LEFT JOIN financial_year_dim d
    ON f.financial_year_key = d.financial_year_key
WHERE d.financial_year_key IS NULL;


-- time_in_ed_fact -> patient_cohort_dim
SELECT COUNT(*) AS orphan_patient_cohorts
FROM time_in_ed_fact f
LEFT JOIN patient_cohort_dim d
    ON f.patient_cohort_key = d.patient_cohort_key
WHERE d.patient_cohort_key IS NULL;


-- time_in_ed_fact -> peer_group_dim
SELECT COUNT(*) AS orphan_peer_groups
FROM time_in_ed_fact f
LEFT JOIN peer_group_dim d
    ON f.peer_group_key = d.peer_group_key
WHERE f.peer_group_key IS NOT NULL
  AND d.peer_group_key IS NULL;





-- Missing peer-group keys should only occur when not applicable

SELECT COUNT(*) AS invalid_missing_peer_keys
FROM seen_on_time_fact
WHERE peer_group_key IS NULL
  AND peer_group_status <> 'not_applicable';


SELECT COUNT(*) AS invalid_missing_peer_keys
FROM within_4_hrs_fact
WHERE peer_group_key IS NULL
  AND peer_group_status <> 'not_applicable';


SELECT COUNT(*) AS invalid_missing_peer_keys
FROM time_in_ed_fact
WHERE peer_group_key IS NULL
  AND peer_group_status <> 'not_applicable';



-- Percentage values should be between 0 and 1

SELECT COUNT(*) AS invalid_seen_on_time
FROM seen_on_time_fact
WHERE percentage_seen_on_time IS NOT NULL
  AND percentage_seen_on_time NOT BETWEEN 0 AND 1;


SELECT COUNT(*) AS invalid_within_4hrs
FROM within_4_hrs_fact
WHERE percentage_within_4hrs IS NOT NULL
  AND percentage_within_4hrs NOT BETWEEN 0 AND 1;



-- P90 time should not be less than median time

SELECT COUNT(*) AS invalid_time_order
FROM time_in_ed_fact
WHERE median_time_minutes IS NOT NULL
  AND p90_time_minutes IS NOT NULL
  AND p90_time_minutes < median_time_minutes;