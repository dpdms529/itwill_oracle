create table insa.emp as select * from hr.employees;

select * from dba_db_links;

create public database link xe_hr
connect to hr identified by hr
using 'XE';

select * from dba_db_links;

select e.employee_id, e.department_id, d.department_name
from insa.emp e, hr.departments@xe_hr d
where e.department_id = d.department_id;

drop public database link xe_hr;