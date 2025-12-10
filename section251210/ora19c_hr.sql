select * from tab;

create table hr.new_emp as select * from hr.employees;
select * from hr.new_emp;

alter table hr.new_emp modify last_name varchar2(50);

truncate table hr.new_emp;

drop table hr.new_emp purge;