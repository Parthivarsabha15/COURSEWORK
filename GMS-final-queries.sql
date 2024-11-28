--1. List of all fitness classes with their schedules and instructor names

SELECT 
    FC.class_id,
    FC.name AS class_name, 
    FC.schedule, 
    S.fname || ' ' || S.lname AS instructor_name
FROM 
    Fitness_class FC
JOIN 
    Staff S 
    ON FC.staff_id = S.staff_id;

--2. Members who booked a yoga class, including booking status
SELECT 
    M.member_ID,
    M.fname || ' ' || M.lname AS member_name, 
    fc.name, fc.type,
    B.booking_status
FROM 
    Booking_system B
JOIN 
    Fitness_class FC 
    ON B.class_id = FC.class_id
JOIN 
    Member M 
    ON B.member_id = M.member_id
WHERE 
    FC.name = 'Yoga';

--3. Total revenue from memberships, personal training, and class bookings for a given month

SELECT
    EXTRACT(MONTH FROM payment_date) AS month,
    SUM(CASE WHEN service_type = 'Membership Fee' THEN amount ELSE 0 END) AS membership_revenue,
    SUM(CASE WHEN service_type  = 'Personal Training' THEN amount ELSE 0 END) AS training_revenue,
    SUM(CASE WHEN service_type = 'Fitness Class Booking' THEN amount ELSE 0 END) AS booking_revenue,
    SUM(amount) AS total_revenue
FROM 
    Billing
where 
    payment_status='Paid' 
GROUP BY 
    extract(month from payment_date);




    ------------------------
--6. Find the members who have the most active workout plans with at least three different exercises in their current routine. (2 marks)
SELECT 
    M.fname || ' ' || M.lname AS member_name,
    COUNT(WP.workout_plan_id) AS active_workout_plans
FROM 
    Member M
JOIN 
    Workout_plan WP ON M.member_id = WP.member_id
WHERE 
    LENGTH(WP.exercise_details) - LENGTH(REPLACE(WP.exercise_details, ',', '')) + 1 >= 3 and plan_status='Active'
GROUP BY 
    M.fname, M.lname
ORDER BY 
    active_workout_plans DESC;

    -------------------------------------
    --7. 
SELECT 
    DC.description, 
    COUNT(DC.Discount_Code_ID) AS total_usage, 
    SUM(B.amount * (DC.discount_percentage / 100)) AS revenue_lost
FROM 
    Billing B
JOIN 
    Discount_Code DC ON B.billing_id = DC.Discount_Code_ID
WHERE 
    DC.expiry_date >= ADD_MONTHS(SYSDATE, -12)
GROUP BY 
    DC.description;


SELECT 
    dc.description, 
    SUM(dc.usage_count) AS usage_count, 
    dc.discount_percentage, 
    SUM(100 * (1 - dc.discount_percentage)) AS rev_lost
FROM 
    discount_code dc
JOIN 
    billing b
ON 
    dc.discount_code_id = b.discount_code_id
WHERE
    dc.expiry_date >= ADD_MONTHS(SYSDATE, -12)
GROUP BY 
    dc.description, 
    dc.discount_percentage;
    