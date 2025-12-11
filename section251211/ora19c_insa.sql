select * from user_tab_privs;

-- 감사 X
select name from hr.emp where dept_id = 80;
select sal from hr.emp where dept_id = 80;
select comm from hr.emp where dept_id = 80;

-- 감사
select * from hr.emp;
select * from hr.emp where dept_id = 80;
select * from hr.emp where id = 145;
select sal, comm from hr.emp where dept_id = 80;
select sal from hr.emp where dept_id = 80 and comm = 0.3;
select * from hr.emp where dept_id = 50;

-- 바인드 변수 값에 따라 감사
select * from hr.emp where dept_id = :b_dept_id;
select * from hr.emp where id = :b_id;

-- 감사
insert into hr.emp(id, name, sal, comm, dept_id) values(300, 'zoey', 1000, 0.1, 80);
-- 감사 X
insert into hr.emp(id, name, sal, comm, dept_id) values(400, 'lucy', 1000, 0.1, 20);
commit;

-- 바인드 변수 값에 따라 감사
insert into hr.emp(id, name, sal, comm, dept_id) values(:b_id, :b_name, :b_sal, :b_comm, :b_dept_id);
commit;

desc hr.emp

-- 감사 X
insert into hr.emp(id, name, dept_id) values(:b_id, :b_name, :b_dept_id);
commit;

update hr.emp
set sal = sal * 1.1
where id = 145;

rollback;

update hr.emp
set sal = sal * 1.1, comm = 0.2
where id = 145;

rollback;

delete from hr.emp where id = 145;
delete from hr.emp where id = 100;
rollback;