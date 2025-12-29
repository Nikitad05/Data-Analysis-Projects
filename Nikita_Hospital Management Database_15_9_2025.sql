-- Create Database
create database hospital;
use hospital;

-- Create Patients Table
create table Patients (
    PatientID int auto_increment primary key,
    Name varchar(50),
    Gender enum('Male','Female','Other'),
    DOB date,
    Phone varchar(15) not null unique,
    Address varchar(100)
);

-- Create Doctors Table
create table Doctors (
    DoctorID int auto_increment primary key,
    Name varchar(50),
    Specialization varchar(50),
    Phone varchar(15) not null unique
);

-- Create Rooms Table
create table Rooms (
    RoomID int auto_increment primary key,
    RoomType varchar(20),
    Status enum('Available','Occupied')
);

-- Create Appointments Table
create table Appointments (
    AppointmentID int auto_increment primary key,
    PatientID int,
    DoctorID int,
    AppointmentDate date,
    Purpose varchar(100),
    foreign key (PatientID) references Patients(PatientID),
    foreign key (DoctorID) references Doctors(DoctorID)
);

-- Create Admissions Table
create table Admissions (
    AdmissionID int auto_increment primary key,
    PatientID int,
    AdmissionDate date,
    DischargeDate date,
    RoomID int,
    foreign key (PatientID) references Patients(PatientID),
    foreign key (RoomID) references Rooms(RoomID)
);

-- Create Billing Table
create table Billing (
    BillID int auto_increment primary key,
    PatientID int,
    AdmissionID int,
    Amount decimal(10,2),
    PaymentStatus enum('Paid','Unpaid'),
    foreign key (PatientID) references Patients(PatientID),
    foreign key (AdmissionID) references Admissions(AdmissionID)
);

-- Create Medications Table
create table Medications (
    MedicationID int auto_increment primary key,
    PatientID int,
    MedicineName varchar(50),
    Dosage varchar(50),
    StartDate date,
    EndDate date,
    foreign key (PatientID) references Patients(PatientID)
);

-- Insert Patients
insert into Patients (Name, Gender, DOB, Phone, Address) values
('Ravi Kumar','Male','1990-05-12','9876543219','Delhi'), 
('Priya Sharma','Female','1985-08-20','9876501235','Mumbai'),
('Amit Patel','Male','1992-11-02','9988776656','Ahmedabad'),
('Neha Verma','Female','1998-01-15','9123456790','Bangalore'),
('Arjun Reddy','Male','1988-03-22','9345678902','Hyderabad');

-- Insert Doctors
insert into Doctors (Name, Specialization, Phone) values
('Dr. Mehta','Cardiologist','9000000001'),
('Dr. Sharma','Orthopedic','9000000002'),
('Dr. Kapoor','Neurologist','9000000003'),
('Dr. Iyer','Dermatologist','9000000004');

-- Insert Rooms
insert into Rooms (RoomType, Status) values
('General','Available'),
('Private','Available'),
('ICU','Occupied'),
('General','Occupied');

-- Insert Appointments
insert into Appointments (PatientID, DoctorID, AppointmentDate, Purpose) values
(1,1,'2025-01-05','Heart Checkup'),
(2,2,'2025-02-10','Knee Pain'),
(3,3,'2025-02-12','Headache'),
(4,4,'2025-03-01','Skin Allergy'),
(5,1,'2025-03-05','Routine Checkup');

-- Insert Admissions
insert into Admissions (PatientID, AdmissionDate, DischargeDate, RoomID) values
(1,'2025-01-10','2025-01-15',1),
(2,'2025-02-11','2025-02-20',2),
(3,'2025-02-15',null,3);

-- Insert Billing
insert into Billing (PatientID, AdmissionID, Amount, PaymentStatus) values
(1,1,5000,'Paid'),
(2,2,12000,'Unpaid'),
(3,3,15000,'Paid');
	
-- Insert Medications
insert into Medications (PatientID, MedicineName, Dosage, StartDate, EndDate) values
(1,'Aspirin','1 tablet/day','2025-01-10','2025-01-20'),
(2,'Paracetamol','2 tablets/day','2025-02-11','2025-02-18'),
(3,'Ibuprofen','1 tablet/day','2025-02-15','2025-02-25');

-- 1. Show all patients
select * from Patients;
-- insight: see all patients in hospital

-- 2. Show all doctors and their specialization
select Name as Doctor, Specialization from Doctors;
-- insight: Shows doctors and their field of expertise

-- 3. Show available rooms
select * from Rooms where Status='Available';
-- insight: check rooms ready for new patients

-- 4. Show all appointments with patient names
select a.AppointmentID, p.Name as Patient, a.AppointmentDate
from Appointments a
join Patients p on a.PatientID = p.PatientID;
-- insight: see which patient has appointment

-- 5. Show billing info with patient
select b.BillID, p.Name as Patient, b.Amount, b.PaymentStatus as Status
from Billing b
join Patients p on b.PatientID = p.PatientID;
-- insight: know who paid or not

-- 6. Show medications with patient
select m.MedicationID, p.Name as Patient, m.MedicineName as Medicine, m.Dosage
from Medications m
join Patients p on m.PatientID = p.PatientID;
-- insight: track patient medicines

-- 7. Show male patients
select Name as Patient from Patients where Gender='Male';
-- insight: list male patients

-- 8. Show patients in ICU
select a.AdmissionID, p.Name as Patient, r.RoomType
from Admissions a
join Patients p on a.PatientID = p.PatientID
join Rooms r on a.RoomID = r.RoomID
where r.RoomType='ICU';
-- insight: see patients in ICU

-- 9. Show all rooms and status
select RoomID, RoomType as Room, Status from Rooms;
-- insight: check free and occupied rooms

-- 10. Show all appointments and mark upcoming ones
select a.AppointmentID, p.Name as Patient, a.AppointmentDate,
case when a.AppointmentDate >= curdate() then 'Upcoming' else 'Past' end as Status
from Appointments a
join Patients p on a.PatientID = p.PatientID;
-- insight: see all appointments and which are upcoming

-- 11. Count total appointments
select count(*) as TotalAppointments from Appointments;
-- insight: total appointments in hospital

-- 12. Total unpaid amount
select sum(Amount) as TotalUnpaid from Billing where PaymentStatus='Unpaid';
-- insight: know pending payments

-- 13. Total appointments per doctor
select d.Name as Doctor, count(a.AppointmentID) as Total
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
group by d.Name;
-- insight: see how busy doctors are

-- 14. Total billing per patient
select p.Name as Patient, sum(b.Amount) as Total
from Billing b
join Patients p on b.PatientID = p.PatientID
group by p.Name;
-- insight: total charges per patient

-- 15. Show earliest appointment for each patient
select p.Name as Patient, min(a.AppointmentDate) as FirstVisit
from Appointments a
join Patients p on a.PatientID = p.PatientID
group by p.Name;
-- insight: shows when each patient first visited

-- 16. Room usage count
select r.RoomID, r.RoomType as Room, count(a.AdmissionID) as TotalUse
from Rooms r
left join Admissions a on r.RoomID = a.RoomID
group by r.RoomID, r.RoomType;
-- insight: see how many times rooms used

-- 17. Patients currently admitted
select a.AdmissionID, p.Name as Patient, a.AdmissionDate
from Admissions a
join Patients p on a.PatientID = p.PatientID
where a.DischargeDate is null;
-- insight: patients still in hospital

-- 18. Show all medications and highlight ongoing ones
select m.MedicationID, p.Name as Patient, m.MedicineName as Medicine, m.EndDate,
case when m.EndDate >= curdate() then 'Ongoing' else 'Completed' end as Status
from Medications m
join Patients p on m.PatientID = p.PatientID;
-- insight: track which medicines are still being taken

-- 19. Admissions by room type
select r.RoomType as Room, count(a.AdmissionID) as Total
from Rooms r
join Admissions a on r.RoomID = a.RoomID
group by r.RoomType;
-- insight: which rooms used most

-- 20. Payments by status
select PaymentStatus as Status, count(BillID) as TotalBills, sum(Amount) as TotalAmount
from Billing
group by PaymentStatus;
-- insight: see paid vs unpaid bills

-- 21. Patient with highest billing
select p.Name as Patient, sum(b.Amount) as Total
from Billing b
join Patients p on b.PatientID = p.PatientID
group by p.Name
order by Total desc
limit 1;
-- insight: patient paying most

-- 22. Doctors with more than 1 patient
select d.Name as Doctor, count(distinct a.PatientID) as TotalPatients
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
group by d.Name
having count(distinct a.PatientID) > 1;
-- insight: busy doctors

-- 23. Most prescribed medicine
select m.MedicineName as Medicine, count(m.MedicationID) as TimesPrescribed
from Medications m
group by m.MedicineName
order by TimesPrescribed desc
limit 1;
-- insight: helps manage stock

-- 24. Total days each patient admitted
select p.Name as Patient, sum(datediff(ifnull(a.DischargeDate,curdate()), a.AdmissionDate)) as TotalDays
from Admissions a
join Patients p on a.PatientID = p.PatientID
group by p.Name;
-- insight: total stay per patient

-- 25. Show all admissions and their current status
select a.AdmissionID, p.Name as Patient, a.AdmissionDate, a.DischargeDate,
case when a.DischargeDate is null then 'Currently Admitted' else 'Discharged' end as Status
from Admissions a
join Patients p on a.PatientID = p.PatientID;
-- insight: shows all admissions and whether the patient is still in hospital

-- 26. Appointments by purpose
select Purpose as Reason, count(AppointmentID) as Total
from Appointments
group by Purpose;
-- insight: why patients come

-- 27. Most used rooms
select r.RoomType as Room, count(a.AdmissionID) as Total
from Rooms r
join Admissions a on r.RoomID = a.RoomID
group by r.RoomType
order by Total desc;
-- insight: which room type popular

-- 28. Patients with both appointments and admissions
select distinct p.Name as Patient
from Patients p
join Appointments a on p.PatientID = a.PatientID
join Admissions ad on p.PatientID = ad.PatientID;
-- insight: patients visiting and admitted

-- 29. Unpaid amount per patient
select p.Name as Patient, sum(b.Amount) as Total
from Billing b
join Patients p on b.PatientID = p.PatientID
where b.PaymentStatus='Unpaid'
group by p.Name;
-- insight: patient owes money

-- 30. Doctors treating Heart Checkup
select distinct d.Name as Doctor
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
where a.Purpose='Heart Checkup';
-- insight: heart patients doctors

-- 31. Last appointment of each patient
select p.Name as Patient, max(a.AppointmentDate) as LastVisit
from Appointments a
join Patients p on a.PatientID = p.PatientID
group by p.Name;
-- insight: last visit info

-- 32. Show all medicines and mark if ended in last 5 days
select m.MedicineName as Medicine, p.Name as Patient, m.EndDate,
case when m.EndDate >= date_sub(curdate(), interval 5 day) then 'Ended Recently' else 'Not Recent' end as Status
from Medications m
join Patients p on m.PatientID = p.PatientID;
-- insight: helps track medicines that ended recently vs older ones

-- 33. Number of patients per doctor
select d.Name as Doctor, count(distinct a.PatientID) as Total
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
group by d.Name;
-- insight: how many patients each doctor treated

-- 34. Prescriptions per patient
select p.Name as Patient, count(m.MedicationID) as Total
from Medications m
join Patients p on m.PatientID = p.PatientID
group by p.Name;
-- insight: number of medicines per patient

-- 35. Ongoing admissions and days admitted
select a.AdmissionID, p.Name as Patient, datediff(curdate(), a.AdmissionDate) as DaysAdmitted
from Admissions a
join Patients p on a.PatientID = p.PatientID
where a.DischargeDate is null;
-- insight: days patient still in hospital

-- 36. Total billing per patient sorted
select p.Name as Patient, sum(b.Amount) as Total
from Billing b
join Patients p on b.PatientID = p.PatientID
group by p.Name
order by Total desc;
-- insight: highest billed patient first

-- 37. Rooms and times occupied
select r.RoomType as Room, count(a.AdmissionID) as Total
from Rooms r
join Admissions a on r.RoomID = a.RoomID
group by r.RoomType;
-- insight: how often room used

-- 38. Payments per patient by status
select p.Name as Patient, b.PaymentStatus as Status, sum(b.Amount) as Total
from Billing b
join Patients p on b.PatientID = p.PatientID
group by p.Name, b.PaymentStatus;
-- insight: track paid/unpaid per patient

-- 39. Patients admitted more than 5 days
select a.AdmissionID, p.Name as Patient, datediff(ifnull(a.DischargeDate, curdate()), a.AdmissionDate) as DaysAdmitted
from Admissions a
join Patients p on a.PatientID = p.PatientID
where datediff(ifnull(a.DischargeDate, curdate()), a.AdmissionDate) > 5;
-- insight: long term patients

-- 40. Show all patients and their appointment count, highlight frequent ones
select p.Name as Patient, count(a.AppointmentID) as TotalAppointments,
case when count(a.AppointmentID) > 1 then 'Frequent' else 'Not Frequent' end as Status
from Patients p
left join Appointments a on p.PatientID = a.PatientID
group by p.Name;
-- insight: helps track patients visiting often

-- 41. Doctors and their patients
select d.Name as Doctor, p.Name as Patient
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
join Patients p on a.PatientID = p.PatientID
order by d.Name;
-- insight: which patient with which doctor

-- 42. Patients and number of medications
select p.Name as Patient, count(m.MedicationID) as TotalMedicines
from Patients p
join Medications m on p.PatientID = m.PatientID
group by p.Name
order by TotalMedicines desc;
-- insight: patients taking more than 1 medicine

-- 43. Show all rooms and mark if they are currently used
select r.RoomID, r.RoomType as Room, r.Status,
case when count(a.AdmissionID) = 0 then 'Not Used' else 'Used' end as RoomUsage
from Rooms r
left join Admissions a on r.RoomID = a.RoomID
group by r.RoomID, r.RoomType, r.Status
order by r.RoomID;
-- insight: helps check room availability and usage status

-- 44. Show all doctors and mark if they have appointments
select d.Name as Doctor,
case when count(a.AppointmentID) = 0 then 'No Appointments' else 'Has Appointments' end as Status
from Doctors d
left join Appointments a on d.DoctorID = a.DoctorID
group by d.DoctorID, d.Name;
-- insight: helps identify doctors with or without patients

-- 45. Patients with no medicine
select p.Name as Patient
from Patients p
left join Medications m on p.PatientID = m.PatientID
where m.MedicationID is null;
-- insight: patients not taking medicine

-- 46. Total billing per doctor
select d.Name as Doctor, sum(b.Amount) as TotalBilling
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
join Admissions ad on a.PatientID = ad.PatientID
join Billing b on ad.AdmissionID = b.AdmissionID
group by d.Name;
-- insight: Revenue linked to doctors via patient admissions, not direct consultation fees

-- 47. Patients never admitted
select p.Name as Patient
from Patients p
left join Admissions a on p.PatientID = a.PatientID
where a.AdmissionID is null;
-- insight: only appointments, no admission

-- 48. Show patient with highest total days admitted
select p.Name as Patient, sum(datediff(ifnull(a.DischargeDate, curdate()), a.AdmissionDate)) as TotalDays
from Admissions a
join Patients p on a.PatientID = p.PatientID
group by p.Name
order by TotalDays desc
limit 1;
-- insight: shows which patient stayed the longest overall

-- 49. Most frequent appointment reason
select Purpose as Reason, count(AppointmentID) as Total
from Appointments
group by Purpose
order by Total desc
limit 1;
-- insight: most common hospital visit reason

-- 50. Show doctor treating most distinct patients
select d.Name as Doctor, count(distinct a.PatientID) as TotalPatients
from Doctors d
join Appointments a on d.DoctorID = a.DoctorID
group by d.Name
order by TotalPatients desc
limit 1;
-- insight: helps identify the busiest doctor
