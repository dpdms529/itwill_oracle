select * from user_sys_privs;
select * from session_roles;
select * from role_sys_privs;
select * from role_tab_privs;

select * from tab;

create table dept(id number, name varchar2(30));

drop table dept purge;

select * from hr.emp;
insert into hr.emp(id, name, sal) values (300, 'oracle', 1000);
commit;
update hr.emp set sal = sal * 1.1 where id = 200;
delete from hr.emp where id = 300;
commit;

select * from user_sys_privs;
select * from hr.employees;
select * from hr.departments;
select * from hr.jobs;
select * from hr.job_history;

drop table test;
create table test(id number);

create table test1(id number);

select * from hr.emp where id = 100;

select * from hr.emp where id = :b_id;