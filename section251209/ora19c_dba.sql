-- role 정보
select * from dba_roles;

-- user + role
select * from user$;

drop role prog;
drop role mgr;

-- user 정보
select * from dba_users;

select * from dba_users where username = 'INSA';
select * from dba_sys_privs where grantee = 'INSA';
select * from dba_tab_privs where grantee = 'INSA';

create role prog;
create role mgr;

select * from dba_roles;

grant create view, create trigger, create procedure to prog;
grant select any table to mgr;
grant select on hr.departments to prog;

select * from dba_sys_privs where grantee = 'PROG';
select * from dba_sys_privs where grantee = 'MGR';
select * from dba_tab_privs where grantee = 'PROG';
select * from dba_tab_privs where grantee = 'MGR';

select * from dba_role_privs where grantee = 'INSA';
grant prog, mgr to insa;
select * from dba_role_privs where grantee = 'INSA';

select * from dba_tab_privs where grantee = 'INSA';
revoke select on hr.departments from insa;

select distinct privilege from dba_sys_privs where privilege like '%ANY%';
select * from dba_sys_privs where privilege like 'CREATE ANY%';
select * from dba_sys_privs where privilege like 'DROP ANY%';

revoke prog, mgr from insa;
select * from dba_role_privs where grantee = 'INSA';
grant prog, mgr to insa;
select * from dba_role_privs where grantee = 'INSA';

-- 유저에게 부여된 롤 전부를 default role에서 제외
select * from dba_role_privs where grantee = 'INSA';
alter user insa default role none;
select * from dba_role_privs where grantee = 'INSA';

-- 유저에게 부여된 롤 전부를 default role로 지정
alter user insa default role all;
select * from dba_role_privs where grantee = 'INSA';

-- 유저에게 부여된 특정한 롤만 default role로 지정
alter user insa default role prog;
select * from dba_role_privs where grantee = 'INSA';

-- 유저에게 부여된 특정한 롤만 제외하고 나머지 롤들은 default role로 지정
alter user insa default role all except mgr;
select * from dba_role_privs where grantee = 'INSA';

drop role mgr;

-- 비밀번호를 이용해서 롤 생성
create role mgr identified by oracle;
select * from dba_roles where role = 'MGR';
grant select any table to mgr;
grant mgr to insa;
select * from dba_role_privs where grantee = 'INSA';

alter user insa default role all;
select * from dba_role_privs where grantee = 'INSA';

-- 롤에 설정된 비밀번호 해제
alter role mgr not identified;
select * from dba_roles where role = 'MGR';
select * from dba_role_privs where grantee = 'INSA';

-- 롤에 비밀번호 설정
alter role mgr identified by oracle;
select * from dba_roles where role = 'MGR';
select * from dba_role_privs where grantee = 'INSA';

-- drop any table 시스템 권한
drop table hr.emp purge; 

-- create any table 시스템 권한
create table hr.emp(id number, name varchar2(30), sal number) tablespace users;
create table insa.emp(id number, name varchar2(30), sal number) tablespace users;

alter user insa quota 10m on users;
select * from dba_ts_quotas where username = 'INSA';

create or replace procedure priv_mgr
authid current_user
is
begin
    if to_char(sysdate, 'hh24:mi') between '14:00' and '14:05' then
        dbms_session.set_role('sec_app_role');
    else
        dbms_session.set_role('all');
    end if;
end priv_mgr;
/

show error

-- sec_app_role 생성 (application 인증 방식)
create role sec_app_role identified using priv_mgr;
select * from dba_roles where role = 'SEC_APP_ROLE';

-- select any dictionary 시스템 권한 부여
grant select any dictionary to sec_app_role;
select * from dba_sys_privs where grantee = 'SEC_APP_ROLE';

-- insa 유저에게 프로시저 실행 권한 부여
grant execute on priv_mgr to insa;
grant execute on priv_mgr to hr;

-- inherit privileges 권한 회수
revoke inherit privileges on user insa from public;
-- inherit privileges 권한 부여
grant inherit privileges on user insa to public;

select * from dba_tab_privs where grantor = 'ORA1';

-- profile
select username, profile from dba_users;
select * from dba_profiles where profile = 'DEFAULT';

select * from v$parameter where name like '%failed%';

alter profile default limit
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LOCK_TIME 1/1440;

select * from dba_profiles where profile = 'DEFAULT';

alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';

select * from dba_users where username = 'INSA';

-- default pofile 수정
alter profile default limit
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LOCK_TIME unlimited;

select * from dba_profiles where profile = 'DEFAULT';

select * from dba_users where username = 'INSA';

alter user insa identified by oracle account unlock password expire;
select * from dba_users where username = 'INSA';

