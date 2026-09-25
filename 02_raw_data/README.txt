MEDCORE HEALTHCARE ANALYTICS DATASET
======================================

Synthetic dataset created for a professional relational healthcare Data Analyst project.

Dataset scale:
- Patients: 10,000
- Hospitals: 8
- Physicians: 250
- Diseases: 40
- Medications: 100
- Laboratory tests: 20
- Admissions: 25,000
- Diagnoses: 50,000
- Treatments: 50,000
- Laboratory results: 200,000

Relationships:
patients.insurance_id -> insurance.insurance_id
admissions.patient_id -> patients.patient_id
admissions.hospital_id -> hospitals.hospital_id
admissions.physician_id -> physicians.physician_id
diagnoses.admission_id -> admissions.admission_id
diagnoses.disease_id -> diseases.disease_id
treatments.admission_id -> admissions.admission_id
treatments.medication_id -> medications.medication_id
lab_results.admission_id -> admissions.admission_id
lab_results.test_id -> lab_tests.test_id

Date range:
Admissions are distributed from 2023-01-01 through 2025-12-15.

Important:
This is entirely synthetic data created for analytics practice.
It does not represent real patients or real medical records.
