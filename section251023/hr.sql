-- [����26] 80 �μ��� �ٹ��ϴ� ������� last_name, job_id, department_name, city ������ּ���.
SELECT e.last_name, e.job_id, d.department_name, l.city
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND e.department_id = 80;

SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.department_id = 20;

SELECT count(*)
FROM hr.employees
WHERE department_id = 20;

-- outer join
SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+);

SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id(+) = d.department_id;

SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id(+) = d.department_id(+);

SELECT e.last_name, e.job_id, d.department_name, l.city
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id(+)
AND d.location_id = l.location_id(+);

-- self join
SELECT w.employee_id, w.last_name, m.employee_id, m.last_name
FROM hr.employees w, hr.employees m
WHERE w.manager_id = m.employee_id;

SELECT w.employee_id, w.last_name, m.employee_id, m.last_name
FROM hr.employees w, hr.employees m
WHERE w.manager_id = m.employee_id(+);

-- non equi join
SELECT employee_id, salary
FROM hr.employees;

SELECT *
FROM hr.job_grades;

SELECT e.employee_id, e.salary, j.grade_level
FROM hr.employees e, hr.job_grades j
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT e.employee_id, e.salary, j.grade_level, d.department_name
FROM hr.employees e, hr.job_grades j, hr.departments d
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal
AND e.department_id = d.department_id(+);

-- ANSI ����
-- natural join
SELECT d.department_name, l.city
FROM hr.departments d, hr.locations l
WHERE d.location_id = l.location_id;

SELECT d.department_name, l.city
FROM hr.departments d NATURAL JOIN hr.locations l;

SELECT d.department_name, l.location_id, l.city
FROM hr.departments d NATURAL JOIN hr.locations l;

SELECT d.department_name, location_id, l.city
FROM hr.departments d NATURAL JOIN hr.locations l;

-- using
SELECT e.employee_id, d.department_name
FROM hr.employees e JOIN hr.departments d
USING(department_id);

-- ���� : ���� �÷��� ���̺� �����ϸ� �ȵ�
SELECT e.employee_id, d.department_name
FROM hr.employees e JOIN hr.departments d
USING(d.department_id);

SELECT e.employee_id, d.department_id, d.department_name
FROM hr.employees e JOIN hr.departments d
USING(department_id);

SELECT e.employee_id, d.department_id, d.department_name
FROM hr.employees e JOIN hr.departments d
USING(department_id)
WHERE d.department_id IN (10, 20);

SELECT e.employee_id, department_id, d.department_name, l.city
FROM hr.employees e JOIN hr.departments d
USING(department_id)
JOIN hr.locations l
USING(location_id)
WHERE department_id IN (10, 20);

-- on
SELECT e.employee_id, d.department_id, d.department_name
FROM hr.employees e JOIN hr.departments d
ON e.department_id = d.department_id;

SELECT e.employee_id, d.department_id, d.department_name
FROM hr.employees e JOIN hr.departments d
WHERE e.department_id = d.department_id;

SELECT e.employee_id, d.department_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id;

SELECT e.employee_id, d.department_id, d.department_name, l.city
FROM hr.employees e JOIN hr.departments d
ON e.department_id = d.department_id
JOIN hr.locations l
ON d.location_id = l.location_id;

SELECT e.employee_id, e.salary, j.grade_level
FROM hr.employees e JOIN hr.job_grades j
ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT e.employee_id, e.last_name, e.salary, j.grade_level
FROM hr.employees e JOIN hr.job_grades j
ON e.salary >= j.lowest_sal AND e.salary <= j.highest_sal
WHERE last_name LIKE '%a%';

SELECT w.employee_id, w.last_name, m.employee_id, m.last_name
FROM hr.employees w JOIN hr.employees m
ON w.manager_id = m.employee_id;

SELECT w.employee_id, w.last_name, m.employee_id, m.last_name
FROM hr.employees w INNER JOIN hr.employees m
ON w.manager_id = m.employee_id;

SELECT e.employee_id, d.department_id, d.department_name
FROM hr.employees e INNER JOIN hr.departments d
ON e.department_id = d.department_id;

SELECT e.employee_id, department_id, d.department_name
FROM hr.employees e INNER JOIN hr.departments d
USING (department_id);

-- outer join
-- left outer join
SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+);

SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e LEFT OUTER JOIN hr.departments d
ON e.department_id = d.department_id;

-- right outer join
SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id(+) = d.department_id;

SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e RIGHT OUTER JOIN hr.departments d
ON e.department_id = d.department_id;

-- full outer join
SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e FULL OUTER JOIN hr.departments d
ON e.department_id = d.department_id;

SELECT e.last_name, e.job_id, d.department_name, l.city
FROM hr.employees e LEFT OUTER JOIN hr.departments d 
ON e.department_id = d.department_id
LEFT OUTER JOIN hr.locations l
ON d.location_id = l.location_id;

-- cross join
SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d;

SELECT e.last_name, e.job_id, d.department_name
FROM hr.employees e CROSS JOIN hr.departments d;

-- [����27] 2006�⵵�� �Ի��� ������� �μ��̸��� �޿��� �Ѿ�, ����� ������ּ���.
-- 1) ����Ŭ ����
SELECT d.department_name �μ��̸�, sum(e.salary) �޿��Ѿ�, avg(e.salary) �޿����
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60
GROUP BY d.department_name;

-- �Ǽ� ����
SELECT distinct e.department_id
FROM hr.employees e
WHERE e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60;

-- 2) ANSI ǥ��
SELECT d.department_name �μ��̸�, sum(e.salary) �޿��Ѿ�, avg(e.salary) �޿����
FROM hr.employees e JOIN hr.departments d
ON e.department_id = d.department_id
WHERE e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60
GROUP BY d.department_name;

-- [����28] 2007�⵵�� �Ի��� ������� �����̸��� �޿��� �Ѿ�, ����� ������ּ���.
-- �� �μ� ��ġ�� ���� ���� ������� ������ ������ּ���.
-- 1) ����Ŭ ����
SELECT l.city �����̸�, sum(e.salary) �޿��Ѿ�, avg(e.salary) �޿����
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id(+)
AND d.location_id = l.location_id(+)
AND e.hire_date between to_date('20070101','yyyymmdd') and to_date('20080101', 'yyyymmdd') - 1/24/60/60
GROUP BY l.city;

-- 2) ANSI ǥ��
SELECT l.city �����̸�, sum(e.salary) �޿��Ѿ�, avg(e.salary) �޿����
FROM hr.employees e LEFT OUTER JOIN hr.departments d 
ON e.department_id = d.department_id
LEFT OUTER JOIN hr.locations l
ON d.location_id = l.location_id
WHERE e.hire_date between to_date('20070101','yyyymmdd') and to_date('20080101', 'yyyymmdd') - 1/24/60/60
GROUP BY l.city;

-- [����29] �����ں��� ���� �Ի��� ����� �̸��� �Ի��� �� �ش� �������� �̸��� �Ի��� ������ּ���.
-- 1) ����Ŭ ����
SELECT w.last_name ����̸�, w.hire_date ����Ի���, m.last_name �������̸�, m.hire_date �������Ի���
FROM hr.employees w, hr.employees m
WHERE w.manager_id = m.employee_id
AND w.hire_date < m.hire_date;

-- 2) ANSI ǥ��
SELECT w.last_name ����̸�, w.hire_date ����Ի���, m.last_name �������̸�, m.hire_date �������Ի���
FROM hr.employees w JOIN hr.employees m
ON w.manager_id = m.employee_id
WHERE w.hire_date < m.hire_date;

-- ��������
-- 110�� ����� �޿����� �� ���� �޿��� �޴� ��� ��ȸ
SELECT salary
FROM hr.employees e
WHERE e.employee_id = 110;
                
SELECT *
FROM hr.employees
WHERE salary > (SELECT salary
                FROM hr.employees e
                WHERE e.employee_id = 110);
                
SELECT *
FROM hr.employees
WHERE salary > (SELECT salary
                FROM hr.employees
                WHERE last_name = 'King');
                
SELECT *
FROM hr.employees
WHERE salary > (SELECT salary
                FROM hr.employees
                WHERE last_name = 'Davies');

SELECT *
FROM hr.employees
WHERE job_id = (SELECT job_id
                FROM hr.employees 
                WHERE employee_id = 110)
AND salary > (SELECT salary
                FROM hr.employees
                WHERE employee_id = 110);

-- [����30] �ְ� �޿��� �޴� ������� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE salary = (SELECT max(salary)
                FROM hr.employees);

-- having�� ��������
SELECT department_id, sum(salary)
FROM hr.employees
GROUP BY department_id
HAVING sum(salary) > (SELECT min(salary)
                        FROM hr.employees
                        WHERE department_id = 40);
                        
-- [����31] ��� �޿��� ���� ���� �μ���ȣ, ��ձ޿��� ������ּ���.
SELECT department_id, avg(salary)
FROM hr.employees
GROUP BY department_id
HAVING avg(salary) = (SELECT min(avg(salary))
                        FROM hr.employees
                        GROUP BY department_id);

                        
                        