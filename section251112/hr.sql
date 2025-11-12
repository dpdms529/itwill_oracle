-- [문제16] 사원번호를 입력값으로 받아서 그 사원의 이름, 급여, 부서이름을 출력하는 프로시저를 생성하세요. 
-- 단 100번 사원이 입력값으로 들어오면 프로그램은 종료 할 수 있도록 작성해주세요.
SELECT e.last_name, e.salary, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id 
AND employee_id = 100;

CREATE OR REPLACE PROCEDURE emp_proc(p_id IN number)
IS
    TYPE rec_type IS RECORD(
        name employees.last_name%type,
        sal employees.salary%type,
        dept_name departments.department_name%type
    );
    v_rec rec_type;
    
    eos EXCEPTION;
BEGIN
    IF p_id = 100 THEN
        RAISE eos;
    END IF;
    
    SELECT e.last_name, e.salary, d.department_name
    INTO v_rec
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id 
    AND employee_id = p_id;
    
    dbms_output.put_line(v_rec.name || ' ' || v_rec.sal || ' ' || v_rec.dept_name); 
EXCEPTION
    WHEN eos THEN
        null;
    WHEN no_data_found THEN
        dbms_output.put_line('데이터가 존재하지 않음');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

exec emp_proc(100);

SELECT text FROM user_source WHERE name = 'EMP_PROC' ORDER BY line;
SELECT * FROM user_objects WHERE object_name =  'EMP_PROC';

-- return
CREATE OR REPLACE PROCEDURE emp_proc(p_id IN number)
IS
    TYPE rec_type IS RECORD(
        name employees.last_name%type,
        sal employees.salary%type,
        dept_name departments.department_name%type
    );
    v_rec rec_type;
BEGIN
    IF p_id = 100 THEN
        RETURN;
    END IF;
    
    SELECT e.last_name, e.salary, d.department_name
    INTO v_rec
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id 
    AND employee_id = p_id;
    
    dbms_output.put_line(v_rec.name || ' ' || v_rec.sal || ' ' || v_rec.dept_name); 
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('데이터가 존재하지 않음');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

exec emp_proc(101);

-- 익명 블록에서 return
DECLARE
    TYPE rec_type IS RECORD(
        name employees.last_name%type,
        sal employees.salary%type,
        dept_name departments.department_name%type
    );
    v_rec rec_type;
BEGIN
    IF :b_id = 100 THEN
        RETURN;
    END IF;
    
    SELECT e.last_name, e.salary, d.department_name
    INTO v_rec
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id 
    AND employee_id = :b_id;
    
    dbms_output.put_line(v_rec.name || ' ' || v_rec.sal || ' ' || v_rec.dept_name); 
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('데이터가 존재하지 않음');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/


-- return 값
CREATE OR REPLACE PROCEDURE emp_proc(p_id IN number, p_name OUT varchar2, p_sal OUT number, p_dept_name OUT varchar2)
IS
BEGIN
    IF p_id = 100 THEN
        RETURN;
    END IF;
    
    SELECT e.last_name, e.salary, d.department_name
    INTO p_name, p_sal, p_dept_name
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id 
    AND employee_id = p_id;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('데이터가 존재하지 않음');
    WHEN others THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;
/

DECLARE
    v_name varchar2(30);
    v_sal number;
    v_dept_name varchar2(30);
BEGIN
    emp_proc(102, v_name, v_sal, v_dept_name);
    dbms_output.put_line(v_name || ' ' || v_sal || ' ' || v_dept_name);
END;
/

var v_name varchar2(30);
var v_sal number;
var v_dept_name varchar2(30);
exec emp_proc(100, :v_name, :v_sal, :v_dept_name);
print :v_name :v_sal :v_dept_name;

-- IN OUT
SELECT substr('01012345678', 1, 3) || '-' || substr('01012345678', 4, 4) || '-' || substr('01012345678', 8, 4)
FROM dual;

var b_no varchar2(20)
exec :b_no := '01012345678'
print :b_no;

BEGIN
    :b_no := substr(:b_no, 1, 3) || '-' || substr(:b_no, 4, 4) || '-' || substr(:b_no, 8);
END;
/

print :b_no;

CREATE OR REPLACE PROCEDURE format_phone(p_no IN OUT varchar2)
IS
BEGIN
    dbms_output.put_line(p_no);
    p_no := substr(p_no, 1, 3) || '-' || substr(p_no, 4, 4) || '-' || substr(p_no, 8);
    dbms_output.put_line(p_no);
END;
/

var b_no varchar2(20);
exec :b_no := '01012345678';
exec format_phone(:b_no);

DECLARE
    v_no varchar2(20) := '01012345678';
BEGIN
    format_phone(v_no);
END;
/

CREATE TABLE hr.sawon
(id number, name varchar2(30), day date, deptno number)
TABLESPACE users;

desc hr.sawon;

INSERT INTO hr.sawon (id, name, day, deptno) VALUES(입력변수, 입력변수, 입력변수, 입력변수);

CREATE OR REPLACE PROCEDURE sawon_insert
(p_id IN sawon.id%type, 
p_name IN sawon.name%type, 
p_day IN sawon.day%type default sysdate, 
p_deptno IN sawon.deptno%type)
IS
BEGIN
    INSERT INTO hr.sawon (id, name, day, deptno) VALUES(p_id, p_name, p_day, p_deptno);
END sawon_insert;
/

-- 위치 지정 방식으로 입력
exec sawon_insert(1, 'oracle', sysdate, 10);
-- 이름 지정 방식으로 입력
exec sawon_insert(p_id=>2, p_name=>'python', p_deptno=>20);
-- 혼합 방식으로 입력
exec sawon_insert(3, 'java', p_deptno=>30);
exec sawon_insert(4, p_name=>'javascript', sysdate, 40); -- PLS-00312: a positional parameter association may not follow a named association

SELECT * FROM hr.sawon;
ROLLBACK;

-- anna 에게 sawon 권한 부여
GRANT select ON hr.sawon TO anna;
GRANT execute ON hr.sawon_insert TO anna;
SELECT * FROM user_tab_privs;

-- 테이블 삭제
DROP TABLE hr.emp PURGE;
DROP TABLE hr.dept PURGE;

CREATE TABLE hr.emp AS SELECT * FROM hr.employees;
CREATE TABLE hr.dept AS SELECT * FROM hr.departments;

ALTER TABLE hr.emp ADD CONSTRAINT empid_pk PRIMARY KEY(employee_id);
ALTER TABLE hr.dept ADD CONSTRAINT deptid_pk PRIMARY KEY(department_id);
ALTER TABLE hr.dept ADD CONSTRAINT dept_mgr_id_fk FOREIGN KEY(manager_id) REFERENCES hr.emp(employee_id);;

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');

SELECT * FROM hr.emp;
SELECT * FROM hr.dept;

-- <<시나리오 1>>
-- 신규 부서 정보를 입력하는 프로시저
CREATE OR REPLACE PROCEDURE add_dept(p_name IN varchar2, p_mgr IN number, p_loc IN number)
IS
    v_max number;
BEGIN
    SELECT max(department_id)
    INTO v_max
    FROM hr.dept;

    INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
    VALUES(v_max + 10, p_name, p_mgr, p_loc);
END add_dept;
/

desc add_dept;
/*
PROCEDURE add_dept
인수 이름  유형       In/Out 기본값?    
------ -------- ------ ------- 
P_NAME VARCHAR2 IN     unknown 
P_MGR  NUMBER   IN     unknown 
P_LOC  NUMBER   IN     unknown 
*/
exec add_dept('경영기획', 100, 1800);
exec add_dept('경영기획', 300, 1800); -- ORA-02291: integrity constraint (HR.DEPT_MGR_ID_FK) violated - parent key not found

SELECT * FROM hr.dept;
rollback;

BEGIN
    add_dept('경영기획', 100, 1800);
    add_dept('데이터아키텍처', 300, 1700);
    add_dept('인재개발', 101, 1800);
END;
/

SELECT * FROM hr.dept;

-- <<시나리오 2>>
-- 신규 부서 정보를 입력하는 프로시저
CREATE OR REPLACE PROCEDURE add_dept(p_name IN varchar2, p_mgr IN number, p_loc IN number)
IS
    v_max number;
BEGIN
    SELECT max(department_id)
    INTO v_max
    FROM hr.dept;

    INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
    VALUES(v_max + 10, p_name, p_mgr, p_loc);
END add_dept;
/

-- 호출하는 프로그램에서 exception 처리
BEGIN
    add_dept('경영기획', 100, 1800);
    add_dept('데이터아키텍처', 300, 1700);
    add_dept('인재개발', 101, 1800);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line(sqlerrm);
END;
/

SELECT * FROM hr.dept;

rollback;

-- <<시나리오 3>>
-- 프로시저에서 exception 처리
-- 신규 부서 정보를 입력하는 프로시저
CREATE OR REPLACE PROCEDURE add_dept(p_name IN varchar2, p_mgr IN number, p_loc IN number)
IS
    v_max number;
BEGIN
    SELECT max(department_id)
    INTO v_max
    FROM hr.dept;

    INSERT INTO hr.dept(department_id, department_name, manager_id, location_id)
    VALUES(v_max + 10, p_name, p_mgr, p_loc);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line(sqlerrm);
END add_dept;
/

BEGIN
    add_dept('경영기획', 100, 1800);
    add_dept('데이터아키텍처', 300, 1700);
    add_dept('인재개발', 101, 1800);
END;
/

SELECT * FROM hr.dept;

rollback;

-- 프로시저 삭제
DROP PROCEDURE add_dept;

-- 함수
-- 프로시저로 구현
CREATE OR REPLACE PROCEDURE get_sal_proc
(p_id IN number, p_sal OUT number)
IS
BEGIN
    SELECT salary
    INTO p_sal
    FROM hr.employees
    WHERE employee_id = p_id;
EXCEPTION
    WHEN no_data_found THEN
        return;
END get_sal_proc;
/

desc get_sal_proc;
/*
PROCEDURE get_sal_proc
인수 이름 유형     In/Out 기본값?    
----- ------ ------ ------- 
P_ID  NUMBER IN     unknown 
P_SAL NUMBER OUT    unknown 
*/

var b_sal number;
exec get_sal_proc(150, :b_sal);
exec get_sal_proc(300, :b_sal);
print :b_sal;

SELECT count(*) FROM hr.employees WHERE salary < :b_sal;

DECLARE
    v_sal number;
    v_cnt number;
BEGIN
    get_sal_proc(150, v_sal);
    dbms_output.put_line(v_sal);
    
    SELECT count(*) 
    INTO v_cnt
    FROM hr.employees 
    WHERE salary < v_sal;
    dbms_output.put_line(v_cnt);   
END;
/

-- 함수 생성
CREATE OR REPLACE function get_sal_func
(p_id IN number)
RETURN number
IS
    v_sal number;
BEGIN
    SELECT salary
    INTO v_sal
    FROM hr.employees
    WHERE employee_id = p_id;
    
    RETURN v_sal;
EXCEPTION
    WHEN no_data_found THEN
        RETURN v_sal;
END get_sal_func;
/

desc get_sal_func;
/*
FUNCTION get_sal_func RETURNS NUMBER
인수 이름 유형     In/Out 기본값?    
----- ------ ------ ------- 
P_ID  NUMBER IN     unknown
*/

-- 함수 호출
var b_sal number;
exec :b_sal := get_sal_func(100);
print b_sal;
exec dbms_output.put_line(get_sal_func(100));

-- 익명 블록으로 함수 호출
DECLARE
    v_sal number;
BEGIN
    v_sal := get_sal_func(100);
    dbms_output.put_line(v_sal);
    dbms_output.put_line(get_sal_func(100));
END;
/

SELECT get_sal_func(employee_id) FROM hr.employees WHERE department_id = 20;

-- 함수 삭제
DROP FUNCTION get_sal_func;

CREATE OR REPLACE FUNCTION tax(p_value IN number)
RETURN number
IS
BEGIN
    RETURN(p_value*0.08);
END tax;
/

SELECT employee_id, salary, tax(salary)
FROM hr.employees;

GRANT select on employees TO anna;
GRANT execute on tax TO anna;

SELECT employee_id, salary, tax(salary)
FROM hr.employees
WHERE tax(salary) > (SELECT max(tax(salary))
                    FROM hr.employees
                    WHERE department_id = 50);

DROP FUNCTION tax;
