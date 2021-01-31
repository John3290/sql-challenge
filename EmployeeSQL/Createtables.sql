--create tables

CREATE TABLE departments (
	dept_no VARCHAR(5) PRIMARY KEY NOT NULL,
	dept_name VARCHAR(100)
);

CREATE TABLE titles (
	title_ID VARCHAR(6) PRIMARY KEY NOT NULL, 
	title VARCHAR(100));
	
CREATE TABLE employees (
	emp_no VARCHAR(6) PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR(6),
	birth_date DATE,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	sex VARCHAR(1),
	hire_date DATE, 
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
	);

CREATE TABLE dept_emp (
	emp_no VARCHAR(6),
	dept_no VARCHAR(5),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no));
	
CREATE TABLE dept_manager (
	dept_no VARCHAR(5),
	emp_no VARCHAR(6),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no));
	
CREATE TABLE salaries (
	emp_no VARCHAR(6),
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no));
	
--List each employees: number, last name, first name, sex, and salary
COPY(SELECT e.emp_no, s.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees e
LEFT JOIN salaries s on e.emp_no = s.emp_no) to 'Users/chilon/Documents/employeesalaries.csv'DELIMITER ',' CSV HEADER;

--list first name, last name, and hire date for employees hired in 1986
SELECT e.emp_no, e.last_name, e.first_name, e.hire_date
from employees e
WHERE EXTRACT(YEAR FROM e.hire_date) = '1986';

--list the managers of each department with: deparment number, department name, manager's employee number, last name, first name
SELECT dm.dept_no, departments.dept_name, dm.emp_no, employees.last_name, employees.first_name
FROM dept_manager dm
INNER JOIN departments ON
dm.dept_no = departments.dept_no
INNER JOIN employees ON
dm.emp_no = employees.emp_no;


--list the department of each employee with: employee number, last name, first name, and department name
SELECT e.emp_no, e.last_name, e.first_name, departments.dept_name
FROM employees e
INNER JOIN dept_manager ON
e.emp_no = dept_manager.emp_no
INNER JOIN departments ON
dept_manager.dept_no = departments.dept_no;

--List first name, last name, and sex for all employees who have the first name of hercules and last names that begin with B

SELECT first_name, last_name, sex 
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--List all employees in the Sales department, their employee number, last name, first name, and department name
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e 
JOIN dept_emp ON
e.emp_no = dept_emp.emp_no
INNER JOIN departments d ON
dept_emp.dept_no = d.dept_no
WHERE dept_name = 'Sales';
--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp ON
e.emp_no = dept_emp.emp_no
INNER JOIN departments AS d ON
dept_emp.dept_no = d.dept_no
WHERE dept_name = 'Sales' OR 
	  dept_name = 'Development';

--In descending order, list the frequency count of employee last names (aka how many employees share each last name)
SELECT last_name, COUNT(last_name) FROM employees
GROUP BY last_name
ORDER BY count(last_name) desc;