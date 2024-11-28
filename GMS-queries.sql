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
    FC.type = 'Yoga';

------------------------------

--3. Total revenue from memberships, personal training, and class bookings for a given month

SELECT 
    EXTRACT(MONTH FROM payment_date) AS month,
    SUM(CASE WHEN service_type = 'Membership' THEN amount ELSE 0 END) AS membership_revenue,
    SUM(CASE WHEN service_type  = 'Personal Training' THEN amount ELSE 0 END) AS training_revenue,
    SUM(CASE WHEN service_type = 'Class Booking' THEN amount ELSE 0 END) AS booking_revenue,
    SUM(amount) AS total_revenue
FROM 
    Billing
WHERE 
    EXTRACT(MONTH FROM payment_date) = :desired_month
    AND EXTRACT(YEAR FROM payment_date) = :desired_year
GROUP BY 
    EXTRACT(MONTH FROM payment_date);

--------------------------------------------
--4. List the top 5 trainers who have conducted the most personal training sessions.
SELECT 
    S.fname || ' ' || S.lname AS trainer_name, 
    COUNT(PTS.session_id) AS session_count
FROM 
    Personal_Training_session PTS
JOIN 
    Staff S ON PTS.staff_id = S.staff_id
GROUP BY 
    S.fname, S.lname
ORDER BY 
    session_count DESC
FETCH FIRST 5 ROWS ONLY;

-------------------------------------------------
--5. List all members whose membership has expired but who have attended the gym in the past 30 days.
SELECT 
    M.fname || ' ' || M.lname AS member_name, 
    A.check_in
FROM 
    Member M
JOIN 
    Membership MS ON M.membership_id = MS.membership_id
JOIN 
    Attendance A ON M.member_id = A.member_id
WHERE 
    MS.end_date < SYSDATE
    AND A.check_in >= SYSDATE - 30;

--6. Find the members who have the most active workout plans with at least three different exercises in their current routine. (2 marks)
SELECT 
    M.fname || ' ' || M.lname AS member_name, 
    COUNT(WP.workout_plan_id) AS active_workout_plans
FROM 
    Member M
JOIN 
    Workout_plan WP ON M.member_id = WP.member_id
WHERE 
    LENGTH(WP.exercise_details) - LENGTH(REPLACE(WP.exercise_details, ',', '')) + 1 >= 3
GROUP BY 
    M.fname, M.lname
ORDER BY 
    active_workout_plans DESC;

    --------------------------------------------
SELECT wp.member_id, COUNT(wp.plan_id) AS active_workout_plan_count
FROM workout_plan wp
WHERE wp.status ='active'
AND LENGTH(wp.exercise_details) - LENGTH(REPLACE(wp.exercise_details, ',', ' ')) + 1, >=3 
GROUP BY wp.member_id
ORDER BY active_workout_plan_count DESC

--7. Calculate the total usage of discount codes and how much revenue was lost due to discounts applied in the last year. (2 marks)
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

--8. Identify the progress of members in the last month at the gym, including the number of fitness classes they attended. 
--The result should display the member's name, the specific dates they attended, 
--and the total number of classes attended during that period. (3 marks)

SELECT 
    M.fname || ' ' || M.lname AS member_name, 
    A.check_in AS attendance_date, 
    COUNT(DISTINCT A.attendance_id) AS total_classes_attended
FROM 
    Member M
JOIN 
    Attendance A ON M.member_id = A.member_id
WHERE 
    A.check_in >= ADD_MONTHS(SYSDATE, -1)
GROUP BY 
    M.fname, M.lname, A.check_in
ORDER BY 
    member_name, attendance_date;