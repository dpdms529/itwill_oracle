--[����37] �⵵,�б⺰ �޿��� �Ѿ��� ���ϼ���.
SELECT 
    to_char(hire_date, 'yyyy') year, 
    sum(case to_char(hire_date, 'q') when '1' then salary end) "1�б�",
    sum(case to_char(hire_date, 'q') when '2' then salary end) "2�б�",
    sum(case to_char(hire_date, 'q') when '3' then salary end) "3�б�",
    sum(case to_char(hire_date, 'q') when '4' then salary end) "4�б�"
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy')
ORDER BY year;

SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) salary
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q')
ORDER BY year, q;

SELECT 
    year, 
    max(case q when '1' then �Ѿ� end) "1�б�",
    max(case q when '2' then �Ѿ� end) "2�б�",
    max(case q when '3' then �Ѿ� end) "3�б�",
    max(case q when '4' then �Ѿ� end) "4�б�"
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) �Ѿ�
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q'))
GROUP BY year
ORDER BY 1;

SELECT 
    year, 
    case q when '1' then salary end
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) salary
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q'));
    
SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, salary
        FROM hr.employees)
PIVOT (sum(salary) for q in ('1' "1�б�", '2' "2�б�", '3' "3�б�", '4' "4�б�"))
ORDER BY 1;

SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) �Ѿ�
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q'))
PIVOT (max(�Ѿ�) for q in ('1' "1�б�", '2' "2�б�", '3' "3�б�", '4' "4�б�"))
ORDER BY 1;

/*
�⵵          1�б�      2�б�      3�б�      4�б�
-------- ---------- ---------- ---------- ----------
2001          17000
2002                     36808      21008      11000
2003                     35000       8000       3500
2004          40700      14300      17000      14000
2005          86900      16800      60800      33400
2006          69400      20400      14200      17100
2007          36600      20200       2500      35600
2008          46900      12300
*/

-- ���߿� ��������
-- �ֺ�
SELECT *
FROM hr.employees
WHERE (manager_id, department_id) IN (SELECT manager_id, department_id
                                        FROM hr.employees
                                        WHERE first_name = 'John');

-- ��ֺ�                                        
SELECT *
FROM hr.employees
WHERE manager_id IN (SELECT manager_id
                    FROM hr.employees
                    WHERE first_name = 'John')
AND department_id IN (SELECT department_id
                    FROM hr.employees
                    WHERE first_name = 'John');  
                    
-- [����38] commission_pct null�� �ƴ� ������� department_id, salary ��ġ�ϴ� ������� ������ ������ּ���.
-- 1) �ֺ�
SELECT *
FROM hr.employees
WHERE (nvl(department_id,0), salary) IN (SELECT nvl(department_id,0), salary
                                        FROM hr.employees
                                        WHERE commission_pct is not null);

SELECT department_id, salary
FROM hr.employees
WHERE commission_pct is not null;

-- 2) ��ֺ�
SELECT *
FROM hr.employees
WHERE nvl(department_id, 0) IN (SELECT nvl(department_id, 0)
                                FROM hr.employees
                                WHERE commission_pct is not null)
AND salary IN (SELECT salary
                FROM hr.employees
                WHERE commission_pct is not null);  
                
-- [����39] location_id�� 1700 ��ġ�� �ִ� ������� salary, commission_pct�� ��ġ�ϴ� ������� ������ ������ּ���.
-- 1) �ֺ�
SELECT *
FROM hr.employees
WHERE (salary, nvl(commission_pct, 0)) IN (SELECT e.salary, nvl(e.commission_pct, 0)
                                            FROM hr.employees e, hr.departments d
                                            WHERE e.department_id = d.department_id
                                            AND d.location_id = 1700);
                                    
SELECT *
FROM hr.employees
WHERE (salary, nvl(commission_pct, 0)) IN (SELECT salary, nvl(commission_pct, 0)
                                            FROM hr.employees
                                            WHERE department_id IN (SELECT department_id
                                                                    FROM hr.departments
                                                                    WHERE location_id = 1700));                           
                                    
SELECT e.salary, e.commission_pct, location_id
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND d.location_id = 1700;

-- 2) ��ֺ�
SELECT *
FROM hr.employees
WHERE salary IN (SELECT e.salary
                FROM hr.employees e, hr.departments d
                WHERE e.department_id = d.department_id
                AND d.location_id = 1700)
AND nvl(commission_pct, 0) IN (SELECT nvl(e.commission_pct, 0)
                                FROM hr.employees e, hr.departments d
                                WHERE e.department_id = d.department_id
                                AND d.location_id = 1700);
                                
-- scalar subquery
SELECT e.employee_id, e.department_id, d.department_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+)
ORDER BY 2;

SELECT employee_id, department_id, (SELECT department_name 
                                    FROM hr.departments 
                                    WHERE department_id = e.department_id)
FROM hr.employees e
ORDER BY 2;

-- [����40] �μ��̸��� �޿��� �Ѿ�, ����� ���ϼ���.
-- 1) �Ϲ����� ����
SELECT d.department_name, sum(salary), avg(salary)
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY 1;

-- 2) inline view �̿�
SELECT d.department_name, sum, avg
FROM hr.departments d, (SELECT e.department_id, sum(salary) sum, avg(salary) avg
                        FROM hr.employees e
                        GROUP BY e.department_id) e
WHERE d.department_id = e.department_id
ORDER BY 1;        
        
-- 3) scalar subquery
SELECT (SELECT department_name FROM hr.departments WHERE department_id = e.department_id) department_name, sum(salary), avg(salary)
FROM hr.employees e
GROUP BY e.department_id
ORDER BY 1;

SELECT 
    department_name, 
    (SELECT sum(salary) 
        FROM hr.employees 
        WHERE department_id = d.department_id) sal,
    (SELECT avg(salary) 
        FROM hr.employees 
        WHERE department_id = d.department_id) avg
FROM hr.departments d;

SELECT department_name, substr(sum_avg, 1, 10) sum, substr(sum_avg, 11) avg
FROM (SELECT department_name, (SELECT lpad(sum(salary), 10)||lpad(round(avg(salary)), 10) FROM hr.employees WHERE department_id = d.department_id) sum_avg
        FROM hr.departments d)
WHERE sum_avg is not null;

-- [����41] ������� employee_id, last_name�� ����ϼ���.
-- �� department_name�� �������� �������� �������ּ���.
-- 1) join
SELECT employee_id, last_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+)
ORDER BY department_name, 1;

-- 2) scalar subquery
SELECT employee_id, last_name
FROM hr.employees e
ORDER BY (SELECT department_name
        FROM hr.departments 
        WHERE department_id = e.department_id), 1;
        
-- ���� ������
-- union
SELECT employee_id, job_id, salary
FROM hr.employees;

SELECT employee_id, job_id
FROM hr.job_history;

SELECT employee_id, job_id, salary
FROM hr.employees
UNION
SELECT employee_id, job_id, NULL
FROM hr.job_history;

-- union all
SELECT employee_id, job_id, salary
FROM hr.employees
UNION ALL
SELECT employee_id, job_id, NULL
FROM hr.job_history;

-- intersect
SELECT employee_id, job_id
FROM hr.employees
INTERSECT
SELECT employee_id, job_id
FROM hr.job_history;

SELECT employee_id, job_id
FROM hr.job_history
WHERE employee_id = 176;

-- minus
SELECT employee_id
FROM hr.employees
MINUS
SELECT employee_id
FROM hr.job_history;

SELECT employee_id, job_id, salary
FROM hr.employees
UNION ALL
SELECT employee_id, job_id, NULL
FROM hr.job_history
ORDER BY 1;

SELECT employee_id, e.last_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+)
UNION
SELECT employee_id, e.last_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id(+) = d.department_id;

SELECT employee_id, e.last_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+)
UNION ALL
SELECT null, null, department_name
FROM hr.departments d
WHERE not exists (SELECT 'x'
                    FROM hr.employees
                    WHERE department_id = d.department_id);

SELECT employee_id, e.last_name, d.department_name
FROM hr.employees e FULL OUTER JOIN hr.departments d
ON e.department_id = d.department_id;

-- union
SELECT employee_id, job_id, salary
FROM hr.employees
UNION
SELECT employee_id, job_id, NULL
FROM hr.job_history;

SELECT employee_id, job_id
FROM hr.employees e
WHERE not exists (SELECT 'x'
                    FROM hr.job_history j
                    WHERE employee_id = e.employee_id
                    and job_id = e.job_id)
UNION ALL
SELECT employee_id, job_id
FROM hr.job_history;   

-- union all
SELECT employee_id, job_id, salary
FROM hr.employees
UNION ALL
SELECT employee_id, job_id, NULL
FROM hr.job_history;

-- intersect
SELECT employee_id, job_id
FROM hr.employees
INTERSECT
SELECT employee_id, job_id
FROM hr.job_history;

SELECT employee_id, job_id
FROM hr.employees e
WHERE exists (SELECT 'x'
                FROM hr.job_history
                WHERE employee_id = e.employee_id
                and job_id = e.job_id);
                
SELECT employee_id, job_id
FROM hr.employees e
WHERE (employee_id, job_id) in (SELECT employee_id, job_id
                                FROM hr.job_history
                                WHERE employee_id = e.employee_id
                                and job_id = e.job_id);              

-- minus
SELECT employee_id, job_id
FROM hr.employees
MINUS
SELECT employee_id, job_id
FROM hr.job_history;

SELECT employee_id, job_id
FROM hr.employees e
WHERE not exists (SELECT 'x'
                FROM hr.job_history
                WHERE employee_id = e.employee_id
                and job_id = e.job_id);
                
SELECT employee_id, job_id
FROM hr.employees e
WHERE (employee_id, job_id) not in (SELECT employee_id, job_id
                                    FROM hr.job_history
                                    WHERE employee_id = e.employee_id
                                    and job_id = e.job_id);                