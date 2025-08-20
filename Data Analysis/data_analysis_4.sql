-- Doctor Performance & Hospital Insights
-- The doctor has the most appointments
WITH doctor_appointments AS (
	SELECT
		d.first_name || ' ' || d.last_name AS doctor_name,
		COUNT(a.appointment_id) AS total_appointment
	FROM doctors d 
	JOIN appointments a ON d.doctor_id = a.doctor_id
	GROUP BY doctor_name
)
SELECT * 
FROM doctor_appointments
ORDER BY total_appointment DESC
LIMIT 1;

-- Average number of appointments per doctor per month?
WITH monthly_counts AS (
	SELECT 
		doctor_id,
		STRFTIME('%Y-%m', appointment_date) AS year_month,
		COUNT(*) AS monthly_appointments
	FROM appointments
	GROUP BY doctor_id, year_month 
)
SELECT
	d.doctor_id,
	d.first_name || ' ' || d.last_name AS doctor_name,
	ROUND(AVG(mc.monthly_appointments), 0) AS avg_appointments_per_month
FROM monthly_counts mc
JOIN doctors d ON mc.doctor_id = d.doctor_id 
GROUP BY d.doctor_id;

-- Distribution of doctors by specialization
SELECT 
	specialization,
	COUNT(*) AS number_of_doctors
FROM doctors
GROUP BY specialization 
ORDER BY number_of_doctors DESC;

-- Average years of experience by specialization
SELECT
	specialization,
	AVG(years_experience) AS avg_years_of_experience
FROM doctors
GROUP BY specialization
ORDER BY avg_years_of_experience DESC;

-- Number of doctors work in each hospital branch
SELECT
	hospital_branch,
	COUNT(*) AS number_of_doctors
FROM doctors
GROUP BY hospital_branch
ORDER BY number_of_doctors DESC;

-- Average cost of treatments given by each doctor
SELECT
	d.doctor_id,
	d.first_name || ' ' || d.last_name AS doctor_name,
	ROUND(AVG(t.cost), 2) AS avg_cost_treatment
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_id, doctor_name
ORDER BY avg_cost_treatment;

-- Doctors are most preferred by repeat patients
WITH repeat_patients AS ( -- Identifies patients with more than one appointment.
	SELECT patient_id
	FROM appointments
	GROUP BY patient_id 
	HAVING COUNT(*) > 1
),
doctor_repeat_visits AS ( -- Filters appointments to include only those by repeat patients, keeping doctor–patient pairs
	SELECT
		a.doctor_id,
		a.patient_id
	FROM appointments a 
	JOIN repeat_patients rp ON a.patient_id = rp.patient_id 
	GROUP BY a.doctor_id, a.patient_id
),
doctor_summary AS ( -- Counts how many unique repeat patients each doctor has
	SELECT
		d.doctor_id,
		d.first_name || ' ' || d.last_name AS doctor_name,
		COUNT(DISTINCT drv.patient_id) AS repeat_patients
	FROM doctor_repeat_visits drv
	JOIN doctors d ON drv.doctor_id = d.doctor_id 
	GROUP BY d.doctor_id, doctor_name
)
SELECT *
FROM doctor_summary 
ORDER BY repeat_patients DESC;

