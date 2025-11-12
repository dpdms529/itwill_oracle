SELECT * FROM session_privs;
SELECT * FROM user_tab_privs;

SELECT * FROM hr.sawon;
desc hr.sawon;

exec hr.sawon_insert(1, 'oracle', p_deptno=>10);

SELECT * FROM hr.sawon;

ROLLBACK;

SELECT employee_id, salary, hr.tax(salary)
FROM hr.employees;