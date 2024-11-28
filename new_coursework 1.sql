--CREATE TABLES 

CREATE TABLE Attendance(
    attendance_id        VARCHAR2(10) NOT NULL,
    member_id            VARCHAR2(10) NOT NULL,
    staff_id             VARCHAR2(10) NOT NULL,
    check_in             TIMESTAMP WITH LOCAL TIME ZONE NOT NULL,
    check_out            TIMESTAMP WITH LOCAL TIME ZONE,
    PRIMARY KEY(attendance_id)
);

CREATE TABLE Booking_system(
    booking_id       VARCHAR2(10) NOT NULL,
    class_id         VARCHAR2(10) NOT NULL,
    member_id        VARCHAR2(10) NOT NULL,
    session_id        VARCHAR2(10),
    BOOKING_DATE      DATE NOT NULL,
    booking_status   VARCHAR2(20) NOT NULL
    PRIMARY KEY(booking_id)
);


CREATE TABLE Fitness_class(
    class_id       VARCHAR2(10) NOT NULL,
    name           VARCHAR2(50) NOT NULL,
    type           VARCHAR2(20) NOT NULL,
    schedule       TIMESTAMP NOT NULL,
    max_capacity   NUMBER(3) NOT NULL,
    staff_id       VARCHAR2(10) NOT NULL
    PRIMARY KEY(Class_id)
);

CREATE TABLE MEMBER(
    Member_id         VARCHAR2(10) NOT NULL,
    membership_id    VARCHAR2(10)  NOT NULL,
    Fname             VARCHAR2(25) NOT NULL,
    lname             VARCHAR2(25) NOT NULL,
    date_of_birth     DATE NOT NULL,
    gender            VARCHAR2(10) NOT NULL,
    address           VARCHAR2(10),
    phone_number      VARCHAR2(15) NOT NULL,
    email             VARCHAR2(50)  NOT NULL,
    emergency_contact VARCHAR2(15),
    PRIMARY KEY(MEMBER_ID)
);

CREATE TABLE Membership(
    membership_id    VARCHAR2(10)  NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    duration         VARCHAR2(10)  NOT NULL,
    status           VARCHAR2(15) NOT NULL,
    plan             VARCHAR2(20) NOT NULL,
    PRIMARY KEY(MEMBERSHIP_ID)
);

CREATE TABLE Billing(
    billing_id       VARCHAR2(10) NOT NULL,
    member_id        VARCHAR2(10) NOT NULL,
    amount           NUMBER(10,2) NOT NULL,
    payment_date     DATE NOT NULL,
    payment_method   VARCHAR2(20) NOT NULL,
    payment_status           VARCHAR2(15)  NOT NULL,
    PRIMARY KEY(billing_ID)
);

CREATE TABLE Personal_Traning_session (
    session_id       VARCHAR2(10) NOT NULL,
    session_date     DATE NOT NULL,
    session_time     TIMESTAMP NOT NULL,
    duration         INTERVAL DAY TO SECOND NOT NULL,
    staff_id         VARCHAR2(10) NOT NULL,
    member_id        VARCHAR2(10) NOT NULL,
    status           VARCHAR2(15),
    PRIMARY KEY(SESSION_ID)
);


CREATE TABLE Staff(
    staff_id       VARCHAR2(10)  NOT NULL,
    Fname           VARCHAR2(25)  NOT NULL,
    Lname           VARCHAR2(25)  NOT NULL,
    phone_number   VARCHAR2(15)  NOT NULL,
    email          VARCHAR2(50) NOT NULL,
    position       VARCHAR2(20) NOT NULL,
    salary         NUMBER(8,2),
    specialization VARCHAR2(50),
    PRIMARY KEY(STAFF_ID)
);

CREATE TABLE Workout_plan(
    workout_plan_id              VARCHAR2(10) NOT NULL,
    member_id                    VARCHAR2(10)  NOT NULL,
    exercise_details            VARCHAR2(250),
    progress_notes               VARCHAR2(250),
    primary key(workout_plan_id)
);

CREATE TABLE Discount_Code(
    Discount_Code_ID            VARCHAR2(10) NOT NULL,
    Description                 VARCHAR2(100),
    Discount_Percentage         NUMBER(5,2) NOT NULL,
    Expiry_Date                 DATE NOT NULL,
    Usage_Count                 NUMBER(5),
    primary key (Discount_Code_ID)
);


