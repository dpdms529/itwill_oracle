-- [����42] 
-- 1) department_id, job_id, manager_id �������� �Ѿ� �޿��� ���
-- 2) department_id, job_id �������� �Ѿױ޿��� ���
-- 3) department_id �������� �Ѿױ޿��� ���
-- 4) ��ü �Ѿ� �޿��� ���
-- 1),2),3),4)�� �Ѳ����� ������ּ���.

SELECT department_id, job_id, manager_id, sum(salary)
FROM hr.employees
GROUP BY department_id, job_id, manager_id
UNION ALL
SELECT department_id, job_id, NULL, sum(salary)
FROM hr.employees
GROUP BY department_id, job_id
UNION ALL
SELECT department_id, NULL, NULL, sum(salary)
FROM hr.employees
GROUP BY department_id
UNION ALL
SELECT NULL, NULL, NULL, sum(salary)
FROM hr.employees
ORDER BY 1, 2, 3;

-- rollup
SELECT department_id, job_id, manager_id, sum(salary)
FROM hr.employees
GROUP BY ROLLUP(department_id, job_id, manager_id);

SELECT department_id, job_id, manager_id, sum(salary)
FROM hr.employees
GROUP BY ROLLUP((department_id, job_id), manager_id);

-- cube
SELECT department_id, job_id, manager_id, sum(salary)
FROM hr.employees
GROUP BY CUBE(department_id, job_id, manager_id);

SELECT department_id, job_id, manager_id, sum(salary)
FROM hr.employees
GROUP BY CUBE(department_id, (job_id, manager_id));

-- grouping sets
SELECT department_id, job_id, manager_id, sum(salary)
FROM hr.employees
GROUP BY grouping sets((department_id, job_id), (department_id, manager_id), ());

SELECT department_id, job_id, manager_id, sum(salary), grouping(department_id), grouping(job_id), grouping(manager_id)
FROM hr.employees
GROUP BY grouping sets((department_id, job_id), (department_id, manager_id), ());

--[����43] �⵵,�б⺰ �޿��� �Ѿ��� ���ϼ���.
/*
YEAR             Q1         Q2         Q3         Q4         ��
-------- ---------- ---------- ---------- ---------- ----------
2001          17000                                       17000
2002                     36808      21008      11000      68816
2003                     35000       8000       3500      46500
2004          40700      14300      17000      14000      86000
2005          86900      16800      60800      33400     197900
2006          69400      20400      14200      17100     121100
2007          36600      20200       2500      35600      94900
2008          46900      12300                            59200
             297500     155808     123508     114600     691416
*/
SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') quarter, sum(salary) sum_sal
FROM hr.employees
GROUP BY CUBE(to_char(hire_date, 'yyyy'), to_char(hire_date, 'q'));

SELECT 
    year,
    max(decode(quarter, '1', sum_sal)) Q1,
    max(decode(quarter, '2', sum_sal)) Q2,
    max(decode(quarter, '3', sum_sal)) Q3,
    max(decode(quarter, '4', sum_sal)) Q4,
    max(decode(quarter, NULL, sum_sal)) ��
FROM (SELECT to_char(hire_date, 'yyyy') year, (to_char(hire_date, 'q')) quarter, sum(salary) sum_sal
        FROM hr.employees
        GROUP BY CUBE(to_char(hire_date, 'yyyy'), to_char(hire_date, 'q')))
GROUP BY year        
ORDER BY 1;

SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, nvl(to_char(hire_date, 'q'), '��') quarter, sum(salary) sum_sal
        FROM hr.employees
        GROUP BY CUBE(to_char(hire_date, 'yyyy'), to_char(hire_date, 'q')))
PIVOT (max(sum_sal) for quarter in ('1' "Q1", '2' "Q2", '3' "Q3", '4' "Q4", '��' "��"))
ORDER BY 1;

-- ���� �˻�
SELECT *
FROM hr.employees
START WITH employee_id = 101
CONNECT BY PRIOR employee_id = manager_id;

SELECT *
FROM hr.employees
START WITH employee_id = 101
CONNECT BY employee_id = PRIOR manager_id;

SELECT level, lpad(last_name, length(last_name)+(level * 2) - 2, ' ') name
FROM hr.employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY last_name;

SELECT level, employee_id, lpad(last_name, length(last_name)+(level * 2) - 2, ' ') name
FROM hr.employees
WHERE employee_id != 148 -- Ư�� �ุ ����
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY last_name;

SELECT level, employee_id, lpad(last_name, length(last_name)+(level * 2) - 2, ' ') name
FROM hr.employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
AND employee_id != 148  -- 148�� ������ ���� ����, �б� ����
ORDER SIBLINGS BY last_name;

-- [����44] SELECT���� �̿��ؼ� 1 ~ 100 ������ּ���.
SELECT level
FROM dual
CONNECT BY level <= 100;

-- [����45] SELECT���� �̿��ؼ� 2���� ������ּ���.
SELECT 2 || ' * ' || level || ' = ' || level * 2 "2��"
FROM dual
CONNECT BY level <= 9;

-- [����46] SELECT���� �̿��ؼ� 2�� ~ 9���� ������ּ���.
SELECT dan|| ' * ' || num || ' = ' || dan * num "������"
FROM (SELECT level+1 dan
        FROM dual
        CONNECT BY level < 9),
    (SELECT level num
        FROM dual
        CONNECT BY level <= 9);

-- ����
-- ���� ���� Ȯ��
show user; -- hr

-- ���� ���� �ý��� ���� Ȯ��
SELECT * FROM user_sys_privs;

-- ���� ���� ��ü ���� Ȯ��
SELECT * FROM user_tab_privs;

-- ���� ���� �� Ȯ��
SELECT * FROM session_roles;

SELECT * FROM user_role_privs;

-- ���� ���� ���� �ý��� ���� Ȯ��
SELECT * FROM role_sys_privs;

-- ���� ���� ���� ��ü ���� Ȯ��
SELECT * FROM role_tab_privs;

-- ���� ������ �ý��� ���� Ȯ��
SELECT * FROM user_sys_privs
UNION
SELECT * FROM role_sys_privs;

SELECT * FROM session_privs;

-- ����ڿ��� �Ҵ�� ���̺����̽� ��뷮 �� ��� ���� �뷮 ��ȸ
SELECT * FROM user_ts_quotas;

SELECT * FROM user_tables;

SELECT * FROM all_tables;