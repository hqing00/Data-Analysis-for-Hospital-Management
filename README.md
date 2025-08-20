# Data Analysis for Hospital Management
This repository contains a project focused on analyzing hospital management data using SQLite. The aim is to explore and analyze data from a hospital management system to extract meaningful insights for improving healthcare operations and decision-making.

## Data
This dataset is obtained from [Hospital Data Management](https://www.kaggle.com/datasets/kanakbaghel/hospital-management-dataset?select=treatments.csv)

**Data Dictionary**   
*patients.csv*
|Column|Description|
|--|--|
|patient_id|Unique ID for each patient|
|first_name|Patient's first name|
|last_name|Patient's last name|
|gender|Gender (M/F)|
|date_of_birth|Date of birth|
|contact_number|Phone number|
|address|Address of the patient|
|registration_date|Date of first registration at the hospital|
|insurance_provider|Insurance company name|
|insurance_number|Policy number|
|email|Email address|

*doctors.csv*
|Column|Description|
|--|--|
|doctor_id|Unique ID for each doctor|
|first_name|Doctor's first name|
|last_name|Doctor's last name|
|specialization|Medical field of expertise|
|phone_number|Contact number|
|years_experience|Total years of experience|
|hospital_branch|Branch of hospital where doctor is based|
|email|Official email address|

*appointments.csv*
|Column|Description|
|--|--|
appointment_id|Unique appointment ID
patient_id|ID of the patient
doctor_id|ID of the attending doctor
appointment_date|Date of the appointment
appointment_time|Time of the appointment
reason_for_visit|Purpose of visit (e.g., checkup)
status|Status (Scheduled, Completed, Cancelled)

*treatments.csv*
|Column|Description|
|--|--|
treatment_id|Unique ID for each treatment
appointment_id|Associated appointment ID
treatment_type|Type of treatment (e.g., MRI, X-ray)
description|Notes or procedure details
cost|Cost of treatment
treatment_date|Date when treatment was given

*billing.csv*
|Column|Description|
|--|--|
bill_id|Unique billing ID
patient_id|ID of the billed patient
treatment_id|ID of the related treatment
bill_date|Date of billing
amount|Total amount billed
payment_method|Mode of payment (Cash, Card, Insurance)
payment_status|Status of payment (Paid, Pending, Failed)
