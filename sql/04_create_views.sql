
-- Create view for ED demand trends

CREATE OR REPLACE VIEW vw_presentations_trend AS
SELECT
    f.reporting_unit_key,
    ru.reporting_unit,
    ru.reporting_unit_type,
    ru.state,

    f.financial_year_key,
    fy.financial_year,
    fy.start_year,
    fy.end_year,

    f.triage_category_key,
    tc.triage_category,
    tc.triage_order,

    f.number_of_presentations,
    f.small_count_flag

FROM presentations_fact f

JOIN reporting_unit_dim ru
    ON f.reporting_unit_key = ru.reporting_unit_key

JOIN financial_year_dim fy
    ON f.financial_year_key = fy.financial_year_key

JOIN triage_category_dim tc
    ON f.triage_category_key = tc.triage_category_key;



-- Create view for ED timeliness performance

CREATE OR REPLACE VIEW vw_seen_on_time_performance AS
SELECT
    f.reporting_unit_key,
    ru.reporting_unit,
    ru.reporting_unit_type,
    ru.state,

    f.financial_year_key,
    fy.financial_year,
    fy.start_year,
    fy.end_year,

    f.triage_category_key,
    tc.triage_category,
    tc.triage_order,

    f.peer_group_key,
    pg.peer_group,

    f.number_of_presentations,
    f.percentage_seen_on_time,
    f.peer_group_average,

    f.small_count_flag,
    f.seen_on_time_caution_flag,
    f.seen_on_time_status,
    f.peer_group_status

FROM seen_on_time_fact f

JOIN reporting_unit_dim ru
    ON f.reporting_unit_key = ru.reporting_unit_key

JOIN financial_year_dim fy
    ON f.financial_year_key = fy.financial_year_key

JOIN triage_category_dim tc
    ON f.triage_category_key = tc.triage_category_key

LEFT JOIN peer_group_dim pg
    ON f.peer_group_key = pg.peer_group_key;



-- Create view for ED departure-within-4-hours performance

CREATE OR REPLACE VIEW vw_within_4hrs_performance AS
SELECT
    f.reporting_unit_key,
    ru.reporting_unit,
    ru.reporting_unit_type,
    ru.state,

    f.financial_year_key,
    fy.financial_year,
    fy.start_year,
    fy.end_year,

    f.patient_cohort_key,
    pc.patient_cohort,
    pc.cohort_type,
    pc.cohort_order,

    f.peer_group_key,
    pg.peer_group,

    f.number_of_presentations,
    f.percentage_within_4hrs,
    f.peer_group_average,

    f.small_count_flag,
    f.within_4hrs_caution_flag,
    f.within_4hrs_status,
    f.peer_group_status

FROM within_4_hrs_fact f

JOIN reporting_unit_dim ru
    ON f.reporting_unit_key = ru.reporting_unit_key

JOIN financial_year_dim fy
    ON f.financial_year_key = fy.financial_year_key

JOIN patient_cohort_dim pc
    ON f.patient_cohort_key = pc.patient_cohort_key

LEFT JOIN peer_group_dim pg
    ON f.peer_group_key = pg.peer_group_key;



-- Create view for ED length-of-stay performance

CREATE OR REPLACE VIEW vw_time_in_ed_performance AS
SELECT
    f.reporting_unit_key,
    ru.reporting_unit,
    ru.reporting_unit_type,
    ru.state,

    f.financial_year_key,
    fy.financial_year,
    fy.start_year,
    fy.end_year,

    f.patient_cohort_key,
    pc.patient_cohort,
    pc.cohort_type,
    pc.cohort_order,

    f.peer_group_key,
    pg.peer_group,

    f.number_of_presentations,
    f.median_time_minutes,
    f.p90_time_minutes,
    f.peer_group_average_90_minutes,

    f.small_count_flag,
    f.median_time_caution_flag,
    f.p90_time_caution_flag,
    f.median_time_status,
    f.p90_time_status,
    f.peer_group_status

FROM time_in_ed_fact f

JOIN reporting_unit_dim ru
    ON f.reporting_unit_key = ru.reporting_unit_key

JOIN financial_year_dim fy
    ON f.financial_year_key = fy.financial_year_key

JOIN patient_cohort_dim pc
    ON f.patient_cohort_key = pc.patient_cohort_key

LEFT JOIN peer_group_dim pg
    ON f.peer_group_key = pg.peer_group_key;