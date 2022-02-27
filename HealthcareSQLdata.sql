USE PollynzConsults
GO
/*Hello Princess, I want to thank you for your hard work and dedication to understanding Transact SQL. 
The goal of this project is to understand the business question and translate it into technical coding.
 I must say that I am impressed because you did meet not only the expectation
but also exceeded them. Thank you.

*/ 

/*Business question 1:
As a group home manager, I would like to get the total number 
of employees' first names, middle names, and last names 
of employees who work the night shift.
*/

SELECT FirstName,
		MiddleName, 
		LastName
FROM hr.Employee HRE
JOIN HR.Shift HRS
ON HRE.ShiftID = HRS.ShiftID
WHERE NAME = 'NIGHT'

/*Business question 2:
As the admin manager, like a data set, is generated, 
that will display the first name, middle name, last name, date of 
birth, job title, vacation hours, address line 1, city, 
state, and zip code of all employees. This information is needed
for an upcoming quarterly audit.
*/
SELECT FirstName,
		MiddleName, 
		LastName,
		BirthDate, 
		JobTitle,VacationHours,
		AddressLine1,
		city,
		State,
		Zipcode
FROM HR.Employee
/*
Business question 3: 
The admin manager would like to thank you for the 
outstanding work that you did in question 2. However, he wants
you to create a derived column called full address, 
and this column should be a combination of the address line 1,
city, state, and zip code. They need this column 
because it is hard for them to understand the address if they are spread 
out on different columns. 
*/

SELECT FirstName,
		MiddleName, 
		LastName,
		BirthDate, 
		JobTitle,
		VacationHours, 
		AddressLine1,
		city,
		State,
		Zipcode,
	CONCAT(AddressLine1, ' ', city, ' ', State, ' ', ZipCode) as FullAddress
FROM HR.Employee

/*
Business question 4: 
As a finance manager, I would like to get records of 
patients' first name, last name, gender, SSN, and date of birth whose 
sum of inpatients and outpatients charges is greater 
than two thousand dollars. This is an urgent need because of
benchmarkingprojects that are going on internally. 
--*/

SELECT
	PatientFirstName,
	PatientLastName, 
	Gender,
	SSN,
	Dateofbirth, 
	InpatientCharges + OutPatientCharges AS SUM
FROM Clients.Patients CP
JOIN Clients.patientCharges CPC
ON CP.ChargedID = CPC.ChargedID
WHERE InpatientCharges + OutPatientCharges > '2000'

/*
Business question 5:
The manager is delighted with question 4; she wants you to add additional 
information to the records. The manager will like
you to add the medical condition (Name) and the drug name. This information 
is needed to keep track of the patients.
*/

SELECT PatientFirstName, PatientLastName,
		Gender,
		SSN, 
		Dateofbirth,
		InpatientCharges + OutPatientCharges AS SUM,
		Name, 
		DrugName
FROM Clients.Patients CP
JOIN Clients.patientCharges CPC
ON CP.ChargedID = CPC.ChargedID
JOIN clients.MedicalCondition CMC
ON CP.DiagonosisId = CMC.DiagonosisID
JOIN clients.Medication CM
ON CMC.DiagonosisID = CM.DiagonosisId
WHERE InpatientCharges + OutPatientCharges > '2000'

/*Business question 6: 
As a group home manager, there have been reports of incidents at the group home, and I would 
like to get the first name,
last name,gender, and name of incident reports of every patient who has had reports recorded 
against them.
*/

SELECT PatientFirstName, PatientLastName, Gender, Name
FROM Clients.Patients CP
JOIN hr.IncidentReports IR
ON CP.ReportID = IR.ReportID

/*Business question 7: 
The report from question 6 is appreciated, but I would like you to add the first name, 
last name, and email address of the
employees who were on duty the day the incident occurred. 
*/

SELECT PatientFirstName,
		PatientLastName,
		CP.Gender,
		Name, 
		firstName,
		Lastname,
		EmailAddress
FROM Clients.Patients CP
JOIN hr.IncidentReports IR
ON CP.ReportID = IR.ReportID
JOIN HR.Employee HE
ON CP.EmployeeID = HE.EmployeeID

/*Business question 8: 

There has been a significant HIPPA violation on the report you submitted in question 4; 
the manager would like you to
rewrite the report to produce records with only the last four digits of the SSN displayed 
while you mask the rest before
the last four with an asterisk (*).
*/

SELECT PatientFirstName,
		PatientLastName,
		Gender,
		SSN, 
		Dateofbirth,InpatientCharges + OutPatientCharges AS SUM,
RIGHT(SSN,4) RIGHT4,
CONCAT (REPLICATE ('*', 5),RIGHT(SSN,4))AS MaskSSN
FROM Clients.Patients CP
JOIN Clients.patientCharges CPC
ON CP.ChargedID = CPC.ChargedID
WHERE InpatientCharges + OutPatientCharges > '2000'

/*
Business question 9: 
As a group home manager, I would like to create a unique ID for all the 
patients in the facility. I want the ID to be a 
combination of the first three letters of the patient's first name, the 
last three letters of the patient's first name, and 
the last digits of their social security number. 
*/
SELECT PatientfirstName, ssn,
SUBSTRING(PatientFirstName, 1,3)PFN,
RIGHT(PatientFirstName, 3)LFN,
RIGHT(SSN, 1) SSN1,
CONCAT(SUBSTRING(PatientFirstName, 1,3),RIGHT(PatientFirstName, 3),RIGHT(SSN, 1)) AS UniqueID
FROM Clients.Patients
/*
Business question 10: 
The group home is preparing to award their employees for their dedication in 
working for the company. As a manager, I would 
like the employee's first name, last name, gender, but the gender should display male 
if M and female is F, and marital 
status. I want a column called "Award Date" to keep track of the years that the employee
 was hired. This is important as we
prepare for their retirement package. 
*/
SELECT  FirstName,
		LastName,
		MaritalStatus,
		YEAR(HireDate) AS AwardDate,
CASE
	WHEN Gender = 'M'THEN 'MALE' 
	WHEN Gender = 'F' THEN 'FEMALE'
	END AS GenderTranslated
FROM Hr.Employee

/*
Business question 11: 
The report on question 10 has been reviewed and validated to be correct; as a manager, I cannot keep track of the query, 
and I do not want the query to get missing. So I would like you to have the code in the database so it will be easy to query
whenever I want to see the report.
*/
CREATE VIEW vEmployee
AS 
(

SELECT  FirstName, LastName, Gender, MaritalStatus, YEAR(HireDate) AS AwardDate,
CASE
	WHEN Gender = 'M'THEN 'MALE' 
	WHEN Gender = 'F' THEN 'FEMALE'
	END AS GenderTranslated
FROM Hr.Employee
)
GO

SELECT *
FROM vEmployee
