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

-- 유저 생성
create user insa
identified by oracle
default tablespace insa_tbs
temporary tablespace insa_temp
quota 1m on insa_tbs
password expire;

select * from dba_users where username = 'INSA';

-- create session 권한 부여
grant create session to insa;

select * from dba_sys_privs where grantee = 'INSA';

-- create table 권한 부여
grant create table to insa;

select * from dba_sys_privs where grantee = 'INSA';

revoke create table from insa;

-- with admin option
grant create table to insa with admin option;

select * from dba_sys_privs where grantee = 'INSA';

create user insa_buha
identified by oracle
default tablespace insa_tbs
temporary tablespace insa_temp
quota 1m on insa_tbs;

grant create session to insa_buha;

select * from dba_sys_privs where grantee = 'INSA_BUHA';
select * from dba_ts_quotas where username = 'INSA_BUHA';

grant create sequence to insa with admin option;
select * from dba_sys_privs where grantee = 'INSA';

create sequence id_seq
start with 1
maxvalue 10
increment by 1
nocycle
nocache;

select * from dba_sequences where sequence_owner = 'INSA' and sequence_name = 'ID_SEQ';

create sequence buha_seq start with 2;

select * from dba_sys_privs where grantee in ('INSA', 'INSA_BUHA');

revoke create sequence from insa;

select * from dba_sys_privs where grantee in ('INSA', 'INSA_BUHA');

revoke create sequence from insa_buha;

select * from dba_sys_privs where grantee in ('INSA', 'INSA_BUHA');

-- 객체 권한 부여
grant select on hr.employees to insa with grant option;
grant select on hr.departments to insa with grant option;

select * from dba_tab_privs where grantee = 'INSA';

select * from dba_tab_privs where grantee in ('INSA', 'INSA_BUHA');

revoke select on hr.departments from insa;

select * from dba_tab_privs where grantee in ('INSA', 'INSA_BUHA');

-- Role
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

create role mgr;

grant select any table to mgr;

select * from dba_roles where role = 'MGR';
select * from dba_role_privs where grantee = 'INSA';

grant mgr to insa;
select * from dba_role_privs where grantee = 'INSA';

alter user insa default role all except mgr;
select * from dba_role_privs where grantee = 'INSA';

alter user insa default role none;

select * from dba_role_privs where grantee = 'INSA';

alter user insa default role all except prog;

select * from dba_role_privs where grantee = 'INSA';

alter user insa default role all;
select * from dba_role_privs where grantee = 'INSA';

select * from dba_sys_privs where grantee in ('INSA', 'PROG', 'MGR');
select * from dba_tab_privs where grantee in ('INSA', 'PROG', 'MGR');

revoke select on hr.employees from insa;
select * from dba_tab_privs where grantee in ('INSA', 'PROG', 'MGR');

grant select on hr.employees to insa;
select * from dba_tab_privs where grantee = 'INSA';

grant select on hr.departments to insa;
select * from dba_tab_privs where grantee = 'INSA';

select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

revoke select on hr.employees from insa;

select * from dba_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');
select * from dba_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

grant select on hr.employees to insa;

revoke select on hr.departments from insa;

grant select on hr.departments to insa;

revoke select on hr.employees from insa;
revoke select on hr.departments from insa;

grant select on hr.departments to insa;
select * from dba_tab_privs where grantee = 'INSA';

revoke select on hr.departments from insa;

select * from dba_roles where role = 'MGR';

-- 롤 삭제
drop role mgr;

-- 패스워드를 설정하여 롤 생성
create role mgr identified by oracle;

select * from dba_roles where role = 'MGR';

grant select any table to mgr;
grant mgr to insa;

select * from dba_role_privs where grantee = 'INSA';

-- 롤에 설정된 패스워드 해제
alter role mgr not identified;
select * from dba_roles where role = 'MGR';
select * from dba_role_privs where grantee = 'INSA';

select * from dba_sys_privs where grantee = 'INSA';