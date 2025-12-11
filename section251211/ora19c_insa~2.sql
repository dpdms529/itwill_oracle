select * from hr.emp where id = 150;

update hr.emp
set sal = sal * 1.1;

delete from hr.emp where id = 200;
select * from hr.emp;

commit;

select * from hr.emp;