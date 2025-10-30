-- merge
MERGE INTO hr.dw_emp d
USING hr.oltp_emp o
ON (d.employee_id = o.employee_id)
WHEN MATCHED THEN
	UPDATE SET
		d.salary = o.salary * 1.1
	DELETE WHERE o.flag = 'd'
WHEN NOT MATCHED THEN
	INSERT (d.employee_id, d.last_name, d.salary, d.department_id) 
	VALUES (o.employee_id, o.last_name, o.salary, o.department_id);
    
SELECT * FROM hr.dw_emp;

ROLLBACK;

-- [문제51] emp_copy 테이블에 있는 departmetn_name값을 departments테이블에 있는 department_name값을 이용해서 수정해주세요.

CREATE TABLE hr.emp_copy
AS
SELECT * FROM hr.employees;

ALTER TABLE hr.emp_copy ADD department_name varchar2(30);

-- 1) correlated subquery를 이용한 UPDATE 이용
SELECT c.department_id, d.department_id, d.department_name
FROM hr.departments d, emp_copy c
WHERE d.department_id = c.department_id;

SELECT * FROM hr.emp_copy;

UPDATE hr.emp_copy c
SET department_name = (SELECT department_name
                        FROM hr.departments
                        WHERE department_id = c.department_id);
                        
SELECT * FROM hr.emp_copy;

ROLLBACK;

-- 2) MERGE문 이용
MERGE INTO hr.emp_copy c
USING hr.departments d
ON (c.department_id = d.department_id)
WHEN MATCHED THEN
    UPDATE SET c.department_name = d.department_name;
    
SELECT * FROM hr.emp_copy;

ROLLBACK;

-- DDL
DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
(id number, name varchar2(30), day date)
TABLESPACE users;

SELECT * FROM user_tables WHERE table_name = 'EMP';
SELECT * FROM user_tab_columns WHERE table_name = 'EMP';

DESC hr.emp

-- 컬럼 추가
ALTER TABLE hr.emp ADD job_id varchar2(20);
ALTER TABLE hr.emp ADD dept_id varchar2(20);

DESC hr.emp

SELECT * FROM user_tab_columns WHERE table_name = 'EMP';

-- 컬럼 속성 수정
ALTER TABLE hr.emp MODIFY job_id varchar2(30);
ALTER TABLE hr.emp MODIFY dept_id number(3);

DESC hr.emp

-- 컬럼 삭제
ALTER TABLE hr.emp DROP COLUMN job_id;

DESC hr.emp

SELECT * FROM user_tab_columns WHERE table_name = 'EMP';

-- 컬럼 비활성화
ALTER TABLE hr.emp SET UNUSED COLUMN dept_id;

DESC hr.emp
SELECT * FROM user_tab_columns WHERE table_name = 'EMP';

SELECT * FROM hr.emp;

SELECT * FROM user_unused_col_tabs;

-- 비활성화 컬럼 삭제
ALTER TABLE hr.emp DROP UNUSED COLUMNS;

SELECT * FROM user_unused_col_tabs;

INSERT INTO hr.emp(id, name, day) VALUES(1, 'james', sysdate);
INSERT INTO hr.emp(id, name, day) VALUES(1, 'noah', sysdate);
INSERT INTO hr.emp(id, name, day) VALUES(null, 'liam', sysdate);

SELECT * FROM hr.emp;

ROLLBACK;

SELECT * FROM user_constraints WHERE table_name = 'EMPLOYEES';
SELECT * FROM user_cons_columns WHERE table_name = 'EMPLOYEES';

-- PK 추가
ALTER TABLE hr.emp ADD CONSTRAINTS emp_id_pk PRIMARY KEY(id);

SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';

SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

INSERT INTO hr.emp(id, name, day) VALUES(1, 'james', sysdate);
INSERT INTO hr.emp(id, name, day) VALUES(1, 'noah', sysdate);
INSERT INTO hr.emp(id, name, day) VALUES(null, 'liam', sysdate);

-- PK 삭제
ALTER TABLE hr.emp DROP CONSTRAINT emp_id_pk;

SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';
SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

ALTER TABLE hr.emp ADD PRIMARY KEY(id);

ALTER TABLE hr.emp DROP PRIMARY KEY;

ALTER TABLE hr.emp ADD CONSTRAINTS emp_id_pk PRIMARY KEY(id);

CREATE TABLE hr.dept(dept_id number, dept_name varchar2(30)) TABLESPACE users;

ALTER TABLE hr.dept ADD CONSTRAINT dept_pk PRIMARY KEY(dept_id);

SELECT * FROM user_constraints WHERE table_name = 'DEPT';
SELECT * FROM user_indexes WHERE table_name = 'DEPT';

INSERT INTO hr.dept(dept_id, dept_name) VALUES(10, '인사');
INSERT INTO hr.dept(dept_id, dept_name)VALUES(20, '영업');
COMMIT;
SELECT * FROM hr.dept;

DESC hr.emp;

ALTER TABLE hr.emp ADD dept_id number;

DESC hr.emp

SELECT * FROM hr.emp;

INSERT INTO hr.emp(id, name, day, dept_id) VALUES(1, 'noah', sysdate, 10);
INSERT INTO hr.emp(id, name, day, dept_id) VALUES(2, 'liam', sysdate, 30);
COMMIT;

SELECT e.*, d.*
FROM hr.emp e, hr.dept d
WHERE e.dept_id = d.dept_id(+);

DELETE FROM hr.emp;
COMMIT;

SELECT * FROM hr.emp;

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');

-- fk 추가
ALTER TABLE hr.emp ADD CONSTRAINT emp_dept_id_fk
FOREIGN KEY(dept_id) references hr.dept(dept_id);

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');

INSERT INTO hr.emp(id, name, day, dept_id) VALUES(1, 'noah', sysdate, 10);
COMMIT;
SELECT * FROM hr.emp;
INSERT INTO hr.emp(id, name, day, dept_id) VALUES(2, 'liam', sysdate, 30);

SELECT * FROM hr.dept;

DELETE FROM hr.dept WHERE dept_id = 20;

ROLLBACK;

DROP TABLE hr.dept PURGE;

-- 제약 조건이 걸린 테이블 삭제
DROP TABLE hr.dept CASCADE CONSTRAINT PURGE;

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');

SELECT * FROM hr.emp;

CREATE TABLE hr.dept(dept_id number, dept_name varchar2(30)) TABLESPACE users;

ALTER TABLE hr.dept ADD CONSTRAINT dept_pk PRIMARY KEY(dept_id);

SELECT * FROM user_constraints WHERE table_name = 'DEPT';
SELECT * FROM user_indexes WHERE table_name = 'DEPT';

INSERT INTO hr.dept(dept_id, dept_name) VALUES(10, '인사');
INSERT INTO hr.dept(dept_id, dept_name)VALUES(20, '영업');
COMMIT;

SELECT * FROM hr.dept;

ALTER TABLE hr.emp ADD CONSTRAINT emp_dept_id_fk
FOREIGN KEY(dept_id) references hr.dept(dept_id);

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');

ALTER TABLE hr.dept DROP PRIMARY KEY;

-- 제약 조건 삭제
ALTER TABLE hr.emp DROP CONSTRAINT emp_dept_id_fk;
ALTER TABLE hr.dept DROP PRIMARY KEY;

ALTER TABLE hr.emp DROP PRIMARY KEY CASCADE;

-- unique 추가
ALTER TABLE hr.dept ADD CONSTRAINT dept_name_uk UNIQUE(dept_name);

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');

INSERT INTO hr.dept(dept_id, dept_name) VALUES(30, '영업');
INSERT INTO hr.dept(dept_id, dept_name) VALUES(30, null);

SELECT * FROM hr.dept;

-- unique 삭제
ALTER TABLE hr.dept DROP CONSTRAINT dept_name_uk;
ALTER TABLE hr.dept DROP UNIQUE(dept_name);

DESC hr.emp

ALTER TABLE hr.emp ADD sal number;

DESC hr.emp

-- check 추가
ALTER TABLE hr.emp ADD CONSTRAINT emp_sal_ck CHECK(sal >= 1000 AND sal <= 2000);

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');

DESC hr.emp
SELECT * FROM hr.emp;

INSERT INTO hr.emp(id, name, day, dept_id, sal) VALUES(2, 'james', sysdate, 20, 500);
INSERT INTO hr.emp(id, name, day, dept_id, sal) VALUES(2, 'james', sysdate, 20, 1500);
COMMIT;
SELECT * FROM hr.emp;

UPDATE hr.emp
SET sal = 200
WHERE id = 1;

INSERT INTO hr.emp(id, name, day, dept_id, sal) VALUES(3, 'john', sysdate, 10, null);

SELECT * FROM hr.emp;

ROLLBACK;

-- check 삭제
ALTER TABLE hr.emp DROP CONSTRAINT emp_sal_ck;

SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');

DESC hr.emp

-- not null 추가
ALTER TABLE hr.emp MODIFY name CONSTRAINT emp_name_nn NOT NULL;

INSERT INTO hr.emp(id, name, day, dept_id, sal) VALUES(3, NULL, sysdate, 10, 2000);

-- not null 삭제
ALTER TABLE hr.emp DROP CONSTRAINT emp_name_nn;
ALTER TABLE hr.emp MODIFY name NULL;

DROP TABLE hr.emp CASCADE CONSTRAINT PURGE;
DROP TABLE hr.dept CASCADE CONSTRAINT PURGE;

CREATE TABLE hr.dept(
	id number CONSTRAINT dept_pk PRIMARY KEY,  -- 열 레벨 정의
	dept_name varchar2(30))
TABLESPACE users;

CREATE TABLE hr.emp(
	id number CONSTRAINT emp_id_pk PRIMARY KEY, -- 열 레벨 정의
	name varchar2(30) CONSTRAINT emp_name_nn NOT NULL,  -- 열 레벨 정의
	sal number,
	dept_id number CONSTRAINT emp_dept_id_fk REFERENCES hr.dept(id),    -- 열 레벨 정의
	CONSTRAINT emp_name_uk UNIQUE(name),    -- 테이블 레벨 정의
	CONSTRAINT emp_sal_ck CHECK(sal BETWEEN 1000 AND 2000)) -- 테이블 레벨 정의
TABLESPACE users;

SELECT * FROM user_constraints WHERE table_name in ('EMP', 'DEPT');

DROP TABLE hr.emp CASCADE CONSTRAINT PURGE;

CREATE TABLE hr.emp(
	id number,
	name varchar2(30) CONSTRAINT emp_name_nn NOT NULL, -- NOT NULL 제약 조건은 열 레벨만 가능
	sal number,
	dept_id number,
    CONSTRAINT emp_id_pk PRIMARY KEY(id),   -- 테이블 레벨 정의
    CONSTRAINT emp_dept_id_fk FOREIGN KEY(dept_id) REFERENCES hr.dept(id),  -- 테이블 레벨 정의
	CONSTRAINT emp_name_uk UNIQUE(name),    -- 테이블 레벨 정의
	CONSTRAINT emp_sal_ck CHECK(sal BETWEEN 1000 AND 2000)) -- 테이블 레벨 정의
TABLESPACE users;

DROP TABLE hr.emp CASCADE CONSTRAINT PURGE;

CREATE TABLE hr.emp(
	id number,
	name varchar2(30) 
        CONSTRAINT emp_name_nn NOT NULL 
        CONSTRAINT emp_name_uk UNIQUE,  -- 열 레벨 정의
	sal number,
	dept_id number,
    CONSTRAINT emp_id_pk PRIMARY KEY(id),   -- 테이블 레벨 정의
    CONSTRAINT emp_dept_id_fk FOREIGN KEY(dept_id) REFERENCES hr.dept(id),  -- 테이블 레벨 정의
	CONSTRAINT emp_sal_ck CHECK(sal BETWEEN 1000 AND 2000)) -- 테이블 레벨 정의
TABLESPACE users;

-- 테이블 이름 수정
RENAME emp TO emp_new;  -- 소유자 이름 사용 X

ALTER TABLE hr.emp_new RENAME TO hr.emp;

SELECT * FROM user_tables WHERE table_name like 'EMP%';
SELECT * FROM user_constraints WHERE table_name IN ('EMP_NEW');

desc hr.emp

-- 컬럼 이름 수정
ALTER TABLE hr.emp RENAME COLUMN id TO emp_id;

desc hr.emp

SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';

-- 제약 조건 이름 수정
ALTER TABLE hr.emp RENAME CONSTRAINT emp_id_pk TO emp_pk;

SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';
SELECT * FROM user_indexes WHERE table_name = 'EMP';

-- 인덱스 이름 수정
ALTER INDEX emp_id_pk RENAME TO emp_id_idx;

SELECT * FROM user_indexes WHERE table_name = 'EMP';
