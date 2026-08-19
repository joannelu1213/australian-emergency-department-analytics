
--- QUESTIONS TO ANSWER: -----

-- 1. How have emergency department presentations changed over time?---

-- National ED demand trends over time

SELECT
    financial_year,
    start_year,
    SUM(number_of_presentations) AS total_presentations
FROM vw_presentations_trend
WHERE reporting_unit_type = 'National'
  AND small_count_flag = FALSE
GROUP BY
    financial_year,
    start_year
ORDER BY
    start_year;


-- Year-on-year growth in national ED demands

WITH national_demand AS (
    SELECT
        financial_year,
        start_year,
        SUM(number_of_presentations) AS total_presentations
    FROM vw_presentations_trend
    WHERE reporting_unit_type = 'National'
      AND small_count_flag = FALSE
    GROUP BY
        financial_year,
        start_year
)

SELECT
    financial_year,
    total_presentations,
    LAG(total_presentations) OVER (
        ORDER BY start_year
    ) AS previous_year_presentations,

    ROUND(
        (
            total_presentations
            - LAG(total_presentations) OVER (ORDER BY start_year)
        )
        / LAG(total_presentations) OVER (ORDER BY start_year)
        * 100,
        2
    ) AS yoy_growth_pct

FROM national_demand
ORDER BY start_year;


-- National ED presentations by triage category

SELECT
    financial_year,
    start_year,
    triage_category,
    number_of_presentations
FROM vw_presentations_trend
WHERE reporting_unit_type = 'National'
  AND small_count_flag = FALSE
ORDER BY
    start_year,
    triage_order;



--- 2. How does ED demand vary across states and reporting units? ---

-- ED demand by state and financial year

SELECT
    financial_year,
    start_year,
    state,
    SUM(number_of_presentations) AS total_presentations
FROM vw_presentations_trend
WHERE reporting_unit_type = 'State'
  AND small_count_flag = FALSE
GROUP BY
    financial_year,
    start_year,
    state
ORDER BY
    start_year,
    state;


-- State ranking by ED presentations in the latest financial year

SELECT
    state,
    SUM(number_of_presentations) AS total_presentations
FROM vw_presentations_trend
WHERE reporting_unit_type = 'State'
  AND financial_year = '2024–25'
  AND small_count_flag = FALSE
GROUP BY state
ORDER BY total_presentations DESC;



-- Top hospitals by ED presentations in the latest financial year

SELECT
    reporting_unit,
    state,
    SUM(number_of_presentations) AS total_presentations
FROM vw_presentations_trend
WHERE reporting_unit_type = 'Hospital'
  AND financial_year = '2024–25'
  AND small_count_flag = FALSE
GROUP BY
    reporting_unit,
    state
ORDER BY
    total_presentations DESC
LIMIT 10;




-- 3. How have ED timeliness measures changed over time? --

-- National seen-on-time performance by triage category

SELECT
    financial_year,
    start_year,
    triage_category,
    percentage_seen_on_time
FROM vw_seen_on_time_performance
WHERE reporting_unit_type = 'National'
  AND seen_on_time_status = 'reported'
ORDER BY
    start_year,
    triage_order;


-- Seen-on-time performance by state in the latest financial year

SELECT
    state,
    triage_category,
    percentage_seen_on_time
FROM vw_seen_on_time_performance
WHERE reporting_unit_type = 'State'
  AND financial_year = '2024–25'
  AND seen_on_time_status = 'reported'
ORDER BY
    state,
    triage_order;


-- Hospital seen-on-time performance compared with peer-group average

SELECT
    reporting_unit,
    state,
    financial_year,
    triage_category,
    percentage_seen_on_time,
    peer_group_average,
    percentage_seen_on_time - peer_group_average
        AS difference_from_peer
FROM vw_seen_on_time_performance
WHERE reporting_unit_type = 'Hospital'
  AND financial_year = '2024–25'
  AND seen_on_time_status = 'reported'
  AND peer_group_status = 'peered'
ORDER BY difference_from_peer DESC;


-- 4. How has within-4-hours ED performance changed over time and across reporting groups?


-- National within-4-hours performance over time

SELECT
    financial_year,
    start_year,
    patient_cohort,
    percentage_within_4hrs
FROM vw_within_4hrs_performance
WHERE reporting_unit_type = 'National'
  AND within_4hrs_status = 'reported'
ORDER BY
    start_year,
    cohort_order;


-- Within-4-hrs performance by state in the latest financial year

SELECT
    state,
    patient_cohort,
    percentage_within_4hrs
FROM vw_within_4hrs_performance
WHERE reporting_unit_type = 'State'
  AND financial_year = '2024–25'
  AND within_4hrs_status = 'reported'
ORDER BY
    state,
    cohort_order;


-- Hospital within-4-hours performance compared with peer-group average in the latest financial year

SELECT
    reporting_unit,
    state,
    patient_cohort,
    percentage_within_4hrs,
    peer_group_average,
    percentage_within_4hrs - peer_group_average
        AS difference_from_peer
FROM vw_within_4hrs_performance
WHERE reporting_unit_type = 'Hospital'
  AND financial_year = '2024–25'
  AND within_4hrs_status = 'reported'
  AND peer_group_status = 'peered'
ORDER BY difference_from_peer DESC;



-- 5. How have median and 90th-percentile time-in-ED measures changed over time, and how do they vary across states, patient cohorts, and peer groups?


-- National time-in-ED performance over time

SELECT
    financial_year,
    start_year,
    patient_cohort,
    median_time_minutes,
    p90_time_minutes
FROM vw_time_in_ed_performance
WHERE reporting_unit_type = 'National'
  AND median_time_status = 'reported'
  AND p90_time_status = 'reported'
ORDER BY
    start_year,
    cohort_order;


-- Time-in-ED performance by state in the latest financial year

SELECT
    state,
    patient_cohort,
    median_time_minutes,
    p90_time_minutes
FROM vw_time_in_ed_performance
WHERE reporting_unit_type = 'State'
  AND financial_year = '2024–25'
  AND median_time_status = 'reported'
  AND p90_time_status = 'reported'
ORDER BY
    state,
    cohort_order;



-- Hospital P90 time compared with peer-group average

SELECT
    reporting_unit,
    state,
    patient_cohort,
    p90_time_minutes,
    peer_group_average_90_minutes,
    p90_time_minutes - peer_group_average_90_minutes
        AS difference_from_peer_minutes
FROM vw_time_in_ed_performance
WHERE reporting_unit_type = 'Hospital'
  AND financial_year = '2024–25'
  AND p90_time_status = 'reported'
  AND peer_group_status = 'peered'
ORDER BY difference_from_peer_minutes;



-- Is increasing ED demand associated with changes in service performance?

-- Compare national ED demand with within-4-hours performance

WITH national_demand AS (
    SELECT
        financial_year,
        start_year,
        SUM(number_of_presentations) AS total_presentations
    FROM vw_presentations_trend
    WHERE reporting_unit_type = 'National'
      AND small_count_flag = FALSE
    GROUP BY financial_year, start_year
),

national_performance AS (
    SELECT
        financial_year,
        start_year,
        percentage_within_4hrs
    FROM vw_within_4hrs_performance
    WHERE reporting_unit_type = 'National'
      AND patient_cohort = 'All patients'
      AND within_4hrs_status = 'reported'
)

SELECT
    d.financial_year,
    d.start_year,
    d.total_presentations,
    p.percentage_within_4hrs
FROM national_demand d
JOIN national_performance p
    ON d.financial_year = p.financial_year
ORDER BY d.start_year;



-- Compare national ED demand with median and P90 time in ED

WITH national_demand AS (
    SELECT
        financial_year,
        start_year,
        SUM(number_of_presentations) AS total_presentations
    FROM vw_presentations_trend
    WHERE reporting_unit_type = 'National'
      AND small_count_flag = FALSE
    GROUP BY financial_year, start_year
),

national_time AS (
    SELECT
        financial_year,
        start_year,
        median_time_minutes,
        p90_time_minutes
    FROM vw_time_in_ed_performance
    WHERE reporting_unit_type = 'National'
      AND patient_cohort = 'All patients'
      AND median_time_status = 'reported'
      AND p90_time_status = 'reported'
)

SELECT
    d.financial_year,
    d.start_year,
    d.total_presentations,
    t.median_time_minutes,
    t.p90_time_minutes
FROM national_demand d
JOIN national_time t
    ON d.financial_year = t.financial_year
ORDER BY d.start_year;


-- Correlation between national ED demand and time-in-ED measures

WITH national_demand AS (
    SELECT
        financial_year,
        start_year,
        SUM(number_of_presentations) AS total_presentations
    FROM vw_presentations_trend
    WHERE reporting_unit_type = 'National'
      AND small_count_flag = FALSE
    GROUP BY financial_year, start_year
),

national_time AS (
    SELECT
        financial_year,
        start_year,
        median_time_minutes,
        p90_time_minutes
    FROM vw_time_in_ed_performance
    WHERE reporting_unit_type = 'National'
      AND patient_cohort = 'All patients'
      AND median_time_status = 'reported'
      AND p90_time_status = 'reported'
)

SELECT
    CORR(d.total_presentations, t.median_time_minutes)
        AS correlation_with_median_time,
    CORR(d.total_presentations, t.p90_time_minutes)
        AS correlation_with_p90_time
FROM national_demand d
JOIN national_time t
    ON d.financial_year = t.financial_year;



-- Correlation between national ED demand and time-in-ED measures

WITH national_demand AS (
    SELECT
        financial_year,
        start_year,
        SUM(number_of_presentations) AS total_presentations
    FROM vw_presentations_trend
    WHERE reporting_unit_type = 'National'
      AND small_count_flag = FALSE
    GROUP BY financial_year, start_year
),

national_time AS (
    SELECT
        financial_year,
        start_year,
        median_time_minutes,
        p90_time_minutes
    FROM vw_time_in_ed_performance
    WHERE reporting_unit_type = 'National'
      AND patient_cohort = 'All patients'
      AND median_time_status = 'reported'
      AND p90_time_status = 'reported'
)

SELECT
    CORR(d.total_presentations, t.median_time_minutes)
        AS correlation_with_median_time,
    CORR(d.total_presentations, t.p90_time_minutes)
        AS correlation_with_p90_time
FROM national_demand d
JOIN national_time t
    ON d.financial_year = t.financial_year;



