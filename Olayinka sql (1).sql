
Created By: Okanlawon Olayinka Sukurat
Created on: 14/10/2024
Description: Analysis_of_Factors_Influencing_CGPA


create database Analysis_of_Factors_Influencing_CGPA

use Analysis_of_Factors_Influencing_CGPA

create table courses
(No int,
[Course Code] varchar (100),
[Course Title] varchar (100),
[Level/Semester] varchar(50),
[Department] varchar (50),
[Credit Unit] int,
[Lecturer Id] varchar (50) )

select *
from Courses

select*
from Courses2

  use Analysis_of_Factors_Influencing_CGPA

  create table Enrollment
  ([Course Tittle Code] int,
  [Student ID] varchar(100),
  [Level/Semester] varchar(100),
  Department varchar(100),
  [Course Code] varchar(100),
  Score int,
  [Lecturer ID] varchar(100) )

  select *from Enrollment

  select *from Enrollment2

  use Analysis_of_Factors_Influencing_CGPA

  create table [Lecturer Profile Data]
  ([LecturerID] varchar(100),
  FirstName varchar(100),	
  LastName varchar(100),
  HireDate date,
  Department varchar(100),
  Desgnation varchar(100) )

  select *from [Lecturer Profile Data]

  select *from Teachers_profile

   use Analysis_of_Factors_Influencing_CGPA

  create table [Student Details Data]
  ([S/N] int,
  StudentID varchar(100),
  FirstName varchar(100),
  LastName varchar(100),
  Gender char(1),
  Department varchar(50),	
  [Birth date] date)

  select *from [Student Details Data]

  select *from [student Profile]

  ---To get distinct count of sudent

   select COUNT(distinct firstName) AS No_of_student from [Student Profile]

   use Analysis_of_Factors_Influencing_CGPA

  create table [Time]
  (TimeID int,
  Year date,
  Month date,
  Day date,
  Semester varchar (100) )

  select *from [Time]

  select *from [Time]

  ---To remove excess column

  Alter table [Time]
  Drop column (column6,column7, column8, column9)

    use Analysis_of_Factors_Influencing_CGPA

  create table [Grade Conversion]
  (Score int,
  Grade varchar (50) )
  
  select *from [Grade Conversion]

  select *from [Grade_Conversion]

  ----Total Enrollment across the year

   select COUNT(distinct [Student_ID]) AS Total_Enrollment from [Enrollment2]
   GROUP BY Student_ID

  -- Total Number of Courses per Semester
  select COUNT(distinct Course_Code) AS Total_Courses from [Enrollment2]
 GROUP BY Level_Semester
 ORDER BY Level_Semester

   -----Calculate mean scores of CGPA

   select Student_ID,AVG(Score) AS Average_score
   from [Enrollment2]
   GROUP BY Student_ID
   ORDER BY Average_score



-----Distint count of courses and teachers
 
 select COUNT(distinct LecturerID)AS No_of_Lecturer
    from Teachers_profile 
   
   select COUNT(distinct Department) AS No_of_courses from Teachers_profile 

----Distribution of student across department

  select StudentID,Department from [student Profile]

  ---Top performing student based on cgpa
   select Student_ID,MAX(Score) AS Top_cgpa from Enrollment2
    GROUP BY Student_ID
	
----Total number of courses
   select count ([Course_code]) AS Total_course from Courses2

----Calculating the CGPA
 ---Adding 'Grade_point' Column (Used to calculate CGPA)
  ALTER TABLE [Grade_Conversion]
  ADD Grade_Point INT
  

---create table Records
  ([Course Title Code] varchar(100),
   [Student ID] varchar(100), 	
   FullName varchar(100),
   Gender char(1), 	
   [Level / Semester] varchar(100),	
   Department varchar(100),
   [Course Code] varchar(100),	
   [Credit Unit] int,
   Score int,
    Grade varchar(50),	
	[Lecturer ID] varchar(100),	
	HireDate date,
	Desgnation varchar(100),
	[Grade Point] int, )

	select *from Records
	select *from [Record 2]



----Calculating the CGPA
 ---Adding 'Grade_Point' Column (Used to calculate CGPA)
  ALTER TABLE Records
  ADD Grade_Point INT
   
---Alter table [Records]
    Drop column Grade_Point2


---Calculating the Values for Grade_Point Column update records

    SELECT Grade_Point  (CASE
    When score BETWEEN 70 AND 100 THEN 5
    When score BETWEEN 60 AND 69 THEN 4
    When score BETWEEN 50 AND 59 THEN 3
	When score BETWEEN 45 AND 49 THEN 2
	When score BETWEEN 40 AND 44 THEN 1

	ELSE 0 
	END

	---Adding CGPA Column
	  ALTER Table [Record 2]
	  ADD CGPA DECIMAL (3,2)

----Calculating CGPA per student
    UPDATE [Record 2]
	SET CGPA = 
	Select CAST([Per_Student])AS DECIMAL (5,2)) / SUM (Credit_unit)
	from [Record 2]

	Select SUM(Grade_Point * Credit_Unit)AS [Per_Student] from [Record 2]
	GROUP BY Grade_Point 

----Descriptive Statistics
    Mean of CGPA
	Select CAST (AVG (CGPA) AS DECIMAL (5,2)AS MEAN_CGPA
	FROM [Record 2]

	-- LEVEL/DEPARTMENTAL PERFORMANCE & ANALYSIS
-- Total Students by Department
    SELECT Department, COUNT(StudentID) AS Total_Students
    FROM [Student Profile]
    GROUP BY Department

	-- Total Lecturers by Department
    SELECT Department, COUNT(LecturerID) AS Total_Lecturers
    FROM Teachers_Profile
    GROUP BY Department

	-- Which Department has the highest Score?
SELECT TOP 1 Department, AVG(Score) AS Avg_Score
FROM [Record 2]
GROUP BY Department
ORDER BY Avg_Score DESC

-- CGPA by Department
SELECT Department, CAST(AVG(CGPA) AS DECIMAL (5,2)) AS Avg_CGPA
FROM [Record 2]
GROUP BY Department
ORDER BY Avg_CGPA DESC

-- CGPA by Level/Semester
SELECT Level_Semester, AVG(CGPA) AS Avg_CGPA
FROM [Record 2]
GROUP BY Level_Semester
ORDER BY Level_Semester

-- CGPA by Gender
SELECT Gender, AVG(CGPA) AS Avg_CGPA
FROM [Record 2]
GROUP BY Gender
ORDER BY Avg_CGPA DESC

-- STUDENTS & LECTURERS PERFORMANCE
-- Top 10 Students with the highest CGPA
SELECT TOP 10 Student_ID, CAST(AVG(CGPA) AS DECIMAL (5,2)) AS Avg_CGPA
FROM [Record 2]
GROUP BY Student_ID
ORDER BY Avg_CGPA DESC

--Top Performing Students in each Department
WITH RankedStudent as (
	SELECT  Department,
			Student_ID,
			CGPA,
			ROW_NUMBER () OVER (PARTITION BY Department ORDER BY CGPA DESC)
			AS Rank
	FROM [Record 2])
	SELECT Department,
			Student_ID,
			CGPA
	FROM RankedStudent
	WHERE Rank = 1;

	--Ranking Lecturers by Avg Score
SELECT TOP 5 Lecturer_ID, AVG(Score) AS Avg_Score
FROM [Record 2]
GROUP BY Lecturer_ID
ORDER BY Avg_Score DESC

-- Course with the Highest Failure Rate
WITH FailureRates AS(
	SELECT Course_Code,
			COUNT(CASE WHEN Score < 45 THEN 1 END)
			AS Failure_rate
	FROM [Record 2]
	GROUP BY Course_Code)
SELECT TOP 1 Course_Code, Failure_rate
FROM FailureRates
ORDER BY Failure_rate DESC


	

  



  

















