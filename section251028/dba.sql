-- ����
SELECT * FROM dba_sys_privs
WHERE grantee = 'HR';

SELECT * FROM dba_tab_privs
WHERE grantee = 'HR';

SELECT * FROM dba_role_privs
WHERE grantee = 'HR';

SELECT * FROM dba_tables;
SELECT * FROM all_tables;

-- ������ ���� ��ȸ
SELECT * FROM dba_data_files;

-- temp ���� ��ȸ
SELECT * FROM dba_temp_files;

-- ���� ������ ���� ���� ��ȸ
SELECT * FROM dba_users;

-- SYS ������ ���� ���� ���� 
SHOW USER;

-- ���� ����
CREATE USER insa
IDENTIFIED BY oracle -- ��й�ȣ
DEFAULT TABLESPACE users -- ���̺����̽� ����
TEMPORARY TABLESPACE temp -- �ӽ� ���̺����̽� ����(���İ��� �޸� ������ �� ó������ ���ϴ� ��� ���)
QUOTA 10M ON users -- �뷮 ����
ACCOUNT UNLOCK; -- ���� ��� ����

-- ���̺����̽��� ��뷮 �� �뷮 Ȯ��
SELECT * FROM dba_ts_quotas;

-- ���� ����
ALTER USER insa
IDENTIFIED BY oracle
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA unlimited ON users
ACCOUNT UNLOCK;

ALTER USER insa
QUOTA unlimited ON users;

-- CREATE SESSION ���� �ο�
GRANT CREATE SESSION TO insa;

-- INSA ������ �ý��� ���� Ȯ��
SELECT * FROM dba_sys_privs WHERE grantee = 'INSA';

-- ���̺� ����
CREATE TABLE insa.emp(id number(4), name varchar2(30), day date default sysdate) TABLESPACE users;

GRANT CREATE TABLE TO insa;