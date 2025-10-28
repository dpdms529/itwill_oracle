-- 권한
SELECT * FROM dba_sys_privs
WHERE grantee = 'HR';

SELECT * FROM dba_tab_privs
WHERE grantee = 'HR';

SELECT * FROM dba_role_privs
WHERE grantee = 'HR';

SELECT * FROM dba_tables;
SELECT * FROM all_tables;

-- 데이터 파일 조회
SELECT * FROM dba_data_files;

-- temp 파일 조회
SELECT * FROM dba_temp_files;

-- 현재 생성된 유저 정보 조회
SELECT * FROM dba_users;

-- SYS 유저만 유저 생성 가능 
SHOW USER;

-- 유저 생성
CREATE USER insa
IDENTIFIED BY oracle -- 비밀번호
DEFAULT TABLESPACE users -- 테이블스페이스 지정
TEMPORARY TABLESPACE temp -- 임시 테이블스페이스 지정(정렬같이 메모리 내에서 다 처리하지 못하는 경우 사용)
QUOTA 10M ON users -- 용량 지정
ACCOUNT UNLOCK; -- 계정 잠금 해제

-- 테이블스페이스별 사용량 및 용량 확인
SELECT * FROM dba_ts_quotas;

-- 유저 수정
ALTER USER insa
IDENTIFIED BY oracle
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA unlimited ON users
ACCOUNT UNLOCK;

ALTER USER insa
QUOTA unlimited ON users;

-- CREATE SESSION 권한 부여
GRANT CREATE SESSION TO insa;

-- INSA 유저의 시스템 권한 확인
SELECT * FROM dba_sys_privs WHERE grantee = 'INSA';

-- 테이블 생성
CREATE TABLE insa.emp(id number(4), name varchar2(30), day date default sysdate) TABLESPACE users;

GRANT CREATE TABLE TO insa;