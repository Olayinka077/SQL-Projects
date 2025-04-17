

-- Create the Department table
CREATE TABLE Department (
    Num_S INT PRIMARY KEY,                             -- Primary Key
    Label VARCHAR(255) NOT NULL,                       -- Department Name
    Manager_Name VARCHAR(255) NOT NULL                 -- Name of the Department Manager
);

-- Create the Employee table
CREATE TABLE Employee (
    Num_E INT PRIMARY KEY,                                      -- Employee ID (Primary Key)
    Name VARCHAR(255) NOT NULL,                                 -- Employee Name
    Position VARCHAR(255) NOT NULL,                             -- Employee Position
    Salary DECIMAL(10,2) CHECK (Salary >= 0),                   -- Salary must be non-negative
    Department_Num_S INT,                                       -- Foreign Key for Department
    CONSTRAINT fk_employee_department 
    FOREIGN KEY (Department_Num_S) 
    REFERENCES Department(Num_S) ON DELETE SET NULL
);

-- Create the Project table
CREATE TABLE Project (
    Num_P INT PRIMARY KEY,                                                              -- Project ID (Primary Key)
    Title VARCHAR(255) NOT NULL,                                                        -- Project Title
    Start_Date DATE NOT NULL,                                                           -- Start Date of Project
    End_Date DATE,                                                                      -- End Date of Project
    Department_Num_S INT,                                                               -- Foreign Key for Department
    CONSTRAINT fk_project_department 
    FOREIGN KEY (Department_Num_S) 
    REFERENCES Department(Num_S) ON DELETE SET NULL,
    CONSTRAINT chk_project_dates CHECK (End_Date IS NULL OR End_Date >= Start_Date)     -- Ensures End Date is after Start Date
);

-- Create the Employee_Project table (tracks employee participation in projects)
CREATE TABLE Employee_Project (
    Employee_Num_E INT,                                                                  -- Foreign Key for Employee
    Project_Num_P INT,                                                                   -- Foreign Key for Project
    Role VARCHAR(255) NOT NULL,                                                          -- Employee role in project
    CONSTRAINT pk_employee_project PRIMARY KEY (Employee_Num_E, Project_Num_P),          -- Composite Primary Key
    CONSTRAINT fk_employee_project_emp FOREIGN KEY (Employee_Num_E) REFERENCES Employee(Num_E) ON DELETE CASCADE,
    CONSTRAINT fk_employee_project_proj FOREIGN KEY (Project_Num_P) REFERENCES Project(Num_P) ON DELETE CASCADE
	);

	--Key Features of This Script
    Primary Keys (PRIMARY KEY): Ensures unique identification of records in each table.
    Foreign Keys (FOREIGN KEY): Establishes relationships between tables for referential integrity.
    Constraints (CHECK, NOT NULL, ON DELETE SET NULL, ON DELETE CASCADE):
    Salary must be non-negative.
    Start Date must be before or equal to End Date.
    If a referenced department is deleted, related employees and projects will have NULL in Department_Num_S.
    If an employee or project is deleted, all related entries in Employee_Project are automatically removed.

	-- Insert data into Department table
INSERT INTO Department (Num_S, Label, Manager_Name) VALUES
(1, 'Engineering', 'Alice Johnson'),
(2, 'Marketing', 'Bob Smith'),
(3, 'Finance', 'Charlie Davis');
select * from Department

-- Insert data into Employee table
INSERT INTO Employee (Num_E, Name, Position, Salary, Department_Num_S) VALUES
(101, 'David Wilson', 'Software Engineer', 75000.00, 1),
(102, 'Emma Brown', 'Marketing Manager', 82000.00, 2),
(103, 'Frank White', 'Financial Analyst', 67000.00, 3),
(104, 'Grace Adams', 'Software Developer', 72000.00, 1),
(105, 'Henry Scott', 'Marketing Specialist', 60000.00, 2);
select * from Employee

-- Insert data into Project table
INSERT INTO Project (Num_P, Title, Start_Date, End_Date, Department_Num_S) VALUES
(201, 'AI Research', '2024-01-01', '2024-12-31', 1),
(202, 'Social Media Strategy', '2024-02-15', '2024-08-15', 2),
(203, 'Investment Analysis', '2024-03-01', '2024-09-30', 3);
select * from Project

-- Insert data into Employee_Project table
INSERT INTO Employee_Project (Employee_Num_E, Project_Num_P, Role) VALUES
(101, 201, 'Lead Developer'),
(104, 201, 'Software Engineer'),
(102, 202, 'Project Coordinator'),
(105, 202, 'Marketing Analyst'),
(103, 203, 'Financial Analyst');
select * from Employee_Project

---What This Script Does
   Populates the Department table with 3 departments: Engineering, Marketing, and Finance.
   Populates the Employee table with 5 employees across different departments.
   Populates the Project table with 3 projects assigned to various departments.
   Populates the Employee_Project table with employees participating in different projects, each assigned a role.


--list of every employee along with the name of their department
Query:

SELECT 
    e.Num_E AS EmployeeID,
    e.Name AS EmployeeName,
    e.Position,
    d.Label AS DepartmentName
FROM Employee e
JOIN Department d ON e.Department_Num_S = d.Num_S;

---Find Employees Participating in Multiple Projects
Question:
"Which employees are involved in more than one project?"
Query:
SELECT 
    Employee_Num_E,
    COUNT(Project_Num_P) AS ProjectCount
    FROM Employee_Project
    GROUP BY Employee_Num_E
    HAVING COUNT(Project_Num_P) > 1;

---Get the Total Salary Expense per Department
Question:
"How much is each department spending on salaries?"
Query:
SELECT 
    d.Label AS DepartmentName,
    SUM(e.Salary) AS TotalSalaryExpense
    FROM Employee e
    JOIN Department d ON e.Department_Num_S = d.Num_S
    GROUP BY d.Label;

---Show Details of Projects and Their Assigned Department
Question:
"Can I view each project along with the department responsible for it?"
Query:
SELECT 
    p.Num_P AS ProjectID,
    p.Title AS ProjectTitle,
    p.Start_Date,
    p.End_Date,
    d.Label AS DepartmentName
    FROM Project p
    JOIN Department d ON p.Department_Num_S = d.Num_S;

---List Employee Participation Details in Projects
Question:
"Which employees are working on which projects, and what are their roles?"
Query:
SELECT 
    e.Num_E AS EmployeeID,
    e.Name AS EmployeeName,
    p.Num_P AS ProjectID,
    p.Title AS ProjectTitle,
    ep.Role AS EmployeeRole
    FROM Employee_Project ep
    JOIN Employee e ON ep.Employee_Num_E = e.Num_E
    JOIN Project p ON ep.Project_Num_P = p.Num_P;

---Find Projects That Have Not Ended Yet
Question:
"Which projects are still in progress or have not yet ended?"
Query:
SELECT 
    Num_P AS ProjectID,
    Title AS ProjectTitle,
    Start_Date,
    End_Date
    FROM Project
    WHERE End_Date IS NULL OR End_Date >= GETDATE();

(Note: GETDATE() is used in SQL Server to get the current date.)

---Identify Departments with No Employees Assigned
Question:
"Which departments currently do not have any employees?"
Query:

SELECT 
    d.Num_S AS DepartmentID,
    d.Label AS DepartmentName
    FROM Department d
    LEFT JOIN Employee e ON d.Num_S = e.Department_Num_S
    WHERE e.Num_E IS NULL;

---Count How Many Employees Are in Each Department
Question:
"How many employees does each department have?"
Query:
SELECT 
    d.Label AS DepartmentName,
    COUNT(e.Num_E) AS EmployeeCount
    FROM Department d
    LEFT JOIN Employee e ON d.Num_S = e.Department_Num_S
    GROUP BY d.Label;

---List Employees Who Earn More Than a Specific Amount
Question:
"Can I list all employees earning more than, say, $70,000?"
Query:
SELECT 
    Num_E AS EmployeeID,
    Name AS EmployeeName,
    Salary
    FROM Employee
    WHERE Salary > 70000;

---Get a Summary of Each Employee’s Project Participation Count
Question:
"For each employee, how many projects are they working on?"
Query:
SELECT 
    e.Num_E AS EmployeeID,
    e.Name AS EmployeeName,
    COUNT(ep.Project_Num_P) AS NumberOfProjects
    FROM Employee e
    LEFT JOIN Employee_Project ep ON e.Num_E = ep.Employee_Num_E
    GROUP BY e.Num_E, e.Name;


















