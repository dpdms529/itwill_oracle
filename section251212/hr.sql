select * from all_db_links;

select e.employee_id, e.department_id, d.department_name
from insa.emp@ora19c_insa e, hr.departments d
where e.department_id = d.department_id;

-- create database link 권한 있는지 확인
select * from user_sys_privs;

-- private database link 생성
create database link ora19c_insa
connect to insa identified by insa
using 'ora19c';

create database link ora19c_insa
connect to insa identified by insa
using '(DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.56.150)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ora19c)
    )
  )';

select * from user_db_links;

drop database link ora19c_insa;