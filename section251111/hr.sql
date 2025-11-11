-- 오류 발생
DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 300;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
END;
/

-- 예외처리
DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 300;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
	WHEN no_data_found then
		dbms_output.put_line('no data found');
	WHEN too_many_rows then
		dbms_output.put_line('too many rows');
	WHEN OTHERS THEN
		dbms_output.put_line('others');
END;
/  

DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE department_id = 20;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
	WHEN no_data_found then
		dbms_output.put_line('no data found');
	WHEN too_many_rows then
		dbms_output.put_line('too many rows');
	WHEN OTHERS THEN
		dbms_output.put_line('others');
END;
/  

-- 프로그램 비정상 종료 시 자동 롤백
DROP TABLE hr.test PURGE;
CREATE TABLE hr.test(id number, name varchar2(30));

DECLARE
    v_rec employees%rowtype;
BEGIN
    INSERT INTO hr.test(id, name) VALUES(1, 'ORACLE'); -- 트랜잭션 시작
    
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE department_id = 20; -- ORA-01422 -> 롤백
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
END;
/

SELECT * FROM hr.test;

DECLARE
    v_rec employees%rowtype;
BEGIN
    INSERT INTO hr.test(id, name) VALUES(1, 'ORACLE'); -- 트랜잭션 시작
    
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE department_id = 20; -- ORA-01422 -> 롤백
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN too_many_rows THEN
        dbms_output.put_line('여러 행 인출');
END;
/

-- 프로그램 정상 종료 -> 트랜잭션 살아있음
SELECT * FROM hr.test;
ROLLBACK;

INSERT INTO hr.test(id, name) VALUES(1, 'ORACLE');
COMMIT;

DECLARE
    v_rec employees%rowtype;
BEGIN
    DELETE FROM hr.test WHERE id = 1;
    
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE department_id = 20; -- ORA-01422 -> 롤백
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN too_many_rows THEN
        dbms_output.put_line('여러 행 인출');
END;
/

SELECT * FROM hr.test;
ROLLBACK;

DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE department_id = 20;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('오류가 발생해서 프로그램 종료');
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- non predefined exception 처리
SELECT * FROM user_constraints WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS');
SELECT * FROM user_cons_columns WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS');
BEGIN
    DELETE FROM hr.departments WHERE department_id = 10;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- non predefined exception 정의
DECLARE
    pk_error EXCEPTION; -- 예외사항 이름 선언
    PRAGMA EXCEPTION_INIT(pk_error, -2292); -- 내가 만든 예외사항 이름과 오라클 오류 번호를 연결하는 지시어
BEGIN
    DELETE FROM hr.departments WHERE department_id = 10;
EXCEPTION
    WHEN pk_error THEN
        dbms_output.put_line('PK 값을 참조하고 있는 자식 행들이 있습니다.');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- 유저 정의 예외사항(User Defined Exceptions)
DECLARE
    e_invalid EXCEPTION; -- 예외사항 이름 선언
BEGIN
    UPDATE hr.employees
    SET salary = salary * 1.1
    WHERE employee_id = 300;
    
    IF sql%notfound THEN
        RAISE e_invalid; -- 유저가 정의한 예외사항 발생
    END IF;
EXCEPTION
    WHEN e_invalid THEN
        dbms_output.put_line('수정된 데이터가 없습니다.');
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

-- raise_application_error
BEGIN
    UPDATE hr.employees
    SET salary = salary * 1.1
    WHERE employee_id = 300;
    
    IF sql%notfound THEN
        RAISE_APPLICATION_ERROR(-20000, '수정된 데이터가 없습니다.');
    END IF;
END;
/

-- 
DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 300;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20000, '사원은 존재하지 않습니다.', FALSE);
END;
/

DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 300;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20000, '사원은 존재하지 않습니다.', TRUE);
END;
/

-- [문제15] 배열변수안에 있는 사원번호(100,300,102,105)를 기준으로 그 사원의 employee_id, last_name, 출력하는 프로그램 작성해주세요. 만약에 사원이 존재하지 않은 경우에도 처리를 한 후 다음 사원을 처리하도록해주세요.
/*
100 King
300사원은 존재하지 않습니다.
102 De Haan
105 Austin
*/

DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 300, 102, 105);
BEGIN
    FOR i IN v_id.first..v_id.last LOOP
        DECLARE
            TYPE rec_type IS RECORD(
                id employees.employee_id%type,
                name employees.last_name%type
            );
            v_rec rec_type;
        BEGIN
            SELECT employee_id, last_name
            INTO v_rec
            FROM hr.employees
            WHERE employee_id = v_id(i);
            dbms_output.put_line(v_rec.id || ' ' || v_rec.name);
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line(v_id(i) || ' 사원은 존재하지 않습니다');
            WHEN too_many_rows THEN
                dbms_output.put_line('too many rows');
            WHEN others THEN
                dbms_output.put_line('other exception');
        END;
    END LOOP;
END;
/

-- 서브 프로그램
-- 프로시저
SELECT * FROM session_privs;

-- 파라미터가 없는 프로시저
CREATE OR REPLACE PROCEDURE emp_proc
IS
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 100;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20000, '사원은 존재하지 않습니다.', TRUE);
END;
/

-- 오류 조회
show error

-- 프로시저 호출
execute emp_proc;
exec emp_proc;

BEGIN
    emp_proc;
END;
/

-- 파라미터가 있는 프로시저 in 모드
CREATE OR REPLACE PROCEDURE emp_proc(p_id IN number)
IS
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = p_id;
    
    dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20000, '사원은 존재하지 않습니다.', TRUE);
END;
/

show error

exec emp_proc(300)

BEGIN
    emp_proc(100);
END;
/

SELECT * FROM user_source;
SELECT text FROM user_source WHERE name = 'EMP_PROC' ORDER BY line;

desc emp_proc

-- 사원번호, 급여 인상 비율을 입력 값으로 받아서 급여를 수정하는 프로그램
CREATE OR REPLACE PROCEDURE raise_salary(p_id IN number, p_pct IN number)
IS
BEGIN
    UPDATE hr.employees
    SET salary = salary * (1 + p_pct / 100)
    WHERE employee_id = p_id;
END raise_salary;
/

desc raise_salary;
/*
인수 이름 유형     In/Out 기본값?    
----- ------ ------ ------- 
P_ID  NUMBER IN     unknown 
P_PCT NUMBER IN     unknown 
*/

SELECT salary FROM hr.employees WHERE employee_id = 100; --24000
exec raise_salary(100, 10);
SELECT salary FROM hr.employees WHERE employee_id = 100; -- 26400
ROLLBACK;
SELECT salary FROM hr.employees WHERE employee_id = 100; -- 24000

-- 전체 사원 급여 10% 인상
BEGIN  
    FOR i IN (SELECT employee_id FROM hr.employees) LOOP
        raise_salary(i.employee_id, 10);
    END LOOP;
    ROLLBACK;
END;
/

SELECT employee_id, salary FROM hr.employees;

-- out 모드
CREATE OR REPLACE PROCEDURE emp_proc(p_id IN number, p_name OUT varchar2, p_sal OUT number)
IS
BEGIN
    SELECT last_name, salary
    INTO p_name, p_sal
    FROM hr.employees
    WHERE employee_id = p_id;
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20000, '사원은 존재하지 않습니다.', TRUE);
END;
/

desc emp_proc;
/*
인수 이름  유형       In/Out 기본값?    
------ -------- ------ ------- 
P_ID   NUMBER   IN     unknown 
P_NAME VARCHAR2 OUT    unknown 
P_SAL  NUMBER   OUT    unknown 
*/

-- 호출
var b_name varchar2(30);
var b_sal number;
exec emp_proc(100, :b_name, :b_sal);
print b_name b_sal;

-- 익명 블록에서 호출
DECLARE
    v_name varchar2(30);
    v_sal number;
BEGIN
    emp_proc(100, v_name, v_sal);
    dbms_output.put_line(v_name || ' ' || v_sal);
END;
/