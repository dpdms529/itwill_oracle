BEGIN
    dbms_output.put_line('오늘 하루도 열심히 공부하자!!');
END;
/

BEGIN
    dbms_output.put_line('today''s : ' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
    dbms_output.put_line('tomorrow''s : ' || to_char(sysdate + 1, 'yyyy-mm-dd hh24:mi:ss'));
END;
/

BEGIN
    dbms_output.put_line(q'[today's : ]' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
    dbms_output.put_line(q'[tomorrow's : ]' || to_char(sysdate + 1, 'yyyy-mm-dd hh24:mi:ss'));
END;
/

DECLARE
    v_name varchar(30);
BEGIN
    dbms_output.put_line('My name is ' || v_name);
    v_name := 'james';
    dbms_output.put_line('My name is ' || v_name);
END;
/

DECLARE
    v_name varchar(30) := 'liam';
BEGIN
    dbms_output.put_line('My name is ' || v_name);
    v_name := 'james';
    dbms_output.put_line('My name is ' || v_name);
END;
/

DECLARE
    /* scalar data type : 단일값만 보유하는 변수 */
    v_a number(5);
    v_b number(3) := 100;
    v_c varchar2(10) NOT NULL := 'oracle';
    v_d CONSTANT date default sysdate;
    v_e CONSTANT number(3) := 20;
BEGIN
    v_a := 200;
    dbms_output.put_line(v_a);
    dbms_output.put_line(v_b);
    dbms_output.put_line(v_c);
    dbms_output.put_line(v_d);
    dbms_output.put_line(v_e);
END;
/

DECLARE
    /* local variable(지역변수) : 선언된 블록 프로그램에서만 수행하는 변수 */
    v_sal number := 10000;
    v_comm number := 1000;
    v_total number;
BEGIN
    v_total := v_sal + v_comm;
    dbms_output.put_line(v_total);
END;
/

SELECT * FROM hr.employees WHERE salary > v_total;
-- v_total 변수는 local variable(지역 변수)이기 때문에 블록 프로그램 바깥쪽에서 사용 불가

var b_total number

DECLARE
    v_sal number := 10000;
    v_comm number := 1000;
BEGIN
    :b_total := v_sal + v_comm;
    dbms_output.put_line(:b_total);
END;
/

print :b_total
print b_total

SELECT * FROM hr.employees WHERE salary > :b_total;

SELECT * FROM hr.employees WHERE employee_id = :b_id;

SELECT * FROM hr.employees WHERE employee_id = 100;
SELECT * FROM hr.employees WHERE employee_id = 101;
SELECT * FROM hr.employees WHERE employee_id = 102;
SELECT * FROM hr.employees WHERE employee_id = 103;
SELECT * FROM hr.employees WHERE employee_id = 104;
SELECT * FROM hr.employees WHERE employee_id = 105;

SELECT * FROM hr.employees WHERE employee_id = :b_id;

DECLARE
    v_last_name varchar2(10) := 'hong';
    v_first_name varchar2(30) := 'gil dong';
BEGIN
    dbms_output.put_line(upper(v_last_name));
    dbms_output.put_line(initcap(v_first_name));
END;
/

DECLARE
    v_last_name varchar2(10) := initcap('hong');
    v_first_name varchar2(30) := initcap('gil dong');
BEGIN
    dbms_output.put_line(v_last_name || ' ' || v_first_name);
END;
/

DECLARE
    v_sal number := 10000;
    v_comm number;
    v_total number;
BEGIN
    v_total := v_sal * 12 + v_sal * nvl(v_comm, 0) * 12;
    dbms_output.put_line(v_total);
END;
/

DECLARE
    v_sal number := 10000;
    v_comm number := 0.1;
    v_total number;
BEGIN
    v_total := coalesce(v_sal * 12 + v_sal * v_comm * 12, v_sal * 12);
    dbms_output.put_line(v_total);
END;
/

DECLARE
    v_begin_date date := to_date('2025-01-01', 'yyyy-mm-dd');
    v_end_date date := to_date('2025-11-04', 'yyyy-mm-dd');
BEGIN
    dbms_output.put_line(v_end_date - v_begin_date);
    dbms_output.put_line(trunc(months_between(v_end_date, v_begin_date)));
    dbms_output.put_line(add_months(v_end_date, 4));
    dbms_output.put_line(next_day(v_end_date, '금요일'));
    dbms_output.put_line(last_day(v_end_date));
END;
/

/* MAIN BLOCK, OUTER BLOCK */
DECLARE
    v_outer_variable varchar2(30) := 'outer variable';
BEGIN
    /* SUB BLOCK, INNER BLOCK */
    DECLARE
        v_inner_variable varchar2(30) := 'inner variable';
    BEGIN
        dbms_output.put_line(v_inner_variable);
        dbms_output.put_line(v_outer_variable);
    END;
    
--    dbms_output.put_line(v_inner_variable);
--    PLS-00201: identifier 'V_INNER_VARIABLE' must be declared
    dbms_output.put_line(v_outer_variable);
END;
/


DECLARE
    v_father_name varchar2(20) := 'Patrick';
    v_date_of_birth date := to_date('1960-01-01', 'yyyy-mm-dd');
BEGIN
    DECLARE
        v_child_name varchar2(20) := 'Mike';
        v_date_of_birth date := to_date('1990-01-01', 'yyyy-mm-dd');
    BEGIN
        dbms_output.put_line('Father''s Name : ' || v_father_name);
        dbms_output.put_line('Date of Birth : ' || v_date_of_birth);
        dbms_output.put_line('Child''s Name : ' || v_child_name);
        dbms_output.put_line('Date of Birth : ' || v_date_of_birth);
    END;
    
    dbms_output.put_line('Father''s Name : ' || v_father_name);
    dbms_output.put_line('Date of Birth : ' || v_date_of_birth);
END;
/

<<outer>>
DECLARE
    v_father_name varchar2(20) := 'Patrick';
    v_date_of_birth date := to_date('1960-01-01', 'yyyy-mm-dd');
BEGIN
    DECLARE
        v_child_name varchar2(20) := 'Mike';
        v_date_of_birth date := to_date('1990-01-01', 'yyyy-mm-dd');
    BEGIN
        dbms_output.put_line('Father''s Name : ' || v_father_name);
        dbms_output.put_line('Date of Birth : ' || outer.v_date_of_birth);
        dbms_output.put_line('Child''s Name : ' || v_child_name);
        dbms_output.put_line('Date of Birth : ' || v_date_of_birth);
    END;
    
    dbms_output.put_line('Father''s Name : ' || v_father_name);
    dbms_output.put_line('Date of Birth : ' || v_date_of_birth);
END;
/

<<outer>>
DECLARE
    v_sal number := 60000;
    v_comm number := v_sal * 0.2;
    v_message varchar2(50) := 'eligible for commission';
BEGIN
    DECLARE
        v_sal number := 50000;
        v_comm number := 0;
        v_total number := v_sal + v_comm;
    BEGIN
        v_message := 'Clerk not ' || v_message;
        outer.v_comm := v_sal * 0.3;
        dbms_output.put_line('******* sub block *******');
        dbms_output.put_line(v_sal);
        dbms_output.put_line(v_comm);
        dbms_output.put_line(v_total);
        dbms_output.put_line(v_message);
    END;
    
    dbms_output.put_line('******* main block *******');
    dbms_output.put_line(v_sal);
    dbms_output.put_line(v_comm);
    -- dbms_output.put_line(v_total);
    dbms_output.put_line('Salesman ' || v_message);
END;
/

DECLARE
    v_flag boolean := true;
BEGIN
    IF v_flag THEN
        dbms_output.put_line('참');
    END IF;
END;
/

DECLARE
    v_flag boolean;
BEGIN
    IF v_flag THEN
        dbms_output.put_line('참');
    ELSE
        dbms_output.put_line('거짓');
    END IF;
END;
/

DECLARE
    v_num number;
BEGIN
    IF v_num IS NULL THEN
        dbms_output.put_line('참');
    ELSE
        dbms_output.put_line('거짓');
    END IF;
END;
/

DECLARE
    v_num number;
BEGIN
    IF v_num IS NOT NULL THEN
        dbms_output.put_line('참');
    ELSE
        dbms_output.put_line('거짓');
    END IF;
END;
/

DECLARE
    v_num1 number := 10;
    v_num2 number := 20;
BEGIN
    IF v_num1 >= v_num2 THEN
        dbms_output.put_line(v_num1 - v_num2);
    ELSIF v_num1 < v_num2 THEN
        dbms_output.put_line(v_num2 - v_num1);
    END IF;
END;
/

DECLARE
    v_sal number := 10000;
    v_comm number := 0.1;
    v_annual_salary number;
BEGIN
    IF v_comm IS NOT NULL THEN
        v_annual_salary := v_sal * 12 + v_sal * v_comm * 12;
        dbms_output.put_line(v_annual_salary);
    ELSE
        v_annual_salary := v_sal * 12;
        dbms_output.put_line(v_annual_salary);
    END IF;
END;
/

DECLARE
    v_sal number := :b_sal;
    v_comm number := :b_comm;
    v_annual_salary number;
BEGIN
    IF v_comm IS NOT NULL THEN
        v_annual_salary := v_sal * 12 + v_sal * v_comm * 12;
        dbms_output.put_line(v_annual_salary);
    ELSE
        v_annual_salary := v_sal * 12;
        dbms_output.put_line(v_annual_salary);
    END IF;
END;
/

DECLARE
    v_result := decode(); -- 오류 발생
BEGIN
    v_result := IF ...; -- 오류 발생
END;
/

DECLARE
	v_grade char(1) := upper('a');
	v_appraisal varchar2(30);
BEGIN
	v_appraisal := CASE v_grade
                        WHEN 'A' THEN '참잘했어요'
                        WHEN 'B' THEN '잘했어요'
                        WHEN 'C' THEN '다음에 잘해요'
                        ELSE 
                            '니가 사람이야!!'
                    END;
    dbms_output.put_line('등급은 ' || v_grade || ' 평가는 ' || v_appraisal);
END;
/

DECLARE
	v_grade char(1) := upper(:b_grade);
	v_appraisal varchar2(30);
BEGIN
	v_appraisal := CASE WHEN v_grade = 'A' THEN '참잘했어요'
                        WHEN v_grade IN ('B', 'C') THEN '잘했어요'
                        WHEN v_grade = 'D' THEN '다음에 잘해요'
                        ELSE 
                            '니가 사람이야!!'
                    END;
    dbms_output.put_line('등급은 ' || v_grade || ' 평가는 ' || v_appraisal);
END;
/

-- SQL*Plus
var b_grade char(1)
exec :b_grade := 'c'

DECLARE
	v_grade char(1) := upper(:b_grade);
	v_appraisal varchar2(30);
BEGIN
	v_appraisal := CASE WHEN v_grade = 'A' THEN '참잘했어요'
                        WHEN v_grade IN ('B', 'C') THEN '잘했어요'
                        WHEN v_grade = 'D' THEN '다음에 잘해요'
                        ELSE 
                            '니가 사람이야!!'
                    END;
    dbms_output.put_line('등급은 ' || v_grade || ' 평가는 ' || v_appraisal);
END;
/

DECLARE
	v_grade char(1) := upper(:b_grade);
	v_appraisal varchar2(30);
BEGIN
    IF v_grade = 'A' THEN
        v_appraisal := '참잘했어요'
    ELSIF v_grade IN ('B', 'C') THEN
        v_appraisal := '잘했어요'
    ELSIF v_grade = 'D' THEN
        v_appraisal := '다음에 잘해요'
    ELSE
        v_appraisal := '니가 사람이야!!'
    END IF;
    
    dbms_output.put_line('등급은 ' || v_grade || ' 평가는 ' || v_appraisal);
END;
/