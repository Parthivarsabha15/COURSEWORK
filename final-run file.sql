DROP TABLE MEMBER cascade constraints;
DROP TABLE MEMBERSHIP_PLAN cascade constraints;
DROP TABLE STAFF cascade constraints;
DROP TABLE FITNESS_CLASS cascade constraints;
DROP TABLE PERSONAL_TRAINING_SESSION cascade constraints;
DROP TABLE BOOKING_SYSTEM cascade constraints;
DROP TABLE BILLING cascade constraints;
DROP TABLE ATTENDANCE cascade constraints;
DROP TABLE DISCOUNT_CODE cascade constraints;
DROP TABLE WORKOUT_PLAN cascade constraints;


CREATE TABLE Member(
    Member_id         VARCHAR2(10) NOT NULL,
    Membership_id    VARCHAR2(10)  NOT NULL,
    Fname             VARCHAR2(25) NOT NULL,
    lname             VARCHAR2(25) NOT NULL,
    date_of_birth     DATE NOT NULL,
    gender            VARCHAR2(10) NOT NULL,
    address           VARCHAR2(30),
    phone_number      VARCHAR2(15) NOT NULL,
    email             VARCHAR2(50)  NOT NULL,
    emergency_contact VARCHAR2(15),
    plan_start_date   DATE NOT NULL,
    plan_status       VARCHAR2(10) NOT NULL,
    PRIMARY KEY(MEMBER_ID),
    CONSTRAINT chk_gender CHECK (UPPER(gender) IN ('MALE', 'FEMALE', 'OTHER'))
);

CREATE TABLE Staff(
    staff_id       VARCHAR2(10)  NOT NULL,
    Fname           VARCHAR2(25)  NOT NULL,
    Lname           VARCHAR2(25)  NOT NULL,
    phone_number   VARCHAR2(15)  NOT NULL,
    email          VARCHAR2(50) NOT NULL,
    position       VARCHAR2(20) NOT NULL,
    salary         NUMBER(8,2) NOT NULL,
    specialization VARCHAR2(50),
    PRIMARY KEY(STAFF_ID),
    CONSTRAINT chk_staff_position CHECK (upper(position) IN ('ADMIN','SUPPORT STAFF', 'FITNESS INSTRUCTOR', 'PERSONAL TRAINER', 'NUTRITIONIST'))
);

CREATE TABLE Booking_System(
    booking_id       VARCHAR2(10) NOT NULL,
    member_id        VARCHAR2(10) NOT NULL,
    class_id       VARCHAR2(10) NULL,
    session_id       VARCHAR2(10) NULL,
    activity_name     VARCHAR2(20) NOT NULL,
    booking_date      DATE NOT NULL,
    booking_status   VARCHAR2(20) NOT NULL,
    CHECK ( (class_id IS NULL AND session_id IS NOT NULL) OR (class_id IS NOT NULL AND session_id IS NULL) ),
    CONSTRAINT chk_booking_status CHECK (UPPER(booking_status) IN ('CONFIRMED', 'CANCELLED') ),
    PRIMARY KEY(booking_id)
);

CREATE TABLE Fitness_class(
    class_id       VARCHAR2(10) NOT NULL,
    staff_id       VARCHAR2(10) NOT NULL,
    class_name      VARCHAR2(20) NOT NULL,
    class_type      VARCHAR2(20) NOT NULL,
    class_time      TIMESTAMP NOT NULL,
    duration        VARCHAR2(30) NOT NULL,
    max_capacity    number(3,0) NOT NULL,
    class_status    VARCHAR2(20) NOT NULL,
    PRIMARY KEY(Class_id)
);

CREATE TABLE Personal_Training_session (
    session_id       VARCHAR2(10) NOT NULL,
    session_date     DATE NOT NULL,
    start_time       TIMESTAMP NOT NULL,
    duration        VARCHAR2(30) NOT NULL,
    staff_id         VARCHAR2(10) NOT NULL,
    member_id        VARCHAR2(10) NOT NULL,
    session_status    VARCHAR2(15)  NOT NULL,
    PRIMARY KEY(SESSION_ID)
);

CREATE TABLE Workout_plan(
    workout_plan_id           VARCHAR2(10) NOT NULL,
    member_id                 VARCHAR2(10)  NOT NULL,
    trainer_id                VARCHAR2(10)  NOT NULL,
    focus_area                VARCHAR2(30)  NOT NULL,
    goal                      VARCHAR2(30)  NOT NULL,
    exercise_details          VARCHAR2(250),
    plan_status               VARCHAR2(10)  NOT NULL,
    progress_notes            VARCHAR2(250),
    primary key(workout_plan_id)
);


CREATE TABLE Membership_plan(
    membership_id              VARCHAR2(10)  NOT NULL,
    plan_name                  VARCHAR2(20) NOT NULL,
    duration_IN_MONTHS        NUMBER(2)  NOT NULL,
    amount                    NUMBER(10,2) NOT NULL,
    PRIMARY KEY(MEMBERSHIP_ID),
    CONSTRAINT uq_plan_name UNIQUE (plan_name)
 );

CREATE TABLE Discount_Code(
    Discount_Code_ID            VARCHAR2(10) NOT NULL,
    Discount_Name                 VARCHAR2(30),
    Discount_Percentage         NUMBER(5,2) NOT NULL,
    Expiry_Date                 DATE NOT NULL,
    Usage_Count                 NUMBER(5),
    primary key (Discount_Code_ID),
    CONSTRAINT uq_Discount_Name UNIQUE (Discount_Name)
);

CREATE TABLE Billing(
    billing_id       VARCHAR2(10) NOT NULL,
    member_id        VARCHAR2(10) NOT NULL,
    Discount_Code_ID       VARCHAR2(10) NULL,
    service_description     VARCHAR2(30) NOT NULL,
    total_amount         NUMBER(10,2) NOT NULL,
    amount_paid      NUMBER(10,2) NOT NULL,
    payment_date     DATE NOT NULL,
    payment_method   VARCHAR2(20) NOT NULL,
    PRIMARY KEY(billing_ID),
    CONSTRAINT chk_service_description CHECK (UPPER(service_description) IN ('MEMBERSHIP FEE', 'TRAINING SESSION','CLASS' ))
);

CREATE TABLE Attendance(
    attendance_id        VARCHAR2(10) NOT NULL,
    member_id            VARCHAR2(10) NOT NULL,
    check_in             TIMESTAMP WITH LOCAL TIME ZONE NOT NULL,
    check_out            TIMESTAMP WITH LOCAL TIME ZONE,
    PRIMARY KEY(attendance_id)
);

--Member
INSERT INTO Member VALUES('M0001', 'MS001', 'John', 'Doe', TO_DATE('1990-05-14', 'YYYY-MM-DD'), 'Male', '101 Main St', '1234567890', 'john.doe@example.com', '987654321', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0002', 'MS001', 'Jane', 'Smith', TO_DATE('1985-03-22', 'YYYY-MM-DD'), 'Female', '202 Elm St', '2345678901', 'jane.smith@example.com', '1234567890', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0003', 'MS001', 'Mike', 'Johnson', TO_DATE('1992-07-30', 'YYYY-MM-DD'), 'Male', '303 Oak St', '3456789012', 'mike.johnson@example.com', '2345678901', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0004', 'MS001', 'Emily', 'Brown', TO_DATE('1995-11-11', 'YYYY-MM-DD'), 'Female', '404 Pine St', '4567890123', 'emily.brown@example.com', '3456789012', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0005', 'MS002', 'Chris', 'Davis', TO_DATE('1988-08-20', 'YYYY-MM-DD'), 'Male', '505 Cedar St', '5678901234', 'chris.davis@example.com', '4567890123', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0006', 'MS001', 'Sara', 'Miller', TO_DATE('1993-09-25', 'YYYY-MM-DD'), 'Female', '606 Birch St', '6789012345', 'sara.miller@example.com', '5678901234', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0007', 'MS001', 'Paul', 'Wilson', TO_DATE('1991-06-10', 'YYYY-MM-DD'), 'Male', '707 Maple St', '7890123456', 'paul.wilson@example.com', '6789012345', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0008', 'MS002', 'Laura', 'Taylor', TO_DATE('1990-02-18', 'YYYY-MM-DD'), 'Female', '808 Walnut St', '8901234567', 'laura.taylor@example.com', '7890123456', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0009', 'MS002', 'Steve', 'Anderson', TO_DATE('1987-12-03', 'YYYY-MM-DD'), 'Male', '909 Chestnut St', '9012345678', 'steve.anderson@example.com', '8901234567', TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0010', 'MS001', 'Amy', 'Thomas', TO_DATE('1994-04-12', 'YYYY-MM-DD'), 'Female', '100 Ash St', '123456789', 'amy.thomas@example.com', '9012345678', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0011', 'MS003', 'Nathan', 'Moore', TO_DATE('1996-10-22', 'YYYY-MM-DD'), 'Male', '111 Redwood St', '1122334455', 'nathan.moore@example.com', '1234567890', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0012', 'MS002', 'Olivia', 'Martin', TO_DATE('1989-01-19', 'YYYY-MM-DD'), 'Female', '121 Spruce St', '2233445566', 'olivia.martin@example.com', '2345678901', TO_DATE('2024-01-30', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0013', 'MS003', 'Tom', 'Jackson', TO_DATE('1986-11-09', 'YYYY-MM-DD'), 'Male', '131 Cypress St', '3344556677', 'tom.jackson@example.com', '3456789012', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0014', 'MS001', 'Sophia', 'White', TO_DATE('1997-08-28', 'YYYY-MM-DD'), 'Female', '141 Palm St', '4455667788', 'sophia.white@example.com', '4567890123', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0015', 'MS002', 'Ryan', 'Harris', TO_DATE('1990-05-02', 'YYYY-MM-DD'), 'Male', '151 Willow St', '5566778899', 'ryan.harris@example.com', '5678901234', TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0016', 'MS003', 'Ella', 'Clark', TO_DATE('1992-09-15', 'YYYY-MM-DD'), 'Female', '161 Poplar St', '6677889900', 'ella.clark@example.com', '6789012345', TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0017', 'MS001', 'Jack', 'Lewis', TO_DATE('1985-07-07', 'YYYY-MM-DD'), 'Male', '171 Fir St', '7788990011', 'jack.lewis@example.com', '7890123456', TO_DATE('2024-03-25', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0018', 'MS002', 'Emma', 'King', TO_DATE('1988-06-14', 'YYYY-MM-DD'), 'Female', '181 Aspen St', '8899001122', 'emma.king@example.com', '8901234567', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0019', 'MS003', 'David', 'Scott', TO_DATE('1993-03-03', 'YYYY-MM-DD'), 'Male', '191 Sequoia St', '9900112233', 'david.scott@example.com', '9012345678', TO_DATE('2024-02-28', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES('M0020', 'MS002', 'Chloe', 'Hall', TO_DATE('1998-12-25', 'YYYY-MM-DD'), 'Female', '201 Pine St', '1122334455', 'chloe.hall@example.com', '1122334455', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0021', 'MS001', 'Jasmi', 'Alasapuri', TO_DATE('1998-12-21', 'YYYY-MM-DD'), 'Female', '201 Pine St', '1122334466', 'jasmi.as@example.com', '1122334455', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0022', 'MS001', 'Fatema', 'Doctor', TO_DATE('1998-12-22', 'YYYY-MM-DD'), 'Female', '201 Pine St', '1122334477', 'fatema.dr@example.com', '1122334455', TO_DATE('2024-03-17', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0023', 'MS001', 'Parth', 'Rathwa', TO_DATE('1998-12-23', 'YYYY-MM-DD'), 'Male', '201 Pine St', '1122334488', 'parth.r@example.com', '1122334455', TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0024', 'MS001', 'Md', 'Rahman', TO_DATE('1998-12-24', 'YYYY-MM-DD'), 'Male', '201 Pine St', '1122334499', 'md.r@example.com', '1122334455', TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO Member VALUES('M0025', 'MS001', 'Dhara', 'Parekh', TO_DATE('1998-12-25', 'YYYY-MM-DD'), 'Female', '201 Pine St', '1122334411', 'dhara.p@example.com', '1122334455', TO_DATE('2024-03-19', 'YYYY-MM-DD'), 'Inactive');

--Staff
INSERT INTO Staff VALUES('ST001', 'John', 'Doe', '555-1234', 'john.doe@example.com', 'Admin', 2500.00, NULL);
INSERT INTO Staff VALUES('ST002', 'Jane', 'Smith', '555-5678', 'jane.smith@example.com', 'Support Staff', 1500.00, NULL);
INSERT INTO Staff VALUES('ST003', 'Robert', 'Johnson', '555-8765', 'robert.johnson@example.com', 'Support Staff', 1500.00, NULL);
INSERT INTO Staff VALUES('ST004', 'Emily', 'Davis', '555-4321', 'emily.davis@example.com', 'Support Staff', 1500.00, NULL);
INSERT INTO Staff VALUES('ST005', 'Michael', 'Wilson', '555-6789', 'michael.wilson@example.com', 'Support Staff', 1500.00, NULL);
INSERT INTO Staff VALUES('ST006', 'Sarah', 'Martinez', '555-2345', 'sarah.martinez@example.com', 'Support Staff', 1500.00, NULL);
INSERT INTO Staff VALUES('ST007', 'David', 'Garcia', '555-3456', 'david.garcia@example.com', 'Personal Trainer', 2000.00, 'Strength');
INSERT INTO Staff VALUES('ST008', 'Laura', 'Rodriguez', '555-6543', 'laura.rodriguez@example.com', 'Personal Trainer', 2000.00, 'Strength');
INSERT INTO Staff VALUES('ST009', 'James', 'Hernandez', '555-7654', 'james.hernandez@example.com', 'Personal Trainer', 2000.00, 'Cardio');
INSERT INTO Staff VALUES('ST010', 'Linda', 'Lopez', '555-5432', 'linda.lopez@example.com', 'Personal Trainer', 2000.00, 'Yoga');
INSERT INTO Staff VALUES('ST011', 'Steven', 'Miller', '555-4321', 'steven.miller@example.com', 'Personal Trainer', 2000.00, 'Pilates');
INSERT INTO Staff VALUES('ST012', 'Nancy', 'Gonzalez', '555-8765', 'nancy.gonzalez@example.com', 'Personal Trainer', 2000.00, 'Martial Arts');
INSERT INTO Staff VALUES('ST013', 'Charles', 'Perez', '555-7654', 'charles.perez@example.com', 'Fitness Instructor', 2000.00, 'Pilates');
INSERT INTO Staff VALUES('ST014', 'Karen', 'Wilson', '555-2345', 'karen.wilson@example.com', 'Fitness Instructor', 2000.00, 'Yoga');
INSERT INTO Staff VALUES('ST015', 'Paul', 'Taylor', '555-3456', 'paul.taylor@example.com', 'Fitness Instructor', 2000.00, 'Cycling');
INSERT INTO Staff VALUES('ST016', 'Rebecca', 'Anderson', '555-6543', 'rebecca.anderson@example.com', 'Fitness Instructor', 2000.00, 'Marshal Art');
INSERT INTO Staff VALUES('ST017', 'Daniel', 'Thomas', '555-1234', 'daniel.thomas@example.com', 'Fitness Instructor', 2000.00, 'Cardio');
INSERT INTO Staff VALUES('ST018', 'Sophia', 'Jackson', '555-5678', 'sophia.jackson@example.com', 'Fitness Instructor',2000.00, 'Marshal Art');
INSERT INTO Staff VALUES('ST019', 'Matthew', 'White', '555-6789', 'matthew.white@example.com', 'Nutritionist', 2000.00, 'Dietary plan');
INSERT INTO Staff VALUES('ST020', 'Olivia', 'Martinez', '555-2345', 'olivia.martinez@example.com', 'Nutritionist', 2000.00, 'Dietary plan');

--Booking system
INSERT INTO Booking_System VALUES('B0001', 'M0001', NULL, 'S0003', 'Training Session', TO_DATE('05/11/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0002', 'M0003', NULL, 'S0001', 'Training Session', TO_DATE('01/05/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0003', 'M0003', 'C0014', NULL, 'Class', TO_DATE('01/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0004', 'M0004', 'C0014', NULL, 'Class', TO_DATE('01/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0005', 'M0005', 'C0020', NULL, 'Class', TO_DATE('15/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0006', 'M0005', NULL, 'S0012', 'Training Session', TO_DATE('25/06/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0007', 'M0004', NULL, 'S0004', 'Training Session', TO_DATE('05/10/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0008', 'M0005', NULL, 'S0005', 'Training Session', TO_DATE('18/10/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0009', 'M0009', 'C0020', NULL, 'Class', TO_DATE('15/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0010', 'M0010', 'C0017', NULL, 'Class', TO_DATE('20/11/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0011', 'M0011', NULL, 'S0018', 'Training Session', TO_DATE('15/06/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0012', 'M0002', NULL, 'S0002', 'Training Session', TO_DATE('10/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0013', 'M0013', 'C0017', NULL, 'Class', TO_DATE('20/11/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0014', 'M0014', 'C0007', NULL, 'Class', TO_DATE('01/08/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0015', 'M0015', NULL, 'S0015', 'Training Session', TO_DATE('15/06/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0016', 'M0006', NULL, 'S0006', 'Training Session', TO_DATE('15/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0017', 'M0017', 'C0007', NULL, 'Class', TO_DATE('01/08/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0018', 'M0018', 'C0016', NULL, 'Class', TO_DATE('01/11/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0019', 'M0019', 'C0011', NULL, 'Class', TO_DATE('06/10/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0020', 'M0008', NULL, 'S0008', 'Training Session', TO_DATE('05/08/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0021', 'M0010', NULL, 'S0010', 'Training Session', TO_DATE('10/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0022', 'M0003', 'C0003', NULL, 'Class', TO_DATE('10/06/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0023', 'M0004', 'C0014', NULL, 'Class', TO_DATE('02/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0024', 'M0010', 'C0008', NULL, 'Class', TO_DATE('20/08/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0025', 'M0015', 'C0017', NULL, 'Class', TO_DATE('25/11/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0026', 'M0014', 'C0012', NULL, 'Class', TO_DATE('15/07/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0027', 'M0002', 'C0020', NULL, 'Class', TO_DATE('10/12/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0028', 'M0018', 'C0018', NULL, 'Class', TO_DATE('05/09/2024', 'DD/MM/YYYY'), 'Cancelled');
INSERT INTO Booking_System VALUES('B0029', 'M0015', 'C0016', NULL, 'Class', TO_DATE('02/11/2024', 'DD/MM/YYYY'), 'Confirmed');
INSERT INTO Booking_System VALUES('B0030', 'M0018', 'C0015', NULL, 'Class', TO_DATE('17/11/2024', 'DD/MM/YYYY'), 'Cancelled');


--Fitness Class

INSERT INTO Fitness_class VALUES('C0001', 'ST014', 'Yoga Basics', 'Yoga', TO_DATE('2024-11-25 08:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Completed');
INSERT INTO Fitness_class VALUES('C0002', 'ST017', 'Cardio Blast', 'Cardio', TO_DATE('2024-12-20 09:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Scheduled');
INSERT INTO Fitness_class VALUES('C0003', 'ST015', 'Cycling Adventure', 'Cycling', TO_DATE('2024-06-18 11:00', 'YYYY-MM-DD HH24:MI'), '45 Minutes', 10, 'Cancelled');
INSERT INTO Fitness_class VALUES('C0004', 'ST014', 'Evening Yoga', 'Yoga', TO_DATE('2024-10-20 13:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Completed');
INSERT INTO Fitness_class VALUES('C0005', 'ST017', 'Cardio Strength', 'Cardio', TO_DATE('2024-09-25 14:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Completed');
INSERT INTO Fitness_class VALUES('C0006', 'ST017', 'HIIT Cardio', 'Cardio', TO_DATE('2024-12-18 16:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 6, 'Scheduled');
INSERT INTO Fitness_class VALUES('C0007', 'ST015', 'Cycling Rush', 'Cycling', TO_DATE('2024-08-15 17:30', 'YYYY-MM-DD HH24:MI'), '30 Minutes', 10, 'Completed');
INSERT INTO Fitness_class VALUES('C0008', 'ST014', 'Night Yoga', 'Yoga', TO_DATE('2024-08-25 19:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Cancelled');
INSERT INTO Fitness_class VALUES('C0009', 'ST013', 'Morning Pilates', 'Pilates', TO_DATE('2024-07-10 06:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Completed');
INSERT INTO Fitness_class VALUES('C0010', 'ST015', 'Cycling Sprint', 'Cycling', TO_DATE('2024-12-22 08:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Scheduled');
INSERT INTO Fitness_class VALUES('C0011', 'ST014', 'Sunrise Yoga', 'Yoga', TO_DATE('2024-10-26 09:30', 'YYYY-MM-DD HH24:MI'), '45 Minutes', 10, 'Completed');
INSERT INTO Fitness_class VALUES('C0012', 'ST017', 'Cardio Burn', 'Cardio', TO_DATE('2024-07-19 11:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Cancelled');
INSERT INTO Fitness_class VALUES('C0013', 'ST017', 'Power Cardio', 'Cardio', TO_DATE('2024-11-26 12:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Completed');
INSERT INTO Fitness_class VALUES('C0014', 'ST013', 'Pilates Core', 'Pilates', TO_DATE('2024-12-15 14:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 10, 'Scheduled');
INSERT INTO Fitness_class VALUES('C0015', 'ST017', 'Extreme Cardio', 'Cardio', TO_DATE('2024-11-26 15:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Cancelled');
INSERT INTO Fitness_class VALUES('C0016', 'ST014', 'Evening Yoga', 'Yoga', TO_DATE('2024-11-09 17:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 10, 'Completed');
INSERT INTO Fitness_class VALUES('C0017', 'ST015', 'Cycling Challenge', 'Cycling', TO_DATE('2024-12-20 18:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Scheduled');
INSERT INTO Fitness_class VALUES('C0018', 'ST014', 'Relaxing Yoga', 'Yoga', TO_DATE('2024-09-20 20:00', 'YYYY-MM-DD HH24:MI'), '45 Minutes', 5, 'Cancelled');
INSERT INTO Fitness_class VALUES('C0019', 'ST013', 'Pilates Flow', 'Pilates', TO_DATE('2024-11-27 06:00', 'YYYY-MM-DD HH24:MI'), '1 Hour', 5, 'Completed');
INSERT INTO Fitness_class VALUES('C0020', 'ST014', 'Morning Yoga', 'Yoga', TO_DATE('2024-12-21 07:30', 'YYYY-MM-DD HH24:MI'), '1 Hour', 10, 'Scheduled');

---Personal Training Session
INSERT INTO Personal_Training_session VALUES('S0001', TO_DATE('10/11/2024', 'DD/MM/YYYY'), TO_DATE('10/11/2024 09:00', 'DD/MM/YYYY HH24:MI'),'1 Hour', 'ST007', 'M0001', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0002', TO_DATE('14/12/2024', 'DD/MM/YYYY'), TO_DATE('14/12/2024 10:00', 'DD/MM/YYYY HH24:MI'),'1 Hour','ST008', 'M0002', 'Scheduled');
INSERT INTO Personal_Training_session VALUES('S0003', TO_DATE('05/05/2024', 'DD/MM/YYYY'), TO_DATE('05/05/2024 11:30', 'DD/MM/YYYY HH24:MI'), '45 Minutes', 'ST009', 'M0003', 'Cancelled');
INSERT INTO Personal_Training_session VALUES('S0004', TO_DATE('12/10/2024', 'DD/MM/YYYY'), TO_DATE('12/10/2024 13:00', 'DD/MM/YYYY HH24:MI'),'1 Hour', 'ST007', 'M0004', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0005', TO_DATE('22/10/2024', 'DD/MM/YYYY'), TO_DATE('22/10/2024 14:30', 'DD/MM/YYYY HH24:MI'),'1 Hour', 'ST012', 'M0005', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0006', TO_DATE('21/12/2024', 'DD/MM/YYYY'), TO_DATE('21/12/2024 15:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST007', 'M0006', 'Scheduled');
INSERT INTO Personal_Training_session VALUES('S0007', TO_DATE('07/09/2024', 'DD/MM/YYYY'), TO_DATE('07/09/2024 16:00', 'DD/MM/YYYY HH24:MI'),'30 Minutes', 'ST008', 'M0007', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0008', TO_DATE('14/08/2024', 'DD/MM/YYYY'), TO_DATE('14/08/2024 17:30', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST009', 'M0008', 'Cancelled');
INSERT INTO Personal_Training_session VALUES('S0009', TO_DATE('09/09/2024', 'DD/MM/YYYY'), TO_DATE('09/09/2024 08:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST008', 'M0009', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0010', TO_DATE('15/12/2024', 'DD/MM/YYYY'), TO_DATE('15/12/2024 09:30', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST007', 'M0010', 'Scheduled');
INSERT INTO Personal_Training_session VALUES('S0011', TO_DATE('01/11/2024', 'DD/MM/YYYY'), TO_DATE('01/11/2024 10:30', 'DD/MM/YYYY HH24:MI'), '45 Minutes', 'ST011', 'M0011', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0012', TO_DATE('02/07/2024', 'DD/MM/YYYY'), TO_DATE('02/07/2024 11:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST012', 'M0012', 'Cancelled');
INSERT INTO Personal_Training_session VALUES('S0013', TO_DATE('20/08/2024', 'DD/MM/YYYY'), TO_DATE('20/08/2024 12:30', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST007', 'M0013', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0014', TO_DATE('25/12/2024', 'DD/MM/YYYY'), TO_DATE('25/12/2024 13:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST010', 'M0014', 'Scheduled');
INSERT INTO Personal_Training_session VALUES('S0015', TO_DATE('18/06/2024', 'DD/MM/YYYY'), TO_DATE('18/06/2024 14:30', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST008', 'M0015', 'Cancelled');
INSERT INTO Personal_Training_session VALUES('S0016', TO_DATE('25/08/2024', 'DD/MM/YYYY'), TO_DATE('25/08/2024 15:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST009', 'M0016', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0017', TO_DATE('15/12/2024', 'DD/MM/YYYY'), TO_DATE('15/12/2024 16:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST011', 'M0017', 'Scheduled');
INSERT INTO Personal_Training_session VALUES('S0018', TO_DATE('13/06/2024', 'DD/MM/YYYY'), TO_DATE('13/06/2024 17:30', 'DD/MM/YYYY HH24:MI'), '45 Minutes','ST012', 'M0018', 'Cancelled');
INSERT INTO Personal_Training_session VALUES('S0019', TO_DATE('30/07/2024', 'DD/MM/YYYY'), TO_DATE('30/07/2024 18:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST009', 'M0019', 'Completed');
INSERT INTO Personal_Training_session VALUES('S0020', TO_DATE('22/12/2024', 'DD/MM/YYYY'), TO_DATE('22/12/2024 09:00', 'DD/MM/YYYY HH24:MI'), '1 Hour','ST010', 'M0020', 'Scheduled');


---Workout plan
INSERT INTO workout_plan VALUES('WP001', 'M0001', 'ST007', 'Strength', 'Increase Strength', 'Deadlifts, Squats, Pull-ups, Treadmill', 'Active', 'Improved lifting capacity by 10%');
INSERT INTO workout_plan VALUES('WP002', 'M0015', 'ST009', 'Cardio', 'Enhance Endurance', 'Running, Cycling, HIIT Workouts', 'Active', 'Increased running distance to 5 miles');
INSERT INTO workout_plan VALUES('WP003', 'M0004', 'ST007', 'Strength', 'Strengthen Core', 'Planks, Russian Twists, Leg Raises', 'Completed', 'Core strength improved significantly');
INSERT INTO workout_plan VALUES('WP004', 'M0002', 'ST008', 'Strength', 'Lose 5kg', 'Circuit Training, Swimming, Treadmill', 'Active', 'Lost 2kg in first 3 weeks');
INSERT INTO workout_plan VALUES('WP005', 'M0010', 'ST007', 'Strength', 'Build Muscle Mass', 'Bicep Curls, Leg Press, Overhead Press', 'Completed', 'Visible muscle definition gained');
INSERT INTO workout_plan VALUES('WP006', 'M0005', 'ST011', 'Pilates', 'Improve Flexibility', 'Pilates, Stretching, Flexibility Training', 'Active', 'Reduced muscle stiffness');
INSERT INTO workout_plan VALUES('WP007', 'M0001', 'ST009', 'Cardio', 'Boost Stamina', 'Long-Distance Running, Swimming, Cycling, Workouts', 'Active', 'Running time improved by 15%');
INSERT INTO workout_plan VALUES('WP008', 'M0002', 'ST012', 'Martial Arts', 'Learn Boxing', 'Shadow Boxing, Punching Bag, Jump Rope', 'Active', 'Improved hand speed and power');
INSERT INTO workout_plan VALUES('WP009', 'M0009', 'ST008', 'Strength', 'Maximize Strength', 'Squats, Deadlifts, Bench Press', 'Completed', 'Lifted 20% heavier weights');
INSERT INTO workout_plan VALUES('WP010', 'M0002', 'ST010', 'Yoga', 'Enhance Flexibility', 'Vinyasa Yoga, Sun Salutations, Breathwork', 'Active', 'Increased range of motion');
INSERT INTO workout_plan VALUES('WP011', 'M0005', 'ST009', 'Cardio', 'Lose Weight', 'HIIT, Burpees, Jumping Jacks', 'Active', 'Lost 6kg over 3 months');
INSERT INTO workout_plan VALUES('WP012', 'M0001', 'ST012', 'Martial Arts', 'Improve Posture', 'Foam Rolling, Stretching, Core Workouts', 'Active', 'Back pain significantly reduced');
INSERT INTO workout_plan VALUES('WP013', 'M0006', 'ST007', 'Strength', 'Build Upper Body', 'Bench Press, Pull-ups', 'Completed', 'Shoulder and chest strength improved');
INSERT INTO workout_plan VALUES('WP014', 'M0015', 'ST008', 'Leg Day', 'Strength', 'Lunges, Leg Press, Hamstring Curls', 'Active', 'Increased leg press weight by 15%');
INSERT INTO workout_plan VALUES('WP015', 'M0015', 'ST007', 'Strength', 'Get Strong and Agile', 'Kettlebells, Sprints, Olympic Lifts', 'Active', 'Better form and higher weights');
INSERT INTO workout_plan VALUES('WP016', 'M0017', 'ST011', 'Pilates', 'Balance and Control', 'Core Exercises, Flexibility Training', 'Completed', 'Improved body balance');
INSERT INTO workout_plan VALUES('WP018', 'M0008', 'ST008', 'Weightlifting', 'Maximize Strength', 'Deadlifts, Squats, Overhead Press', 'Active', 'Improved lifting form');
INSERT INTO workout_plan VALUES('WP019', 'M0001', 'ST010', 'Yoga', 'Relax and Stretch', 'Restorative Yoga, Breathing Exercises, Sun Salutations', 'Active', 'Reduced stress significantly');
INSERT INTO workout_plan VALUES('WP020', 'M0005', 'ST009', 'Cardio', 'Build Upper Body', 'Laps, Bodyweight Exercises, HIIT', 'Active', 'Better upper body strength');
INSERT INTO workout_plan VALUES('WP021', 'M0004', 'ST009', 'Cardio', 'Lose Weight', 'HIIT, Burpees, Jumping Jacks', 'Active', 'Lost 8kg over 3 months');
INSERT INTO workout_plan VALUES('WP022', 'M0010', 'ST011', 'Pilates', 'Improve Flexibility', 'Pilates, Stretching, Flexibility Training', 'Completed', 'Reduced muscle stiffness');
INSERT INTO workout_plan VALUES('WP023', 'M0017', 'ST010', 'Yoga', 'Enhance Flexibility', 'Restorative Yoga, Breathing Exercises, Sun Salutations', 'Completed', 'Increased range of motion');
INSERT INTO workout_plan VALUES('WP024', 'M0004', 'ST010', 'Yoga', 'Relax and Stretch', 'Vinyasa Yoga, Sun Salutations, Breathwork', 'Active', 'Reduced stress significantly');
INSERT INTO workout_plan VALUES('WP025', 'M0011', 'ST009', 'Cardio', 'Build Upper Body', 'Laps, Bodyweight Exercises, HIIT', 'Active', 'Lost 10kg over 3 months');

---MEMBERSHIP_PLAN
INSERT INTO membership_plan VALUES('MS001', 'Silver', '3', 100);
INSERT INTO membership_plan VALUES('MS002', 'Gold', '6', 200);
INSERT INTO membership_plan VALUES('MS003', 'Platinum', '12', 400);

---DISCOUNT
INSERT INTO discount_code VALUES('D0S05', 'Silver', 5, TO_DATE('31/12/2025', 'DD/MM/YYYY'), 14);
INSERT INTO discount_code VALUES('D0G10', 'Gold', 10, TO_DATE('31/12/2025', 'DD/MM/YYYY'), 7);
INSERT INTO discount_code VALUES('D0P15', 'Platinum', 15, TO_DATE('31/12/2025', 'DD/MM/YYYY'), 4);
INSERT INTO discount_code VALUES('D0C05', 'Fitness_Class', 5, TO_DATE('31/12/2025', 'DD/MM/YYYY'), 4);

--Attendance 
INSERT INTO Attendance VALUES('A0001', 'M0008', TO_TIMESTAMP('2024-11-25 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 10:00', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0002', 'M0006', TO_TIMESTAMP('2024-11-26 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 09:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0003', 'M0008', TO_TIMESTAMP('2024-11-27 08:00', 'YYYY-MM-DD HH24:MI'), NULL);
INSERT INTO Attendance VALUES('A0004', 'M0006', TO_TIMESTAMP('2024-11-28 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 11:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0005', 'M0001', TO_TIMESTAMP('2024-11-29 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 12:30', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0006', 'M0003', TO_TIMESTAMP('2024-11-30 08:00', 'YYYY-MM-DD HH24:MI'), NULL);
INSERT INTO Attendance VALUES('A0007', 'M0003', TO_TIMESTAMP('2024-12-01 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 15:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0008', 'M0004', TO_TIMESTAMP('2024-12-02 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 16:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0009', 'M0005', TO_TIMESTAMP('2024-12-03 08:00', 'YYYY-MM-DD HH24:MI'), NULL);
INSERT INTO Attendance VALUES('A0010', 'M0012', TO_TIMESTAMP('2024-12-04 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-25 18:30', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0011', 'M0004', TO_TIMESTAMP('2024-12-05 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 10:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0012', 'M0005', TO_TIMESTAMP('2024-12-06 08:00', 'YYYY-MM-DD HH24:MI'), NULL);
INSERT INTO Attendance VALUES('A0013', 'M0009', TO_TIMESTAMP('2024-12-07 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 12:00', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0014', 'M0010', TO_TIMESTAMP('2024-12-08 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 12:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0015', 'M0018', TO_TIMESTAMP('2024-12-09 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 14:30', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0016', 'M0002', TO_TIMESTAMP('2024-12-10 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 15:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0017', 'M0013', TO_TIMESTAMP('2024-12-11 08:00', 'YYYY-MM-DD HH24:MI'), NULL);
INSERT INTO Attendance VALUES('A0018', 'M0014', TO_TIMESTAMP('2024-12-12 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 17:00', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0019', 'M0015', TO_TIMESTAMP('2024-12-13 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2024-11-26 18:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO Attendance VALUES('A0020', 'M0006', TO_TIMESTAMP('2024-12-14 08:00', 'YYYY-MM-DD HH24:MI'), NULL);

--Billing
INSERT INTO Billing VALUES('BI001', 'M0001', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI002', 'M0002', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI003', 'M0003', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI004', 'M0004', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI005', 'M0005', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI006', 'M0006', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-06-30', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI007', 'M0007', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI008', 'M0008', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI009', 'M0009', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI010', 'M0010', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-08-15', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI011', 'M0011', 'D0P15', 'Membership Fee', 400, 320, TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI012', 'M0012', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI013', 'M0013', 'D0P15', 'Membership Fee', 400, 320, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI014', 'M0014', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI015', 'M0015', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-09-25', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI016', 'M0016', 'D0P15', 'Membership Fee', 400, 320, TO_DATE('2024-10-01', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI017', 'M0017', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-10-05', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI018', 'M0018', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-10-09', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI019', 'M0019', 'D0P15', 'Membership Fee', 400, 320, TO_DATE('2024-10-15', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI020', 'M0020', 'D0G10', 'Membership Fee', 300, 270, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI021', 'M0021', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI022', 'M0022', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI023', 'M0023', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI024', 'M0024', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI025', 'M0025', 'D0S05', 'Membership Fee', 200, 190, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI026', 'M0001', NULL, 'Training session', 150, 150, TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI027', 'M0004', NULL, 'Training session', 150, 150, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI028', 'M0005', NULL, 'Training session', 150, 150, TO_DATE('2024-10-18', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI029', 'M0002', NULL, 'Training session', 150, 150, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI030', 'M0015', NULL, 'Training session', 150, 150, TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI031', 'M0006', NULL, 'Training session', 150, 150, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI032', 'M0008', NULL, 'Training session', 150, 150, TO_DATE('2024-08-05', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI033', 'M0010', NULL, 'Training session', 150, 150, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI034', 'M0003', NULL, 'Class', 50, 50, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI035', 'M0004', NULL, 'Class', 50, 50, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI036', 'M0005', NULL, 'Class', 50, 50, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI037', 'M0009', NULL, 'Class', 50, 50, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI038', 'M0010', NULL, 'Class', 50, 50, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI039', 'M0013', NULL, 'Class', 50, 50, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'Debit Card');
INSERT INTO Billing VALUES('BI040', 'M0014', NULL, 'Class', 50, 50, TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO Billing VALUES('BI041', 'M0017', NULL, 'Class', 50, 50, TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Direct Debit');
INSERT INTO Billing VALUES('BI042', 'M0018', NULL, 'Class', 50, 50, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI043', 'M0019', NULL, 'Class', 50, 50, TO_DATE('2024-10-06', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI044', 'M0003', NULL, 'Class', 50, 50, TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI045', 'M0004', NULL, 'Class', 50, 50, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI046', 'M0010', NULL, 'Class', 50, 50, TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI047', 'M0015', NULL, 'Class', 50, 50, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI048', 'M0014', NULL, 'Class', 50, 50, TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI049', 'M0002', NULL, 'Class', 50, 50, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI050', 'M0018', NULL, 'Class', 50, 50, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI051', 'M0015', NULL, 'Class', 50, 50, TO_DATE('2024-11-02', 'YYYY-MM-DD'), 'Cash');
INSERT INTO Billing VALUES('BI052', 'M0018', NULL, 'Class', 50, 50, TO_DATE('2024-11-17', 'YYYY-MM-DD'), 'Cash');




---FOREIGN KEYS
ALTER TABLE member
    ADD CONSTRAINT member_membership_id_fk FOREIGN KEY(Membership_id)
    REFERENCES Membership_plan(membership_id);

ALTER TABLE Booking_system
    ADD CONSTRAINT booking_member_fk FOREIGN KEY (member_id )
    REFERENCES member ( member_id );

ALTER TABLE Booking_system
    ADD CONSTRAINT booking_class_fk FOREIGN KEY (class_id )
    REFERENCES fitness_class( class_id );
    
ALTER TABLE Booking_system
    ADD CONSTRAINT booking_session_fk FOREIGN KEY (session_id )
    REFERENCES Personal_Training_session( session_id );


ALTER TABLE Fitness_class
    ADD CONSTRAINT class_staff_fk FOREIGN KEY (staff_id )
    REFERENCES Staff(staff_id );


ALTER TABLE Personal_Training_session
    ADD CONSTRAINT Personal_Training_session_member_id FOREIGN KEY(member_id)
    references Member(member_id);

ALTER TABLE Personal_Training_session
    ADD CONSTRAINT Personal_Training_session_Staff_id FOREIGN KEY(Staff_id)
    references Staff(Staff_id);

ALTER TABLE Workout_plan
    ADD CONSTRAINT Workout_plan_member_id FOREIGN KEY(member_id)
    references Member(member_id);

ALTER TABLE Workout_plan
    ADD CONSTRAINT Workout_plan_trainer_id FOREIGN KEY(trainer_id)
    references Staff(staff_id);

ALTER TABLE Billing
    ADD CONSTRAINT Billing_member_id FOREIGN KEY(member_id)
    references Member(member_id);

ALTER TABLE Billing
    ADD CONSTRAINT Billing_discount_code_id FOREIGN KEY(discount_code_id)
    references Discount_code(discount_code_id);

ALTER TABLE Attendance
    ADD CONSTRAINT Attendance_member_id FOREIGN KEY(member_id)
    references Member(member_id);




