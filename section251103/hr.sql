SELECT * FROM session_privs;
SELECT privilege, admin_option FROM user_sys_privs
union
SELECT privilege, admin_option FROM role_sys_privs;

-- sequence 생성
CREATE SEQUENCE id_seq;

-- sequence 조회
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

-- 테스트 테이블 생성
CREATE TABLE hr.seq_test(id number, name varchar2(30), day timestamp) TABLESPACE users;

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'liam', localtimestamp);
COMMIT;

SELECT * FROM hr.seq_test;

SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'noah', localtimestamp);
COMMIT;
SELECT * FROM hr.seq_test;
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'james', localtimestamp);
SELECT * FROM hr.seq_test;
ROLLBACK;

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'emma', localtimestamp);
SELECT * FROM hr.seq_test;

SELECT id_seq.currval FROM dual;

-- sequence 삭제
DROP SEQUENCE hr.id_seq;

CREATE SEQUENCE hr.id_seq
START WITH 1    -- 시작번호, 기본값 1
MAXVALUE 3      -- 최대값, 지정하지 않으면 기본값 10^27
INCREMENT BY 1  -- 증가분, 기본값 1
NOCYCLE         -- 최대값 도달 시 시퀀스를 계속 생성할지 여부 지정(순환 여부), 기본값 NOCYCLE
NOCACHE;        -- 시퀀스 값을 메모리에 미리 생성해서 사용할지 여부를 지정, 기본값 CACHE 20

SELECT * FROM user_objects WHERE object_name = 'ID_SEQ';
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

TRUNCATE TABLE hr.seq_test;

SELECT * FROM hr.seq_test;

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'liam', localtimestamp);
SELECT * FROM hr.seq_test;
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'noah', localtimestamp);
SELECT * FROM hr.seq_test;
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'emma', localtimestamp);
SELECT * FROM hr.seq_test;
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

-- maxvalue까지 생성했기 때문에 오류 발생
INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'jack', localtimestamp);
-- ORA-08004: sequence ID_SEQ.NEXTVAL exceeds MAXVALUE and cannot be instantiated
SELECT * FROM hr.seq_test;
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

COMMIT;

-- sequence 수정
ALTER SEQUENCE hr.id_seq
INCREMENT BY 2
MAXVALUE 100;

SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

INSERT INTO hr.seq_test(id, name, day) VALUES(id_seq.nextval, 'jack', localtimestamp);
SELECT * FROM hr.seq_test;
SELECT * FROM user_sequences WHERE sequence_name = 'ID_SEQ';

GRANT SELECT, INSERT, UPDATE, DELETE ON hr.seq_test TO insa;
SELECT * FROM user_tab_privs;

-- sequence 권한 부여
GRANT SELECT ON hr.id_seq TO insa;
SELECT * FROM user_tab_privs;

INSERT INTO hr.seq_test(id, name, day) VALUES(hr.id_seq.nextval, 'austin', localtimestamp);
SELECT * FROM hr.seq_test;
COMMIT;

-- sequence 권한 회수
REVOKE SELECT ON hr.id_seq FROM insa;

-- synonym
SELECT * FROM session_privs;

CREATE TABLE hr.emp_copy_2025
AS
SELECT * FROM hr.employees;

SELECT * FROM hr.emp_copy_2025;

-- synonym 생성
CREATE SYNONYM ec FOR hr.emp_copy_2025;

SELECT * FROM ec;

SELECT * FROM user_synonyms WHERE table_name = 'EMP_COPY_2025';

-- synonym 권한 부여
GRANT SELECT ON hr.emp_copy_2025 TO insa;

DROP SYNONYM ec;

SELECT * FROM session_privs;

-- public synonym 생성
CREATE PUBLIC SYNONYM ec FOR hr.emp_copy_2025;

SELECT * FROM all_synonyms WHERE synonym_name = 'EC';

SELECT * FROM user_tab_privs;

-- 권한 회수
REVOKE SELECT ON hr.emp_copy_2025 FROM insa;

-- public synonym 삭제
DROP PUBLIC SYNONYM ec;

SELECT * FROM session_privs;

-- rowid
DROP TABLE hr.emp CASCADE CONSTRAINT PURGE;

CREATE TABLE hr.emp
AS
SELECT * FROM hr.employees;

SELECT * FROM hr.emp WHERE employee_id = 100;

-- rowid 조회
SELECT rowid, e.* FROM hr.emp e;

SELECT * FROM user_objects WHERE object_name = 'EMP';
SELECT * FROM user_tables WHERE table_name = 'EMP';

-- by user rowid scan
SELECT * FROM hr.emp WHERE rowid = 'AAAE/uAAEAAAAFTAAA';

SELECT rowid, employee_id FROM hr.emp ORDER BY employee_id;

SELECT rowid FROM hr.emp WHERE employee_id = 100 ORDER BY employee_id;

SELECT rowid, e.*
FROM hr.emp e
WHERE rowid = (SELECT rowid FROM hr.emp WHERE employee_id = 100);

SELECT * FROM hr.emp WHERE last_name = 'King';

SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';
SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

-- PK 생성을 통한 unique index 생성
ALTER TABLE hr.emp ADD CONSTRAINT emp_id_pk PRIMARY KEY(employee_id);

SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';
SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

SELECT * FROM hr.emp WHERE employee_id = 100;

-- PK 삭제를 통한 unique index 제거
ALTER TABLE hr.emp DROP CONSTRAINT emp_id_pk;
ALTER TABLE hr.emp DROP PRIMARY KEY;
SELECT * FROM user_constraints WHERE table_name = 'EMP';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP';
SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

-- 수동으로 unique index 생성
CREATE UNIQUE INDEX hr.emp_idx ON hr.emp(employee_id) TABLESPACE users;

-- index 삭제
DROP INDEX hr.emp_idx;

-- non unique index 생성
CREATE INDEX hr.emp_idx ON hr.emp(employee_id) TABLESPACE users;

SELECT * FROM session_privs;

-- 인덱스 삭제
DROP INDEX hr.emp_idx;

-- unique index 생성 후 PK 생성
CREATE UNIQUE INDEX hr.emp_idx ON hr.emp(employee_id) TABLESPACE users;
SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

SELECT * FROM hr.emp WHERE employee_id = 100;

SELECT * FROM user_constraints WHERE table_name = 'EMP';

ALTER TABLE hr.emp ADD CONSTRAINT emp_id_pk PRIMARY KEY(employee_id);
SELECT * FROM user_indexes WHERE table_name = 'EMP';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP';

--  PK가 참조하는 인덱스 삭제 불가
DROP INDEX hr.emp_idx;
-- ORA-02429: cannot drop index used for enforcement fo unique/primary key

-- PK 제거 후 인덱스 제거
ALTER TABLE hr.emp DROP PRIMARY KEY;
DROP INDEX hr.emp_idx;

-- with문
-- 사원 수가 가장 많은 부서 정보 조회
WITH
    dept_cnt AS (SELECT department_id, count(*) cnt
                FROM hr.employees
                GROUP BY department_id)            
    SELECT d2.* 
    FROM dept_cnt d1, hr.departments d2
    WHERE d1.department_id = d2.department_id
    AND d1.cnt = (SELECT max(cnt) FROM dept_cnt);
    
-- 부서별 총급여의 평균보다 총급여가 많은 부서 조회    
WITH
    dept_cost AS (SELECT d.department_name, e.sumsal
                    FROM (SELECT department_id, sum(salary) sumsal
                            FROM hr.employees
                            GROUP BY department_id) e, hr.departments d
                    WHERE e.department_id = d.department_id),
    avg_cost AS (SELECT sum(sumsal) / count(*) dept_avg
                FROM dept_cost)
    SELECT *
    FROM dept_cost
    WHERE sumsal > (SELECT dept_avg FROM avg_cost);