-- =====================================================================
-- MedCore Healthcare Analytics — Table Creation Script (MySQL 8.0)
-- Order: insurance -> hospitals -> physicians -> diseases -> medications
--        -> lab_tests -> patients -> admissions -> diagnoses -> treatments
--        -> lab_results
--
-- NOTE: Columns for `patients`, `hospitals`, `admissions`, `diagnoses`,
-- `diseases`, `lab_tests`, `lab_results` are confirmed from the SQL
-- analysis document (exact names used in JOINs/WHERE clauses).
-- Columns for `insurance`, `physicians`, `medications`, `treatments`
-- are BEST-EFFORT GUESSES based on the README description — verify
-- them against your real CSV headers before running the import.
-- =====================================================================
USE healthcare_data_analyst;
-- Drop in reverse dependency order (safe re-run during development)
DROP TABLE IF EXISTS lab_results;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS lab_tests;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS diseases;
DROP TABLE IF EXISTS physicians;
DROP TABLE IF EXISTS hospitals;
DROP TABLE IF EXISTS insurance;


-- ============================================================
-- MedCore Healthcare
-- Table: insurance
-- Database: MySQL
-- ============================================================

CREATE TABLE insurance (
    insurance_id VARCHAR(10) NOT NULL,
    insurance_provider VARCHAR(100) NOT NULL,
    insurance_type VARCHAR(20) NOT NULL,

    CONSTRAINT pk_insurance
        PRIMARY KEY (insurance_id),

    CONSTRAINT chk_insurance_type
        CHECK (insurance_type IN ('Private', 'Public'))
);

-- =====================================================================
-- 2. hospitals  (~8 rows) — hospital_id, hospital_name, city confirmed
-- =====================================================================
DROP TABLE IF EXISTS hospitals;

CREATE TABLE hospitals (
    hospital_id VARCHAR(10) NOT NULL,
    hospital_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    hospital_type VARCHAR(50) NOT NULL,
    bed_capacity INT,

    CONSTRAINT pk_hospitals
        PRIMARY KEY (hospital_id),

    CONSTRAINT chk_bed_capacity
        CHECK (bed_capacity > 0)

) ENGINE=InnoDB;

-- =====================================================================
-- 3. physicians  (~250 rows) — ASSUMED columns, verify against CSV
-- =====================================================================
DROP TABLE IF EXISTS physicians;

CREATE TABLE physicians (
    physician_id VARCHAR(10) NOT NULL,
    physician_name VARCHAR(150) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    hospital_id VARCHAR(10),
    years_experience INT,

    CONSTRAINT pk_physicians
        PRIMARY KEY (physician_id),

    CONSTRAINT fk_physicians_hospital
        FOREIGN KEY (hospital_id)
        REFERENCES hospitals(hospital_id),

    CONSTRAINT chk_years_experience
        CHECK (years_experience >= 0)
        
) ENGINE=InnoDB;

-- =====================================================================
-- 4. diseases  (~40 rows) — disease_id, disease_name, category confirmed
-- =====================================================================
DROP TABLE IF EXISTS diseases;

CREATE TABLE diseases (
    disease_id VARCHAR(10) NOT NULL,
    disease_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,

    CONSTRAINT pk_diseases
        PRIMARY KEY (disease_id)

) ENGINE=InnoDB;

-- =====================================================================
-- 5. medications  (~100 rows) — ASSUMED columns, verify against CSV
-- =====================================================================
CREATE TABLE medications (
    medication_id        VARCHAR(10) PRIMARY KEY,
    medication_name      VARCHAR(150),
    medication_category  VARCHAR(100)
) ENGINE=InnoDB;

-- =====================================================================
-- 6. lab_tests  (~20 rows) — test_id, test_name, unit confirmed
-- =====================================================================
CREATE TABLE lab_tests (
    test_id                VARCHAR(10) PRIMARY KEY,
    test_name              VARCHAR(150) NOT NULL,
    unit                   VARCHAR(50),
    reference_range_low    DECIMAL(10,2),
    reference_range_high   DECIMAL(10,2)
) ENGINE=InnoDB;

-- =====================================================================
-- 7. patients  (~10,000 rows) — confirmed from README example
-- =====================================================================
CREATE TABLE patients (
    patient_id       VARCHAR(10) PRIMARY KEY,
    date_of_birth    DATE NOT NULL,
    gender           VARCHAR(20),
    city             VARCHAR(100),
    insurance_id     VARCHAR(10),
    FOREIGN KEY (insurance_id) REFERENCES insurance(insurance_id)
) ENGINE=InnoDB;

-- =====================================================================
-- 8. admissions  (~25,000 rows) — columns confirmed from SQL queries
-- =====================================================================
CREATE TABLE admissions (
    admission_id     VARCHAR(10) PRIMARY KEY,
    patient_id       VARCHAR(10) NOT NULL,
    hospital_id      VARCHAR(10) NOT NULL,
    physician_id     VARCHAR(10),
    admit_date       DATE NOT NULL,
    discharge_date   DATE,
    admission_type   VARCHAR(50),   -- Emergency, Elective, Urgent
    outcome          VARCHAR(50),   -- Discharged, Transferred, Readmitted, Deceased
    FOREIGN KEY (patient_id)   REFERENCES patients(patient_id),
    FOREIGN KEY (hospital_id)  REFERENCES hospitals(hospital_id),
    FOREIGN KEY (physician_id) REFERENCES physicians(physician_id),
    INDEX idx_admissions_patient (patient_id),
    INDEX idx_admissions_hospital (hospital_id),
    INDEX idx_admissions_admit_date (admit_date)
) ENGINE=InnoDB;

-- =====================================================================
-- 9. diagnoses  (~50,000 rows) — admission_id, disease_id confirmed
-- =====================================================================
CREATE TABLE diagnoses (
    diagnosis_id     VARCHAR(10) PRIMARY KEY,
    admission_id     VARCHAR(10) NOT NULL,
    disease_id       VARCHAR(10) NOT NULL,
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id),
    FOREIGN KEY (disease_id)   REFERENCES diseases(disease_id),
    INDEX idx_diagnoses_admission (admission_id),
    INDEX idx_diagnoses_disease (disease_id)
) ENGINE=InnoDB;

-- =====================================================================
-- 10. treatments  (~50,000 rows) — ASSUMED columns, verify against CSV
-- =====================================================================
CREATE TABLE treatments (
    treatment_id     VARCHAR(10) PRIMARY KEY,
    admission_id     VARCHAR(10) NOT NULL,
    medication_id    VARCHAR(10) NOT NULL,
    treatment_date   DATE,
    dosage           VARCHAR(50),
    FOREIGN KEY (admission_id)  REFERENCES admissions(admission_id),
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id),
    INDEX idx_treatments_admission (admission_id),
    INDEX idx_treatments_medication (medication_id)
) ENGINE=InnoDB;

-- =====================================================================
-- 11. lab_results  (~200,000 rows) — result_status confirmed from queries
-- =====================================================================
CREATE TABLE lab_results (
    lab_result_id    VARCHAR(10) PRIMARY KEY,
    admission_id     VARCHAR(10) NOT NULL,
    test_id          VARCHAR(10) NOT NULL,
    result_value     DECIMAL(10,2),
    result_status    VARCHAR(20),   -- Normal, Low, High
    result_date      DATE,
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id),
    FOREIGN KEY (test_id)      REFERENCES lab_tests(test_id),
    INDEX idx_lab_results_admission (admission_id),
    INDEX idx_lab_results_test (test_id)
) ENGINE=InnoDB;

------
ALTER TABLE insurance CHANGE COLUMN provider_name insurance_provider VARCHAR(100);

ALTER TABLE hospitals ADD COLUMN bed_capacity INT;