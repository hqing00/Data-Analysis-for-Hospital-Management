-- Patient & Appointment Analysis
-- Appointments were Completed, Scheduled, and Cancelled
SELECT status, COUNT(status) AS appointment_status_count
FROM appointments
WHERE status != 'No-show'
GROUP BY status;

-- Average number of appointments per patient
SELECT CAST(AVG(appointment_count) AS INTEGER) AS avg_appointments_per_patient
FROM (
	SELECT patient_id, COUNT(*) AS appointment_count
	FROM appointments
	GROUP BY patient_id
) AS patient_appointments;

-- Top 5 patients with the most appointments
SELECT 
	p.first_name || ' ' || p.last_name AS patient_name,
	COUNT(a.appointment_id) AS total_appointments
FROM patients p 
JOIN appointments a ON p.patient_id = a.patient_id 
GROUP BY patient_name
ORDER BY total_appointments DESC
LIMIT 5;

-- Monthly trend of appointments
SELECT
	SUBSTR(appointment_date, 1, 7) AS year_month,
	COUNT(*) AS appointment_count
FROM appointments
GROUP BY year_month
ORDER BY year_month;

-- Patients registered in the latest month
SELECT registration_date, COUNT(*) AS patients_registered
FROM patients
WHERE SUBSTR(registration_date, 1, 7) = (
	SELECT SUBSTR(registration_date, 1, 7)
	FROM patients
	ORDER BY registration_date DESC
	LIMIT 1
);

-- Patients are male vs. female
SELECT gender, COUNT(*) AS total_patients
FROM patients
WHERE gender IS NOT NULL
GROUP BY gender;

-- Distribution of appointments by reason for visit
SELECT reason_for_visit, COUNT(*) AS total_appointments
FROM appointments
WHERE reason_for_visit IS NOT NULL
GROUP BY reason_for_visit 
ORDER BY total_appointments DESC;

-- Days between a patient’s registration and first appointment
SELECT
	p.patient_id,
	p.first_name || ' ' || last_name AS patient_name,
	p.registration_date,
	MIN(appointment_date) AS first_appointment_date,
	JULIANDAY(MIN(a.appointment_date)) - JULIANDAY(p.registration_date) AS days_between
FROM patients p 
JOIN appointments a ON p.patient_id = a.patient_id
WHERE p.registration_date IS NOT NULL AND a.appointment_date IS NOT NULL
GROUP BY p.patient_id;
-- negative is invalid, but it doesn't matter since this is synthetic data

-- Percentage of appointments ended in treatment
SELECT 
    ROUND(
        (SELECT COUNT(DISTINCT appointment_id) FROM treatments) * 100.0 / 
        (SELECT COUNT(*) FROM appointments), 
    2) AS percentage_with_treatment;

-- List patients who never completed any appointments
SELECT p.first_name || ' ' || last_name AS patient_name
FROM patients p 
WHERE p.patient_id NOT IN (
	SELECT DISTINCT patient_id 
	FROM appointments
	WHERE status = 'Completed'
);
