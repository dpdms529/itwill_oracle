show user

select * from session_roles;
select * from user_role_privs;
select * from user_sys_privs;
select * from user_tab_privs;
select * from role_sys_privs;
select * from role_tab_privs;
select * from session_privs;

select * from hr.locations;
select * from hr.employees;
select * from hr.departments;

create or replace function today
return varchar2
is
begin
    return to_char(sysdate, 'yyy-mm-dd hh24:mi:ss');
end today;
/

select today from dual;

select * from tab;
select * from emp;

-- Definer¡¯s right
select * from user_tab_privs;
desc hr.insert_emp1

exec hr.insert_emp1(2, 'oracle', 3000)
select * from emp;

select * from hr.emp;

-- Invoker¡¯s right
select * from user_tab_privs;
exec hr.insert_emp2(3, 'SQL', 5000)

select * from emp;

select * from user_ts_quotas;

select * from user_tab_privs;