select * from user_users;

SELECT *
FROM hr.employees;

SELECT *
FROM employees;

SELECT *
FROM hr.employees
WHERE employee_id = 100;

SELECT /*+ full(e) */ *
FROM hr.employees e
WHERE employee_id = 100;

desc hr.employees;

SELECT salary, salary * 12
FROM hr.employees;

SELECT hire_date, hire_date + 100, hire_date - 100
FROM hr.employees;