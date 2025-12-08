-- 세션이 가진 롤
select * from session_roles;
-- 유저가 가진 롤
select * from user_role_privs;
-- 롤이 가진 시스템 권한
select * from role_sys_privs;
-- 유저가 가진 시스템 권한
select * from user_sys_privs;
-- 세션이 가진 시스템 권한
select * from session_privs;
-- 롤이 가진 객체 권한
select * from role_tab_privs;
-- 유저가 가진 객체 권한
select * from user_tab_privs;

select * from hr.departments;
select * from hr.employees;
select * from hr.locations;

create or replace view emp_view
as
select * from hr.employees;
-- ORA-01031: 권한이 불충분합니다

create or replace view dept_view
as
select * from hr.departments;
-- ORA-01031: 권한이 불충분합니다

select * from user_tab_privs;

create or replace view emp_view
as
select * from hr.employees;

create or replace view dept_view
as
select * from hr.departments;

select * from session_privs;
select * from user_tab_privs;
select * from role_tab_privs;

create or replace view dept_view
as
select * from hr.departments;

-- 객체 정보 조회
select * from user_objects where object_name in ('EMP_VIEW', 'DEPT_VIEW');

-- 뷰 정보 조회
select * from user_views where view_name in ('EMP_VIEW', 'DEPT_VIEW');

select * from emp_view;
select * from dept_view;

drop view emp_view;
drop view dept_view;

select * from session_privs;
select * from user_tab_privs;
select * from role_tab_privs;

create or replace procedure dept_proc(p_id number)
is
    v_rec hr.departments%rowtype;
begin
    select * 
    into v_rec
    from hr.departments 
    where department_id = p_id;
    
    dbms_output.put_line(p_id || ' ' || v_rec.department_name);
exception
    when no_data_found then
        raise_application_error(-20000, '부서는 존재하지 않습니다.');
end dept_proc;
/

show error

select * from user_tab_privs;

exec dept_proc(300)

select * from user_objects where object_name = 'DEPT_PROC';