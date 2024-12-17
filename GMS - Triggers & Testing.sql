--1. Create a trigger to automatically set the membership status to "Inactive" when a member's membership has expired (i.e., the current date exceeds the membership's end date).
 
CREATE OR REPLACE TRIGGER trg_set_membership_inactive
BEFORE INSERT OR UPDATE OF plan_start_date, Membership_id ON Member
FOR EACH ROW
DECLARE
    v_duration NUMBER; -- To hold the duration of the membership in months
    v_end_date DATE;   -- To calculate the expiration date
BEGIN
    -- Get the membership duration from the Membership_plan table
    SELECT TO_NUMBER(duration_IN_MONTHS)
    INTO v_duration
    FROM Membership_plan
    WHERE membership_id = :NEW.Membership_id;
 
    -- Calculate the expiration date
    v_end_date := ADD_MONTHS(:NEW.plan_start_date, v_duration);
 
    -- Set the plan_status to 'Inactive' if the membership has expired
    IF v_end_date < SYSDATE THEN
        :NEW.plan_status := 'Inactive';
    ELSE
        :NEW.plan_status := 'Active';
    END IF;
END;
/
 
 
---TESTING THE TRIGGER
 
--WHEN INSERING A ROW
INSERT INTO Member (Member_id, Membership_id, Fname, lname, date_of_birth, gender, address, phone_number, email, emergency_contact, plan_start_date, plan_status)
VALUES ('TEST1', 'MS001', 'Rachel', 'Green', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'Female', '123 Claremont Road', '555-1234', 'rachel.green@example.com', '555-5678', TO_DATE('2024-09-07', 'YYYY-MM-DD'), 'Active');
 
--WHEN UPDATING PLAN_START_DATE
UPDATE Member
SET plan_start_date = TO_DATE('2023-12-05', 'YYYY-MM-DD')
WHERE Member_id = 'TEST1';
 
----WHEN UPDATING MEMBERSHIP_ID
UPDATE Member
SET membership_id = 'MS003'
WHERE Member_id = 'TEST1';
 
SELECT * FROM Member WHERE Member_id = 'TEST1';
 
delete from member where member_id='TEST1';
 
--2. Create a trigger to automatically decrease the available spots for a fitness class when a member books a class and ensure the class capacity is not exceeded.
 
CREATE OR REPLACE TRIGGER trg_decrease_class_capacity
BEFORE INSERT ON Booking_System
FOR EACH ROW
DECLARE
    available_spots NUMBER;
BEGIN
    SELECT max_capacity - (
        SELECT COUNT(*)
        FROM Booking_System
        WHERE class_id = :NEW.class_id)
    INTO available_spots
    FROM Fitness_class
    WHERE class_id = :NEW.class_id;
 
    -- Optional: Debugging message
    DBMS_OUTPUT.PUT_LINE('Available spots for this class: ' || (available_spots - 1) );
 
    -- Check if there are no available spots
    IF available_spots <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No available spots for the class.');
    END IF;
END;
/
 
--testing trigger
INSERT INTO Fitness_class (class_id, staff_id, class_name, class_type, class_time, duration, max_capacity, class_status)
VALUES ('TEST1', 'ST014', 'Yoga', 'Fitness', SYSTIMESTAMP, '1 Hour', 2, 'Active');
 
INSERT INTO Booking_System (booking_id, member_id, class_id, session_id, activity_name, booking_date, booking_status)
VALUES ('TEST1', 'M0001', 'TEST1', NULL, 'Yoga', SYSDATE, 'Confirmed');
 
INSERT INTO Booking_System (booking_id, member_id, class_id, session_id, activity_name, booking_date, booking_status)
VALUES ('TEST2', 'M0002', 'TEST1', NULL, 'Yoga', SYSDATE, 'Confirmed');
 
-- This should fail
INSERT INTO Booking_System (booking_id, member_id, class_id, session_id, activity_name, booking_date, booking_status)
VALUES ('TEST3', 'M0003', 'TEST1', NULL, 'Yoga', SYSDATE, 'Confirmed');
 
 
DELETE FROM Booking_System where booking_id='TEST1';
DELETE FROM Booking_System where booking_id='TEST2';
DELETE FROM Booking_System where booking_id='TEST3';
DELETE FROM Fitness_class where class_id='TEST1';
 
--3. Create a trigger to automatically notify members when their membership is about to expire (e.g., 7 days before the end date).
 
CREATE OR REPLACE TRIGGER trg_notify_membership_expiration
AFTER INSERT OR UPDATE ON Member
FOR EACH ROW
DECLARE
    v_expiration_date DATE;
    v_duration NUMBER;  -- To store the membership duration
BEGIN
    -- Check if the membership status is 'Active'
    IF :NEW.plan_status = 'Active' THEN
        -- Get the membership duration based on the membership_id from Membership_plan table
        SELECT TO_NUMBER(duration_in_months) -- Assuming duration is in months
        INTO v_duration
        FROM Membership_plan
        WHERE membership_id = :NEW.Membership_id;
 
        -- Calculate the expiration date based on the plan_start_date and membership duration
        v_expiration_date := ADD_MONTHS(:NEW.plan_start_date, v_duration);
 
        -- Check if the membership will expire within the next 7 days
        IF v_expiration_date - SYSDATE <= 7 THEN
            -- Notify the member (e.g., print message for now)
            DBMS_OUTPUT.PUT_LINE('Notification: Your membership will expire on ' || TO_CHAR(v_expiration_date, 'DD-MON-YYYY') || '. Please renew your membership.');
        END IF;
    END IF;
END;
/
 
 
INSERT INTO Member (Member_id, Membership_id, Fname, lname, date_of_birth, gender, address, phone_number, email, emergency_contact, plan_start_date, plan_status)
VALUES ('TEST1', 'MS001', 'Monica', 'Geller', TO_DATE('1995-05-20', 'YYYY-MM-DD'), 'Female', '456 Elm St', '555-6789', 'monica.geller@example.com', '555-1234', TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'Active');
 
delete from member where member_id='TEST1';
has context menu