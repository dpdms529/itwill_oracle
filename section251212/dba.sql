select * from dba_users;

drop user insa cascade;

select name from v$database;

-- db link 조회
select * from dba_db_links;

-- db link 생성
create public database link ora19c_insa
connect to insa identified by insa
using 'ora19c';

-- db link를 통해 원격 DB의 테이블 조회
select * 
from insa.emp@ora19c_insa;

select e.employee_id, e.department_id, d.department_name
from insa.emp@ora19c_insa e, hr.departments d
where e.department_id = d.department_id;

select * from dba_db_links;

-- public db link 삭제
drop public database link ora19c_insa;

select * from dba_db_links;

select * from dba_sys_privs where grantee = 'HR';