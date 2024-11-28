Here are the SQL queries addressing each of the requirements. Adjust the date ranges as needed for your database. These queries assume the table structure provided in your files:

1. List of all fitness classes with their schedules and instructor names
sql
Copy code
SELECT 
    FC.name AS class_name, 
    FC.schedule, 
    CONCAT(S.fname, ' ', S.lname) AS instructor_name
FROM 
    Fitness_class FC
JOIN 
    Staff S ON FC.staff_id = S.staff_id;
2. Members who booked a yoga class, including booking status
sql
Copy code
SELECT 
    M.fname || ' ' || M.lname AS member_name, 
    B.booking_status
FROM 
    Booking_system B
JOIN 
    Fitness_class FC ON B.class_id = FC.class_id
JOIN 
    Member M ON B.member_id = M.member_id
WHERE 
    LOWER(FC.type) = 'yoga';
3. Total revenue from memberships, personal training, and class bookings for a given month
sql
Copy code
SELECT 
    EXTRACT(MONTH FROM payment_date) AS month,
    SUM(CASE WHEN payment_method = 'Membership' THEN amount ELSE 0 END) AS membership_revenue,
    SUM(CASE WHEN payment_method = 'Personal Training' THEN amount ELSE 0 END) AS training_revenue,
    SUM(CASE WHEN payment_method = 'Class Booking' THEN amount ELSE 0 END) AS booking_revenue,
    SUM(amount) AS total_revenue
FROM 
    Billing
WHERE 
    EXTRACT(MONTH FROM payment_date) = :desired_month
    AND EXTRACT(YEAR FROM payment_date) = :desired_year
GROUP BY 
    EXTRACT(MONTH FROM payment_date);
4. Top 5 trainers with the most personal training sessions
sql
Copy code
SELECT 
    CONCAT(S.fname, ' ', S.lname) AS trainer_name, 
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
5. Members with expired memberships who attended in the past 30 days
sql
Copy code
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
6. Members with most active workout plans and at least three exercises
sql
Copy code
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
7. Total usage and revenue loss from discount codes in the last year
sql
Copy code
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
8. Member progress in the last month, including class attendance
sql
Copy code
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