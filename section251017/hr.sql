-- null
SELECT 
	employee_id, 
	salary, 
	commission_pct, 
	salary * 12 + salary * 12 * commission_pct
FROM hr.employees;

-- nvl
SELECT 
	employee_id, 
	salary, 
	nvl(commission_pct, 0), 
	salary * 12 + salary * 12 * nvl(commission_pct, 0)
FROM hr.employees;

-- 별칭
SELECT 
	employee_id 사번, 
	salary 급여, 
	nvl(commission_pct, 0) 보너스, 
	salary * 12 + salary * 12 * nvl(commission_pct, 0) as annual_salary
FROM hr.employees;

-- 연결 연산자
SELECT
    employee_id,
    last_name || first_name
FROM hr.employees;

SELECT
    1000,
    100||00
FROM dual;

SELECT
    1000,
    100||'00'
FROM dual;

SELECT
    last_name,
    salary,
    salary || 00
FROM hr.employees;

desc hr.employees;

-- 리터럴 문자열
SELECT
    employee_id,
    'My Name is ' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
    employee_id,
    'My Name''s ' || last_name || ' ' || first_name "Name"
FROM hr.employees;

-- q(대체 인용) 연산자
SELECT
	employee_id,
	q'[My name's ]' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'<My name's >' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'{My name's }' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'(My name's )' || last_name || ' ' || first_name "Name"
FROM hr.employees;

SELECT
	employee_id,
	q'!My name's !' || last_name || ' ' || first_name "Name"
FROM hr.employees;

-- 중복행 제거
SELECT
    department_id
FROM hr.employees;

SELECT
    unique department_id
FROM hr.employees;

SELECT
    distinct department_id
FROM hr.employees;

SELECT
    distinct department_id, job_id
FROM hr.employees;

-- [문제1] employees 테이블에서 employee_id, last_name과 first_name은 연결해서 표시하고(공백으로 구분) 열 별칭은 화면 예처럼 쿼리문을 작성해 주세요.
SELECT employee_id "Emp#", last_name || ' ' || first_name "Employee Name"
FROM hr.employees;

/*
<화면결과>
Emp#   Employee Name
------- ------------------------------
100 	   King Steven
101 	   Kochhar Neena
*/


-- [문제2] employees 테이블에서 컬럼중에 last_name, job_id를 연결해서 표시하고(쉼표와 공백으로 구분) 열 별칭은 화면 예처럼 쿼리문을 작성해 주세요.
SELECT last_name || ', ' || job_id "Employee and Title"
FROM hr.employees;

/*
<화면결과>
Employee and Title
-------------------------
Abel, SA_REP
Ande, SA_REP
*/

-- [문제3] departments 테이블에 있는 데이터에서 department_name , manager_id 칼럼을 가지고 화면 결과처럼 출력하는 쿼리문을 작성해 주세요.
SELECT department_name || q'[ Department's Manager Id: ]' ||  manager_id "Department and Manager"
FROM hr.departments;

/*
<화면결과>
Department and Manager
--------------------------------------------------				
Administration Department's Manager Id: 200
Marketing Department's Manager Id: 201
......
*/

SELECT *
FROM hr.employees
WHERE last_name = 'King';

-- 결과는 같지만 악성 쿼리
SELECT *
FROM hr.employees
WHERE UPPER(last_name) = 'King';

-- 날짜형
desc hr.employees;

SELECT *
FROM hr.employees
WHERE hire_date = '01/01/13';

SELECT *
FROM hr.employees
WHERE hire_date = '2001-01-13';

SELECT *
FROM hr.employees
WHERE hire_date = '13-Jan-01';

SELECT *
FROM hr.employees
WHERE hire_date = to_date('2001-01-13', 'yyyy-mm-dd');

SELECT *
FROM hr.employees
WHERE hire_date = to_date('20010113', 'yyyymmdd');

-- 국가별 형식 조회
SELECT * FROM nls_session_parameters;

-- 비교 연산자
SELECT *
FROM hr.employees
WHERE employee_id = 100;

SELECT *
FROM hr.employees
WHERE employee_id <> 100;

SELECT *
FROM hr.employees
WHERE employee_id != 100;

SELECT *
FROM hr.employees
WHERE employee_id ^= 100;

SELECT *
FROM hr.employees
WHERE employee_id > 100;

SELECT *
FROM hr.employees
WHERE employee_id >= 100;

SELECT *
FROM hr.employees
WHERE employee_id < 100;

SELECT *
FROM hr.employees
WHERE employee_id <= 100;

-- 논리 연산자
SELECT *
FROM hr.employees
WHERE department_id = 50
AND salary >= 5000;

-- [문제4] employees 테이블에서 급여가 2500 ~ 3500 인 사원들의 last_name, salary를 출력해주세요.
SELECT last_name, salary
FROM hr.employees
WHERE salary >= 2500
AND salary <= 3500;

SELECT last_name, salary
FROM hr.employees
WHERE salary BETWEEN 2500 AND 3500;

-- [문제5] employees 테이블에서 급여가 2500 ~ 3500 이 아닌 사원들의 last_name, salary를 출력해주세요.
SELECT last_name, salary
FROM hr.employees
WHERE salary < 2500
OR salary > 3500;

SELECT last_name, salary
FROM hr.employees
WHERE NOT (salary >= 2500
AND salary <= 3500);

SELECT last_name, salary
FROM hr.employees
WHERE salary NOT BETWEEN 2500 AND 3500;

-- 문자열 비교
SELECT *
FROM hr.employees
WHERE last_name >= 'Abel'
AND last_name <= 'Austin';

SELECT *
FROM hr.employees
WHERE last_name BETWEEN 'Abel' AND 'Austin';

-- [문제6] employees 테이블에서 hire_date(입사일) 2001(01) ~ 2002(02)년도에 입사한 사원 정보를 출력해주세요.
SELECT *
FROM hr.employees
WHERE hire_date >= TO_DATE('20010101', 'yyyymmdd')
AND hire_date < TO_DATE('20031231 23:59:59', 'yyyymmdd hh24:mi:ss');

SELECT *
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20010101', 'yyyymmdd') AND TO_DATE('20031231 23:59:59', 'yyyymmdd hh24:mi:ss');

SELECT *
FROM hr.employees
WHERE hire_date >= TO_DATE('20010101', 'yyyymmdd')
AND hire_date < TO_DATE('20030101', 'yyyymmdd');

SELECT *
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20010101', 'yyyymmdd') AND TO_DATE('20030101', 'yyyymmdd') - 1/24/60/60;

-- IN 연산자
SELECT *
FROM hr.employees
WHERE employee_id = 100
OR employee_id = 105
OR employee_id = 200;

SELECT *
FROM hr.employees
WHERE employee_id IN(100, 105, 200);

SELECT *
FROM hr.employees
WHERE employee_id NOT IN(100, 105, 200);

SELECT *
FROM hr.employees
WHERE employee_id <> 100
AND employee_id <> 105
AND employee_id <> 200;

-- 논리 연산자 우선 순위
SELECT *
FROM hr.employees
WHERE department_id = 30
OR department_id = 50
OR department_id = 60
AND salary > 5000;

SELECT *
FROM hr.employees
WHERE (department_id = 30
OR department_id = 50
OR department_id = 60)
AND salary > 5000;

SELECT *
FROM hr.employees
WHERE department_id IN (30, 50, 60)
AND salary > 5000;

-- NULL 값 체크 연산자
SELECT *
FROM hr.employees
WHERE commission_pct IS NULL;

SELECT *
FROM hr.employees
WHERE commission_pct IS NOT NULL;

-- LIKE 연산자
SELECT *
FROM hr.employees
WHERE last_name LIKE 'K%';

SELECT *
FROM hr.employees
WHERE last_name LIKE '_i%';

SELECT *
FROM hr.employees
WHERE last_name LIKE '__e%';

SELECT *
FROM hr.employees
WHERE hire_date LIKE '02%';

-- JOB_ID 값 중에 HR%로 시작되는 패턴을 추출해야한다면?
-- %를 순수한 문자로 검색해야 할 경우
SELECT *
FROM hr.employees
WHERE job_id LIKE 'HR^%%' ESCAPE '^';

-- [문제7] employees 테이블에 있는 데이터 중에 job_id가 SA로 시작되고 salary 값은 10000이상 받는 사원들의 정보를 출력해주세요.
SELECT *
FROM hr.employees
WHERE job_id LIKE 'SA%'
AND salary >= 10000;

-- [문제8] last_name의 세번째 문자가 'a' 또는 'e' 글자가 포함된 사원들의 정보를 출력해주세요.
SELECT *
FROM hr.employees
WHERE last_name LIKE '__a%'
OR last_name LIKE '__e%';

SELECT *
FROM hr.employees
WHERE REGEXP_LIKE(last_name, '^..[ae]');