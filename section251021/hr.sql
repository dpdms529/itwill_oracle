-- 날짜 함수
SELECT
    sysdate,
    systimestamp,
    current_date,
    current_timestamp,
    localtimestamp
FROM dual;

-- 세션 타임존 수정
ALTER SESSION SET TIME_ZONE = '+09:00';

-- 날짜 계산
SELECT sysdate + sysdate
FROM dual;

SELECT
    sysdate + 100,
    sysdate - 100
FROM dual;

SELECT
    employee_id,
    hire_date,
    TRUNC(sysdate - hire_date)
FROM hr.employees;

SELECT
    systimestamp,
    TO_CHAR(systimestamp + 10/24, 'yyyy-mm-dd hh24:mi:ss'),
    TO_CHAR(localtimestamp + 10/24, 'yyyy-mm-dd hh24:mi:ss'),
    TO_CHAR(current_timestamp + 10/24, 'yyyy-mm-dd hh24:mi:ss')
FROM dual;

SELECT
    employee_id,
    hire_date,
    TRUNC(sysdate - hire_date) 근무일수, 
    TRUNC(months_between(sysdate, hire_date)) 근무개월수
FROM hr.employees;

SELECT 
    sysdate,
    add_months(sysdate, 5),
    add_months(sysdate, -5)
FROM dual;

SELECT
    sysdate,
    next_day(sysdate, '금요일')
FROM dual;

SELECT
    sysdate,
    last_day(sysdate),
    last_day(add_months(sysdate, 1))
FROM dual;

SELECT
    systimestamp,
    trunc(systimestamp, 'month'),
    trunc(systimestamp, 'year'),
    TO_CHAR(trunc(systimestamp), 'yy/mm/dd hh24:mi:ss.sssss')
FROM dual;

SELECT
    systimestamp,
    round(systimestamp, 'month'),
    round(systimestamp, 'year'),
    round(systimestamp)
FROM dual;

-- [문제18] 20년 이상 근무한 사원들의 사원번호(employee_id), 입사날짜(hire_date),  근무개월수를 조회하세요.
SELECT employee_id 사원번호, hire_date 입사날짜, trunc(months_between(sysdate, hire_date)) 근무개월수
FROM hr.employees
WHERE months_between(sysdate, hire_date) >= 240;

-- [문제19] 사원의 last_name,hire_date 및 근무 6 개월 후 월요일에 해당하는 날짜를 조회하세요. 열별칭은 REVIEW 로 지정합니다.
SELECT last_name, hire_date, next_day(add_months(hire_date, 6), '월요일') review
FROM hr.employees;

SELECT
    sysdate,
    to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss.sssss'),
    to_char(sysdate, 'yy yyyy rr rrrr year') 년,
    to_char(sysdate, 'mm mon month') 월,
    to_char(sysdate, 'dd ddd') 일,
    to_char(sysdate, 'hh hh12 hh24') 시,
    to_char(sysdate, 'mi ss sssss') 분초밀리초,
    to_char(sysdate, 'day dy d') 요일,
    to_char(sysdate, 'ww w') 주,
    to_char(sysdate, 'q"분기"') 분기,
    to_char(sysdate, 'ddsp ddth ddthsp') 문자일
FROM dual;

select * from nls_session_parameters;

-- [문제20] 사원들의 사원번호, 입사한 요일을 출력하세요. 단 요일을 오름차순 정렬해주세요.
SELECT employee_id 사원번호, to_char(hire_date, 'day') 입사요일
FROM hr.employees
ORDER BY to_char(hire_date, 'd');

-- 월요일부터 정렬
SELECT employee_id 사원번호, to_char(hire_date, 'day') 입사요일
FROM hr.employees                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
ORDER BY to_char(hire_date-1, 'd');

SELECT
    salary,
    to_char(salary, '$999,999.00'),
    to_char(salary, '$000,999.00'),
    to_char(salary, 'L999G999D00')
FROM hr.employees;

SELECT
    100,
    -100,
    to_char(-100, '999mi'),
    to_char(-100, '999pr'),
    to_char(100, 's999')
FROM dual;

ALTER SESSION SET NLS_LANGUAGE = korean;
ALTER SESSION SET NLS_TERRITORY = korea;

select * from nls_session_parameters;

SELECT
    employee_id,
    salary,
    hire_date,
    to_char(hire_date, 'day month mon'),
    to_char(salary, 'L999G999D00')
FROM hr.employees;

-- [문제21] 2006년도에 홀수달에 입사한 사원들의 정보를 출력해주세요.
SELECT *
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20060101', 'yyyymmdd') AND TO_DATE('20070101', 'yyyymmdd') - 1/24/60/60
AND mod(to_number(to_char(hire_date, 'mm')), 2) = 1;

SELECT 
    '1' + 2, -- 암시적 형 변환
    to_number('1', '9') + 2, -- 명시적 형 변환
    to_number('1') + 2
FROM dual;

SELECT
    to_char(to_date('95-10-27', 'yy-mm-dd'), 'yyyy-mm-dd'),
    to_char(to_date('95-10-27', 'rr-mm-dd'), 'yyyy-mm-dd')
FROM dual;

-- Null 관련 함수
-- nvl
SELECT
    employee_id,
    salary,
    commission_pct,
    salary * 12 + salary * 12 * commission_pct ann_sal_1,
    salary * 12 + salary * 12 * nvl(commission_pct, 0) ann_sal_2
FROM hr.employees;

SELECT
    employee_id,
    salary,
    commission_pct,
    nvl(commission_pct, 0),
    nvl(to_char(commission_pct), 'no comm')
FROM hr.employees;

SELECT
    employee_id,
    salary,
    commission_pct,
    salary * 12 + salary * 12 * commission_pct ann_sal_1,
    salary * 12 + salary * 12 * nvl(commission_pct, 0) ann_sal_2,
    nvl2(commission_pct, salary * 12 + salary * 12 * commission_pct, salary * 12) ann_sal3
FROM hr.employees;

SELECT
    employee_id,
    salary,
    commission_pct,
    nvl(commission_pct, 0),
    nvl(to_char(commission_pct), 'no comm'),
    nvl2(commission_pct, to_char(salary*12), 'no comm')
FROM hr.employees;

SELECT
    employee_id,
    salary,
    commission_pct,
    salary * 12 + salary * 12 * commission_pct ann_sal_1,
    salary * 12 + salary * 12 * nvl(commission_pct, 0) ann_sal_2,
    nvl2(commission_pct, salary * 12 + salary * 12 * commission_pct, salary * 12) ann_sal3,
    coalesce(salary * 12 + salary * 12 * commission_pct, salary * 12, 0) ann_sal4
--    coalesce(salary * 12 + salary * 12 * commission_pct, 'no comm', 0) 오류
FROM hr.employees;