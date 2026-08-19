-- Note:
-- Data is loaded from locally generated CSV files in data/processed/.
-- Because PostgreSQL server-side COPY may have local file permission
-- limitations on macOS, the tables are loaded using the psql client-side
-- \copy command.

-- Run these commands from psql while connected to:
-- australian_ed_analytics

-- The file paths below are local paths and may need to be updated
-- on another machine.

-- Dimension tables

\copy reporting_unit_dim FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/reporting_unit_dim.csv' WITH (FORMAT csv, HEADER true);

\copy financial_year_dim FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/financial_year_dim.csv' WITH (FORMAT csv, HEADER true);

\copy triage_category_dim FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/triage_category_dim.csv' WITH (FORMAT csv, HEADER true);

\copy patient_cohort_dim FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/patient_cohort_dim.csv' WITH (FORMAT csv, HEADER true);

\copy peer_group_dim FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/peer_group_dim.csv' WITH (FORMAT csv, HEADER true);


-- Fact tables

\copy presentations_fact FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/presentations_fact.csv' WITH (FORMAT csv, HEADER true);

\copy seen_on_time_fact FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/seen_on_time_fact.csv' WITH (FORMAT csv, HEADER true);

\copy within_4_hrs_fact FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/within_4_hrs_fact.csv' WITH (FORMAT csv, HEADER true);

\copy time_in_ed_fact FROM '/Users/zhihuilu/australian-emergency-department-analytics/data/processed/time_in_ed_fact.csv' WITH (FORMAT csv, HEADER true);






-- Queries to inspect tables

SELECT COUNT(*) FROM reporting_unit_dim;


SELECT COUNT(*) FROM triage_category_dim;     
SELECT COUNT(*) FROM patient_cohort_dim;      
SELECT COUNT(*) FROM peer_group_dim;          

SELECT COUNT(*) FROM presentations_fact;      
SELECT COUNT(*) FROM seen_on_time_fact;       
SELECT COUNT(*) FROM within_4_hrs_fact;      
SELECT COUNT(*) FROM time_in_ed_fact;   