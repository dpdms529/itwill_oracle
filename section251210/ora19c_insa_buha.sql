select * from user_tab_privs;

select * from hr.emp;
insert into hr.emp(id, name, sal) values (300, 'oracle', 1000);
update hr.emp set sal = sal * 1.1 where id = 200;
delete from hr.emp where id = 300;
commit;

select * from user_sys_privs;
select * from hr.employees;
select * from hr.departments;