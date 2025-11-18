DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
AS
SELECT employee_id, salary, job_id
FROM hr.employees;

SELECT * FROM hr.emp;

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 3000, 'IT_PROG');

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;

ROLLBACK;

SELECT * FROM hr.jobs
WHERE job_id = 'IT_PROG';

-- 익명 블록
DECLARE
    v_min number;
    v_max number;
BEGIN
    SELECT min_salary min, max_salary max
    INTO v_min, v_max
    FROM hr.jobs
    WHERE job_id = :b_job;
    
    IF :b_sal NOT BETWEEN v_min AND v_max THEN
        RAISE_APPLICATION_ERROR(-20000, '급여는 ' || v_min || ' ~ ' || v_max || ' 사이여야 합니다.');
    END IF;
END;
/

-- 프로시저
CREATE OR REPLACE PROCEDURE check_sal_proc(p_job IN varchar2, p_sal IN number)
IS
    v_min number;
    v_max number;
BEGIN
    SELECT min_salary min, max_salary max
    INTO v_min, v_max
    FROM hr.jobs
    WHERE job_id = p_job;
    
    IF p_sal NOT BETWEEN v_min AND v_max THEN
        RAISE_APPLICATION_ERROR(-20000, '급여는 ' || v_min || ' ~ ' || v_max || ' 사이여야 합니다.');
    END IF;
END check_sal_proc;
/

exec check_sal_proc('IT_PROG', 3000);

DROP PROCEDURE check_sal_proc;

-- 트리거
CREATE OR REPLACE TRIGGER check_sal_trg
BEFORE
INSERT OR UPDATE OF salary, job_id ON hr.emp
FOR EACH ROW
DECLARE
    v_min number;
    v_max number;
BEGIN
    SELECT min_salary min, max_salary max
    INTO v_min, v_max
    FROM hr.jobs
    WHERE job_id = :new.job_id;
    
    IF :new.salary NOT BETWEEN v_min AND v_max THEN
        RAISE_APPLICATION_ERROR(-20000, '급여는 ' || v_min || ' ~ ' || v_max || ' 사이여야 합니다.');
    END IF;
END check_sal_trg;
/

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 3000, 'IT_PROG');

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;

UPDATE hr.emp
SET job_id = 'AD_ASST'
WHERE employee_id = 103;

ROLLBACK;

DROP TRIGGER check_sal_trg;

-- 트리거에서 프로시저 호출
CREATE OR REPLACE TRIGGER check_sal_trg
BEFORE
INSERT OR UPDATE OF salary, job_id ON hr.emp
FOR EACH ROW
BEGIN
    check_sal_proc(:new.job_id, :new.salary);
END check_sal_trg;
/

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 4000, 'IT_PROG');

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;

UPDATE hr.emp
SET job_id = 'AD_ASST'
WHERE employee_id = 103;

-- call 문 : 호출문
call hr.check_sal_proc('IT_PROG', 3000);

-- 트리거에서 CALL문을 이용해서 프로시저 호출
CREATE OR REPLACE TRIGGER check_sal_trg
BEFORE
INSERT OR UPDATE OF salary, job_id ON hr.emp
FOR EACH ROW
CALL check_sal_proc(:new.job_id, :new.salary)
/

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 4000, 'IT_PROG');

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;

UPDATE hr.emp
SET job_id = 'AD_ASST'
WHERE employee_id = 103;

SELECT * FROM user_triggers WHERE trigger_name = 'CHECK_SAL_TRG';
SELECT * FROM user_source WHERE name = 'CHECK_SAL_TRG' ORDER BY line;

DROP TRIGGER CHECK_SAL_TRG;
DROP PROCEDURE CHECK_SAL_PROC;

-- 복합 트리거의 필요성 mutating error
CREATE OR REPLACE TRIGGER check_sal_trg
AFTER
INSERT OR UPDATE OF salary, job_id ON hr.emp
FOR EACH ROW
DECLARE
    v_min number;
    v_max number;
BEGIN
    SELECT min(salary), max(salary)
    INTO v_min, v_max
    FROM hr.emp
    WHERE job_id = :new.job_id;
    
    IF :new.salary NOT BETWEEN v_min AND v_max THEN
        RAISE_APPLICATION_ERROR(-20000, '급여는 ' || v_min || ' ~ ' || v_max || ' 사이여야 합니다.');
    END IF;
END check_sal_trg;
/
SELECT * FROM user_triggers;

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 5000, 'IT_PROG');
-- ORA-04091: table HR.EMP is mutating, trigger/function may not see it

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;
-- ORA-04091: table HR.EMP is mutating, trigger/function may not see it

UPDATE hr.emp
SET job_id = 'AD_ASST'
WHERE employee_id = 103;
-- ORA-04091: table HR.EMP is mutating, trigger/function may not see it

-- 직무별 직원 급여 범위 배열 생성
DECLARE
    CURSOR cur IS 
        SELECT job_id, min(salary) min_sal, max(salary) max_sal
        FROM hr.emp
        GROUP BY job_id;
        
    TYPE rec_type IS RECORD (
        min_sal hr.emp.salary%type,
        max_sal hr.emp.salary%type
    );
    TYPE tab_type IS TABLE OF rec_type INDEX BY varchar2(30);
    v_tab tab_type;
    v_job varchar2(30);
BEGIN
    FOR i IN cur LOOP
        v_tab(i.job_id).min_sal := i.min_sal;
        v_tab(i.job_id).max_sal := i.max_sal;
    END LOOP;
    
    v_job := v_tab.first;
    LOOP
        dbms_output.put_line(v_job || ' ' || v_tab(v_job).min_sal || ' ' || v_tab(v_job).max_sal);
        v_job := v_tab.next(v_job);
        EXIT WHEN v_job is null;
    END LOOP;
END;
/

-- 복합 트리거 생성
CREATE OR REPLACE TRIGGER check_sal_trg
FOR INSERT OR UPDATE OF salary, job_id ON hr.emp
COMPOUND TRIGGER
    TYPE rec_type IS RECORD (
        min_sal hr.emp.salary%type,
        max_sal hr.emp.salary%type
    );
    TYPE tab_type IS TABLE OF rec_type INDEX BY varchar2(30);
    v_tab tab_type;
BEFORE STATEMENT IS
    CURSOR cur IS 
        SELECT job_id, min(salary) min_sal, max(salary) max_sal
        FROM hr.emp
        GROUP BY job_id;
BEGIN
    FOR i IN cur LOOP
        v_tab(i.job_id).min_sal := i.min_sal;
        v_tab(i.job_id).max_sal := i.max_sal;
    END LOOP;
END BEFORE STATEMENT;
AFTER EACH ROW IS
BEGIN
    IF :new.salary NOT BETWEEN v_tab(:new.job_id).min_sal AND v_tab(:new.job_id).max_sal THEN
        RAISE_APPLICATION_ERROR(-20000, '급여는 ' || v_tab(:new.job_id).min_sal || ' ~ ' || v_tab(:new.job_id).max_sal || ' 사이여야 합니다.');
    END IF;
END AFTER EACH ROW;
END check_sal_trg;
/

DROP TRIGGER check_sal_trg;

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 3000, 'IT_PROG');

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;

UPDATE hr.emp
SET job_id = 'AD_ASST'
WHERE employee_id = 103;

SELECT * FROM user_triggers;
SELECT * FROM user_procedures;

-- 패키지 글로벌 변수 사용
CREATE OR REPLACE PACKAGE check_sal_pkg
IS
    TYPE rec_type IS RECORD (
        min_sal hr.emp.salary%type,
        max_sal hr.emp.salary%type
    );
    TYPE tab_type IS TABLE OF rec_type INDEX BY varchar2(30);
    v_tab tab_type;
END check_sal_pkg;
/

CREATE OR REPLACE TRIGGER check_sal_before_trg
BEFORE
INSERT OR UPDATE OF salary, job_id ON hr.emp
DECLARE
    CURSOR cur IS 
        SELECT job_id, min(salary) min_sal, max(salary) max_sal
        FROM hr.emp
        GROUP BY job_id;  
BEGIN
    FOR i IN cur LOOP
        check_sal_pkg.v_tab(i.job_id).min_sal := i.min_sal;
        check_sal_pkg.v_tab(i.job_id).max_sal := i.max_sal;
    END LOOP;    
END check_sal_before_trg;
/

CREATE OR REPLACE TRIGGER check_sal_after_row_trg
AFTER
INSERT OR UPDATE OF salary, job_id ON hr.emp
FOR EACH ROW
BEGIN
    IF :new.salary NOT BETWEEN check_sal_pkg.v_tab(:new.job_id).min_sal AND check_sal_pkg.v_tab(:new.job_id).max_sal THEN
        RAISE_APPLICATION_ERROR(-20000, '급여는 ' || check_sal_pkg.v_tab(:new.job_id).min_sal || ' ~ ' || check_sal_pkg.v_tab(:new.job_id).max_sal || ' 사이여야 합니다.');
    END IF;
END check_sal_after_row_trg;
/

INSERT INTO hr.emp(employee_id, salary, job_id) VALUES(300, 3000, 'IT_PROG');

UPDATE hr.emp
SET salary = 20000
WHERE employee_id = 103;

UPDATE hr.emp
SET job_id = 'AD_ASST'
WHERE employee_id = 103;


SELECT * FROM user_triggers;
DROP TRIGGER CHECK_SAL_BEFORE_TRG;
DROP TRIGGER CHECK_SAL_AFTER_ROW_TRG;

-- 독립 트랜잭션 처리
CREATE TABLE hr.log_table(
    username varchar2(30),
    date_time timestamp,
    message varchar2(100)
)TABLESPACE users;

CREATE TABLE hr.temp_table(n number) TABLESPACE users;

CREATE OR REPLACE PROCEDURE hr.log_message(p_message IN varchar2)
IS
BEGIN
    INSERT INTO hr.log_table(username, date_time, message)
    VALUES(user, localtimestamp, p_message);
    COMMIT;
END log_message;
/

SELECT * FROM hr.log_table;
SELECT * FROM hr.temp_table;

BEGIN
    hr.log_message('열심히 복습하자!!');
    INSERT INTO hr.temp_table(n) VALUES(100);
    hr.log_message('열심히 공부해서 꼭 취업하자!!');
    ROLLBACK;
END;
/

SELECT * FROM hr.log_table;
SELECT * FROM hr.temp_table;

TRUNCATE TABLE hr.log_table;
TRUNCATE TABLE hr.temp_table;

-- PRAGMA AUTONOMOUS_TRANSACTION
CREATE OR REPLACE PROCEDURE hr.log_message(p_message IN varchar2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO hr.log_table(username, date_time, message)
    VALUES(user, localtimestamp, p_message);
    COMMIT;
END log_message;
/

BEGIN
    hr.log_message('열심히 복습하자!!');
    INSERT INTO hr.temp_table(n) VALUES(100);
    hr.log_message('열심히 공부해서 꼭 취업하자!!');
    ROLLBACK;
END;
/

SELECT * FROM hr.log_table;
SELECT * FROM hr.temp_table;

TRUNCATE TABLE hr.log_table;
TRUNCATE TABLE hr.temp_table;

CREATE TABLE hr.log_tab(id number, name varchar2(30), log_day timestamp default systimestamp);
CREATE TABLE hr.test(id number, name varchar2(30), log_day timestamp default systimestamp);

CREATE OR REPLACE TRIGGER hr.log_trigger
AFTER
INSERT ON hr.test
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO hr.log_tab(id, name, log_day) VALUES(:new.id, :new.name, :new.log_day);
    COMMIT;
END log_trigger;
/

INSERT INTO hr.test(id, name) VALUES (100, 'ORACLE');
SELECT * FROM hr.log_tab;
SELECT * FROM hr.test;
ROLLBACK;
SELECT * FROM hr.log_tab;
SELECT * FROM hr.test;
