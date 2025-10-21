-- ��¥ �Լ�
SELECT
    sysdate,
    systimestamp,
    current_date,
    current_timestamp,
    localtimestamp
FROM dual;

-- ���� Ÿ���� ����
ALTER SESSION SET TIME_ZONE = '+09:00';

-- ��¥ ���
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
    TRUNC(sysdate - hire_date) �ٹ��ϼ�, 
    TRUNC(months_between(sysdate, hire_date)) �ٹ�������
FROM hr.employees;

SELECT 
    sysdate,
    add_months(sysdate, 5),
    add_months(sysdate, -5)
FROM dual;

SELECT
    sysdate,
    next_day(sysdate, '�ݿ���')
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

-- [����18] 20�� �̻� �ٹ��� ������� �����ȣ(employee_id), �Ի糯¥(hire_date),  �ٹ��������� ��ȸ�ϼ���.
SELECT employee_id �����ȣ, hire_date �Ի糯¥, trunc(months_between(sysdate, hire_date)) �ٹ�������
FROM hr.employees
WHERE months_between(sysdate, hire_date) >= 240;

-- [����19] ����� last_name,hire_date �� �ٹ� 6 ���� �� �����Ͽ� �ش��ϴ� ��¥�� ��ȸ�ϼ���. ����Ī�� REVIEW �� �����մϴ�.
SELECT last_name, hire_date, next_day(add_months(hire_date, 6), '������') review
FROM hr.employees;

SELECT
    sysdate,
    to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss.sssss'),
    to_char(sysdate, 'yy yyyy rr rrrr year') ��,
    to_char(sysdate, 'mm mon month') ��,
    to_char(sysdate, 'dd ddd') ��,
    to_char(sysdate, 'hh hh12 hh24') ��,
    to_char(sysdate, 'mi ss sssss') ���ʹи���,
    to_char(sysdate, 'day dy d') ����,
    to_char(sysdate, 'ww w') ��,
    to_char(sysdate, 'q"�б�"') �б�,
    to_char(sysdate, 'ddsp ddth ddthsp') ������
FROM dual;

select * from nls_session_parameters;

-- [����20] ������� �����ȣ, �Ի��� ������ ����ϼ���. �� ������ �������� �������ּ���.
SELECT employee_id �����ȣ, to_char(hire_date, 'day') �Ի����
FROM hr.employees
ORDER BY to_char(hire_date, 'd');

-- �����Ϻ��� ����
SELECT employee_id �����ȣ, to_char(hire_date, 'day') �Ի����
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

-- [����21] 2006�⵵�� Ȧ���޿� �Ի��� ������� ������ ������ּ���.
SELECT *
FROM hr.employees
WHERE hire_date BETWEEN TO_DATE('20060101', 'yyyymmdd') AND TO_DATE('20070101', 'yyyymmdd') - 1/24/60/60
AND mod(to_number(to_char(hire_date, 'mm')), 2) = 1;

SELECT 
    '1' + 2, -- �Ͻ��� �� ��ȯ
    to_number('1', '9') + 2, -- ����� �� ��ȯ
    to_number('1') + 2
FROM dual;

SELECT
    to_char(to_date('95-10-27', 'yy-mm-dd'), 'yyyy-mm-dd'),
    to_char(to_date('95-10-27', 'rr-mm-dd'), 'yyyy-mm-dd')
FROM dual;

-- Null ���� �Լ�
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
--    coalesce(salary * 12 + salary * 12 * commission_pct, 'no comm', 0) ����
FROM hr.employees;