--[문제37] 년도,분기별 급여의 총액을 구하세요.
SELECT 
    to_char(hire_date, 'yyyy') year, 
    sum(case to_char(hire_date, 'q') when '1' then salary end) "1분기",
    sum(case to_char(hire_date, 'q') when '2' then salary end) "2분기",
    sum(case to_char(hire_date, 'q') when '3' then salary end) "3분기",
    sum(case to_char(hire_date, 'q') when '4' then salary end) "4분기"
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy')
ORDER BY year;

SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) salary
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q')
ORDER BY year, q;

SELECT 
    year, 
    max(case q when '1' then 총액 end) "1분기",
    max(case q when '2' then 총액 end) "2분기",
    max(case q when '3' then 총액 end) "3분기",
    max(case q when '4' then 총액 end) "4분기"
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) 총액
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
PIVOT (sum(salary) for q in ('1' "1분기", '2' "2분기", '3' "3분기", '4' "4분기"))
ORDER BY 1;

SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) 총액
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q'))
PIVOT (max(총액) for q in ('1' "1분기", '2' "2분기", '3' "3분기", '4' "4분기"))
ORDER BY 1;

/*
년도          1분기      2분기      3분기      4분기
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

-- 다중열 서브쿼리
-- 쌍비교
SELECT *
FROM hr.employees
WHERE (manager_id, department_id) IN (SELECT manager_id, department_id
                                        FROM hr.employees
                                        WHERE first_name = 'John');

-- 비쌍비교                                        
SELECT *
FROM hr.employees
WHERE manager_id IN (SELECT manager_id
                    FROM hr.employees
                    WHERE first_name = 'John')
AND department_id IN (SELECT department_id
                    FROM hr.employees
                    WHERE first_name = 'John');  
                    
-- [문제38] commission_pct null이 아닌 사원들의 department_id, salary 일치하는 사원들의 정보를 출력해주세요.
-- 1) 쌍비교
SELECT *
FROM hr.employees
WHERE (nvl(department_id,0), salary) IN (SELECT nvl(department_id,0), salary
                                        FROM hr.employees
                                        WHERE commission_pct is not null);

SELECT department_id, salary
FROM hr.employees
WHERE commission_pct is not null;

-- 2) 비쌍비교
SELECT *
FROM hr.employees
WHERE nvl(department_id, 0) IN (SELECT nvl(department_id, 0)
                                FROM hr.employees
                                WHERE commission_pct is not null)
AND salary IN (SELECT salary
                FROM hr.employees
                WHERE commission_pct is not null);  
                
-- [문제39] location_id가 1700 위치에 있는 사원들의 salary, commission_pct가 일치하는 사원들의 정보를 출력해주세요.
-- 1) 쌍비교
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

-- 2) 비쌍비교
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

-- [문제40] 부서이름별 급여의 총액, 평균을 구하세요.
-- 1) 일반적인 형식
SELECT d.department_name, sum(salary), avg(salary)
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY 1;

-- 2) inline view 이용
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

-- [문제41] 사원들의 employee_id, last_name을 출력하세요.
-- 단 department_name을 기준으로 오름차순 정렬해주세요.
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
        
-- 집합 연산자
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