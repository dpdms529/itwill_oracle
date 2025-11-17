-- DML 작업 복제
-- 테이블 생성
-- source 테이블
CREATE TABLE hr.emp_target
(id number,
name varchar2(30),
day timestamp default systimestamp,
sal number)
TABLESPACE users;

-- target 테이블
CREATE TABLE hr.emp_source
(id number,
name varchar2(30),
day timestamp default systimestamp,
sal number)
TABLESPACE users;

-- 트리거 생성
CREATE OR REPLACE TRIGGER emp_copy_trigger
AFTER
INSERT OR DELETE OR UPDATE ON hr.emp_source
FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO hr.emp_target(id, name, day, sal) VALUES(:new.id, :new.name, :new.day, :new.sal);
    ELSIF deleting THEN
        DELETE FROM hr.emp_target WHERE id = :old.id;
    ELSIF updating('sal') THEN
        UPDATE hr.emp_target
        SET sal = :new.sal
        WHERE id = :old.id;
    ELSIF updating('name') THEN
        UPDATE hr.emp_target
        SET name = :new.name
        WHERE id = :old.id;
    END IF;
END emp_copy_trigger;
/

-- insert
INSERT INTO hr.emp_source(id, name, day, sal) VALUES(100, 'ORA1', default, 1000);

-- update sal
UPDATE hr.emp_source
SET sal = 2000
WHERE id = 100;

-- update name
UPDATE hr.emp_source
SET name = 'ORACLE'
WHERE id = 100;

-- delete
DELETE FROM hr.emp_source WHERE id = 100;
DELETE FROM hr.emp_target WHERE id = 100;

SELECT s.id s_id, s.name s_name, s.day s_day, s.sal s_sal, t.id t_id, t.name t_name, t.day t_day, t.sal t_sal
FROM emp_source s, emp_target t
WHERE s.id = t.id
AND s.id = 100;

SELECT * FROM hr.emp_source;
SELECT * FROM hr.emp_target;

ROLLBACK;
COMMIT;

-- 감사
-- 테이블 생성
CREATE TABLE hr.audit_emp_sal
(name varchar2(30),
day timestamp,
id number,
old_sal number,
new_sal number)
TABLESPACE users;

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
AS
SELECT employee_id id, salary sal, job_id job, department_id dept_id
FROM hr.employees;

SELECT * FROM hr.audit_emp_sal;
SELECT * FROM hr.emp;

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE hr.update_proc(p_id IN number)
IS
BEGIN
    UPDATE hr.emp
    SET sal = sal * 1.1
    WHERE id = p_id;
END update_proc;
/

SELECT sal FROM hr.emp WHERE id = 200;
exec update_proc(200)
SELECT sal FROM hr.emp WHERE id = 200;
ROLLBACK;

-- 트리거 생성
CREATE OR REPLACE TRIGGER emp_sal_audit
AFTER
UPDATE OF sal ON hr.emp
FOR EACH ROW
BEGIN
    IF :old.sal != :new.sal THEN
        INSERT INTO hr.audit_emp_sal(name, day, id, old_sal, new_sal) VALUES(user, systimestamp, :new.id, :old.sal, :new.sal);
    END IF;
END emp_sal_audit;
/

SELECT sal FROM hr.emp WHERE id = 100;
SELECT * FROM hr.audit_emp_sal;

exec update_proc(100)

SELECT sal FROM hr.emp WHERE id = 100;
SELECT * FROM hr.audit_emp_sal;

ROLLBACK;

-- anna에 프로시저 실행 권한 부여
GRANT execute ON hr.update_proc TO anna;

SELECT sal FROM hr.emp WHERE id = 200;
SELECT * FROM hr.audit_emp_sal;

-- 테이블 생성
DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
AS
SELECT employee_id id, salary sal, department_id dept_id
FROM hr.employees;

DROP TABLE hr.dept PURGE;

CREATE TABLE hr.dept
AS
SELECT d.department_id dept_id, d.department_name dept_name, sum(e.salary) total_sal
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

SELECT * FROM hr.emp;
SELECT * FROM hr.dept;

CREATE OR REPLACE VIEW hr.emp_details
AS
SELECT e.id, e.sal, e.dept_id, d.dept_name, d.total_sal
FROM hr.emp e, hr.dept d
WHERE e.dept_id = d.dept_id;

SELECT * FROM hr.emp_details;

desc hr.emp_details

-- 뷰를 통한 INSERT
INSERT INTO hr.emp_details(id, sal, dept_id, dept_name) VALUES(300, 2000, 60, 'IT');

SELECT *
FROM hr.emp_details;

-- INSTEAD OF TRIGGER
CREATE OR REPLACE TRIGGER hr.emp_details_trigger
INSTEAD OF
INSERT OR UPDATE OR DELETE ON hr.emp_details
FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO hr.emp(id, sal, dept_id) VALUES(:new.id, :new.sal, :new.dept_id);
    
        UPDATE hr.dept
        SET total_sal = total_sal + :new.sal
        WHERE dept_id = :new.dept_id;
    ELSIF updating('sal') THEN
        UPDATE hr.emp
        SET sal = :new.sal
        WHERE id = :old.id;
        
        UPDATE hr.dept
        SET total_sal  = total_sal + (:new.sal - :old.sal)
        WHERE dept_id = :old.dept_id;
    ELSIF updating('dept_id') THEN
        UPDATE hr.emp
        SET dept_id = :new.dept_id
        WHERE id = :old.id;
        
        UPDATE hr.dept
        SET total_sal  = total_sal - :old.sal
        WHERE dept_id = :old.dept_id;
        
        UPDATE hr.dept
        SET total_sal  = total_sal + :new.sal
        WHERE dept_id = :new.dept_id;
    ELSIF deleting THEN
        DElETE FROM hr.emp WHERE id = :old.id; 
        
        UPDATE hr.dept
        SET total_sal = total_sal - :old.sal
        WHERE dept_id = :old.dept_id;
    END IF;
END emp_details_trigger;
/

SELECT * FROM hr.emp_details;
SELECT * FROM hr.emp;
SELECT * FROM hr.dept; --28800 -> 30800
INSERT INTO hr.emp_details(id, sal, dept_id, dept_name) VALUES(300, 2000, 60, 'IT');

ROLLBACK;

SELECT * FROM hr.emp_details WHERE id = 200; -- 4400 -> 2000
UPDATE hr.emp_details
SET sal = 2000
WHERE id = 200;

UPDATE hr.emp_details
SET dept_id = 20
WHERE id = 200;

SELECT * FROM hr.emp_details WHERE dept_id in (20);

DELETE FROM hr.emp_details WHERE id = 201;

ROLLBACK;

GRANT select ON hr.emp_details TO anna;
GRANT INSERT, UPDATE, DELETE ON hr.emp_details TO anna;

SELECT * FROM hr.emp_details;

DROP TABLE hr.emp PURGE;

-- DDL TRIGGER
-- 데이터베이스 레벨
DROP TABLE hr.dept PURGE;
-- ORA-20000: DROP or TRUNCATE 할 수 없습니다.

TRUNCATE TABLE hr.dept;
-- ORA-20000: DROP or TRUNCATE 할 수 없습니다.

CREATE TABLE hr.emp AS SELECT * FROM hr.employees;

-- 스키마(유저)레벨
TRUNCATE TABLE hr.emp;
-- ORA-20000: DROP or TRUNCATE할 수 없습니다.

DROP TABLE hr.emp PURGE;
-- ORA-20000: DROP or TRUNCATE할 수 없습니다.

-- DDL 감사
CREATE TABLE hr.emp
AS
SELECT * FROM hr.employees;

ALTER TABLE hr.emp ADD PRIMARY KEY(employee_id);

ALTER TABLE hr.emp ADD test varchar2(30);

ALTER TABLE hr.emp MODIFY test number(5);

ALTER TABLE hr.emp DROP COLUMN test;

ALTER TABLE hr.emp DROP PRIMARY KEY;

TRUNCATE TABLE hr.emp;

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
AS
SELECT * FROM hr.employees;

CREATE OR REPLACE VIEW test_view
AS
SELECT employee_id, salary FROM hr.emp e;

CREATE OR REPLACE PROCEDURE test_proc
IS
BEGIN
    dbms_output.put_line('test');
END;
/

exec test_proc;

DROP VIEW test_view;

DROP PROCEDURE test_proc;