-- [����9] employees ���̺� �ִ� ������ �߿� job_id�� SA�� ���۵ǰ� salary ���� 10000�̻� �ް� 2005�⵵�� �Ի���(hire_date)
-- ������� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE job_id LIKE 'SA%'
AND salary >= 10000
AND hire_date BETWEEN TO_DATE('20050101', 'yyyymmdd') AND TO_DATE('20060101', 'yyyymmdd') - 1/24/60/60;

-- [����10] employees���̺��� job_id �� SA_REP �Ǵ� AD_PRES ����� �߿� salary���� 10000 �ʰ��� ������� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE job_id in ('SA_REP', 'AD_PRES')
AND salary > 10000;

SELECT *
FROM hr.employees
WHERE (job_id = 'SA_REP'
OR job_id = 'AD_PRES')
AND salary > 10000;

SELECT * FROM nls_session_parameters;

-- ����
-- �������� ����
SELECT employee_id, last_name, salary
FROM hr.employees
ORDER BY salary;

SELECT employee_id, last_name, salary
FROM hr.employees
ORDER BY salary ASC;

-- �������� ����
SELECT employee_id, last_name, salary
FROM hr.employees
ORDER BY salary DESC;

-- ǥ���� ��� ����
SELECT employee_id, last_name, salary, salary * 12
FROM hr.employees
ORDER BY salary * 12;

-- �� ��Ī ��� ����
SELECT employee_id, last_name, salary, salary * 12 annual_salary
FROM hr.employees
ORDER BY annual_salary;

-- �� ��Ī ���� ������ : ū ����ǥ ����� ��� �����ϰ� ū ����ǥ ����ؾ� ��
SELECT employee_id, last_name, salary, salary * 12 "annual_salary"
FROM hr.employees
ORDER BY "annual_salary";

-- ��ġ ǥ��� ���
SELECT employee_id, last_name, salary, salary * 12 annual_salary
FROM hr.employees
ORDER BY 4;

-- ���� ���� �÷� ���� �� ��� ����
SELECT employee_id, last_name, department_id, salary * 12 annual_salary
FROM hr.employees
ORDER BY 3 ASC, 4 DESC;

-- [����11] 2006�⵵ �Ի��� ����� employee_id, last_name, hire_date�� ������ּ��� �� last_name �̸��� �������� ������������ ���ּ���.
SELECT employee_id, last_name, hire_date
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20060101', 'yyyymmdd') AND TO_DATE('20070101', 'yyyymmdd') - 1/24/60/60
ORDER BY last_name;

-- [����12] 80�� department_id ����߿� commission_pct ���� 0.2 �̰� job_id�� SA_MAN�� ����� employee_id, last_name, salary�� ������ּ���.
-- �� last_name �̸��� �������� �������������� �ּ���.
SELECT employee_id, last_name, salary
FROM hr.employees
WHERE department_id = 80
AND commission_pct = 0.2
AND job_id = 'SA_MAN'
ORDER BY last_name;

-- [����13] salary�� 5000 ~ 12000�� ������ ������ �ʴ� ��� ����� last_name �� salary�� ������ּ���. �� salary�� �������� �������� �����ϼ���.
SELECT last_name, salary
FROM hr.employees
WHERE salary < 5000
OR salary > 12000
ORDER BY salary DESC;

-- �Լ�
-- ���� �Լ�
-- upper, lower, initcap
SELECT last_name, upper(last_name), lower(last_name), initcap(last_name)
FROM hr.employees;

SELECT *
FROM hr.employees
WHERE upper(last_name) = 'KING';

SELECT *
FROM hr.employees
WHERE last_name = initcap('KING');

-- concat
SELECT last_name, first_name, last_name || ' ' || first_name, concat(concat(last_name,' '), first_name)
FROM hr.employees;

-- length, lengthb
SELECT last_name, length(last_name), lengthb(last_name)
FROM hr.employees;

SELECT length('����Ŭ'), lengthb('����Ŭ')
FROM dual;

-- nls_database_parameters
SELECT *
FROM nls_database_parameters;

-- instr
SELECT last_name, instr(last_name, 'a'), instr(last_name, 'a', 1, 1),instr(last_name, 'a', 1, 2)
FROM hr.employees;

SELECT last_name
FROM hr.employees
WHERE last_name LIKE '%a%a%';

SELECT last_name
FROM hr.employees
WHERE instr(last_name, 'a', 1, 2) > 0;

-- substr
SELECT last_name, substr(last_name, 1, 1), substr(last_name, 2, 1), substr(last_name, -2, 2)
FROM hr.employees;

SELECT substr('abcdef', 1, 2), substrb('abcdef', 1, 2), substr('�����ٶ󸶹�', 1, 2), substrb('�����ٶ󸶹�', 1, 6)
FROM dual;

-- trim
SELECT 'aabbcaa', trim('a' from 'aabbcaa'), ltrim('aabbcaa', 'a'), rtrim('aabbcaa', 'a')
FROM dual;

SELECT '  oracle  ', trim(' ' from '  oracle  '), ltrim('  oracle  ', ' '), rtrim('  oracle  ', ' ')
FROM dual;

SELECT '  oracle  ', length('  oracle  '), trim('  oracle  '), length(trim('  oracle  ')), ltrim('  oracle  '), length(ltrim('  oracle  ')), rtrim('  oracle  '), length(rtrim('  oracle  '))
FROM dual;

-- [����14] employees ���̺� last_name �÷��� �� �߿�  "J" �Ǵ� "A" �Ǵ� "M"���� �����ϴ� 
-- ������� last_name, last_name�� ���̸� ǥ���ϴ� query(select��) �� �ۼ��մϴ�.
-- ������� last_name �������� �������� ������ �ּ���.
SELECT last_name, length(last_name)
FROM hr.employees
WHERE last_name LIKE 'J%'
OR last_name LIKE 'A%'
OR last_name LIKE 'M%'
ORDER BY last_name desc;

SELECT last_name, length(last_name)
FROM hr.employees
WHERE SUBSTR(last_name, 1, 1) = 'J'
OR SUBSTR(last_name, 1, 1) = 'A'
OR SUBSTR(last_name, 1, 1) = 'M'
ORDER BY last_name desc;

SELECT last_name, length(last_name)
FROM hr.employees
WHERE SUBSTR(last_name, 1, 1) IN ('J', 'A', 'M')
ORDER BY last_name desc;

SELECT last_name, length(last_name)
FROM hr.employees
WHERE INSTR(last_name, 'J', 1, 1) = 1
OR INSTR(last_name, 'A', 1, 1) = 1
OR INSTR(last_name, 'M', 1, 1) = 1
ORDER BY last_name desc;

SELECT last_name, length(last_name)
FROM hr.employees
WHERE REGEXP_LIKE(last_name, '^[AJM]')
ORDER BY last_name desc;

-- [����15] employees���̺��� department_id(�μ��ڵ�)�� 50�� ����� �߿� 
-- last_name�� �ι�° ��ġ�� "a"���ڰ� �ִ� ������� ��ȸ�ϼ���.
SELECT *
FROM hr.employees
WHERE department_id = 50
AND instr(last_name, 'a') = 2;

SELECT *
FROM hr.employees
WHERE department_id = 50
AND substr(last_name, 2, 1) = 'a';

SELECT *
FROM hr.employees
WHERE department_id = 50
AND last_name LIKE '_a%';

-- replace
SELECT 
    replace('100-001', '-', '%'),
    replace('100-001', '-', ''),
    replace('  100 001  ',' ', '')
FROM dual;

-- lpad, rpad
SELECT 
    salary, 
    lpad(salary, 10, '*'),
    rpad(salary, 10, '*')
FROM hr.employees;

-- [����16] salary�� �ִ� ���� 1000�� * ������ּ���.
SELECT salary, lpad('*', (salary/1000), '*') STAR
FROM hr.employees;

/*
SALARY    STAR
-------   -------
6000      ****** 
4800      **** 
4800      **** 
...
*/

-- ���� �Լ�
-- round
SELECT 
    45.926,
    ROUND(45.926),
    ROUND(45.926, 0),
    ROUND(45.926, 1),
    ROUND(45.926, 2),
    ROUND(45.926, -1),
    ROUND(45.926, -2),
    ROUND(55.926, -2)
FROM dual;

-- trunc
SELECT 
    45.926,
    TRUNC(45.926),
    TRUNC(45.926, 0),
    TRUNC(45.926, 1),
    TRUNC(45.926, 2),
    TRUNC(45.926, -1),
    TRUNC(45.926, -2),
    TRUNC(55.926, -2)
FROM dual;

-- ceil
SELECT 
    round(10.1),
    ceil(10.1),
    ceil(10.00000001)
FROM dual;

-- floor
SELECT 
    trunc(10.1),
    floor(10.1),
    floor(10.00000001),
    floor(-10.00000001)
FROM dual;

SELECT
    10/3,
    TRUNC(10/3),
    MOD(10,3)
FROM dual;

SELECT
    2 * 2 * 2,
    POWER(2, 3)
FROM dual;

SELECT
    abs(-100)
FROM dual;

SELECT
    sqrt(9)
FROM dual;

-- [����17] employees ���̺� �ִ� employee_id, last_name, salary, 
-- salary�� 10% �λ�� �޿��� ����ϸ鼭 ���� �޿��� �Ҽ����� �ݿø��ؼ� ���������� ǥ���ϰ� 
-- ����Ī�� New Salary�� ǥ���ϼ���.
SELECT employee_id, last_name, salary, round(salary * 1.1) "New Salary", round(salary * 1.1) - salary "Diff New Salary"
FROM hr.employees;