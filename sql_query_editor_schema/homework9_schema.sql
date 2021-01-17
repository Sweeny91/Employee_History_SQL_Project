-- Link to schema: https://app.quickdatabasediagrams.com/#/d/zCVBoS
-- Note: All CSVs were manually imported using pgAdmin


-- Table Schemata:

DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS dept_emp CASCADE;
DROP TABLE IF EXISTS dept_manager CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS titles CASCADE;

-- Create "titles" table

CREATE TABLE "titles" (
    "title_id" VARCHAR(6) NOT NULL,
    "title" VARCHAR(30) NOT NULL,
	PRIMARY KEY (title_id)
);

-- Create "departments" table

CREATE TABLE "departments" (
    "dept_no" VARCHAR(5) NOT NULL,
    "dept_name" VARCHAR(30) NOT NULL,
	PRIMARY KEY (dept_no)
);

-- Create "employees" table

CREATE TABLE "employees" (
    "emp_no" INT NOT NULL,
    "emp_title_id" VARCHAR(6) NOT NULL,
    "birth_date" DATE NOT NULL,
    "first_name" VARCHAR(30) NOT NULL,
    "last_name" VARCHAR(30) NOT NULL,
    "sex" VARCHAR(2) NOT NULL,
    "hire_date" DATE NOT NULL,
   	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

-- Create "department/manager" table

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(5) NOT NULL,
    "emp_no" INT NOT NULL,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Create "department/employee" table

CREATE TABLE "dept_emp" (
    "emp_no" INT NOT NULL,
    "dept_no" VARCHAR(5) NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Create "salaries" table

CREATE TABLE "salaries" (
    "emp_no" INT NOT NULL,
    "salary" INT NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Query created tables for correctness 

SELECT * FROM departments
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM titles

-- DATA ANALYSIS

-- Query 1.) List the following for each employee: "Employee Number", "Last Name", "First Name", "Sex", and "Salary".
--
SELECT e.emp_no, e.last_name, e.first_name, e.sex,
s.salary
FROM employees e
INNER JOIN salaries s ON
e.emp_no = s.emp_no;

-- Query 2.) List the "First Name", "Last Name", and "Hire Date" for employees hired in 1986.
--
SELECT last_name, first_name, hire_date FROM employees
WHERE hire_date >= '1986-1-1' AND hire_date <= '1986-12-31';

-- Query 3.) List the Manager of each department with the following information: 
-- 			 "Last Name", "First Name", "Department Number", "Department Name", & "Manager Employee Number".
--
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM dept_manager dm
INNER JOIN departments d ON
dm.dept_no = d.dept_no
INNER JOIN employees e ON
dm.emp_no = e.emp_no;

-- Query 4.) List the department of each employee with the following information: 
-- 			 "Employee Number", "Last Name", "First Name", and "Department Name".
--
SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employees e
INNER JOIN dept_emp de ON
e.emp_no = de.emp_no
INNER JOIN departments d ON
de.dept_no = d.dept_no;

-- Query 5.) List the "First Name", "Last Name", and "Sex" for Employees where:
-- 			 First Name = "Hercules" and Last Names start with "B".
--
SELECT first_name, last_name, sex
FROM employees
Where first_name = 'Hercules'
AND LEFT(last_name, 1) = 'B'

-- Query 6.) List all Employees in the Sales department, with: 
-- 			 "Employee Number", "Last Name", "First Name", and "Department Name".
--
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
INNER JOIN dept_emp de ON
e.emp_no = de.emp_no
INNER JOIN departments d ON
de.dept_no = d.dept_no
WHERE dept_name = 'Sales';

-- Query 7.) List all employees in the Sales and Development departments, with: 
-- 			 "Employee Number", "Last Name", "First Name", and "Department Name".
--
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
INNER JOIN dept_emp de ON
e.emp_no = de.emp_no
INNER JOIN departments d ON
de.dept_no = d.dept_no
WHERE dept_name = 'Development'
OR dept_name = 'Sales';

-- Query 8.) List the count of occurances of each of the different employee last names, in descending order.
--
SELECT last_name, COUNT (last_name)
FROM employees
GROUP BY last_name
ORDER BY last_name desc;
