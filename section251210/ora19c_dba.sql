select username, profile from dba_users;
select * from dba_profiles where profile = 'DEFAULT';

-- profile 생성
create profile insa_profile limit
failed_login_attempts 3
password_lock_time 1/1440
password_verify_function verify_function_itwill;

select * from dba_profiles where profile = 'INSA_PROFILE';

-- 유저 profile 수정
alter user insa profile insa_profile;

alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:ss';
select * from dba_users where username = 'INSA';

alter user insa password expire;

select * from dba_users where username = 'INSA';

alter user insa identified by "Itwill!234";

select * from dba_profiles where profile = 'INSA_PROFILE';

-- profile 수정
alter profile insa_profile limit
password_verify_function null;

select * from dba_profiles where profile = 'INSA_PROFILE';

select * from dba_users where username = 'INSA';
alter user insa identified by insa account unlock;

-- profile 삭제
drop profile insa_profile cascade;
select * from dba_users where username = 'INSA';

-- profile 생성
create profile insa_profile limit
password_life_time 5/1440
password_grace_time 5/1440;

select * from dba_profiles where profile = 'INSA_PROFILE';

alter user insa profile insa_profile;
select * from dba_users where username = 'INSA';

alter profile insa_profile limit
password_life_time unlimited
password_grace_time unlimited
password_reuse_time unlimited
password_reuse_max unlimited;

select * from dba_profiles where profile = 'INSA_PROFILE';

alter user insa identified by insa;

select * from dba_users where username = 'INSA';

alter profile insa_profile limit
sessions_per_user default
idle_time 1;

select * from dba_profiles where profile = 'INSA_PROFILE';

drop profile insa_profile cascade;

select * from dba_users where username = 'INSA';

select * from v$parameter where name = 'resource_limit';
select * from user$;

show parameter os_authent_prefix;

create user ops$jack
identified externally
default tablespace users
temporary tablespace temp
quota 1m on users;

select * from dba_users where username = 'OPS$JACK';

grant create session, select any table to ops$jack;

select * from dba_sys_privs where grantee = 'OPS$JACK';

select * from v$session where username = 'OPS$JACK';

alter system kill session '166,33816' immediate;
drop user ops$jack cascade;

-- audit
select * from v$parameter where name = 'audit_trail';

-- 감사 정보가 저장되는 딕셔너리 테이블
select * from aud$;

-- 감사 설정을 볼 수 있는 뷰
select * from dba_stmt_audit_opts where audit_option = 'TABLE';

-- 감사 정보를 볼 수 있는 뷰
select username, owner, obj_name, action_name, decode(returncode, 0, 'success', returncode) sess, timestamp from dba_audit_object;

select * from aud$;

create table insa.dept as select * from hr.departments;

select * from dba_ts_quotas where username = 'INSA';
select * from dba_data_files;
select * from dba_users where username = 'INSA';
alter user insa quota 10m on insa_tbs;

select * from aud$;

delete from aud$;
rollback;
select * from aud$;
truncate table aud$;
select * from aud$;

revoke prog, mgr from insa;
drop table hr.emp purge;

create table hr.emp
as 
select employee_id id, last_name name, salary sal
from hr.employees;

select * from hr.emp;

grant select, insert, update, delete on hr.emp to insa, insa_buha;

select * from dba_tab_privs where grantee in ('INSA', 'INSA_BUHA');

select * from dba_obj_audit_opts where owner = 'HR';
select owner, object_name, object_type, sel, ins, upd, del from dba_obj_audit_opts where owner = 'HR';

select username, owner, obj_name, action_name, decode(returncode, 0, 'success', returncode) sess, timestamp from dba_audit_object;

noaudit select, insert, update, delete on hr.emp;
select owner, object_name, object_type, sel, ins, upd, del from dba_obj_audit_opts where owner = 'HR';

truncate table aud$;
select * from aud$;

select * from dba_sys_privs where privilege = 'SELECT ANY TABLE';

grant select any table to insa, insa_buha;

audit select any table by insa, insa_buha;
select * from dba_stmt_audit_opts where audit_option = 'SELECT ANY TABLE';

truncate table aud$;
select * from aud$;

select username, owner, obj_name, action_name, decode(returncode, 0, 'success', returncode) sess, timestamp from dba_audit_object;

noaudit select any table by insa, insa_buha;

truncate table aud$;

audit create table by insa;
select * from dba_stmt_audit_opts where audit_option = 'CREATE TABLE';

select username, owner, obj_name, action_name, decode(returncode, 0, 'success', returncode) sess, timestamp from dba_audit_object;

noaudit create table by insa;

truncate table aud$;
select * from aud$;

select * from v$parameter where name = 'audit_trail';

-- 10g
alter system set audit_trail = db_extended scope = spfile;

-- 11g
alter system set audit_trail = db, extended scope = spfile;

audit table;

select * from dba_stmt_audit_opts where audit_option = 'TABLE';
select username, owner, obj_name, action_name, decode(returncode, 0, 'success', returncode) sess, timestamp, sql_text from dba_audit_object;

noaudit table;
truncate table aud$;

alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
audit select, insert, update, delete on hr.emp;
select * from dba_obj_audit_opts where owner = 'HR';
select username, owner, obj_name, action_name, decode(returncode, 0, 'success', returncode) sess, timestamp, sql_text, sql_bind from dba_audit_object;
