-- null
SELECT 
	employee_id, 
	salary, 
	commission_pct, 
	salary * 12 + salary * 12 * commission_pct
FROM hr.employees;

-- nvl
SELECT 
	employee_id, 
	salary, 
	nvl(commission_pct, 0), 
	salary * 12 + salary * 12 * nvl(commission_pct, 0)
FROM hr.employees;

-- ��Ī
SELECT 
	employee_id ���, 
	salary �޿�, 
	nvl(commission_pct, 0) ���ʽ�, 
	salary * 12 + salary * 12 * nvl(commission_pct, 0) as annual_salary
FROM hr.employees;

-- ���� ������
SELECT
    employee_id,
    last_name || first_name
FROM hr.employees;

SELECT
    1000,
    100||00
FROM dual;

SELECT
    1000,
    100||'00'
FROM dual;

SELECT
    last_name,
    salary,
    salary || 00
FROM hr.employees;

desc hr.employees;

-- ���ͷ� ���ڿ�
SELECT
    employee_id,
    'My Name is ' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
    employee_id,
    'My Name''s ' || last_name || ' ' || first_name "Name"
FROM hr.employees;

-- q(��ü �ο�) ������
SELECT
	employee_id,
	q'[My name's ]' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'<My name's >' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'{My name's }' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'(My name's )' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'!My name's !' || last_name || ' ' || first_name "Name"
FROM hr.employees;

-- �ߺ��� ����
SELECT
    department_id
FROM hr.employees;

SELECT
    unique department_id
FROM hr.employees;

SELECT
    distinct department_id
FROM hr.employees;

SELECT
    distinct department_id, job_id
FROM hr.employees;

-- [����1] employees ���̺��� employee_id, last_name�� first_name�� �����ؼ� ǥ���ϰ�(�������� ����) �� ��Ī�� ȭ�� ��ó�� �������� �ۼ��� �ּ���.
SELECT employee_id "Emp#", last_name || ' ' || first_name "Employee Name"
FROM hr.employees;

/*
<ȭ����>
Emp#   Employee Name
------- ------------------------------
100 	   King Steven
101 	   Kochhar Neena
*/


-- [����2] employees ���̺��� �÷��߿� last_name, job_id�� �����ؼ� ǥ���ϰ�(��ǥ�� �������� ����) �� ��Ī�� ȭ�� ��ó�� �������� �ۼ��� �ּ���.
SELECT last_name || ', ' || job_id "Employee and Title"
FROM hr.employees;

/*
<ȭ����>
Employee and Title
-------------------------
Abel, SA_REP
Ande, SA_REP
*/

-- [����3] departments ���̺� �ִ� �����Ϳ��� department_name , manager_id Į���� ������ ȭ�� ���ó�� ����ϴ� �������� �ۼ��� �ּ���.
SELECT department_name || q'[ Department's Manager Id: ]' ||  manager_id "Department and Manager"
FROM hr.departments;

/*
<ȭ����>
Department and Manager
--------------------------------------------------				
Administration Department's Manager Id: 200
Marketing Department's Manager Id: 201
......
*/

SELECT *
FROM hr.employees
WHERE last_name = 'King';

-- ����� ������ �Ǽ� ����
SELECT *
FROM hr.employees
WHERE UPPER(last_name) = 'King';

-- ��¥��
desc hr.employees;

SELECT *
FROM hr.employees
WHERE hire_date = '01/01/13';

SELECT *
FROM hr.employees
WHERE hire_date = '2001-01-13';

SELECT *
FROM hr.employees
WHERE hire_date = '13-Jan-01';

SELECT *
FROM hr.employees
WHERE hire_date = to_date('2001-01-13', 'yyyy-mm-dd');

SELECT *
FROM hr.employees
WHERE hire_date = to_date('20010113', 'yyyymmdd');

-- ������ ���� ��ȸ
SELECT * FROM nls_session_parameters;

-- �� ������
SELECT *
FROM hr.employees
WHERE employee_id = 100;

SELECT *
FROM hr.employees
WHERE employee_id <> 100;

SELECT *
FROM hr.employees
WHERE employee_id != 100;

SELECT *
FROM hr.employees
WHERE employee_id ^= 100;

SELECT *
FROM hr.employees
WHERE employee_id > 100;

SELECT *
FROM hr.employees
WHERE employee_id >= 100;

SELECT *
FROM hr.employees
WHERE employee_id < 100;

SELECT *
FROM hr.employees
WHERE employee_id <= 100;

-- �� ������
SELECT *
FROM hr.employees
WHERE department_id = 50
AND salary >= 5000;

-- [����4] employees ���̺��� �޿��� 2500 ~ 3500 �� ������� last_name, salary�� ������ּ���.
SELECT last_name, salary
FROM hr.employees
WHERE salary >= 2500
AND salary <= 3500;

SELECT last_name, salary
FROM hr.employees
WHERE salary BETWEEN 2500 AND 3500;

-- [����5] employees ���̺��� �޿��� 2500 ~ 3500 �� �ƴ� ������� last_name, salary�� ������ּ���.
SELECT last_name, salary
FROM hr.employees
WHERE salary < 2500
OR salary > 3500;

SELECT last_name, salary
FROM hr.employees
WHERE NOT (salary >= 2500
AND salary <= 3500);

SELECT last_name, salary
FROM hr.employees
WHERE salary NOT BETWEEN 2500 AND 3500;

-- ���ڿ� ��
SELECT *
FROM hr.employees
WHERE last_name >= 'Abel'
AND last_name <= 'Austin';

SELECT *
FROM hr.employees
WHERE last_name BETWEEN 'Abel' AND 'Austin';

-- [����6] employees ���̺��� hire_date(�Ի���) 2001(01) ~ 2002(02)�⵵�� �Ի��� ��� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE hire_date >= TO_DATE('20010101', 'yyyymmdd')
AND hire_date < TO_DATE('20031231 23:59:59', 'yyyymmdd hh24:mi:ss');

SELECT *
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20010101', 'yyyymmdd') AND TO_DATE('20031231 23:59:59', 'yyyymmdd hh24:mi:ss');

SELECT *
FROM hr.employees
WHERE hire_date >= TO_DATE('20010101', 'yyyymmdd')
AND hire_date < TO_DATE('20030101', 'yyyymmdd');

SELECT *
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20010101', 'yyyymmdd') AND TO_DATE('20030101', 'yyyymmdd') - 1/24/60/60;

-- IN ������
SELECT *
FROM hr.employees
WHERE employee_id = 100
OR employee_id = 105
OR employee_id = 200;

SELECT *
FROM hr.employees
WHERE employee_id IN(100, 105, 200);

SELECT *
FROM hr.employees
WHERE employee_id NOT IN(100, 105, 200);

SELECT *
FROM hr.employees
WHERE employee_id <> 100
AND employee_id <> 105
AND employee_id <> 200;

-- �� ������ �켱 ����
SELECT *
FROM hr.employees
WHERE department_id = 30
OR department_id = 50
OR department_id = 60
AND salary > 5000;

SELECT *
FROM hr.employees
WHERE (department_id = 30
OR department_id = 50
OR department_id = 60)
AND salary > 5000;

SELECT *
FROM hr.employees
WHERE department_id IN (30, 50, 60)
AND salary > 5000;

-- NULL �� üũ ������
SELECT *
FROM hr.employees
WHERE commission_pct IS NULL;

SELECT *
FROM hr.employees
WHERE commission_pct IS NOT NULL;

-- LIKE ������
SELECT *
FROM hr.employees
WHERE last_name LIKE 'K%';

SELECT *
FROM hr.employees
WHERE last_name LIKE '_i%';

SELECT *
FROM hr.employees
WHERE last_name LIKE '__e%';

SELECT *
FROM hr.employees
WHERE hire_date LIKE '02%';

-- JOB_ID �� �߿� HR%�� ���۵Ǵ� ������ �����ؾ��Ѵٸ�?
-- %�� ������ ���ڷ� �˻��ؾ� �� ���
SELECT *
FROM hr.employees
WHERE job_id LIKE 'HR^%%' ESCAPE '^';

-- [����7] employees ���̺� �ִ� ������ �߿� job_id�� SA�� ���۵ǰ� salary ���� 10000�̻� �޴� ������� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE job_id LIKE 'SA%'
AND salary >= 10000;

-- [����8] last_name�� ����° ���ڰ� 'a' �Ǵ� 'e' ���ڰ� ���Ե� ������� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE last_name LIKE '__a%'
OR last_name LIKE '__e%';

SELECT *
FROM hr.employees
WHERE REGEXP_LIKE(last_name, '^..[ae]');