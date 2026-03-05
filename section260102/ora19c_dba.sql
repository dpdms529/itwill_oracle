alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
select * from dba_objects where owner = 'HR' and object_name='JOB_HISTORY';

select * from dba_datapump_jobs;

select * from dba_db_links;

create public database link xe_link connect to system identified by oracle using 'xe';

select * from hr.employees@xe_link;

drop user jan cascade;

create user jan
identified by jan
default tablespace sysaux
temporary tablespace temp
quota unlimited on sysaux;

grant create session to jan;

select * from dba_tables
where owner= 'JAN';

select * from dba_tables;

select * from dba_users where username='YEEUN';
drop user yeeun cascade;

select * from dba_ts_quotas
where username='YEEUN';

create table yeeun.emp as select * from hr.employees where 1 = 2;

create user yeeun identified by yeeun quota unlimited on users;
select * from dba_segments where owner = 'YEEUN';