-- Treatment Analysis
-- Top 5 most common treatment types
SELECT treatment_type, COUNT(*) AS treatment_count
FROM treatments
GROUP BY treatment_type
ORDER BY treatment_count DESC
LIMIT 5;

-- Average cost per treatment type
SELECT treatment_type, ROUND(AVG(cost), 2) AS average_cost
FROM treatments
GROUP BY treatment_type
ORDER BY average_cost DESC;

-- The most expensive treatment
SELECT treatment_type, ROUND(SUM(cost)) AS total_cost
FROM treatments
GROUP BY treatment_type 
ORDER BY total_cost DESC
LIMIT 1;

-- Number of treatments were given per month
SELECT SUBSTR(treatment_date, 1, 7) AS month, COUNT(*) AS treatment_count
FROM treatments
GROUP BY "month" 
ORDER BY "month";

-- Number of treatments were given per doctor
SELECT 
	d. first_name || ' ' || last_name AS doctor_name,
	(
		SELECT COUNT(*)
		FROM appointments a 
		JOIN treatments t ON a.appointment_id = t.appointment_id 
		WHERE a.doctor_id = d.doctor_id
	) AS total_treatments
	FROM doctors d 
	ORDER BY total_treatments DESC;

SELECT 
    d.first_name || ' ' || d.last_name AS doctor_name,
    COUNT(t.treatment_id) AS total_treatments
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_id, doctor_name
ORDER BY total_treatments DESC;

-- Number of unique patients received treatments
SELECT COUNT(DISTINCT a.patient_id) AS patients_treated
FROM treatments t 
JOIN appointments a ON t.appointment_id = a.appointment_id;

-- Average number of treatments per appointment
SELECT ROUND(AVG(treatment_count), 2) AS avg_treatments_per_appointment
FROM (
    SELECT appointment_id, COUNT(*) AS treatment_count
    FROM treatments
    GROUP BY appointment_id
) sub;

-- Treatments with cost per usage
SELECT 
	treatment_type, 
	COUNT(*) AS frequency,
	ROUND(AVG(cost), 2) AS average_cost,
	ROUND(SUM(cost), 2) AS total_cost
FROM treatments
GROUP BY treatment_type 
ORDER BY total_cost DESC;

-- Average cost of treatments by specialization
SELECT 
    d.specialization,
    ROUND(AVG(t.cost), 2) AS avg_treatment_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.specialization
ORDER BY avg_treatment_cost DESC;