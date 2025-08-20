-- Billing & Payment Analysis
-- Total billed amount 
SELECT SUM(amount)
FROM billing;

-- Average bill per treatment
SELECT t.treatment_type, ROUND(AVG(b.amount), 2) AS avg_bill_amount
FROM treatments t
JOIN billing b ON t.treatment_id = b.treatment_id 
GROUP BY t.treatment_type;

-- Number of bills by Payment Status
SELECT payment_status, COUNT(*) AS bills_number
FROM billing
GROUP BY payment_status
ORDER BY bills_number DESC;

-- Monthly revenue trend
SELECT
	SUBSTR(bill_date, 1, 7) AS "month",
	SUM(amount) AS total_revenue
FROM billing
GROUP BY "month"
ORDER BY "month";

-- Percentage of payments were made by payment method
SELECT 
	payment_method, 
	COUNT(*) * 100 / (SELECT COUNT(*) FROM billing) AS percentage
FROM billing
GROUP BY payment_method 
ORDER BY percentage DESC;

-- Number of patients have multiple unpaid bills
SELECT COUNT(*) AS num_of_patients
FROM (
    SELECT b.patient_id
    FROM billing b
    JOIN patients p ON b.patient_id = p.patient_id
    WHERE b.payment_status = 'Pending'
    GROUP BY b.patient_id
    HAVING COUNT(*) > 1
) AS unpaid;

SELECT COUNT(*) AS num_of_patients
FROM patients p
WHERE EXISTS (
    SELECT 1
    FROM billing b
    WHERE b.patient_id = p.patient_id
      AND b.payment_status = 'Pending'
    GROUP BY b.patient_id
    HAVING COUNT(*) > 1
);

-- Average amount per payment method
SELECT
	payment_method,
	ROUND(AVG(amount), 2) AS avg_amount
FROM billing
GROUP BY payment_method 
ORDER BY avg_amount;

-- Treatments generate the highest total revenue
SELECT
	t.treatment_type,
    ROUND(SUM(b.amount)) AS total_revenue
FROM billing b
JOIN treatments t ON b.treatment_id = t.treatment_id 
GROUP BY t.treatment_type 
ORDER BY total_revenue DESC
LIMIT 1;

-- Doctor's appointment generated the most billed revenue
WITH doctor_revenue AS (
    SELECT 
        d.doctor_id,
        d.first_name || ' ' || d.last_name AS doctor_name,
        SUM(b.amount) AS total_revenue
    FROM billing b
    JOIN appointments a ON b.patient_id = a.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    GROUP BY d.doctor_id
)
SELECT *
FROM doctor_revenue
ORDER BY total_revenue DESC
LIMIT 1;

-- The billing coverage rate (total billed vs total paid)
SELECT
	ROUND(
	SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) * 1
	/ SUM(amount) * 100, 2) AS coverage_rate_percent
FROM billing;

-- Total billed amount by payment status
SELECT 
	payment_status, 
	ROUND(SUM(amount), 2) AS total_billed_amount
FROM billing
GROUP BY payment_status 
ORDER BY total_billed_amount DESC;