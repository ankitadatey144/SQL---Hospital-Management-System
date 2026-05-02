
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Create Patient Table
CREATE TABLE Patient (
    P_ID INT PRIMARY KEY,
    P_Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Address VARCHAR(100)
);
INSERT INTO Patient VALUES 
(111, 'Yash S.', 25, 'Male', 'Mumbai'),
(222, 'Mahesh T.', 30, 'Male', 'Pune'),
(333, 'Sakshi P.', 22, 'Female', 'Baner');



CREATE TABLE Doctors (
    Doctor_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(50),
    Dept_ID INT
);
INSERT INTO Doctors VALUES
(101, 'Dr. Sanjay Iyer', 'Cardiology', 1),
(102, 'Dr. Priya Iyer', 'General Medicine', 3),
(103, 'Dr. Amit Iyer', 'Neurology', 3),
(104, 'Dr. Sunita Sharma', 'Neurology', 4);

CREATE TABLE Appointments (
    Appt_ID INT PRIMARY KEY,
    Patient_ID INT,
    Doctor_ID INT,
    Appt_Date DATE,
    Status VARCHAR(20),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(P_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID)
);
INSERT INTO Appointments VALUES
(501, 333, 102, '2023-02-28', 'Scheduled'),
(502, 333, 103, '2023-12-10', 'Completed'),
(503, 111, 101, '2023-02-05', 'Cancelled'),
(504, 222, 101, '2023-05-01', 'Completed');



CREATE TABLE Billing (
    Bill_ID INT PRIMARY KEY,
    Patient_ID INT,
    Amount DECIMAL(10, 2),
    Bill_Date DATE,
    Status VARCHAR(20),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(P_ID)
);
INSERT INTO Billing VALUES
(901, 333, 862.00, '2023-07-28', 'Pending'),
(902, 111, 4071.50, '2023-08-26', 'Unpaid'),
(903, 222, 2510.00, '2023-03-11', 'Paid');

-- showing all appointments with patient and doctor name
SELECT A.Appt_ID, P.P_Name AS Patient, D.Name AS Doctor, A.Appt_Date
FROM Appointments A
JOIN Patient P ON A.Patient_ID = P.P_ID
JOIN Doctors D ON A.Doctor_ID = D.Doctor_ID;

-- list of bills for specific patient
SELECT P.P_Name, B.Amount, B.Status, B.Bill_Date
FROM Billing B
JOIN Patient P ON B.Patient_ID = P.P_ID
WHERE P.P_Name = 'Sakshi P.';

-- total revenue generated from paid bills
SELECT SUM(Amount) AS Total_Revenue 
FROM Billing 
WHERE Status = 'Paid';

-- how many appointments each doctor has scheduled
SELECT D.Name, COUNT(A.Appt_ID) AS Total_Appointments
FROM Doctors D
LEFT JOIN Appointments A ON D.Doctor_ID = A.Doctor_ID
GROUP BY D.Name;

-- identifying patients who have "unpaid" or "pending" bills
SELECT P.P_Name, B.Amount, B.Status
FROM Patient P
JOIN Billing B ON P.P_ID = B.Patient_ID
WHERE B.Status IN ('Unpaid', 'Pending');

-- finding busiest day for appointments
SELECT Appt_Date, COUNT(*) AS Appt_Count
FROM Appointments
GROUP BY Appt_Date
ORDER BY Appt_Count DESC
LIMIT 1;
