-- 상수 표준화
CREATE OR REPLACE PACKAGE global_consts
IS
    c_mile_2_kilo constant number := 1.6093;
    c_kilo_2_mile constant number := 0.6214;
    c_yard_2_meter constant number := 0.9144;
    c_meter_2_yard constant number := 1.0936;
END;
/

exec dbms_output.put_line('20 mile = ' || 20 * global_consts.c_mile_2_kilo || 'km')
exec dbms_output.put_line('20 kilo = ' || 20 * global_consts.c_kilo_2_mile || 'mi')
exec dbms_output.put_line('20 yard = ' || 20 * global_consts.c_yard_2_meter || 'm')
exec dbms_output.put_line('20 meter = ' || 20 * global_consts.c_meter_2_yard || 'yd')

CREATE OR REPLACE FUNCTION mtr_to_yrd(p_m IN number)
RETURN number
IS
BEGIN
    RETURN p_m * global_consts.c_meter_2_yard;
END mtr_to_yrd;
/

exec dbms_output.put_line(mtr_to_yrd(20))

GRANT execute ON hr.global_consts TO anna;
GRANT execute ON hr.mtr_to_yrd TO anna;

-- ORA-01400: cannot insert NULL into ("HR"."DEPARTMENTS"."DEPARTMENT_NAME")
BEGIN
    INSERT INTO hr.departments(department_id, department_name) VALUES(300, NULL);
END;
/

-- 예외 처리
BEGIN
    INSERT INTO hr.departments(department_id, department_name) VALUES(300, NULL);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- 예외 선언
DECLARE
    e_notnull EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_notnull, -1400);
BEGIN
    INSERT INTO hr.departments(department_id, department_name) VALUES(300, NULL);
EXCEPTION
    WHEN e_notnull THEN
        dbms_output.put_line('필수 항목 값을 꼭 입력해주세요.');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- 예외명 표준화
CREATE OR REPLACE PACKAGE err_pkg
IS
    notnull_err EXCEPTION;
    PRAGMA EXCEPTION_INIT(notnull_err, -1400);
END err_pkg;
/

BEGIN
    INSERT INTO hr.departments(department_id, department_name) VALUES(300, NULL);
EXCEPTION
    WHEN err_pkg.notnull_err THEN
        dbms_output.put_line('필수 항목 값을 꼭 입력해주세요.');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- 패키지 커서 지속 상태
-- open 하지 않은 상태에서 fetch 하면 ORA-01001: invalid cursor
DECLARE
    CURSOR emp_cur IS
        SELECT *
        FROM hr.employees
        WHERE department_id = 20;
    v_rec emp_cur%rowtype;
BEGIN
    OPEN emp_cur;
    
    LOOP
        FETCH emp_cur INTO v_rec;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
    END LOOP;
END;
/

CREATE OR REPLACE PACKAGE pack_cur
IS
    PROCEDURE open;
    PROCEDURE next(p_num IN number);
    PROCEDURE close;
END pack_cur;
/

CREATE OR REPLACE PACKAGE BODY pack_cur
IS    
    /* private cursor : package body 안에서만 사용하는 cursor */
    CURSOR c1 IS
        SELECT employee_id, last_name
        FROM hr.employees
        ORDER BY employee_id desc;
        
    /* private variable : package body 안에서만 사용하는 variable */   
    v_id number;
    v_name varchar2(30);
        
    PROCEDURE open
    IS
    BEGIN
        IF NOT c1%isopen THEN
            OPEN c1;
            dbms_output.put_line('c1 cursor open');
        END IF;
    END open;
    
    PROCEDURE next(p_num IN number)
    IS
    BEGIN
        LOOP
            EXIT WHEN c1%rowcount >= p_num OR c1%notfound;
            FETCH c1 INTO v_id, v_name;
            dbms_output.put_line(v_id || ' ' || v_name);
        END LOOP;
    END next;
    
    PROCEDURE close
    IS
    BEGIN
        IF c1%isopen THEN
            CLOSE c1;
            dbms_output.put_line('c1 cursor close');
        END IF;
    END close;
END pack_cur;
/

BEGIN
    pack_cur.open;
    pack_cur.next(10);
    pack_cur.close;
END;
/

-- specification에서 선언한 public(global)변수는 세션이 열려 있는 동안 변경한 값을 지속적으로 사용
-- package specification
CREATE OR REPLACE PACKAGE comm_pkg
IS
    g_comm number := 0.1;
    PROCEDURE reset_comm(p_comm IN number);
END comm_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY comm_pkg
IS  
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean;
    
    PROCEDURE reset_comm(p_comm IN number)
    IS
    BEGIN
        IF validate_comm(p_comm) THEN
            dbms_output.put_line('OLD : ' || g_comm);
            g_comm := p_comm;
            dbms_output.put_line('NEW : ' || g_comm);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
        END IF;
    END reset_comm;
    
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean
    IS
        v_comm number;
    BEGIN
        SELECT max(commission_pct)
        INTO v_comm
        FROM hr.employees;
        
        IF p_comm > v_comm THEN
            RETURN FALSE;
        ELSE 
            RETURN TRUE;
        END IF;
    END validate_comm;
END comm_pkg;
/

exec comm_pkg.reset_comm(0.2)
exec dbms_output.put_line(comm_pkg.g_comm)

-- PRAGMA SERIALLY_REUSABLE
-- specification에서 선언한 public(global)변수는 호출이 끝나면 초기값으로 되돌아 가도록 수행해야 한다.
-- package specification
CREATE OR REPLACE PACKAGE comm_pkg
IS
    PRAGMA SERIALLY_REUSABLE;
    g_comm number := 0.1;
    PROCEDURE reset_comm(p_comm IN number);
END comm_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY comm_pkg
IS  
    PRAGMA SERIALLY_REUSABLE;
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean;
    
    PROCEDURE reset_comm(p_comm IN number)
    IS
    BEGIN
        IF validate_comm(p_comm) THEN
            dbms_output.put_line('OLD : ' || g_comm);
            g_comm := p_comm;
            dbms_output.put_line('NEW : ' || g_comm);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
        END IF;
    END reset_comm;
    
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean
    IS
        v_comm number;
    BEGIN
        SELECT max(commission_pct)
        INTO v_comm
        FROM hr.employees;
        
        IF p_comm > v_comm THEN
            RETURN FALSE;
        ELSE 
            RETURN TRUE;
        END IF;
    END validate_comm;
END comm_pkg;
/

exec comm_pkg.reset_comm(0.2)
exec dbms_output.put_line(comm_pkg.g_comm)

-- 패키지 삭제
DROP PACKAGE comm_pkg;

-- 패키지 BODY만 삭제
DROP PACKAGE BODY comm_pkg;

-- trigger
-- 테스트 테이블 생성
DROP TABLE hr.dept PURGE;

CREATE TABLE hr.dept
AS
SELECT * FROM hr.departments;

SELECT * FROM hr.dept;

INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
VALUES (300, 'Data Architect', 100, 1500);

SELECT * FROM hr.dept;

ROLLBACK;

-- 트리거 권한 조회
SELECT * FROM session_privs;

-- before 문장 트리거
CREATE OR REPLACE TRIGGER dept_before
BEFORE
INSERT ON hr.dept
BEGIN
    dbms_output.put_line('isnert하기 전에 문장 트리거 수행');
END dept_before;
/

INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
VALUES (300, 'Data Architect', 100, 1500);

ROLLBACK;

-- after 문장 트리거
CREATE OR REPLACE TRIGGER dept_after
AFTER
INSERT ON hr.dept
BEGIN
    dbms_output.put_line('isnert한 후에 문장 트리거 수행');
END dept_after;
/

INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
VALUES (300, 'Data Architect', 100, 1500);

ROLLBACK;

-- 행 트리거
-- before 행 트리거
CREATE OR REPLACE TRIGGER dept_row_before
BEFORE
INSERT ON hr.dept
FOR EACH ROW
BEGIN
    dbms_output.put_line('isnert하기 전에 행 트리거 수행');
END dept_row_before;
/

INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
VALUES (300, 'Data Architect', 100, 1500);

ROLLBACK;

-- after 행 트리거
CREATE OR REPLACE TRIGGER dept_row_after
AFTER
INSERT ON hr.dept
FOR EACH ROW
BEGIN
    dbms_output.put_line('isnert한 후에 행 트리거 수행');
END dept_row_after;
/

INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
VALUES (300, 'Data Architect', 100, 1500);

ROLLBACK;

-- 트리거 정보 조회
SELECT * FROM user_triggers WHERE table_name = 'DEPT';
SELECT * FROM user_source WHERE name = 'DEPT_ROW_AFTER';
SELECT status FROM user_triggers WHERE trigger_name = 'DEPT_ROW_AFTER';
SELECT status FROM user_objects WHERE object_name = 'DEPT_ROW_AFTER';

-- 트리거 비활성화
ALTER TRIGGER dept_row_after DISABLE;

SELECT status FROM user_triggers WHERE trigger_name = 'DEPT_ROW_AFTER';
SELECT status FROM user_objects WHERE object_name = 'DEPT_ROW_AFTER';

-- 트리거 활성화
ALTER TRIGGER dept_row_after ENABLE;

SELECT status FROM user_triggers WHERE trigger_name = 'DEPT_ROW_AFTER';

-- 트리거 삭제
DROP TRIGGER dept_before;
DROP TRIGGER dept_after;
DROP TRIGGER dept_row_before;
DROP TRIGGER dept_row_after;

SELECT * FROM user_triggers;

-- before 문장 트리거
CREATE OR REPLACE TRIGGER secure_dept
BEFORE
INSERT OR UPDATE OR DELETE ON hr.dept
BEGIN
    IF to_char(sysdate, 'hh24:mi') NOT BETWEEN '09:00' AND '15:00' THEN
        RAISE_APPLICATION_ERROR(-20000, 'DML 작업을 수행할 수 없습니다.');
    END IF;
END secure_dept;
/

-- ORA-20000: DML 작업을 수행할 수 없습니다.
INSERT INTO hr.dept(department_id, department_name, manager_id, location_id) VALUES(300, 'Data Architect', 100, 1500);

UPDATE hr.dept
SET location_id = 1500
WHERE department_id = 10;

DELETE FROM hr.dept
WHERE department_id = 10;

DROP TRIGGER secure_dept;

-- after 문장 트리거
CREATE OR REPLACE TRIGGER secure_dept
AFTER
INSERT OR UPDATE OR DELETE ON hr.dept
BEGIN
    IF to_char(sysdate, 'hh24:mi') NOT BETWEEN '09:00' AND '15:00' THEN
        RAISE_APPLICATION_ERROR(-20000, 'DML 작업을 수행할 수 없습니다.');
    END IF;
END secure_dept;
/

-- ORA-20000: DML 작업을 수행할 수 없습니다.
INSERT INTO hr.dept(department_id, department_name, manager_id, location_id) VALUES(300, 'Data Architect', 100, 1500);

UPDATE hr.dept
SET location_id = 1500
WHERE department_id = 10;

DELETE FROM hr.dept
WHERE department_id = 10;

SELECT * FROM hr.dept;

-- 조건부 술어
-- before 문장 트리거
CREATE OR REPLACE TRIGGER secure_dept
BEFORE
INSERT OR UPDATE OR DELETE ON hr.dept
BEGIN
    IF to_char(sysdate, 'hh24:mi') NOT BETWEEN '09:00' AND '16:00' THEN
        IF inserting THEN
            RAISE_APPLICATION_ERROR(-20000, 'insert 작업을 수행할 수 없습니다.');
        ELSIF updating THEN
            RAISE_APPLICATION_ERROR(-20001, 'update 작업을 수행할 수 없습니다.');
        ELSIF deleting THEN
            RAISE_APPLICATION_ERROR(-20002, 'delete 작업을 수행할 수 없습니다.');
        END IF;
    END IF;
END secure_dept;
/

-- ORA-20000: insert 작업을 수행할 수 없습니다.
INSERT INTO hr.dept(department_id, department_name, manager_id, location_id) VALUES(300, 'Data Architect', 100, 1500);

-- ORA-20001: update 작업을 수행할 수 없습니다.
UPDATE hr.dept
SET location_id = 1500
WHERE department_id = 10;

-- ORA-20002: delete 작업을 수행할 수 없습니다.
DELETE FROM hr.dept
WHERE department_id = 10;

SELECT * FROM hr.dept;

-- 

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
AS
SELECT employee_id, last_name, salary, department_id FROM hr.employees;

-- before 문장 트리거
CREATE OR REPLACE TRIGGER emp_before
BEFORE
UPDATE ON hr.emp
BEGIN
    dbms_output.put_line('update하기 전에 문장 트리거 수행');
END emp_before;
/

-- after 문장 트리거
CREATE OR REPLACE TRIGGER emp_after
AFTER
UPDATE ON hr.emp
BEGIN
    dbms_output.put_line('update한 후에 문장 트리거 수행');
END emp_after;
/

-- before 행 트리거
CREATE OR REPLACE TRIGGER emp_row_before
BEFORE
UPDATE ON hr.emp
FOR EACH ROW
BEGIN
    dbms_output.put_line('update하기 전에 행 트리거 수행');
END emp_row_before;
/

-- after 행 트리거
CREATE OR REPLACE TRIGGER emp_row_after
AFTER
UPDATE ON hr.emp
FOR EACH ROW
BEGIN
    dbms_output.put_line('update한 후에 행 트리거 수행');
END emp_row_after;
/

UPDATE hr.emp
SET salary = salary * 1.1
WHERE employee_id = 300;

ROLLBACK;

UPDATE hr.emp
SET salary = salary * 1.1
WHERE department_id = 20;

ROLLBACK;

DROP TRIGGER emp_before;
DROP TRIGGER emp_after;
DROP TRIGGER emp_row_before;
DROP TRIGGER emp_row_after;

SELECT * FROM user_triggers;

-- 수식자 : OLD, NEW
CREATE OR REPLACE TRIGGER emp_trg
BEFORE
INSERT OR DELETE OR UPDATE OF salary ON hr.emp
FOR EACH ROW
WHEN (NEW.department_id = 20 OR OLD.department_id = 10)
DECLARE
    v_sal number;
BEGIN
    IF deleting THEN
        dbms_output.put_line('OLD SALARY : ' || :OLD.salary);
    ELSIF updating THEN
        v_sal := :NEW.salary - :OLD.salary;
        dbms_output.put_line('EMPLOYEE_ID : ' || :OLD.employee_id);
        dbms_output.put_line('OLD SALARY : ' || :OLD.salary);
        dbms_output.put_line('NEW SALARY : ' || :NEW.salary);
        dbms_output.put_line('급여차이 : ' || v_sal);
    ELSIF inserting THEN
        dbms_output.put_line('NEW SALARY : ' || :NEW.salary);
    END IF;
END emp_trg;
/

desc hr.emp;
SELECT * FROM hr.emp;

INSERT INTO hr.emp VALUES(300, 'oracle', 100000, 20);
ROLLBACK;

DELETE FROM hr.emp WHERE department_id = 10;
ROLLBACK;

UPDATE hr.emp
SET salary = salary * 1.1
WHERE department_id = 10;
ROLLBACK;

UPDATE hr.emp
SET salary = salary * 1.1
WHERE department_id = 20;
ROLLBACK;