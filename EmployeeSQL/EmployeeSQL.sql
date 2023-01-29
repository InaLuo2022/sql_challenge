-- Create tables, import tables and set primary and foreign keys
-- Table: public.departments

DROP TABLE IF EXISTS public.departments;

CREATE TABLE public.departments
(
    dept_no character varying(255) NOT NULL,
    dept_name character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT departments_pkey PRIMARY KEY (dept_no)
)

SELECT * FROM departments

---- Table: public.titles
DROP TABLE IF EXISTS public.titles;

CREATE TABLE public.titles
(
   title_id character varying(255) NOT NULL,
   title character varying(255) NOT NULL,
   CONSTRAINT titless_pkey PRIMARY KEY (title_id)
)

SELECT * FROM titles;

-- Table: public.employees

DROP TABLE IF EXISTS public.employees;

CREATE TABLE public.employees
(
   emp_no character varying(255) NOT NULL,
   emp_title_id character varying(255) NOT NULL,
   birth_date date NOT NULL, 
   first_name character varying(255) NOT NULL,
   last_name character varying(255) NOT NULL,
   sex character varying(255) NOT NULL,
   hire_date date NOT NULL,
   CONSTRAINT employees_pkey PRIMARY KEY (emp_no),
   CONSTRAINT employees_fkey FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
)

SELECT * FROM employees

ALTER SYSTEM SET datestyle TO 'ISO, MDY';

SELECT * FROM employees;

-- Table: public.dept_emp

DROP TABLE IF EXISTS public.dept_emp;

CREATE TABLE public.dept_emp
(
    emp_no character varying(255) NOT NULL,
    dept_no character varying(255) NOT NULL,
	CONSTRAINT dept_emp_pkey PRIMARY KEY (emp_no,dept_no),
	CONSTRAINT dept_emp_emp_fkey FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    CONSTRAINT dept_emp_dept_fkey FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
)

SELECT * FROM dept_emp

-- Table: public.dept_manager

DROP TABLE IF EXISTS public.dept_manager;

CREATE TABLE public.dept_manager
(
   dept_no character varying(255) NOT NULL,
   emp_no character varying(255) NOT NULL,
   CONSTRAINT dept_no_fkey FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
   CONSTRAINT emp_no_fkey FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)

SELECT * FROM dept_manager

ALTER TABLE dept_manager ADD COLUMN dept_manager_id SERIAL PRIMARY KEY

SELECT * FROM dept_manager

---- Table: public.salaries

DROP TABLE IF EXISTS public.salaries;

CREATE TABLE public.salaries
(
   emp_no character varying(255) NOT NULL,
   salary character varying(255) NOT NULL,
   CONSTRAINT salaries_pkey PRIMARY KEY (emp_no)
)

SELECT * FROM salaries;

-- Data Analysis
-- 1. List the employee number, last name, first name, sex, and salary of each employee.

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
    FROM employees, salaries
    WHERE employees.emp_no = salaries.emp_no
	ORDER BY employees.emp_no

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT employees.first_name, employees.last_name, employees.hire_date
	FROM employees
	WHERE employees.hire_date >=  '1986-01-01' AND employees.hire_date <=  '1986-12-30'
	ORDER BY employees.hire_date
	
-- 3. List the manager of each department along with their department number, department name, 
--    employee number, last name, and first name.

SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
	FROM dept_manager, departments, employees
	WHERE dept_manager.dept_no = departments.dept_no AND dept_manager.emp_no = employees.emp_no
	ORDER BY dept_manager.dept_no

-- 4. List the department number for each employee along with that employee’s employee number, 
--    last name, first name, and department name.

SELECT dept_emp.dept_no, departments.dept_name, dept_emp.emp_no, employees.last_name, employees.first_name
    FROM dept_emp, departments, employees
	WHERE dept_emp.dept_no = departments.dept_no AND dept_emp.emp_no = employees.emp_no
	ORDER BY dept_emp.dept_no

-- 5. List the first name, last name, and sex of each employee whose first name is Hercules and 
-- whose last name begins with the letter B.

SELECT employees.first_name, employees.last_name, employees.sex
	FROM employees
	WHERE employees.first_name = 'Hercules' AND LEFT(employees.last_name,1) = 'B'
	ORDER BY employees.emp_no

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.

SELECT dept_emp.dept_no, departments.dept_name, dept_emp.emp_no, employees.last_name, employees.first_name
	FROM dept_emp, departments, employees
	WHERE departments.dept_name = 'Sales' AND dept_emp.dept_no = departments.dept_no AND employees.emp_no = dept_emp.emp_no
	ORDER BY employees.emp_no ASC
	
-- 7. List each employee in the Sales and Development departments, including their employee number, 
-- last name, first name, and department name.

SELECT dept_emp.dept_no, departments.dept_name, dept_emp.emp_no, employees.last_name, employees.first_name
	FROM dept_emp, departments, employees
	WHERE (departments.dept_name = 'Sales' AND dept_emp.dept_no = departments.dept_no AND employees.emp_no = dept_emp.emp_no)
	OR (departments.dept_name = 'Development' AND dept_emp.dept_no = departments.dept_no AND employees.emp_no = dept_emp.emp_no)
	ORDER BY (dept_emp.dept_no, dept_emp.emp_no) DESC
	
-- 8. List the frequency counts, in descending order, of all the employee last names 
-- (that is, how many employees share each last name).

SELECT employees.last_name,
		count(employees.last_name)
		FROM employees
		GROUP BY employees.last_name
		ORDER BY employees.last_name DESC
