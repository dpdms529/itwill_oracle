SELECT * FROM user_tab_privs;

GRANT select ON hr.departments TO insa;

REVOKE SELECT ON hr.departments FROM insa;

-- ���̺� ����, CTAS
-- ���̺� ����, ������, �������� �� NOT NULL �� ����
CREATE TABLE emp
AS
SELECT * FROM hr.employees;

SELECT * FROM hr.emp;

DROP TABLE hr.emp PURGE;

CREATE TABLE emp
AS
SELECT employee_id id, last_name || ' ' || first_name name, salary sal, department_id dept_id FROM hr.employees;

SELECT * FROM hr.emp;

DROP TABLE hr.emp PURGE;

-- ���̺� ������ ����, �����ʹ� ���� X
CREATE TABLE emp
AS
SELECT * FROM hr.employees
WHERE 1 = 2;

SELECT * FROM hr.emp;

SELECT * FROM user_tables WHERE table_name = 'EMP';
SELECT * FROM user_tab_columns WHERE table_name = 'EMP';

-- insert subquery
INSERT INTO hr.emp
SELECT * FROM hr.employees;

SELECT * FROM hr.emp;

COMMIT;

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
(id number,
name varchar2(30),
dept_id number,
dept_name varchar2(30))
TABLESPACE users;

INSERT INTO hr.emp(id, name)
SELECT employee_id, last_name
FROM hr.employees;

COMMIT;

SELECT * FROM hr.emp;

SELECT * FROM hr.emp WHERE id = 100;

UPDATE hr.emp
SET name = null
WHERE id = 100;

COMMIT;

SELECT * FROM hr.emp WHERE id = 100;

-- update subquery
SELECT * FROM hr.emp WHERE id = 100;
SELECT last_name FROM hr.employees WHERE employee_id = 100;

UPDATE hr.emp
SET name = (SELECT last_name FROM hr.employees WHERE employee_id = 100)
WHERE id = 100;

COMMIT;

SELECT * FROM hr.emp WHERE id = 100;

UPDATE hr.emp
SET dept_id = (SELECT department_id FROM hr.employees WHERE employee_id = 100)
WHERE id = 100;

SELECT * FROM hr.emp WHERE id = 100;

ROLLBACK;

UPDATE hr.emp e
SET dept_id = (SELECT department_id 
                FROM hr.employees 
                WHERE employee_id = e.id);
                
SELECT * FROM hr.emp;   

COMMIT;

UPDATE hr.emp e
SET dept_name = (SELECT department_name
                FROM hr.departments 
                WHERE department_id = e.dept_id);

SELECT * FROM hr.emp; 

COMMIT;

-- delete subquery
SELECT employee_id
FROM hr.employees
WHERE hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd');

SELECT *
FROM hr.emp
WHERE id IN (SELECT employee_id
                FROM hr.employees
                WHERE hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
                AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd'));
                
SELECT *
FROM hr.emp e
WHERE exists(SELECT 'x'
                FROM hr.employees
                WHERE employee_id = e.id
                AND hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
                AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd'));
                
DELETE FROM hr.emp
WHERE id IN (SELECT employee_id
                FROM hr.employees
                WHERE hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
                AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd'));
                
ROLLBACK;                
                
DELETE FROM hr.emp e
WHERE exists (SELECT 'x'
                FROM hr.employees
                WHERE employee_id = e.id
                AND hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
                AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd'));
                
ROLLBACK;       

SELECT *
FROM hr.emp
WHERE id IN (SELECT employee_id
                FROM hr.job_history);

DELETE FROM hr.emp               
WHERE id IN (SELECT employee_id
                FROM hr.job_history);                
                
ROLLBACK;                
                
SELECT *
FROM hr.emp e
WHERE exists (SELECT employee_id
                FROM hr.job_history
                WHERE employee_id = e.id);                
                
DELETE FROM hr.emp e
WHERE exists (SELECT employee_id
                FROM hr.job_history
                WHERE employee_id = e.id); 
                
ROLLBACK;           

-- DML ������ : DDL�� ���� ���� ����                
DELETE FROM hr.emp e
WHERE exists (SELECT employee_id
                FROM hr.job_history
                WHERE employee_id = e.id); 
                
SELECT *
FROM hr.emp e
WHERE exists (SELECT employee_id
                FROM hr.job_history
                WHERE employee_id = e.id);         
                
CREATE TABLE hr.test(id number) TABLESPACE users;   

SELECT *
FROM hr.emp e
WHERE exists (SELECT employee_id
                FROM hr.job_history
                WHERE employee_id = e.id);    
                
ROLLBACK;   

SELECT *
FROM hr.emp e
WHERE exists (SELECT employee_id
                FROM hr.job_history
                WHERE employee_id = e.id);  

-- savepoint                
SELECT * FROM hr.test;

INSERT INTO hr.test(id) VALUES(1);
INSERT INTO hr.test(id) VALUES(2);
INSERT INTO hr.test(id) VALUES(3);

COMMIT;

SELECT * FROM hr.test;

-- 1
INSERT INTO hr.test(id) VALUES(100);
SAVEPOINT A;

-- 2
UPDATE hr.test
SET id = 300
WHERE id = 3;
SAVEPOINT B;

SELECT * FROM hr.test;

-- 3
DELETE FROM hr.test WHERE id = 2;

SELECT * FROM hr.test;

ROLLBACK; -- 1, 2, 3 ���� ���
ROLLBACK TO B; -- B ���ķθ� ���

SELECT * FROM hr.test;

COMMIT;

-- ���� ���̺� insert
CREATE TABLE hr.sal_history
(id number, day date, sal number)
TABLESPACE users;

CREATE TABLE hr.mgr_history
(id number, mgr number, sal number)
TABLESPACE users;

INSERT INTO hr.sal_history(id, day, sal)
SELECT employee_id, hire_date, salary
FROM hr.employees;

SELECT * FROM hr.sal_history;

INSERT INTO hr.mgr_history(id, mgr, sal)
SELECT employee_id, manager_id, salary
FROM hr.employees;

SELECT * FROM hr.mgr_history;

ROLLBACK;

-- ������ insert all
INSERT ALL
INTO hr.sal_history(id, day, sal) VALUES(employee_id, hire_date, salary)
INTO hr.mgr_history(id, mgr, sal) VALUES(employee_id, manager_id, salary)
SELECT employee_id, hire_date, manager_id, salary
FROM hr.employees;

SELECT * FROM hr.sal_history;
SELECT * FROM hr.mgr_history;

ROLLBACK;

INSERT ALL
INTO hr.sal_history(id, day, sal) VALUES(no, hire, sal)
INTO hr.mgr_history(id, mgr, sal) VALUES(no, mgr_id, sal)
SELECT employee_id no, hire_date hire, manager_id mgr_id, salary*1.1 sal
FROM hr.employees;

SELECT * FROM hr.sal_history;
SELECT * FROM hr.mgr_history;

ROLLBACK;


-- ���� insert all
CREATE TABLE hr.emp_history
(id number, day date, sal number)
TABLESPACE users;

CREATE TABLE hr.emp_sal
(id number, comm number, sal number)
TABLESPACE users;

SELECT * FROM hr.emp_history;
SELECT * FROM hr.emp_sal;

SELECT employee_id id, hire_date day, salary sal, commission_pct comm
FROM hr.employees;

INSERT ALL
WHEN day < to_date('2005-01-01', 'yyyy-mm-dd') AND sal >= 5000 THEN
    INTO hr.emp_history(id, day, sal) VALUES (id, day, sal)
WHEN comm IS NOT NULL THEN
    INTO hr.emp_sal(id, comm, sal) VALUES(id, comm, sal)
SELECT employee_id id, hire_date day, salary sal, commission_pct comm
FROM hr.employees;

SELECT * FROM hr.emp_history;
SELECT * FROM hr.emp_sal;

ROLLBACK;

-- insert first
CREATE TABLE hr.sal_low
(id number, name varchar2(30), sal number)
TABLESPACE users;

CREATE TABLE hr.sal_mid
(id number, name varchar2(30), sal number)
TABLESPACE users;

CREATE TABLE hr.sal_high
(id number, name varchar2(30), sal number)
TABLESPACE users;

SELECT employee_id, last_name, salary
FROM hr.employees;

INSERT FIRST
WHEN salary < 5000 THEN
    INTO hr.sal_low(id, name, sal) VALUES(employee_id, last_name, salary)
WHEN salary BETWEEN 5000 AND 10000 THEN
    INTO hr.sal_mid(id, name, sal) VALUES(employee_id, last_name, salary)
ELSE
    INTO hr.sal_high(id, name, sal) VALUES(employee_id, last_name, salary)
SELECT employee_id, last_name, salary
FROM hr.employees;

SELECT * FROM hr.sal_low; -- 49
SELECT * FROM hr.sal_mid; -- 43
SELECT * FROM hr.sal_high; -- 15

ROLLBACK;

INSERT ALL
WHEN salary < 5000 THEN
    INTO hr.sal_low(id, name, sal) VALUES(employee_id, last_name, salary)
WHEN salary <= 10000 THEN
    INTO hr.sal_mid(id, name, sal) VALUES(employee_id, last_name, salary)
ELSE
    INTO hr.sal_high(id, name, sal) VALUES(employee_id, last_name, salary)
SELECT employee_id, last_name, salary
FROM hr.employees;

SELECT * FROM hr.sal_low; -- 49
SELECT * FROM hr.sal_mid; -- 43
SELECT * FROM hr.sal_high; --15

ROLLBACK;

-- ���� ȯ�� ����
CREATE TABLE hr.oltp_emp
AS
SELECT employee_id, last_name, salary, department_id
FROM hr.employees;

SELECT * FROM hr.oltp_emp;

CREATE TABLE hr.dw_emp
AS
SELECT employee_id, last_name, salary, department_id
FROM hr.employees
WHERE department_id = 20;

SELECT * FROM hr.dw_emp;

desc hr.oltp_emp

-- ���� ���̺� �÷� �߰�
ALTER TABLE hr.oltp_emp ADD flag char(1);

desc hr.oltp_emp

SELECT * FROM hr.oltp_emp;

SELECT * FROM hr.oltp_emp WHERE employee_id IN (201, 202);

UPDATE hr.oltp_emp
SET flag = 'd'
WHERE employee_id = 202;

UPDATE hr.oltp_emp
SET salary = 20000
WHERE employee_id = 201;

COMMIT;

SELECT * FROM hr.oltp_emp WHERE employee_id IN (201, 202);

-- [����47] oltp_emp�� �ִ� ����� �߿� dw_emp�� �����ϴ� ��� ������ ������ּ���.
SELECT *
FROM hr.oltp_emp o
WHERE exists (SELECT 'x'
                FROM hr.dw_emp
                WHERE employee_id = o.employee_id);

-- [����48] dw_emp�� �ִ� ����� �߿� oltp_emp�� �����ϴ� ������� oltp_emp�� �ִ� �޿��� �������� 10% �λ����ּ���. �׽�Ʈ�� �� rollback �����ϼ���.
UPDATE hr.dw_emp d
SET salary = (SELECT salary
                FROM hr.oltp_emp
                WHERE employee_id = d.employee_id) * 1.1;
                
SELECT d.employee_id dw_id, d.salary dw_sal, o.employee_id oltp_id, o.salary oltp_sal
FROM hr.dw_emp d, hr.oltp_emp o
WHERE d.employee_id = o.employee_id;

ROLLBACK;

-- [����49] dw_emp�� �ִ� ����� �߿� oltp_emp�� �����ϴ� ������߿� flag���� 'd'�� ����� ���ؼ� ������ �ּ���.�׽�Ʈ�� �� rollback �����ϼ���.
DELETE FROM hr.dw_emp d
WHERE exists (SELECT 'x'
                FROM hr.oltp_emp
                WHERE employee_id = d.employee_id
                AND flag = 'd');
                
SELECT d.employee_id dw_id, o.employee_id oltp_id, o.flag
FROM hr.dw_emp d, hr.oltp_emp o
WHERE d.employee_id = o.employee_id;         

ROLLBACK;

-- [����50] oltp_emp���̺� �ִ� ������ �߿� dw_emp ���̺� ���� �����͵��� dw_emp���̺� �Է����ּ���.
INSERT INTO hr.dw_emp(employee_id, last_name, salary, department_id)
SELECT employee_id, last_name, salary, department_id 
FROM hr.oltp_emp o
WHERE not exists (SELECT 'x'
                    FROM hr.dw_emp
                    WHERE employee_id = o.employee_id);                   
                    
SELECT *
FROM hr.dw_emp d
WHERE not exists (SELECT 'x' FROM hr.oltp_emp);

ROLLBACK;