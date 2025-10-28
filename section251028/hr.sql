-- [문제42] 
-- 1) department_id, job_id, manager_id 기준으로 총액 급여를 출력
-- 2) department_id, job_id 기준으로 총액급여를 출력
-- 3) department_id 기준으로 총액급여를 출력
-- 4) 전체 총액 급여를 출력
-- 1),2),3),4)를 한꺼번에 출력해주세요.

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

--[문제43] 년도,분기별 급여의 총액을 구하세요.
/*
YEAR             Q1         Q2         Q3         Q4         합
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
    max(decode(quarter, NULL, sum_sal)) 합
FROM (SELECT to_char(hire_date, 'yyyy') year, (to_char(hire_date, 'q')) quarter, sum(salary) sum_sal
        FROM hr.employees
        GROUP BY CUBE(to_char(hire_date, 'yyyy'), to_char(hire_date, 'q')))
GROUP BY year        
ORDER BY 1;

SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, nvl(to_char(hire_date, 'q'), '합') quarter, sum(salary) sum_sal
        FROM hr.employees
        GROUP BY CUBE(to_char(hire_date, 'yyyy'), to_char(hire_date, 'q')))
PIVOT (max(sum_sal) for quarter in ('1' "Q1", '2' "Q2", '3' "Q3", '4' "Q4", '합' "합"))
ORDER BY 1;

-- 계층 검색
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
WHERE employee_id != 148 -- 특정 행만 제외
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY last_name;

SELECT level, employee_id, lpad(last_name, length(last_name)+(level * 2) - 2, ' ') name
FROM hr.employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
AND employee_id != 148  -- 148번 조직은 전부 제거, 분기 제거
ORDER SIBLINGS BY last_name;

-- [문제44] SELECT문을 이용해서 1 ~ 100 출력해주세요.
SELECT level
FROM dual
CONNECT BY level <= 100;

-- [문제45] SELECT문을 이용해서 2단을 출력해주세요.
SELECT 2 || ' * ' || level || ' = ' || level * 2 "2단"
FROM dual
CONNECT BY level <= 9;

-- [문제46] SELECT문을 이용해서 2단 ~ 9단을 출력해주세요.
SELECT dan|| ' * ' || num || ' = ' || dan * num "구구단"
FROM (SELECT level+1 dan
        FROM dual
        CONNECT BY level < 9),
    (SELECT level num
        FROM dual
        CONNECT BY level <= 9);

-- 권한
-- 현재 유저 확인
show user; -- hr

-- 내가 받은 시스템 권한 확인
SELECT * FROM user_sys_privs;

-- 내가 받은 객체 권한 확인
SELECT * FROM user_tab_privs;

-- 내가 받은 롤 확인
SELECT * FROM session_roles;

SELECT * FROM user_role_privs;

-- 내가 받은 롤의 시스템 권한 확인
SELECT * FROM role_sys_privs;

-- 내가 받은 롤의 객체 권한 확인
SELECT * FROM role_tab_privs;

-- 현재 세션의 시스템 권한 확인
SELECT * FROM user_sys_privs
UNION
SELECT * FROM role_sys_privs;

SELECT * FROM session_privs;

-- 사용자에게 할당된 테이블스페이스 사용량 및 사용 가능 용량 조회
SELECT * FROM user_ts_quotas;

SELECT * FROM user_tables;

SELECT * FROM all_tables;