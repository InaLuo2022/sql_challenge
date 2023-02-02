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
