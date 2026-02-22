CREATE DATABASE ScholarshipDB;
USE ScholarshipDB;

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    course VARCHAR(100),
    family_income DECIMAL(10,2)
);

CREATE TABLE Scholarships (
    scholarship_id INT PRIMARY KEY AUTO_INCREMENT,
    scholarship_name VARCHAR(150) NOT NULL,
    provider VARCHAR(100),
    min_percentage DECIMAL(5,2),
    max_income_limit DECIMAL(10,2),
    scholarship_amount DECIMAL(10,2)
);

CREATE TABLE Eligibility (
    eligibility_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    scholarship_id INT,
    eligibility_status VARCHAR(20),
    checked_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (scholarship_id) REFERENCES Scholarships(scholarship_id)
);

CREATE TABLE Disbursement (
    disbursement_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    scholarship_id INT,
    amount_paid DECIMAL(10,2),
    payment_date DATE,
    payment_status VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (scholarship_id) REFERENCES Scholarships(scholarship_id)
);

INSERT INTO Students(full_name, gender, date_of_birth, email, phone, course, family_income)
VALUES
('Rahul Sharma', 'Male', '2003-05-10', 'rahul@email.com', '9876543210', 'BSc IT', 180000),
('Sneha Patil', 'Female', '2002-08-15', 'sneha@email.com', '9876501234', 'BCom', 120000);

INSERT INTO Scholarships(scholarship_name, provider, min_percentage, max_income_limit, scholarship_amount)
VALUES
('Merit Scholarship', 'State Govt', 75, 300000, 25000),
('Need Based Scholarship', 'Central Govt', 60, 200000, 30000);

INSERT INTO Eligibility(student_id, scholarship_id, eligibility_status, checked_date)
VALUES
(1, 1, 'Eligible', CURDATE()),
(2, 2, 'Eligible', CURDATE());

INSERT INTO Disbursement(student_id, scholarship_id, amount_paid, payment_date, payment_status)
VALUES
(1, 1, 25000, CURDATE(), 'Paid'),
(2, 2, 30000, CURDATE(), 'Paid');

SELECT * FROM Students;

SELECT full_name, family_income
FROM Students
WHERE family_income < 200000;

SELECT s.full_name, sc.scholarship_name, d.amount_paid, d.payment_status
FROM Students s
JOIN Disbursement d ON s.student_id = d.student_id
JOIN Scholarships sc ON sc.scholarship_id = d.scholarship_id;

SELECT student_id, SUM(amount_paid) AS total_amount
FROM Disbursement
GROUP BY student_id;

SELECT student_id, SUM(amount_paid) AS total_amount
FROM Disbursement
GROUP BY student_id
HAVING SUM(amount_paid) > 25000;

SELECT full_name
FROM Students
WHERE family_income <
(
    SELECT max_income_limit
    FROM Scholarships
    WHERE scholarship_name = 'Merit Scholarship'
);

CREATE VIEW Paid_Scholarships AS
SELECT s.full_name, sc.scholarship_name, d.amount_paid
FROM Students s
JOIN Disbursement d ON s.student_id = d.student_id
JOIN Scholarships sc ON sc.scholarship_id = d.scholarship_id
WHERE d.payment_status = 'Paid';

SELECT * FROM Paid_Scholarships;