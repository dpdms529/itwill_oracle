1. tablespace 생성하세요.
  tablespace 이름 	: dw_tbs
  datafile 위치 및 이름 	: /home/oracle/userdata/dw_tbs01.dbf
  datafile 사이즈 	: 5m
  datafile 자동 확장 활성화
  extent 관리		: local uniform size 1m
  segment space management: auto
  
create tablespace dw_tbs
datafile '/home/oracle/userdata/dw_tbs01.dbf' size 5m autoextend on
extent management local uniform size 1m
segment space management auto;

select tablespace_name, initial_extent, next_extent, status, extent_management, allocation_type segment_space_management from dba_tablespaces;
select file_name, tablespace_name, bytes, autoextensible, online_status from dba_data_files;


2. dw_tbs 테이블 스페이스에 데이터 파일을 추가 해주세요.
  datafile 위치 및 이름 	: /home/oracle/userdata/dw_tbs02.dbf
  datafile 사이즈 	: 5m
  datafile 자동 확장 비활성화
  
alter tablespace dw_tbs add datafile '/home/oracle/userdata/dw_tbs02.dbf' size 5m autoextend off;



select file_name, tablespace_name, bytes, autoextensible, online_status from dba_data_files;

3. /home/oracle/userdata/dw_tbs02.dbf 데이터 파일을 자동 확장 기능으로 수정하세요.

alter database datafile '/home/oracle/userdata/dw_tbs02.dbf' autoextend on;

select file_name, tablespace_name, bytes, autoextensible, online_status from dba_data_files;

4. hr.employees 테이블을 hr.emp_dw 복제하세요. hr.emp_dw 테이블은 dw_tbs 테이블스페이스에 생성하세요.

create table hr.emp_dw
tablespace dw_tbs
as
select * from hr.employees;

select * from hr.emp_dw;
select * from dba_tables where owner='HR' and table_name='EMP_DW';
select * from dba_segments where owner = 'HR' and segment_name = 'EMP_DW';
select * from dba_extents where owner = 'HR' and segment_name = 'EMP_DW';

5. dw_tbs에 있는 데이터 파일을  
	/u01/app/oracle/oradata/ORA19C/ 디렉터리로  이관 작업하세요.
    
alter tablespace dw_tbs offline;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

mv -v '/home/oracle/userdata/dw_tbs01.dbf' '/u01/app/oracle/oradata/ORA19C/'
mv -v '/home/oracle/userdata/dw_tbs02.dbf' '/u01/app/oracle/oradata/ORA19C/'

alter tablespace dw_tbs rename datafile '/home/oracle/userdata/dw_tbs01.dbf' to '/u01/app/oracle/oradata/ORA19C/dw_tbs01.dbf';
alter tablespace dw_tbs rename datafile '/home/oracle/userdata/dw_tbs02.dbf' to '/u01/app/oracle/oradata/ORA19C/dw_tbs02.dbf';

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

alter tablespace dw_tbs online;

select file_name, tablespace_name, bytes, autoextensible, online_status from dba_data_files;

6. dw_tbs 테이블스페이스 삭제

drop tablespace dw_tbs including contents and datafiles;

select tablespace_name, initial_extent, next_extent, status, extent_management, allocation_type segment_space_management from dba_tablespaces;
select file_name, tablespace_name, bytes, autoextensible, online_status from dba_data_files;
select * from dba_data_files;

select * from dba_tables where owner = 'HR' and table_name = 'EMPLOYEES';
select owner, table_name, buffer_pool from dba_tables where owner = 'HR' and table_name = 'EMPLOYEES';

select * from v$sgastat where name = 'free memory';

alter system set db_4k_cache_size = 12m;

create tablespace oltp_tbs
datafile '/home/oracle/userdata/oltp_tbs01.dbf' size 5m autoextend on
blocksize 4k
extent management local uniform size 1m
segment space management auto;

select * from dba_tablespaces;

create table hr.emp_oltp
tablespace oltp_tbs
as select * from hr.employees;

select * from dba_tables where owner = 'HR' and table_name = 'EMP_OLTP';
select * from dba_segments where owner = 'HR' and segment_name = 'EMP_OLTP';
select * from dba_extents where owner = 'HR' and segment_name = 'EMP_OLTP';

select * from hr.emp_oltp where employee_id = 200;

drop tablespace oltp_tbs including contents and datafiles;

select tablespace_name, contents from dba_tablespaces;

select * from v$parameter where name like 'undo%';


-- 현재 접속 중인 세션
select * from v$session where username = 'HR';

-- 트랜잭션이 걸려있으면 xacts=1, 없으면 0
select n.usn, n.name, s.extents, s.rssize, s.xacts, s.status
from v$rollname n, v$rollstat s
where n.usn = s.usn;

-- 현재 트랜잭션을 수행 중인 세션
select s.username, t.xidusn, t.ubafil, t.ubablk, t.used_ublk
from v$session s, v$transaction t
where s.saddr = t.ses_addr;

select * from dba_data_files;

-- undo data file 추가
alter tablespace UNDOTBS1 add datafile '/u01/app/oracle/oradata/ORA19C/undotbs02.dbf' size 10m autoextend on;
select * from dba_data_files;

-- undo data file 삭제
alter tablespace UNDOTBS1 drop datafile '/u01/app/oracle/oradata/ORA19C/undotbs02.dbf';
select * from dba_data_files;

-- 새로운 undo tablespace 생성
create undo tablespace undo1
datafile '/u01/app/oracle/oradata/ORA19C/undo01.dbf' size 10m autoextend on;

select * from dba_tablespaces;

select * from v$parameter where name like 'undo%';
-- undo_tablespace에 지정된 테이블스페이스만 undo로 사용 가능

select n.usn, n.name, s.extents, s.rssize, s.xacts, s.status
from v$rollname n, v$rollstat s
where n.usn = s.usn;

select * from dba_rollback_segs;

alter system set undo_tablespace = undo1 scope = both;
select * from v$parameter where name like 'undo%';

-- undo segment 정보
select n.usn, n.name, s.extents, s.rssize, s.xacts, s.status
from v$rollname n, v$rollstat s
where n.usn = s.usn;

select * from dba_rollback_segs;

-- 현재 트랜잭션을 수행 중인 세션
select s.username, t.xidusn, t.ubafil, t.ubablk, t.used_ublk
from v$session s, v$transaction t
where s.saddr = t.ses_addr;

alter system set undo_tablespace = undotbs1 scope = both;

-- undo segment 정보
select n.usn, n.name, s.extents, s.rssize, s.xacts, s.status
from v$rollname n, v$rollstat s
where n.usn = s.usn;

select * from dba_rollback_segs;

-- 현재 트랜잭션을 수행 중인 세션
select s.username, t.xidusn, t.ubafil, t.ubablk, t.used_ublk
from v$session s, v$transaction t
where s.saddr = t.ses_addr;

select * from v$parameter where name like 'undo%';

select * from v$parameter where name = 'undo_retention';

alter system set undo_retention = 1800;

select tablespace_name, retention from dba_tablespaces;

-- guarantee
alter tablespace undotbs1 retention guarantee;

alter tablespace undotbs1 retention noguarantee;

select * from dba_rollback_segs;

select n.usn, n.name, s.extents, s.rssize, s.xacts, s.status
from v$rollname n, v$rollstat s
where n.usn = s.usn;

select * from dba_rollback_segs;

-- 현재 트랜잭션을 수행 중인 세션
select s.username, t.xidusn, t.ubafil, t.ubablk, t.used_ublk
from v$session s, v$transaction t
where s.saddr = t.ses_addr;

-- undo tablespace 삭제
drop tablespace undo1 including contents and datafiles;

create user ora1 identified by oracle;
grant create session, create table to ora1;

select * from dba_sys_privs where grantee='ORA1';

create table test(id number, name varchar2(30));

select * from database_properties;

select * from dba_users where username = 'ORA1';
select * from dba_data_files;

create tablespace oltp_tbs
datafile '/u01/app/oracle/oradata/ORA19C/oltp_tbs01.dbf' size 5m autoextend on
extent management local uniform size 1m
segment space management auto;

create temporary tablespace oltp_temp
tempfile '/u01/app/oracle/oradata/ORA19C/oltp_temp01.dbf' size 5m autoextend on
extent management local uniform size 1m
segment space management manual;

select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_temp_files;

select * from dba_users;

create user ora2
identified by oracle
default tablespace oltp_tbs
temporary tablespace oltp_temp
quota 1m on oltp_tbs;

select * from dba_users where username like 'ORA%' order by 1;

alter database default tablespace oltp_tbs;
alter database default temporary tablespace oltp_temp;

select * from database_properties;

create user ora4
identified by oracle;

select * from dba_users;

alter database default tablespace users;
alter database default temporary tablespace temp;

select * from dba_users where username = 'ORA2';

alter user ora2
default tablespace oltp_tbs
temporary tablespace oltp_temp;

select * from dba_users where username = 'ORA2';

-- database level default tablespace 삭제 불가
drop tablespace users including contents and datafiles;
drop tablespace temp including contents and datafiles;