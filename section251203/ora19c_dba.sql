select * from dba_tablespaces;
select * from dba_data_files;

drop tablespace userdata including contents and datafiles;

select * from dba_tablespaces;
select * from dba_data_files;

create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m;

select * from dba_tablespaces;
select * from dba_data_files;

alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' resize 10m;

select * from dba_tablespaces;
select * from dba_data_files;

alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' autoextend on;
alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' autoextend off;

alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' resize 5m;

select * from dba_data_files;

-- 테이블스페이스에 데이터 파일 추가
alter tablespace insa_tab add datafile '/u01/app/oracle/oradata/ORA19C/insa_tab02.dbf' size 5m;

select * from dba_data_files;

alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' autoextend on;
alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab02.dbf' autoextend on;

select * from dba_data_files;

alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' autoextend off;
-- 자동 확장 기능 활성화 시 maxsize 값 제어 가능
alter database datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' autoextend on next 2m maxsize 10m;

select * from dba_data_files;

drop tablespace insa_tab including contents and datafiles;

select * from dba_tablespaces;
select * from dba_data_files;

-- Extent 크기 지정
create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local uniform size 1m;

select * from dba_tablespaces;
select * from dba_data_files;

-- 테이블 생성
create table hr.insa
tablespace insa_tab
as
select * from hr.employees;

select * from dba_segments where owner = 'HR' and segment_name = 'INSA';
select * from dba_extents where owner = 'HR' and segment_name = 'INSA';

insert into hr.insa
select * from hr.insa;

rollback;

-- Dictionary Managed Tablespace일 경우 참조되는 딕셔너리 테이블
select * from fet$;
select * from uet$;

drop tablespace insa_tab including contents and datafiles;

-- extent 크기 관리 기본
create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m;

select * from dba_tablespaces;

drop tablespace insa_tab including contents and datafiles;

-- extent 크기 관리 local autoallocate(기본값)
create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local autoallocate;

select * from dba_tablespaces;

drop tablespace insa_tab including contents and datafiles;

-- extent 크기 관리 local uniform
create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local uniform;

select * from dba_tablespaces;

drop tablespace insa_tab including contents and datafiles;

-- extent 크기 관리 local uniform size
create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local uniform size 1m;

select * from dba_tablespaces;

drop tablespace insa_tab including contents and datafiles;

-- segment 크기 관리
create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local
segment space management manual;

select tablespace_name, segment_space_management from dba_tablespaces;

drop tablespace insa_tab including contents and datafiles;

create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local
segment space management auto;

select tablespace_name, segment_space_management from dba_tablespaces;

-- 테이블 생성
create table hr.insa
tablespace insa_tab
as
select * from hr.employees;

select * from dba_tables where table_name = 'INSA';
select table_name, pct_used, freelists, freelist_groups from dba_tables where table_name = 'INSA';

select tablespace_name, segment_space_management from dba_tablespaces;

select * from dba_segments where owner = 'HR' and segment_name = 'INSA';
select * from dba_extents where owner = 'HR' and segment_name = 'INSA';

drop tablespace insa_tab including contents and datafiles;

create tablespace insa_tab
datafile '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m
extent management local;

select * from dba_tablespaces;
select * from dba_data_files;

create table hr.insa
tablespace insa_tab
as
select * from hr.employees;

select * from dba_tables where table_name = 'INSA';
select * from v$datafile;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

select * from v$database; -- 2600226

alter system checkpoint;

alter tablespace insa_tab read only;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

select count(*) from hr.insa;
select * from hr.insa where employee_id = 100;

update hr.insa set salary = salary * 1.1 where employee_id = 100;
delete from hr.insa where employee_id = 100;
insert into hr.insa select * from hr.employees;

create table hr.insa_dept
tablespace insa_tab
as select * from hr.departments;

desc hr.insa

alter table hr.insa modify last_name varchar2(30);

desc hr.insa

alter table hr.insa add dept_name varchar2(30);

desc hr.insa

alter table hr.insa drop column dept_name;

truncate table hr.insa;

drop table hr.insa;

alter tablespace insa_tab read write;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

create table hr.insa
tablespace insa_tab
as select * from hr.employees;

select count(*) from hr.insa;

-- offline으로 변경
alter tablespace insa_tab offline;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

-- online으로 변경
alter tablespace insa_tab online;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

drop tablespace insa_tab including contents and datafiles;

create tablespace insa_tab
datafile '/home/oracle/insa_tab01.dbf' size 5m autoextend on next 2m maxsize 10m;

create table hr.insa
tablespace insa_tab
as select * from hr.employees;

select count(*) from hr.insa;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

-- 데이터파일 이관 작업
/home/oracle/insa_tab01.dbf -> /u01/app/oracle/oradata/ORA19C/insa_tab01.dbf

-- 1. 테이블스페이스 offline
alter tablespace insa_tab offline normal;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

-- 2. 물리적으로 데이터 파일 이동
SYS@ora19c> ! mv -v /home/oracle/insa_tab01.dbf /u01/app/oracle/oradata/ORA19C/
‘/home/oracle/insa_tab01.dbf’ -> ‘/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf’

SYS@ora19c> ! ls /u01/app/oracle/oradata/ORA19C/insa_tab01.dbf
/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf

-- 3. 기존 파일을 새로운 파일 위치로 수정
alter tablespace insa_tab rename datafile '/home/oracle/insa_tab01.dbf' to '/u01/app/oracle/oradata/ORA19C/insa_tab01.dbf';

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

-- 4. 테이블스페이스 online 설정
alter tablespace insa_tab online;

select d.file_id, d.tablespace_name, d.file_name, v.checkpoint_change#, v.enabled, d.online_status
from v$datafile v, dba_data_files d
where v.file# = d.file_id;

-- 모든 데이터 파일 이관
select name from v$datafile;
select name from v$tempfile;