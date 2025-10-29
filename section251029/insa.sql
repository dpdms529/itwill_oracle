show user;

SELECT * FROM user_tab_privs;

SELECT * FROM hr.employees;

SELECT * FROM hr.departments;

-- 사용자 소유 테이블 조회
SELECT * FROM user_tables;

-- 사용자 소유 오브젝트 조회
SELECT * FROM user_objects;

DESC insa.emp

-- 사용자 소유 테이블 컬럼 정보 조회
SELECT * FROM user_tab_columns WHERE table_name = 'EMP';

-- INSERT
INSERT INTO insa.emp(id, name, day)
VALUES(1, 'liam', to_date('2025-10-29', 'yyyy-mm-dd'));

SELECT * FROM insa.emp;

ROLLBACK;

SELECT * FROM insa.emp;

INSERT INTO insa.emp(id, name, day)
VALUES(1, 'liam', to_date('2025-10-29', 'yyyy-mm-dd'));

INSERT INTO insa.emp(id, name, day)
VALUES(2, 'NOAH', sysdate);

SELECT * FROM insa.emp;

COMMIT;

INSERT INTO insa.emp(id, name, day)
VALUES(3, 'james', to_date('2025-10-01', 'yyyy-mm-dd'));

INSERT INTO insa.emp(id, name, day)
VALUES(4, 'henry', to_date('2024-11-01', 'yyyy-mm-dd'));

SELECT * FROM insa.emp;

ROLLBACK;

SELECT * FROM insa.emp;

INSERT INTO insa.emp(id, name)
VALUES(3, 'james');

INSERT INTO insa.emp(id, name, day)
VALUES(4, 'henry', default);

SELECT * FROM insa.emp;

INSERT INTO insa.emp(id, name, day)
VALUES(5, default, default);

SELECT * FROM insa.emp;

INSERT INTO insa.emp(id, name, day)
VALUES(6, 'khai', null);

SELECT * FROM insa.emp;

ROLLBACK;

SELECT * FROM insa.emp;

-- UPDATE
UPDATE insa.emp
SET day = to_date('2025-10-01', 'yyyy-mm-dd');

SELECT * FROM insa.emp;

ROLLBACK;

SELECT * FROM insa.emp;

UPDATE insa.emp
SET day = to_date('2025-10-01', 'yyyy-mm-dd')
WHERE id = 2;

SELECT * FROM insa.emp;

COMMIT;

SELECT * FROM insa.emp;

UPDATE insa.emp
SET day = default
WHERE id = 2;

SELECT * FROM insa.emp;

UPDATE insa.emp
SET day = null
WHERE id = 2;

SELECT * FROM insa.emp;

ROLLBACK;

-- delete
DELETE FROM insa.emp;

SELECT * FROM insa.emp;

ROLLBACK;

DELETE FROM insa.emp
WHERE id = 1;

SELECT * FROM insa.emp;

COMMIT;

SELECT * FROM insa.emp;

-- 테이블 삭제
-- 테이블 소유자, SYS 유저만 삭제 가능
DROP TABLE insa.emp PURGE;


