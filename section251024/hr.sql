SELECT *
FROM hr.employees
WHERE salary = (SELECT min(salary)
                FROM hr.employees);
                
SELECT *
FROM hr.employees
WHERE salary = (SELECT min(salary)
                FROM hr.employees
                GROUP BY department_id);                
/* 
ORA-01427: single-row subquery returns more than one row
01427. 00000 -  "single-row subquery returns more than one row"
*/

-- 다중 행 서브쿼리
-- in
SELECT *
FROM hr.employees
WHERE salary IN (SELECT min(salary)
                    FROM hr.employees
                    GROUP BY department_id);

-- any               
SELECT *
FROM hr.employees
WHERE salary > (SELECT min(salary)
                    FROM hr.employees
                    GROUP BY department_id);
                    
SELECT salary
FROM hr.employees
WHERE job_id = 'IT_PROG';                    
                    
SELECT *
FROM hr.employees
WHERE salary > (SELECT min(salary)
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');                    

SELECT *
FROM hr.employees
WHERE salary > any (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');
                    
SELECT *
FROM hr.employees
WHERE salary > 9000
OR salary > 6000
OR salary > 4800
OR salary > 4800
OR salary > 4200;

SELECT *
FROM hr.employees
WHERE salary < (SELECT max(salary)
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');

SELECT *
FROM hr.employees
WHERE salary < any (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');

SELECT *
FROM hr.employees
WHERE salary < 9000
OR salary < 6000
OR salary < 4800
OR salary < 4800
OR salary < 4200;


SELECT *
FROM hr.employees
WHERE salary = any (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');

SELECT *
FROM hr.employees
WHERE salary = 9000
OR salary = 6000
OR salary = 4800
OR salary = 4800
OR salary = 4200;

-- all  
SELECT *
FROM hr.employees
WHERE salary > (SELECT max(salary)
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');
                    
SELECT *
FROM hr.employees
WHERE salary > all (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');
                    
SELECT *
FROM hr.employees
WHERE salary > 9000
AND salary > 6000
AND salary > 4800
AND salary > 4800
AND salary > 4200;

SELECT *
FROM hr.employees
WHERE salary < (SELECT min(salary)
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');

SELECT *
FROM hr.employees
WHERE salary < all (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');

SELECT *
FROM hr.employees
WHERE salary < 9000
AND salary < 6000
AND salary < 4800
AND salary < 4800
AND salary < 4200;


SELECT *
FROM hr.employees
WHERE salary = all (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');

SELECT *
FROM hr.employees
WHERE salary = 9000
AND salary = 6000
AND salary = 4800
AND salary = 4800
AND salary = 4200;

-- [문제32] 관리자 사원들의 정보를 추출해주세요.
SELECT *
FROM hr.employees
WHERE employee_id in (SELECT manager_id
                        FROM hr.employees);
                        
-- [문제33] 관리자 아닌 사원들의 정보를 추출해주세요.
SELECT *
FROM hr.employees
WHERE employee_id not in (SELECT manager_id
                            FROM hr.employees
                            WHERE manager_id is not null);
                            
SELECT *
FROM hr.employees
WHERE not(employee_id = null
OR employee_id = 100
OR employee_id = 100
OR employee_id = 102
OR employee_id = 103);  

SELECT *
FROM hr.employees
WHERE employee_id != null
AND employee_id != 100
AND employee_id != 100
AND employee_id != 102
AND employee_id != 103;  

SELECT distinct manager_id
FROM hr.employees;

-- [문제] 자신의 부서 평균 급여 보다 더 많이 받는 사원들의 정보를 추출해주세요.
SELECT *
FROM hr.employees e
WHERE salary > (SELECT avg(salary)
                FROM hr.employees
                WHERE department_id = e.department_id);
                
SELECT *
FROM hr.employees e, 
    (SELECT department_id, avg(salary) avg_salary
    FROM hr.employees
    GROUP BY department_id) a
WHERE e.salary > a.avg_salary
AND e.department_id = a.department_id;

-- [문제32] 관리자 사원들의 정보를 추출해주세요.
SELECT *
FROM hr.employees e
WHERE exists (SELECT 'x'
                FROM hr.employees
                WHERE manager_id = e.employee_id);
 
-- [문제33] 관리자 아닌 사원들의 정보를 추출해주세요.                
SELECT *
FROM hr.employees e
WHERE not exists (SELECT 'x'
                FROM hr.employees
                WHERE manager_id = e.employee_id);       
                
                
-- [문제34] 소속사원이 있는 부서정보를 출력해주세요.
SELECT *
FROM hr.departments d
WHERE exists (SELECT 1
                FROM hr.employees
                WHERE department_id = d.department_id);
                                            
SELECT *
FROM hr.departments d
WHERE d.department_id in (SELECT department_id
                            FROM hr.employees);

-- [문제35] 소속사원이 없는 부서정보를 출력해주세요.                
SELECT *
FROM hr.departments d
WHERE not exists (SELECT 1
                FROM hr.employees
                WHERE department_id = d.department_id);
                
SELECT *
FROM hr.departments d
WHERE d.department_id not in (SELECT department_id
                            FROM hr.employees
                            WHERE department_id is not null);       
                            
-- [문제] 자신의 부서 평균 급여 보다 더 많이 받는 사원들의 정보를 추출해주세요.
SELECT *
FROM hr.employees e
WHERE salary > (SELECT avg(salary)
                FROM hr.employees
                WHERE department_id = e.department_id);   
                
SELECT department_id, avg(salary) avg_salary
FROM hr.employees
GROUP BY department_id;                
                
SELECT e.*
FROM hr.employees e, 
    (SELECT department_id, avg(salary) avg_sal
    FROM hr.employees
    GROUP BY department_id) e1
WHERE e.department_id = e1.department_id
AND e.salary > e1.avg_sal;

SELECT *
FROM hr.departments d, 
(SELECT department_id, count(*) cnt
FROM hr.employees e
GROUP BY department_id) c
WHERE c.department_id = d.department_id(+);

-- [문제36] 부서별 입사인원수를 가로방향으로 출력해주세요.
SELECT 
    count(case department_id when 10 then 1 end) "10",
    count(case department_id when 20 then 1 end) "20",
    count(case department_id when 30 then 1 end) "30",
    count(case department_id when 40 then 1 end) "40",
    count(case department_id when 50 then 1 end) "50",
    count(case department_id when 60 then 1 end) "60",
    count(case department_id when 70 then 1 end) "70",
    count(case department_id when 80 then 1 end) "80",
    count(case department_id when 90 then 1 end) "90",
    count(case department_id when 100 then 1 end) "100",
    count(case department_id when 110 then 1 end) "110",
    count(case when department_id is null then 1 end) "부서가 없는 사원"
FROM hr.employees;


SELECT 
    min(decode(dept_id, 10, cnt)) "10", 
    min(decode(dept_id, 20, cnt)) "20", 
    min(decode(dept_id, 30, cnt)) "30", 
    min(decode(dept_id, 40, cnt)) "40", 
    min(decode(dept_id, 50, cnt)) "50", 
    min(decode(dept_id, 60, cnt)) "60",
    min(decode(dept_id, 70, cnt)) "70", 
    min(decode(dept_id, 80, cnt)) "80", 
    min(decode(dept_id, 90, cnt)) "90", 
    min(decode(dept_id, 100, cnt)) "100", 
    min(decode(dept_id, 110, cnt)) "110", 
    min(decode(dept_id, null, cnt)) "부서가 없는 사원"
FROM (SELECT department_id dept_id, count(*) cnt
        FROM hr.employees
        GROUP BY department_id);
        
SELECT department_id dept_id, count(*) cnt
        FROM hr.employees
        GROUP BY department_id;        
            
SELECT *
FROM (SELECT department_id
        FROM hr.employees)
PIVOT (count(*) FOR department_id IN (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, null "부서가 없는 사원"));

SELECT department_id, sum(salary)
FROM hr.employees
GROUP By department_id;

SELECT department_id, sum(salary)
FROM hr.employees
GROUP BY department_id;

SELECT *
FROM (SELECT department_id, salary
        FROM hr.employees)
PIVOT (sum(salary) FOR department_id IN (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, null "부서가 없는 사원"));

-- [문제37] 년도별 입사 인원수를 출력해주세요. (가로방향으로 출력해주세요)
SELECT * 
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'))
PIVOT (max(cnt) FOR year in ('2001' "2001", '2002' "2002", '2003' "2003", '2004' "2004", '2005' "2005", '2006' "2006", '2007' "2007", '2008' "2008"));

SELECT 
    min(decode(year, '2001', cnt)) "2001",
    min(decode(year, '2002', cnt)) "2002",
    min(decode(year, '2003', cnt)) "2003",
    min(decode(year, '2004', cnt)) "2004",
    min(decode(year, '2005', cnt)) "2005",
    min(decode(year, '2006', cnt)) "2006",
    min(decode(year, '2007', cnt)) "2007",
    min(decode(year, '2008', cnt)) "2008"
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'));
   
   
SELECT * 
FROM (
        SELECT * 
        FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
                FROM hr.employees
                GROUP BY to_char(hire_date, 'yyyy'))
                PIVOT (max(cnt) FOR year in ('2001' "2001", '2002' "2002", '2003' "2003", '2004' "2004", '2005' "2005", '2006' "2006", '2007' "2007", '2008' "2008")))
UNPIVOT(인원수 FOR 년도 IN ("2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008"));

SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy');

SELECT * 
FROM (
        SELECT * 
        FROM (SELECT to_char(hire_date, 'yyyy') year
                FROM hr.employees)
                PIVOT (count(*) FOR year in ('2001' "2001", '2002' "2002", '2003' "2003", '2004' "2004", '2005' "2005", '2006' "2006", '2007' "2007", '2008' "2008")))
UNPIVOT(인원수 FOR 년도 IN ("2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008"));
        