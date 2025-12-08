select * from dba_users;
select * from dba_tablespaces;

drop tablespace oltp_tbs including contents and datafiles;
drop tablespace oltp_temp including contents and datafiles;

select * from dba_data_files;

-- 테이블스페이스 생성
create tablespace insa_tbs
datafile '/u01/app/oracle/oradata/ORA19C/insa_tbs01.dbf' size 10m autoextend on
extent management local uniform size 1m
segment space management auto;

-- 임시 테이블스페이스 생성
create temporary tablespace insa_temp
tempfile '/u01/app/oracle/oradata/ORA19C/insa_temp01.dbf' size 10m autoextend on
extent management local uniform size 1m
segment space management manual;

select * from dba_data_files;
select * from dba_tablespaces;
select * from dba_ts_quotas where tablespace_name = 'INSA_TBS';

-- insa 유저 생성
create user insa
identified by oracle
default tablespace insa_tbs
temporary tablespace insa_temp
quota 1m on insa_tbs
password expire;

select * from dba_users where username = 'INSA';

-- insa에게 create session 시스템 권한 부여
grant create session to insa;
select * from dba_sys_privs where grantee = 'INSA';

-- insa에게 create table 시스템 권한 부여
grant create table to insa;
select * from dba_sys_privs where grantee = 'INSA';

revoke create table from insa;

-- insa에게 with admin option으로 create table 시스템 권한 부여
grant create table to insa with admin option;
select * from dba_sys_privs where grantee = 'INSA';

-- insa_buha 유저 생성
create user insa_buha
identified by oracle
default tablespace insa_tbs
temporary tablespace insa_temp
quota 1m on insa_tbs;

select * from dba_ts_quotas where username = 'INSA_BUHA';

-- insa_buha에게 create session 시스템 권한 부여
grant create session to insa_buha;

select * from dba_sys_privs where grantee = 'INSA_BUHA';

-- INSA에게 create sequence 시스템 권한 부여
grant create sequence to insa with admin option;
select * from dba_sys_privs where grantee = 'INSA';

-- 시퀀스 조회
select * from dba_sequences where sequence_owner = 'INSA' and sequence_name = 'ID_SEQ';

select * from dba_sys_privs where grantee in ('INSA', 'INSA_BUHA');

-- create sequence 권한 회수 -> insa가 insa_buha에게 부여한 create sequence는 회수되지 않음
revoke create sequence from insa;
select * from dba_sys_privs where grantee in ('INSA', 'INSA_BUHA');

revoke create sequence from insa_buha;
select * from dba_sys_privs where grantee in ('INSA', 'INSA_BUHA');

-- INSA에게 select on hr.employees, hr.departments 객체 권한 부여
grant select on hr.employees to insa with grant option;
grant select on hr.departments to insa with grant option;

select * from dba_tab_privs where grantee = 'INSA';

-- INSA, INSA_BUHA 유저가 가진 객체 권한 조회
select * from dba_tab_privs where grantee in ('INSA', 'INSA_BUHA');

-- INSA가 가진 select on hr.departments 객체 권한 회수
revoke select on hr.departments from insa;
select * from dba_tab_privs where grantee in ('INSA', 'INSA_BUHA');

-- prog 롤 생성
create role prog;
select * from dba_roles where role = 'PROG';

-- 롤에 시스템 권한 부여
grant create session, create procedure, create trigger, create view to prog;
select * from dba_sys_privs where grantee = 'PROG';

-- 롤에 객체 권한 부여
grant select on hr.departments to prog;
select * from dba_tab_privs where grantee = 'PROG';

-- 롤을 유저에게 부여
grant prog to insa;
select * from dba_role_privs where grantee = 'INSA';

-- mgr 롤 생성
create role mgr;

-- mgr 롤에 select any table 객체 권한 부여
grant select any table to mgr;
select * from dba_roles where role = 'MGR';

-- mgr 롤을 유저에게 부여
grant mgr to insa;
select * from dba_role_privs where grantee = 'INSA';

select * from dba_role_privs where grantee = 'INSA';

-- mgr을 제외하고 모든 롤에 대해 default role 활성화
alter user insa default role all except mgr;
select * from dba_role_privs where grantee = 'INSA';

-- default role 비활성화
alter user insa default role none;
select * from dba_role_privs where grantee = 'INSA';

-- prog를 제외하고 모든 롤에 대해 default role 활성화
alter user insa default role all except prog;
select * from dba_role_privs where grantee = 'INSA';

-- 유저에게 부여한 롤 전부에 대해 default role 활성화
alter user insa default role all;
select * from dba_role_privs where grantee = 'INSA';

select * from dba_sys_privs where grantee in ('INSA', 'PROG', 'MGR');
select * from dba_tab_privs where grantee in ('INSA', 'PROG', 'MGR');

-- 뷰 생성 시 주의 사항
revoke select on hr.employees from insa;
select * from dba_tab_privs where grantee in ('INSA', 'PROG', 'MGR');

grant select on hr.employees to insa;
grant select on hr.departments to insa;
select * from dba_tab_privs where grantee = 'INSA';

select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

revoke select on hr.employees from insa;
select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

grant select on hr.employees to insa;
select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

revoke select on hr.departments from insa;
select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

grant select on hr.departments to insa;
select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

-- 프로시저 생성 시 주의사항
revoke select on hr.employees from insa;
revoke select on hr.departments from insa;
select * from dba_tab_privs where grantee = 'INSA';

grant select on hr.departments to insa;
select * from dba_tab_privs where grantee = 'INSA';

revoke select on hr.employees from insa;
grant select on hr.employees to insa;

revoke select on hr.departments from insa;
grant select on hr.departments to insa;

-- role 삭제
drop role mgr;

-- 패스워드를 설정하여 롤 생성
create role mgr identified by oracle;
select * from dba_roles where role = 'MGR';

-- mgr 롤에 권한 부여
grant select any table to mgr;
grant mgr to insa;
select * from dba_role_privs where grantee = 'INSA';

-- 롤에 설정된 패스워드 해제
alter role mgr not identified;

select * from dba_roles where role = 'MGR';
select * from dba_role_privs where grantee = 'INSA';