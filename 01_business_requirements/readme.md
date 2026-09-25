# MedCore Healthcare Analytics Project

## Healthcare Data Analysis | PostgreSQL | SQL | Data Quality | Business Intelligence

---

## 1. Project Overview

**MedCore Healthcare** is a fictional healthcare organization operating a network of hospitals.

The objective of this project is to build an end-to-end healthcare analytics solution that transforms raw relational healthcare data into actionable business insights.

The project simulates the work of a **Data Analyst working in a healthcare environment**, from database design and data quality assessment to SQL analysis, KPI development, and executive reporting.

The analysis focuses on:

* Patient demographics
* Hospital admissions
* Emergency and elective care
* Diagnoses and chronic conditions
* Treatments and medications
* Laboratory results
* Length of stay
* Readmissions
* Patient outcomes
* Mortality
* Hospital performance
* Healthcare utilization

All data used in this project is **synthetic** and does not represent real patients or real medical records.

---

# 2. Business Context

MedCore Healthcare's management team wants to better understand how healthcare services are being used across its hospital network.

Management needs reliable answers to questions such as:

* How many patients are being treated?
* Which hospitals have the highest admission volumes?
* What are the main diseases treated across the network?
* How does patient age relate to hospital utilization?
* What is the average length of stay?
* Which hospitals have the highest readmission rates?
* What proportion of admissions are emergencies?
* Which diagnoses are associated with longer hospital stays?
* What are the most frequently used medications?
* How frequently are abnormal laboratory results observed?
* How do patient outcomes vary across hospitals?
* Where are there potential operational areas requiring further investigation?

The purpose of the analysis is **not to make clinical diagnoses or medical recommendations**.

The purpose is to provide management with reliable descriptive and operational insights that can support healthcare planning and performance monitoring.

---

# 3. Project Objectives

The project has five main objectives.

### Objective 1 — Build a relational healthcare database

Create a normalized PostgreSQL database containing interconnected healthcare entities.

### Objective 2 — Ensure data quality

Identify and investigate:

* Missing values
* Duplicate records
* Invalid dates
* Invalid relationships
* Orphan records
* Inconsistent categorical values
* Impossible admission durations
* Abnormal laboratory results

### Objective 3 — Analyze healthcare operations

Use SQL to analyze:

* Patient volume
* Admissions
* Hospital utilization
* Length of stay
* Diagnoses
* Treatments
* Laboratory activity
* Patient outcomes

### Objective 4 — Develop healthcare KPIs

Create a standardized KPI layer that can be used by management.

### Objective 5 — Communicate insights professionally

Build a dashboard and present findings in a format suitable for healthcare management and business stakeholders.

---

# 4. Dataset

The project uses a synthetic relational healthcare dataset containing approximately **335,000 records across 11 CSV files**.

| Table         | Approx. Records | Description                           |
| ------------- | --------------: | ------------------------------------- |
| `patients`    |          10,000 | Patient demographic information       |
| `insurance`   |               8 | Insurance providers and types         |
| `hospitals`   |               8 | Hospital information                  |
| `physicians`  |             250 | Physician information and specialties |
| `diseases`    |              40 | Disease reference data                |
| `medications` |             100 | Medication reference data             |
| `lab_tests`   |              20 | Laboratory test definitions           |
| `admissions`  |          25,000 | Hospital admissions                   |
| `diagnoses`   |          50,000 | Diagnoses associated with admissions  |
| `treatments`  |          50,000 | Treatments and medications            |
| `lab_results` |         200,000 | Laboratory measurements               |

### Data period

The admission data covers approximately:

**January 2023 – December 2025**

### Data source

The dataset is synthetic and was generated specifically for this portfolio project.

No real patient information is used.

---

# 5. Data Model

The database follows a relational structure.

The main relationships include:

```text
INSURANCE
    │
    └── PATIENTS
            │
            └── ADMISSIONS
                    │
          ┌─────────┼──────────┐
          │         │          │
          ▼         ▼          ▼
     DIAGNOSES  TREATMENTS  LAB_RESULTS
          │         │          │
          ▼         ▼          ▼
      DISEASES MEDICATIONS  LAB_TESTS


ADMISSIONS
    │
    ├── HOSPITALS
    │
    └── PHYSICIANS
```

### Primary entities

* Patients
* Admissions
* Hospitals
* Physicians
* Diseases
* Diagnoses
* Medications
* Treatments
* Laboratory Tests
* Laboratory Results
* Insurance

---

# 6. Technical Stack

### Database

* PostgreSQL

### Data Analysis

* SQL
* PostgreSQL SQL functions and aggregations
* Common Table Expressions
* Window Functions
* Date and time analysis
* Conditional aggregation

### Data Visualization

One of:

* Power BI
* Tableau

### Data Preparation

* CSV
* SQL
* Python, where appropriate

### Documentation

* Markdown
* GitHub

---

# 7. Project Workflow

The project follows an end-to-end Data Analyst workflow.

```text
Business Requirements
        ↓
Data Modeling
        ↓
Database Design
        ↓
CSV Import
        ↓
Data Quality Assessment
        ↓
Exploratory SQL Analysis
        ↓
KPI Development
        ↓
Business Analysis
        ↓
Dashboard Development
        ↓
Insights & Recommendations
        ↓
Portfolio Documentation
```

---

# 8. Phase 1 — Business Requirements

Before analyzing the data, define the business questions.

## Key business questions

### Patient Population

1. How many unique patients are treated by MedCore?
2. What is the patient distribution by age group?
3. What is the gender distribution?
4. Which cities contribute the largest patient populations?

### Hospital Operations

5. Which hospitals have the highest admission volume?
6. What is the average length of stay by hospital?
7. How does emergency admission volume vary by hospital?
8. How does hospital utilization change over time?

### Diagnoses

9. What are the most common diagnoses?
10. Which disease categories generate the most admissions?
11. Which diagnoses are associated with longer hospital stays?
12. How does disease prevalence vary by age group?

### Readmissions

13. What percentage of patients are readmitted?
14. What percentage of patients are readmitted within 30 days?
15. Which diagnosis categories are associated with higher readmission levels?

### Patient Outcomes

16. What proportion of admissions result in discharge, transfer, readmission, or death?
17. How do outcomes vary across hospitals?
18. How do outcomes vary by admission type?

### Laboratory Analysis

19. Which laboratory tests are performed most frequently?
20. What percentage of laboratory results are outside the reference range?
21. Which tests have the highest proportion of abnormal results?

---

# 9. Phase 2 — Database Design

Create the PostgreSQL database and define all tables.

The database should contain:

* Primary keys
* Foreign keys
* NOT NULL constraints where appropriate
* Appropriate data types
* Referential integrity
* Indexes for frequently queried columns

Example:

```sql
CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20),
    city VARCHAR(100),
    insurance_id VARCHAR(10),

    FOREIGN KEY (insurance_id)
        REFERENCES insurance(insurance_id)
);
```

The database design should be documented using an **Entity Relationship Diagram (ERD)**.

---

# 10. Phase 3 — Data Import

Import the CSV files into PostgreSQL.

The recommended import sequence is:

```text
1. insurance
2. hospitals
3. physicians
4. diseases
5. medications
6. lab_tests
7. patients
8. admissions
9. diagnoses
10. treatments
11. lab_results
```

This order helps ensure that referenced records exist before dependent tables are populated.

---

# 11. Phase 4 — Data Quality Assessment

Before performing business analysis, validate the dataset.

## Checks to perform

### Duplicate records

Identify duplicate primary keys.

```sql
SELECT
    patient_id,
    COUNT(*)
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;
```

### Missing values

```sql
SELECT
    COUNT(*) AS missing_patient_ids
FROM patients
WHERE patient_id IS NULL;
```

### Foreign key integrity

Check whether every admission references an existing patient.

```sql
SELECT COUNT(*)
FROM admissions a
LEFT JOIN patients p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;
```

### Invalid dates

```sql
SELECT *
FROM admissions
WHERE discharge_date < admit_date;
```

### Length of stay

Calculate:

```sql
discharge_date - admit_date
```

and investigate negative or unrealistic values.

### Categorical consistency

Check values such as:

* Gender
* Admission type
* Outcome
* Hospital type
* Disease category

The objective is to ensure that the dataset is reliable before analysis begins.

---

# 12. Phase 5 — Exploratory Data Analysis

Perform exploratory analysis using SQL.

Examples include:

* Patient counts
* Admission trends
* Disease frequency
* Hospital performance
* Physician activity
* Medication utilization
* Laboratory activity

Example:

```sql
SELECT
    admission_type,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY admission_type
ORDER BY admission_count DESC;
```

---

# 13. Phase 6 — Healthcare KPI Development

Develop a standardized KPI layer.

## Patient Volume

```text
Unique Patients =
COUNT(DISTINCT patient_id)
```

## Admission Volume

```text
Total Admissions =
COUNT(admission_id)
```

## Average Length of Stay

```text
Average LOS =
AVG(discharge_date - admit_date)
```

## Emergency Admission Rate

```text
Emergency Admission Rate =
Emergency Admissions / Total Admissions
```

## Mortality Rate

```text
Mortality Rate =
Deceased Admissions / Total Admissions
```

## Readmission Rate

```text
Readmission Rate =
Readmitted Admissions / Total Admissions
```

## 30-Day Readmission Rate

A patient is considered readmitted when a subsequent admission occurs within 30 days after discharge.

This KPI should be calculated using patient-level chronological admission history.

---

# 14. Phase 7 — Advanced SQL Analysis

The project should demonstrate intermediate and advanced SQL skills.

### SQL techniques to demonstrate

* `JOIN`
* `LEFT JOIN`
* `GROUP BY`
* `HAVING`
* `CASE`
* `COALESCE`
* `CTE`
* `WINDOW FUNCTIONS`
* `ROW_NUMBER()`
* `LAG()`
* `LEAD()`
* `RANK()`
* `DENSE_RANK()`
* Date functions
* Conditional aggregation
* Subqueries

Example:

```sql
WITH patient_admissions AS (
    SELECT
        patient_id,
        admission_id,
        admit_date,
        discharge_date,
        LAG(admit_date) OVER (
            PARTITION BY patient_id
            ORDER BY admit_date
        ) AS previous_admission_date
    FROM admissions
)

SELECT
    patient_id,
    admission_id,
    admit_date,
    previous_admission_date,
    admit_date - previous_admission_date AS days_since_previous_admission
FROM patient_admissions;
```

This analysis can be used to investigate readmission patterns.

---

# 15. Phase 8 — Dashboard

Create an executive healthcare dashboard.

## Dashboard Page 1 — Executive Overview

Include:

* Total Patients
* Total Admissions
* Average Length of Stay
* Emergency Admission Rate
* Readmission Rate
* Mortality Rate

Charts:

* Admissions over time
* Admissions by hospital
* Admissions by admission type
* Patient outcomes

---

## Dashboard Page 2 — Patient & Disease Analysis

Include:

* Patient demographics
* Age groups
* Gender
* Top diagnoses
* Disease categories
* Disease trends

---

## Dashboard Page 3 — Hospital Performance

Include:

* Admissions by hospital
* Average length of stay
* Emergency admission rate
* Patient outcomes
* Readmission rate

---

## Dashboard Page 4 — Laboratory Analysis

Include:

* Number of laboratory tests
* Normal vs abnormal results
* Abnormal results by test
* Laboratory trends

---

# 16. Phase 9 — Business Insights

The final analysis should not simply present charts.

Each major finding should answer:

### What happened?

Describe the observed pattern.

### Where did it happen?

Identify the hospital, patient group, disease category, or time period involved.

### How large is the difference?

Quantify the finding.

### What could explain the pattern?

Discuss plausible explanations carefully.

### What should be investigated next?

Suggest an evidence-based next step.

Avoid presenting correlation as causation.

For example:

> Emergency admissions increased during the observed period, with the largest increase occurring among older patients. Respiratory diagnoses represented a substantial proportion of these admissions. This pattern identifies an area for further investigation, but the analysis does not establish that respiratory disease caused the increase.

This style demonstrates analytical maturity.

---

# 17. Recommended Portfolio Evidence

A strong portfolio project should show evidence of the work, not just the final dashboard.

Include the following screenshots or artifacts in the GitHub repository.

## Evidence 1 — Project Architecture

Screenshot of the project folder structure.

Show:

```text
data/
sql/
documentation/
dashboard/
README.md
```

---

## Evidence 2 — ERD

Include a screenshot of the complete Entity Relationship Diagram.

The screenshot should clearly show:

* Tables
* Primary keys
* Foreign keys
* Relationships
* Cardinality

Suggested filename:

```text
docs/erd.png
```

---

## Evidence 3 — PostgreSQL Database

Include a screenshot showing the database and tables inside PostgreSQL / pgAdmin.

Suggested filename:

```text
docs/postgresql_database.png
```

---

## Evidence 4 — Data Quality Checks

Include screenshots of SQL queries demonstrating:

* Duplicate checks
* Missing-value checks
* Foreign-key validation
* Invalid date checks

Suggested filename:

```text
docs/data_quality_checks.png
```

---

## Evidence 5 — SQL Analysis

Include screenshots of important SQL queries and results.

Do not screenshot every query.

Select approximately **5–8 strong examples** demonstrating:

* Complex JOINs
* CTEs
* Window functions
* Date analysis
* Aggregations
* Readmission analysis

---

## Evidence 6 — KPI Layer

Show the SQL logic used to calculate your main KPIs.

For example:

```text
Total Patients
Total Admissions
Average Length of Stay
Emergency Admission Rate
Readmission Rate
Mortality Rate
```

---

## Evidence 7 — Dashboard

Include high-quality screenshots of the final dashboard.

Recommended:

```text
docs/dashboard_overview.png
docs/dashboard_patient_analysis.png
docs/dashboard_hospital_analysis.png
docs/dashboard_laboratory_analysis.png
```

---

## Evidence 8 — Key Findings

Create a short document containing approximately **5–10 key findings**.

Each finding should include:

```text
Finding
Evidence
Business Context
Potential Explanation
Recommended Investigation
```

---

# 18. GitHub Repository Structure

Recommended final repository:

```text
medcore-healthcare-analytics/
│
├── README.md
│
├── data/
│   ├── patients.csv
│   ├── insurance.csv
│   ├── hospitals.csv
│   ├── physicians.csv
│   ├── diseases.csv
│   ├── medications.csv
│   ├── lab_tests.csv
│   ├── admissions.csv
│   ├── diagnoses.csv
│   ├── treatments.csv
│   └── lab_results.csv
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_constraints.sql
│   ├── 04_indexes.sql
│   ├── 05_data_quality.sql
│   ├── 06_patient_analysis.sql
│   ├── 07_hospital_analysis.sql
│   ├── 08_diagnosis_analysis.sql
│   ├── 09_readmission_analysis.sql
│   ├── 10_laboratory_analysis.sql
│   └── 11_kpi_queries.sql
│
├── documentation/
│   ├── business_requirements.md
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   └── key_findings.md
│
├── erd/
│   └── medcore_erd.png
│
├── dashboard/
│   ├── dashboard_screenshot.png
│   └── dashboard_documentation.md
│
└── screenshots/
    ├── database.png
    ├── data_quality.png
    ├── sql_analysis.png
    └── dashboard.png
```

---

# 19. Portfolio Presentation

When presenting this project to a recruiter or hiring manager, focus on the business problem rather than simply listing technologies.

A strong project description could be:

> **Healthcare Analytics — MedCore Healthcare**
>
> Designed and analyzed a relational healthcare database containing over 335,000 synthetic healthcare records across 11 interconnected tables. Built the database in PostgreSQL, implemented primary and foreign key relationships, performed data-quality validation, developed healthcare KPIs, analyzed admissions, diagnoses, readmissions and patient outcomes, and created an executive dashboard to communicate operational insights.

### Technologies

```text
PostgreSQL
SQL
Power BI / Tableau
Excel
Python
Git / GitHub
```

---

# 20. Skills Demonstrated

This project demonstrates the following Data Analyst skills:

### Data Management

* Relational database design
* Data modeling
* Primary and foreign keys
* Referential integrity
* Data normalization
* Data validation

### SQL

* Complex joins
* Aggregations
* CTEs
* Window functions
* Date analysis
* Conditional logic
* KPI calculations

### Data Quality

* Missing-value analysis
* Duplicate detection
* Referential-integrity checks
* Data consistency checks
* Anomaly detection

### Business Analysis

* KPI definition
* Healthcare operations analysis
* Trend analysis
* Segmentation
* Readmission analysis
* Hospital performance analysis

### Data Visualization

* Dashboard design
* KPI cards
* Trend analysis
* Interactive filtering
* Executive reporting

### Communication

* Business requirements
* Analytical storytelling
* Insight generation
* Stakeholder communication
* Documentation

---

# 21. Important Analytical Considerations

Because the dataset is synthetic, findings should not be presented as real-world healthcare statistics.

The project is intended to demonstrate:

* Analytical methodology
* SQL proficiency
* Database design
* Data quality practices
* Business thinking
* Visualization skills
* Communication skills

Healthcare-related conclusions should remain descriptive unless supported by an appropriate causal research design.

---

# 22. Final Deliverables

The completed project should contain:

* [ ] Business requirements
* [ ] Relational database design
* [ ] ERD
* [ ] PostgreSQL database
* [ ] 11 CSV datasets
* [ ] SQL table creation scripts
* [ ] Foreign-key constraints
* [ ] Database indexes
* [ ] Data-quality analysis
* [ ] Exploratory analysis
* [ ] Healthcare KPI calculations
* [ ] Advanced SQL queries
* [ ] Readmission analysis
* [ ] Hospital performance analysis
* [ ] Laboratory analysis
* [ ] Executive dashboard
* [ ] Key findings
* [ ] Business interpretation
* [ ] Portfolio screenshots
* [ ] GitHub documentation

---

# 23. Project Success Criteria

The project will be considered complete when a reviewer can:

1. Understand the business problem from the README.
2. Understand the database structure from the ERD.
3. Recreate the PostgreSQL database.
4. Import the provided CSV files.
5. Verify the relationships between tables.
6. Review the data-quality checks.
7. Understand the SQL analysis.
8. Understand how the KPIs were calculated.
9. Review the dashboard.
10. Understand the main business findings.

The final result should demonstrate not only the ability to write SQL, but the ability to take a business problem, structure data, analyze it, and communicate useful information to stakeholders.

---

# 24. Project Status

**Status:** In Progress

### Completed

* Synthetic healthcare dataset generated
* 11 relational CSV files created
* 335,000+ records generated
* Primary/foreign-key relationships designed
* Referential integrity validated

### Next Steps

* [ ] Create PostgreSQL database
* [ ] Create all tables
* [ ] Import CSV files
* [ ] Add constraints and indexes
* [ ] Perform data-quality assessment
* [ ] Develop SQL analysis
* [ ] Build KPI layer
* [ ] Perform readmission analysis
* [ ] Build dashboard
* [ ] Document key findings
* [ ] Prepare final portfolio presentation
