show user;

SELECT * FROM user_tab_privs;

SELECT * FROM hr.employees;

SELECT * FROM hr.departments;

-- ����� ���� ���̺� ��ȸ
SELECT * FROM user_tables;

-- ����� ���� ������Ʈ ��ȸ
SELECT * FROM user_objects;

DESC insa.emp

-- ����� ���� ���̺� �÷� ���� ��ȸ
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

-- ���̺� ����
-- ���̺� ������, SYS ������ ���� ����
DROP TABLE insa.emp PURGE;


