
-- Create dimension tables

-- Create reporting_unit_dim table

CREATE TABLE reporting_unit_dim (
    reporting_unit_key INTEGER PRIMARY KEY,
    reporting_unit VARCHAR(255) NOT NULL,
    reporting_unit_type VARCHAR(50) NOT NULL,
    state VARCHAR(10) NOT NULL,

    UNIQUE (reporting_unit, reporting_unit_type)
);


-- Create finanical_year_dim table

CREATE TABLE financial_year_dim (
    financial_year_key INTEGER PRIMARY KEY,
    financial_year VARCHAR(10) NOT NULL UNIQUE,
    start_year INTEGER NOT NULL,
    end_year INTEGER NOT NULL,

    CHECK (end_year = start_year + 1)
);


-- Create triage_category_dim table

CREATE TABLE triage_category_dim (
    triage_category_key INTEGER PRIMARY KEY,
    triage_category VARCHAR(50) NOT NULL UNIQUE,
    triage_order INTEGER NOT NULL UNIQUE
);

-- Create patient_cohort_dim table

CREATE TABLE patient_cohort_dim (
    patient_cohort_key INTEGER PRIMARY KEY,
    patient_cohort VARCHAR(100) NOT NULL UNIQUE,
    cohort_type VARCHAR(50) NOT NULL,
    cohort_order INTEGER NOT NULL UNIQUE
);

-- Create peer_group_dim table

CREATE TABLE peer_group_dim (
    peer_group_key INTEGER PRIMARY KEY,
    peer_group VARCHAR(100) NOT NULL UNIQUE
);


-- Create fact tables

-- Create presentations_fact table

CREATE TABLE presentations_fact (
    reporting_unit_key INTEGER NOT NULL,
    financial_year_key INTEGER NOT NULL,
    triage_category_key INTEGER NOT NULL,
    number_of_presentations NUMERIC,
    small_count_flag BOOLEAN NOT NULL,

    PRIMARY KEY (
        reporting_unit_key,
        financial_year_key,
        triage_category_key
    ),

    FOREIGN KEY (reporting_unit_key)
        REFERENCES reporting_unit_dim(reporting_unit_key),

    FOREIGN KEY (financial_year_key)
        REFERENCES financial_year_dim(financial_year_key),

    FOREIGN KEY (triage_category_key)
        REFERENCES triage_category_dim(triage_category_key)
);

-- Create seen_on_time_fact

CREATE TABLE seen_on_time_fact (
    reporting_unit_key INTEGER NOT NULL,
    financial_year_key INTEGER NOT NULL,
    triage_category_key INTEGER NOT NULL,
    peer_group_key INTEGER,
    number_of_presentations NUMERIC,
    percentage_seen_on_time NUMERIC,
    peer_group_average NUMERIC,
    small_count_flag BOOLEAN NOT NULL,
    seen_on_time_caution_flag BOOLEAN NOT NULL,
    seen_on_time_status VARCHAR(50) NOT NULL,
    peer_group_status VARCHAR(30) NOT NULL,

    PRIMARY KEY (
        reporting_unit_key,
        financial_year_key,
        triage_category_key
    ),

    FOREIGN KEY (reporting_unit_key)
        REFERENCES reporting_unit_dim(reporting_unit_key),

    FOREIGN KEY (financial_year_key)
        REFERENCES financial_year_dim(financial_year_key),

    FOREIGN KEY (triage_category_key)
        REFERENCES triage_category_dim(triage_category_key),

    FOREIGN KEY (peer_group_key)
        REFERENCES peer_group_dim(peer_group_key)
);

-- Create within_4_hrs_fact

CREATE TABLE within_4_hrs_fact (
    reporting_unit_key INTEGER NOT NULL,
    financial_year_key INTEGER NOT NULL,
    patient_cohort_key INTEGER NOT NULL,
    peer_group_key INTEGER,
    number_of_presentations NUMERIC,
    percentage_within_4hrs NUMERIC,
    peer_group_average NUMERIC,
    small_count_flag BOOLEAN NOT NULL,
    within_4hrs_caution_flag BOOLEAN NOT NULL,
    within_4hrs_status VARCHAR(50) NOT NULL,
    peer_group_status VARCHAR(30) NOT NULL,

    PRIMARY KEY (
        reporting_unit_key,
        financial_year_key,
        patient_cohort_key
    ),

    FOREIGN KEY (reporting_unit_key)
        REFERENCES reporting_unit_dim(reporting_unit_key),

    FOREIGN KEY (financial_year_key)
        REFERENCES financial_year_dim(financial_year_key),

    FOREIGN KEY (patient_cohort_key)
        REFERENCES patient_cohort_dim(patient_cohort_key),

    FOREIGN KEY (peer_group_key)
        REFERENCES peer_group_dim(peer_group_key)
);


-- Create time_in_ed_fact
CREATE TABLE time_in_ed_fact (
    reporting_unit_key INTEGER NOT NULL,
    financial_year_key INTEGER NOT NULL,
    patient_cohort_key INTEGER NOT NULL,
    peer_group_key INTEGER,
    number_of_presentations NUMERIC,
    median_time_minutes NUMERIC,
    p90_time_minutes NUMERIC,
    peer_group_average_90_minutes NUMERIC,
    small_count_flag BOOLEAN NOT NULL,
    median_time_caution_flag BOOLEAN NOT NULL,
    p90_time_caution_flag BOOLEAN NOT NULL,
    median_time_status VARCHAR(50) NOT NULL,
    p90_time_status VARCHAR(50) NOT NULL,
    peer_group_status VARCHAR(30) NOT NULL,

    PRIMARY KEY (
        reporting_unit_key,
        financial_year_key,
        patient_cohort_key
    ),

    FOREIGN KEY (reporting_unit_key)
        REFERENCES reporting_unit_dim(reporting_unit_key),

    FOREIGN KEY (financial_year_key)
        REFERENCES financial_year_dim(financial_year_key),

    FOREIGN KEY (patient_cohort_key)
        REFERENCES patient_cohort_dim(patient_cohort_key),

    FOREIGN KEY (peer_group_key)
        REFERENCES peer_group_dim(peer_group_key)
);



