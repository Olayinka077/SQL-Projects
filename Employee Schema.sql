Employment Participation Schema
create by Okanlawon Olayinka Sukurat
On 12th February, 2025

-- Create Department Table
CREATE TABLE Department (
    Num_S INT PRIMARY KEY,
    Label VARCHAR(255) NOT NULL,
    Manager_Name VARCHAR(255) NOT NULL);
	select *from Department

	-- Create Employee Table
CREATE TABLE Employee (
    Num_E INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Position VARCHAR(255) NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Department_Num_S INT,
    FOREIGN KEY (Department_Num_S) REFERENCES Department(Num_S) ON DELETE SET NULL);
	select * from Employee

-- Create Project Table
CREATE TABLE Project (
    Num_P INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Department_Num_S INT,
    FOREIGN KEY (Department_Num_S) REFERENCES Department(Num_S) ON DELETE SET NULL);

	-- Create Employee_Project Table (Tracks employee roles in projects)
CREATE TABLE Employee_Project (
    Employee_Num_E INT,
    Project_Num_P INT,
    Role VARCHAR(255) NOT NULL,
    PRIMARY KEY (Employee_Num_E, Project_Num_P),
    FOREIGN KEY (Employee_Num_E) REFERENCES Employee(Num_E) ON DELETE CASCADE,
    FOREIGN KEY (Project_Num_P) REFERENCES Project(Num_P) ON DELETE CASCADE);
	select *
