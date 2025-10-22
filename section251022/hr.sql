-- nullif
SELECT 
    employee_id,
    length(last_name),
    length(first_name),
    nullif(length(last_name), length(first_name))
FROM hr.employees;

-- lnnvl
SELECT *
FROM hr.employees
WHERE department_id <> 50
OR department_id is null;

SELECT *
FROM hr.employees
WHERE LNNVL(department_id = 50);

-- decode
SELECT
    employee_id,
    salary,
    job_id,
    decode(job_id, 'IT_PROG', salary * 1.1,
                    'ST_CLERK', salary * 1.2,
                    'SA_REP', salary * 1.3,
                    salary) revised_salary
FROM hr.employees;

SELECT
    employee_id,
    salary,
    job_id,
    hire_date,
    decode(job_id, 'IT_PROG', salary * 1.1,
                    'ST_CLERK', salary * 1.2,
                    'SA_REP', salary * 1.3,
                    salary) revised_salary,
    decode(job_id, 'IT_PROG', decode(to_char(hire_date, 'yyyy'), '2005', salary * 1.15, salary * 1.1), salary) revised_salary2
FROM hr.employees;

-- case
SELECT
    employee_id,
    salary,
    job_id,
    hire_date,
    case job_id
        when 'IT_PROG' then salary * 1.1
        when 'ST_CLERK' then salary * 1.2
        when 'SA_REP' then salary * 1.3
        else salary 
    end revised_salary
FROM hr.employees;

SELECT
    employee_id,
    salary,
    job_id,
    hire_date,
    case
        when job_id = 'IT_PROG' then salary * 1.1
        when job_id = 'ST_CLERK' then salary * 1.2
        when job_id = 'SA_REP' then salary * 1.3
        else salary 
    end revised_salary
FROM hr.employees;

SELECT
    employee_id,
    salary,
    job_id,
    hire_date,
    case
        when job_id = 'IT_PROG' then case when to_char(hire_date, 'yyyy') = '2005' then salary * 1.15 else salary * 1.1 end
        when job_id = 'ST_CLERK' then salary * 1.2
        when job_id = 'SA_REP' then salary * 1.3
        else salary 
    end revised_salary
FROM hr.employees;

-- [문제22] 사원들의 급여를 표기준 이용해서 출력해주세요.
/*
         ~4999      : low
     5000~9999      : medium
    10000~19999     : good
    20000~          : excellent
*/

SELECT
    employee_id,
    salary,
    case
        when salary < 5000 then 'low'
        when salary < 10000 then 'medium'
        when salary < 20000 then 'good'
        else 'excellent'
    end grade
FROM hr.employees;

SELECT
		employee_id,
    salary,
    commission_pct,
    salary * 12 + salary * 12 * nvl(commission_pct, 0) ann_sal_1,
    nvl2(commission_pct, salary * 12 + salary * 12 * commission_pct, salary * 12) ann_sal2,
    decode(commission_pct, null, salary * 12, salary * 12 + salary * 12 * commission_pct) ann_sal3,
    case
        when commission_pct is null then salary * 12
        else salary * 12 + salary * 12 * commission_pct
    end ann_sal4
FROM hr.employees;

-- 그룹 함수
-- count
SELECT count(*) FROM hr.employees;

SELECT count(department_id) FROM hr.employees;

SELECT count(commission_pct) FROM hr.employees;

-- 중복을 제거한 행수 구하기
SELECT count(distinct department_id) FROM hr.employees;

SELECT count(unique department_id) FROM hr.employees;

SELECT count(*)
FROM hr.employees
WHERE department_id = 50;

-- sum
SELECT sum(salary) FROM hr.employees;

-- avg
SELECT avg(salary) FROM hr.employees;

SELECT round(avg(salary)) FROM hr.employees;

SELECT avg(commission_pct) FROM hr.employees;
SELECT avg(nvl(commission_pct, 0)) FROM hr.employees;

-- median
SELECT median(salary) FROM hr.employees;

-- variance
SELECT variance(salary) FROM hr.employees;

-- stddev
SELECT stddev(salary) FROM hr.employees;

-- max
SELECT max(salary) FROM hr.employees;

-- min
SELECT min(salary) FROM hr.employees;

SELECT
    count(last_name),
    count(hire_date),
    max(last_name),
    max(hire_date),
    min(last_name),
    min(hire_date)
FROM hr.employees;

-- group by
SELECT department_id, sum(salary)
FROM hr.employees
GROUP BY department_id;

SELECT department_id, sum(salary)
FROM hr.employees;

SELECT department_id, job_id, sum(salary)
FROM hr.employees
GROUP BY department_id;


SELECT department_id, job_id job, sum(salary)
FROM hr.employees
GROUP BY department_id, job;

SELECT department_id, sum(salary)
FROM hr.employees
WHERE sum(salary) >= 15000 
GROUP BY department_id;

-- having
SELECT department_id, sum(salary)
FROM hr.employees
GROUP BY department_id
HAVING sum(salary) >= 15000;

SELECT department_id, count(*)
FROM hr.employees
GROUP BY department_id;

SELECT department_id, count(*), sum(salary)
FROM hr.employees
GROUP BY department_id
HAVING count(*) >= 5;

SELECT department_id, sum(salary)
FROM hr.employees
WHERE last_name like '%i%'
GROUP BY department_id
HAVING sum(salary) >= 10000
ORDER BY 1;

SELECT department_id, max(sum(salary))
FROM hr.employees
GROUP BY department_id;

SELECT max(sum(salary))
FROM hr.employees
GROUP BY department_id;

-- 나쁜 예시
SELECT department_id, sum(salary)
FROM hr.employees
GROUP BY department_id
HAVING department_id in (50, 60, 70);

SELECT department_id, sum(salary)
FROM hr.employees
WHERE department_id in (50, 60, 70)
GROUP BY department_id;

-- [문제23] 2008년도에 입사한 사원들의 job_id별 인원수를 구하고 인원수가 많은 순으로 출력하세요.
SELECT job_id, count(*) cnt
FROM hr.employees
WHERE hire_date between to_date('20080101', 'yyyymmdd') and to_date('20090101', 'yyyymmdd') - 1/24/60/60
GROUP BY job_id
ORDER BY cnt desc;

-- [문제24] 년도별 입사 인원수를 출력해주세요.
SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy')
ORDER BY year;

-- [문제25] 년도별 입사 인원수를 아래 화면과 같이 출력해주세요.
SELECT 
    count(*) TOTAL,
    count(case when to_char(hire_date, 'yyyy') = '2001' then 1 end) "2001년",
    count(case when to_char(hire_date, 'yyyy') = '2002' then 1 end) "2002년",
    count(case when to_char(hire_date, 'yyyy') = '2003' then 1 end) "2003년"
FROM hr.employees;

/*
     TOTAL     2001년     2002년     2003년
---------- ---------- ---------- ----------
       107          1          7          6
*/

-- Join
-- cartesian product
SELECT *
FROM hr.employees, hr.departments;

SELECT count(*)
FROM hr.employees, hr.departments;

select count(*)
from hr.employees;

select count(*)
from hr.departments;

-- 등가 조인
SELECT e.department_id, department_name
FROM hr.employees, hr.departments
WHERE department_id = department_id; --  오류 발생

SELECT e.department_id, department_name
FROM hr.employees, hr.departments
WHERE hr.employees.department_id = hr.departments.department_id;

SELECT e.department_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id;

-- 현재 사원들이 근무하는 도시 조회
SELECT e.employee_id, l.city
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id;

-- 현재 사원들이 근무하는 국가 조회
SELECT e.employee_id, c.country_name
FROM hr.employees e, hr.departments d, hr.locations l, hr.countries c
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id;
