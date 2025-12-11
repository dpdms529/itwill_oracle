drop table hr.emp purge;

create table hr.emp as select employee_id id, last_name name, salary sal, commission_pct comm, department_id dept_id
from hr.employees;

select * from hr.emp;

-- 80번 부서의 급여와 커미션 정보를 조회하는 쿼리를 감사하고자함
select * from hr.emp where dept_id = 80;

-- fga 생성
begin
	dbms_fga.add_policy(
		object_schema => 'hr',
		object_name => 'emp',
		policy_name => 'emp_fga',
		audit_condition => 'dept_id = 80',
		audit_column => 'sal, comm',
		audit_column_opts => dbms_fga.all_columns,
		statement_types => 'select, insert, update, delete',
		enable => true
	);
end;
/

select * from dba_audit_policies;
select * from fga_log$;
select * from dba_fga_audit_trail;

-- 객체 권한 부여
grant select, insert, update, delete on hr.emp to insa;

-- FGA 삭제
exec dbms_fga.drop_policy(
        object_schema => 'hr',
		object_name => 'emp',
		policy_name => 'emp_fga'
    );

select * from dba_audit_policies;
select * from fga_log$;
truncate table fga_log$;

create table hr.fga_emp_log(
    object_schema varchar2(30),
    object_name varchar2(30),
    policy_name varchar2(30),
    user_name varchar2(30),
    sql_text varchar2(4000),
    sql_bind varchar2(100),
    day timestamp
);

create or replace procedure hr.fga_trail_proc(
    object_schema in varchar2,
    object_name in varchar2,
    policy_name in varchar2)
is
    pragma autonomous_transaction;
begin
    insert into hr.fga_emp_log(object_schema, object_name, policy_name, user_name, sql_text, sql_bind, day)
    values(object_schema, object_name, policy_name, sys_context('userenv', 'session_user'), sys_context('userenv', 'current_sql'), sys_context('userenv', 'current_bind'), localtimestamp);
    commit;
end fga_trail_proc;
/

show error

select sys_context('userenv', 'session_user') from dual;

-- fga 생성
begin
	dbms_fga.add_policy(
		object_schema => 'hr',
		object_name => 'emp',
		policy_name => 'emp_fga',
		statement_types => 'select, insert, update, delete',
        handler_schema => 'hr',
        handler_module => 'fga_trail_proc',
		enable => true
	);
end;
/

select * from dba_audit_policies;
select * from fga_log$;
select * from dba_fga_audit_trail;

truncate table fga_log$;

-- 정책 비활성화
exec dbms_fga.disable_policy(object_schema => 'hr', object_name => 'emp', policy_name => 'emp_fga');
select * from dba_audit_policies;

-- 정책 활성화
exec dbms_fga.enable_policy(object_schema => 'hr', object_name => 'emp', policy_name => 'emp_fga');
select * from dba_audit_policies;

-- 정책 삭제
exec dbms_fga.drop_policy(object_schema => 'hr', object_name => 'emp', policy_name => 'emp_fga');
select * from dba_audit_policies;

-- AUD$, FGA_LOG$ 딕셔너리 테이블을 다른 테이블스페이스로 이관
select table_name, tablespace_name
from dba_tables
where table_name in ('AUD$', 'FGA_LOG$');

select * from dba_data_files;

create tablespace audit_aux
datafile '/u01/app/oracle/oradata/ORA19C/audit_aux01.dbf' size 10m autoextend on 
extent management local uniform size 1m
segment space management auto;

select * from dba_tablespaces;
select * from dba_data_files;

-- aud$ 딕셔너리 테이블을 audit_aux 테이블스페이스로 이관
begin
    dbms_audit_mgmt.set_audit_trail_location(
        audit_trail_type => dbms_audit_mgmt.audit_trail_aud_std,
        audit_trail_location_value => 'audit_aux'
    );
end;
/
select table_name, tablespace_name
from dba_tables
where table_name in('AUD$', 'FGA_LOG$');

-- fga_log$ 딕셔너리 테이블을 audit_aux 테이블스페이스로 이관
begin
    dbms_audit_mgmt.set_audit_trail_location(
        audit_trail_type => dbms_audit_mgmt.audit_trail_fga_std,
        audit_trail_location_value => 'audit_aux'
    );
end;
/

select table_name, tablespace_name
from dba_tables
where table_name in('AUD$', 'FGA_LOG$');

-- fga 생성
begin
	dbms_fga.add_policy(
		object_schema => 'hr',
		object_name => 'emp',
		policy_name => 'emp_fga',
		statement_types => 'select, insert, update, delete',
        handler_schema => 'hr',
        handler_module => 'fga_trail_proc',
		enable => true
	);
end;
/

select * from dba_audit_policies;

select * from fga_log$;
select * from dba_fga_audit_trail;

-- fga_log$ 딕셔너리 테이블을 system 테이블스페이스로 이관
begin
    dbms_audit_mgmt.set_audit_trail_location(
        audit_trail_type => dbms_audit_mgmt.audit_trail_fga_std,
        audit_trail_location_value => 'system'
    );
end;
/

select * from fga_log$;
select * from dba_fga_audit_trail;


-- aud$ 딕셔너리 테이블을 system 테이블스페이스로 이관
begin
    dbms_audit_mgmt.set_audit_trail_location(
        audit_trail_type => dbms_audit_mgmt.audit_trail_aud_std,
        audit_trail_location_value => 'system'
    );
end;
/

select table_name, tablespace_name
from dba_tables
where table_name in('AUD$', 'FGA_LOG$');

