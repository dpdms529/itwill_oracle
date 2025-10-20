-- [문제9] employees 테이블에 있는 데이터 중에 job_id가 SA로 시작되고 salary 값은 10000이상 받고 2005년도에 입사한(hire_date)
-- 사원들의 정보를 출력해주세요.
SELECT *
FROM hr.employees
WHERE job_id LIKE 'SA%'
AND salary >= 10000
AND hire_date BETWEEN TO_DATE('20050101', 'yyyymmdd') AND TO_DATE('20060101', 'yyyymmdd') - 1/24/60/60;

-- [문제10] employees테이블에서 job_id 가 SA_REP 또는 AD_PRES 사원들 중에 salary값이 10000 초과한 사원들의 정보를 출력해주세요.
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

-- 정렬
-- 오름차순 정렬
SELECT employee_id, last_name, salary
FROM hr.employees
ORDER BY salary;

SELECT employee_id, last_name, salary
FROM hr.employees
ORDER BY salary ASC;

-- 내림차순 정렬
SELECT employee_id, last_name, salary
FROM hr.employees
ORDER BY salary DESC;

-- 표현식 사용 가능
SELECT employee_id, last_name, salary, salary * 12
FROM hr.employees
ORDER BY salary * 12;

-- 열 별칭 사용 가능
SELECT employee_id, last_name, salary, salary * 12 annual_salary
FROM hr.employees
ORDER BY annual_salary;

-- 열 별칭 사용시 주의점 : 큰 따옴표 사용한 경우 동일하게 큰 따옴표 사용해야 함
SELECT employee_id, last_name, salary, salary * 12 "annual_salary"
FROM hr.employees
ORDER BY "annual_salary";

-- 위치 표기법 사용
SELECT employee_id, last_name, salary, salary * 12 annual_salary
FROM hr.employees
ORDER BY 4;

-- 정렬 기준 컬럼 여러 개 기술 가능
SELECT employee_id, last_name, department_id, salary * 12 annual_salary
FROM hr.employees
ORDER BY 3 ASC, 4 DESC;

-- [문제11] 2006년도 입사한 사원의 employee_id, last_name, hire_date를 출력해주세요 단 last_name 이름을 기준으로 오름차순정렬 해주세요.
SELECT employee_id, last_name, hire_date
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20060101', 'yyyymmdd') AND TO_DATE('20070101', 'yyyymmdd') - 1/24/60/60
ORDER BY last_name;

-- [문제12] 80번 department_id 사원중에 commission_pct 값이 0.2 이고 job_id는 SA_MAN인 사원의 employee_id, last_name, salary를 출력해주세요.
-- 단 last_name 이름을 기준으로 오름차순정렬해 주세요.
SELECT employee_id, last_name, salary
FROM hr.employees
WHERE department_id = 80
AND commission_pct = 0.2
AND job_id = 'SA_MAN'
ORDER BY last_name;

-- [문제13] salary가 5000 ~ 12000의 범위에 속하지 않는 모든 사원의 last_name 및 salary를 출력해주세요. 단 salary을 기준으로 내림차순 정렬하세요.
SELECT last_name, salary
FROM hr.employees
WHERE salary < 5000
OR salary > 12000
ORDER BY salary DESC;

-- 함수
-- 문자 함수
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

SELECT length('오라클'), lengthb('오라클')
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

SELECT substr('abcdef', 1, 2), substrb('abcdef', 1, 2), substr('가나다라마바', 1, 2), substrb('가나다라마바', 1, 6)
FROM dual;

-- trim
SELECT 'aabbcaa', trim('a' from 'aabbcaa'), ltrim('aabbcaa', 'a'), rtrim('aabbcaa', 'a')
FROM dual;

SELECT '  oracle  ', trim(' ' from '  oracle  '), ltrim('  oracle  ', ' '), rtrim('  oracle  ', ' ')
FROM dual;

SELECT '  oracle  ', length('  oracle  '), trim('  oracle  '), length(trim('  oracle  ')), ltrim('  oracle  '), length(ltrim('  oracle  ')), rtrim('  oracle  '), length(rtrim('  oracle  '))
FROM dual;

-- [문제14] employees 테이블에 last_name 컬럼의 값 중에  "J" 또는 "A" 또는 "M"으로 시작하는 
-- 사원들의 last_name, last_name의 길이를 표시하는 query(select문) 를 작성합니다.
-- 사원들의 last_name 기준으로 내림차순 정렬해 주세요.
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

-- [문제15] employees테이블에서 department_id(부서코드)가 50번 사원들 중에 
-- last_name에 두번째 위치에 "a"글자가 있는 사원들을 조회하세요.
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

-- [문제16] salary에 있는 값을 1000당 * 출력해주세요.
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

-- 숫자 함수
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

-- [문제17] employees 테이블에 있는 employee_id, last_name, salary, 
-- salary를 10% 인상된 급여를 계산하면서 계산된 급여는 소수점은 반올림해서 정수값으로 표현하고 
-- 열별칭은 New Salary로 표시하세요.
SELECT employee_id, last_name, salary, round(salary * 1.1) "New Salary", round(salary * 1.1) - salary "Diff New Salary"
FROM hr.employees;