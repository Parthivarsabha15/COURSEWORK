--1. List of all fitness classes with their schedules and instructor names

SELECT 
    FC.class_id,
    FC.class_name, FC.class_type, 
    FC.class_time, 
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
    fc.class_name, fc.class_type,
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
    FC.class_type = 'Yoga';

--3. Total revenue from memberships, personal training, and class bookings for a given month

SELECT
    TO_CHAR(payment_date,'Month') AS month_name,
    SUM(CASE WHEN service_description = 'Membership Fee' THEN amount_paid ELSE 0 END) AS membership_revenue,
    SUM(CASE WHEN service_description  = 'Training session' THEN amount_paid ELSE 0 END) AS session_revenue,
    SUM(CASE WHEN service_description  = 'Class' THEN amount_paid ELSE 0 END) AS class_revenue,
    SUM(amount_paid) AS total_revenue
FROM 
    Billing
GROUP BY 
    TO_CHAR(payment_date,'Month')
ORDER BY
    MIN(payment_date);

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

--5. List all members whose membership has expired but who have attended the gym in the past 30 days.
SELECT 
    M.fname || ' ' || M.lname AS member_name, 
    m.member_id, 
    A.check_in as last_attended,
    m.plan_status
FROM 
    Member M
JOIN 
    Attendance A 
    ON M.member_id = A.member_id
WHERE 
    A.check_in >= ADD_MONTHS(SYSDATE, -1) and a.check_in < SYSDATE
    AND m.plan_status='Inactive';

--6. Find the members who have the most active workout plans with at least three different exercises in their current routine. (2 marks)
SELECT 
    M.fname || ' ' || M.lname AS member_name,
    COUNT(WP.workout_plan_id) AS active_workout_plans
FROM 
    Member M
JOIN 
    Workout_plan WP 
    ON M.member_id = WP.member_id
WHERE 
    LENGTH(WP.exercise_details) - LENGTH(REPLACE(WP.exercise_details, ',', '')) + 1 >= 3 and wp.plan_status='Active'
GROUP BY 
    M.fname, M.lname
ORDER BY 
    active_workout_plans DESC;

--7. Calculate the total usage of discount codes and how much revenue was lost due to discounts applied in the last year. (2 marks)
SELECT 
    DC.discount_code_id, 
    DC.discount_name,
    DC.USAGE_COUNT,
    SUM(B.total_amount - B.amount_paid) AS revenue_lost
FROM 
    Billing B
JOIN 
    Discount_Code DC 
    ON B.Discount_Code_ID = DC.Discount_Code_ID
WHERE 
    B.payment_date >= ADD_MONTHS(SYSDATE, -12)  -- Filter for the last year
    AND B.Discount_Code_ID IS NOT NULL           -- Only consider records where a discount was applied
GROUP BY 
    DC.discount_code_id, 
    DC.discount_name,DC.USAGE_COUNT;

--8. Identify the progress of members in the last month at the gym, including the number of fitness classes they attended. 
--The result should display the member's name, the specific dates they attended, 
--and the total number of classes attended during that period. (3 marks)

SELECT 
    M.Fname || ' ' || M.Lname AS Member_Name,
    TO_CHAR(A.check_in, 'YYYY-MM-DD') AS Attendance_Date,
    COUNT(*) OVER (PARTITION BY M.Member_id) AS Total_Classes_Attended
FROM 
    Attendance A
JOIN 
    Member M
    ON A.member_id = M.Member_id
WHERE 
    A.check_in >= ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), -1) -- Start of the previous month
    AND A.check_in < TRUNC(SYSDATE, 'MONTH')             -- Start of the current month
ORDER BY
    Total_Classes_Attended DESC;



    