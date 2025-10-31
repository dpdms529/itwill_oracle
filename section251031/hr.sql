-- init
SELECT * FROM hr.emp;
SELECT * FROM hr.dept;

SELECT * FROM user_constraints WHERE table_name = 'EMP';

ALTER TABLE hr.emp DROP CONSTRAINT emp_sal_ck;
ALTER TABLE hr.emp DROP CONSTRAINT emp_name_uk;

INSERT INTO hr.dept(id, dept_name)
SELECT department_id, department_name
FROM hr.departments;

INSERT INTO hr.emp(emp_id, name, sal, dept_id)
SELECT employee_id, last_name, salary, department_id
FROM hr.employees;

COMMIT;

SELECT * FROM hr.emp;
SELECT * FROM hr.dept;

SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');

SELECT * FROM hr.dept;

ALTER TABLE hr.dept RENAME COLUMN id TO dept_id;

SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');

-- ������ ���̺� ��ȸ
SHOW recyclebin

SELECT * FROM user_recyclebin;

-- ������ ���̺� ���� ����
PURGE recyclebin;

SELECT * FROM hr.emp;
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');

-- ���̺� ����
DROP TABLE hr.emp;

SELECT * FROM hr.emp;
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');

-- ���� ���̺� ��ȸ
SELECT * FROM user_recyclebin;

SELECT * FROM "BIN$OCbOYC3eQU6vZWJizOBiBA==$0";

-- ���̺� ����
FLASHBACK TABLE emp TO BEFORE DROP;

SELECT * FROM user_recyclebin;

SELECT * FROM hr.emp;
SELECT * FROM user_indexes WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_ind_columns WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_constraints WHERE table_name IN ('DEPT', 'EMP');
SELECT * FROM user_cons_columns WHERE table_name IN ('DEPT', 'EMP');

-- recyclebin�� ������ �̸��� ���̺��� ������ �ִ� ��� �ֱ� ������ ���̺���� ���� (STACK)
DROP TABLE hr.emp;

CREATE TABLE hr.emp
AS SELECT * FROM hr.employees;

SELECT * FROM user_recyclebin;

DROP TABLE hr.emp;

SELECT * FROM user_recyclebin;

FLASHBACK TABLE emp TO BEFORE DROP;

SELECT * FROM user_recyclebin;

FLASHBACK TABLE emp TO BEFORE DROP;

-- ���ο� �̸����� ���̺� ����
FLASHBACK TABLE emp TO BEFORE DROP RENAME TO emp_new;

SELECT * FROM emp_new;
SELECT * FROM user_indexes WHERE table_name = 'EMP_NEW';
SELECT * FROM user_ind_columns WHERE table_name = 'EMP_NEW';
SELECT * FROM user_constraints WHERE table_name = 'EMP_NEW';
SELECT * FROM user_cons_columns WHERE table_name = 'EMP_NEW';

-- ���̺� ���� ����
DROP TABLE hr.emp_new PURGE;
SELECT * FROM user_recyclebin;

DROP TABLE hr.dept;
DROP TABLE hr.emp;

-- Ư���� ���̺� recyclebin���� ������ ����
PURGE TABLE EMP;
SELECT * FROM user_recyclebin;

PURGE RECYCLEBIN;

SELECT * FROM user_recyclebin;

CREATE TABLE hr.emp
TABLESPACE users
AS
SELECT * FROM hr.employees;

-- ���̺� ���� ��� ����
SELECT * FROM user_tables WHERE table_name = 'EMP';
-- ���׸�Ʈ�� ���� ��� ���� - ���丮���� ���� �κи�
SELECT * FROM user_segments WHERE segment_name = 'EMP';
SELECT * FROM user_extents WHERE segment_name = 'EMP';

INSERT INTO hr.emp
SELECT * FROM hr.emp;

COMMIT;

SELECT count(*) FROM hr.emp;
SELECT * FROM user_segments WHERE segment_name = 'EMP';
SELECT * FROM user_extents WHERE segment_name = 'EMP';

-- delete�� �����ص� �þ ���丮�� ������ �پ���� ����
DELETE FROM hr.emp;

COMMIT;

SELECT count(*) FROM hr.emp;
SELECT * FROM user_segments WHERE segment_name = 'EMP';
SELECT * FROM user_extents WHERE segment_name = 'EMP';

INSERT INTO hr.emp
SELECT * FROM hr.employees;

COMMIT;

SELECT count(*) FROM hr.emp;
SELECT * FROM user_tables WHERE table_name = 'EMP';
SELECT * FROM user_segments WHERE segment_name = 'EMP';
SELECT * FROM user_extents WHERE segment_name = 'EMP';

-- truncate�� MINEXTENT�� ����� EXTENT�� ��� ����
TRUNCATE TABLE hr.emp;
SELECT count(*) FROM hr.emp;
SELECT * FROM user_tables WHERE table_name = 'EMP';
SELECT * FROM user_segments WHERE segment_name = 'EMP';
SELECT * FROM user_extents WHERE segment_name = 'EMP';

-- comment
-- ���̺� �ּ� Ȯ��
SELECT * FROM user_tab_comments WHERE table_name = 'EMPLOYEES';

-- �÷� �ּ� Ȯ��
SELECT * FROM user_col_comments WHERE table_name = 'EMPLOYEES';

-- ���̺� �ּ� ����
COMMENT ON TABLE hr.emp IS '��� ���� ���̺�';
SELECT * FROM user_tab_comments WHERE table_name = 'EMP';

-- �÷� �ּ� ����
COMMENT ON COLUMN hr.emp.employee_id IS '��� ��ȣ';
COMMENT ON COLUMN hr.emp.salary IS '��� �޿�';
SELECT * FROM user_col_comments WHERE table_name = 'EMP';

-- ���̺� �ּ� ����
COMMENT ON TABLE hr.emp IS '';
SELECT * FROM user_tab_comments WHERE table_name = 'EMP';

-- �÷� �ּ� ����
COMMENT ON COLUMN hr.emp.employee_id IS '';
COMMENT ON COLUMN hr.emp.salary IS '';
SELECT * FROM user_col_comments WHERE table_name = 'EMP';

-- view
SELECT * FROM hr.employees;

GRANT SELECT ON hr.employees TO insa;
SELECT * FROM user_tab_privs;

REVOKE SELECT ON hr.employees FROM insa;
SELECT * FROM user_tab_privs;

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
TABLESPACE users
AS
SELECT employee_id, last_name, department_id
FROM hr.employees;

SELECT * FROM hr.emp;

GRANT SELECT ON hr.emp TO insa;
SELECT * FROM user_tab_privs;

-- view ����
CREATE VIEW hr.emp_view
AS
SELECT employee_id, last_name, department_id
FROM hr.employees;

SELECT * FROM hr.emp_view;

SELECT * FROM user_objects WHERE object_name = 'EMP_VIEW';
SELECT * FROM user_tables WHERE table_name = 'EMP_VIEW';
SELECT * FROM user_segments WHERE segment_name = 'EMP_VIEW';
SELECT * FROM user_views WHERE view_name = 'EMP_VIEW';

-- view ��ȸ ���� �ο�
GRANT SELECT ON hr.emp_view TO insa;

SELECT * FROM user_sys_privs;
SELECT * FROM role_sys_privs;
SELECT * FROM session_privs;

-- view ����
DROP VIEW hr.emp_view;

SELECT * FROM user_tab_privs;

-- view ����
CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT employee_id, last_name|| ' ' || first_name name, department_id
FROM hr.employees;

desc hr.emp_view

SELECT * FROM hr.emp_view;

DROP VIEW hr.emp_view;

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
TABLESPACE users
AS
SELECT employee_id id, last_name name, salary sal, department_id dept_id
FROM hr.employees;

SELECT * FROM hr.emp;

GRANT SELECT ON hr.emp TO insa;
REVOKE SELECT ON hr.emp FROM insa;

CREATE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp;

SELECT * FROM hr.emp_view;

GRANT SELECT ON hr.emp_view TO insa;

SELECT * FROM user_tab_privs;
DROP VIEW hr.emp_view;

CREATE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp
WHERE dept_id = 20;

GRANT SELECT ON hr.emp_view TO insa;

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp
WHERE dept_id IN (20, 30, 40);

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp
WHERE dept_id IN (20, 30, 40);

DROP VIEW hr.emp_view;

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp;

INSERT INTO hr.emp_view(id, name, dept_id) VALUES(300, 'ORACLE', 10);

SELECT * FROM hr.emp_view;
SELECT * FROM hr.emp;

ROLLBACK;

SELECT * FROM hr.emp_view WHERE id = 100;

UPDATE hr.emp_view
SET dept_id = 10
WHERE id = 100;

DELETE FROM hr.emp_view WHERE id = 100;

ROLLBACK;

GRANT INSERT, UPDATE, DELETE ON hr.emp_view TO insa;
SELECT * FROM user_tab_privs;

SELECT * FROM hr.emp WHERE id = 101;

REVOKE DELETE ON hr.emp_view FROM insa;

SELECT * FROM user_tables WHERE table_name = 'EMP';

DROP TABLE hr.emp PURGE;

CREATE TABLE hr.emp
TABLESPACE users
AS
SELECT employee_id id, last_name name, salary sal, department_id dept_id
FROM hr.employees;

DROP VIEW hr.emp_view;

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, dept_id
FROM hr.emp;

GRANT SELECT ON hr.emp_view TO insa;
GRANT INSERT, UPDATE, DELETE ON hr.emp_view TO insa;

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, last_name ||' '|| first_name name, dept_id
FROM hr.emp;

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp
WHERE dept_id = 20;

SELECT * FROM hr.emp WHERE id = 500;

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp
WHERE dept_id = 20
WITH CHECK OPTION CONSTRAINT emp_view_ck;

SELECT * FROM user_constraints WHERE table_name = 'EMP_VIEW';

CREATE OR REPLACE VIEW hr.emp_view
AS
SELECT id, name, dept_id
FROM hr.emp
WITH READ ONLY;