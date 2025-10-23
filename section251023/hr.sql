-- [문제26] 80 부서에 근무하는 사원들의 last_name, job_id, department_name, city 출력해주세요.
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

-- ANSI 조인
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

-- 오류 : 조인 컬럼에 테이블 지정하면 안됨
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

-- [문제27] 2006년도에 입사한 사원들의 부서이름별 급여의 총액, 평균을 출력해주세요.
-- 1) 오라클 전용
SELECT d.department_name 부서이름, sum(e.salary) 급여총액, avg(e.salary) 급여평균
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60
GROUP BY d.department_name;

-- 건수 검증
SELECT distinct e.department_id
FROM hr.employees e
WHERE e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60;

-- 2) ANSI 표준
SELECT d.department_name 부서이름, sum(e.salary) 급여총액, avg(e.salary) 급여평균
FROM hr.employees e JOIN hr.departments d
ON e.department_id = d.department_id
WHERE e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60
GROUP BY d.department_name;

-- [문제28] 2007년도에 입사한 사원들의 도시이름별 급여의 총액, 평균을 출력해주세요.
-- 단 부서 배치를 받지 않은 사원들의 정보도 출력해주세요.
-- 1) 오라클 전용
SELECT l.city 도시이름, sum(e.salary) 급여총액, avg(e.salary) 급여평균
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id(+)
AND d.location_id = l.location_id(+)
AND e.hire_date between to_date('20070101','yyyymmdd') and to_date('20080101', 'yyyymmdd') - 1/24/60/60
GROUP BY l.city;

-- 2) ANSI 표준
SELECT l.city 도시이름, sum(e.salary) 급여총액, avg(e.salary) 급여평균
FROM hr.employees e LEFT OUTER JOIN hr.departments d 
ON e.department_id = d.department_id
LEFT OUTER JOIN hr.locations l
ON d.location_id = l.location_id
WHERE e.hire_date between to_date('20070101','yyyymmdd') and to_date('20080101', 'yyyymmdd') - 1/24/60/60
GROUP BY l.city;

-- [문제29] 관리자보다 먼저 입사한 사원의 이름과 입사일 및 해당 관리자의 이름과 입사일 출력해주세요.
-- 1) 오라클 전용
SELECT w.last_name 사원이름, w.hire_date 사원입사일, m.last_name 관리자이름, m.hire_date 관리자입사일
FROM hr.employees w, hr.employees m
WHERE w.manager_id = m.employee_id
AND w.hire_date < m.hire_date;

-- 2) ANSI 표준
SELECT w.last_name 사원이름, w.hire_date 사원입사일, m.last_name 관리자이름, m.hire_date 관리자입사일
FROM hr.employees w JOIN hr.employees m
ON w.manager_id = m.employee_id
WHERE w.hire_date < m.hire_date;

-- 서브쿼리
-- 110번 사원의 급여보다 더 많은 급여를 받는 사원 조회
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

-- [문제30] 최고 급여를 받는 사원들의 정보를 출력해주세요.
SELECT *
FROM hr.employees
WHERE salary = (SELECT max(salary)
                FROM hr.employees);

-- having절 서브쿼리
SELECT department_id, sum(salary)
FROM hr.employees
GROUP BY department_id
HAVING sum(salary) > (SELECT min(salary)
                        FROM hr.employees
                        WHERE department_id = 40);
                        
-- [문제31] 평균 급여가 가장 낮은 부서번호, 평균급여를 출력해주세요.
SELECT department_id, avg(salary)
FROM hr.employees
GROUP BY department_id
HAVING avg(salary) = (SELECT min(avg(salary))
                        FROM hr.employees
                        GROUP BY department_id);

                        
                        