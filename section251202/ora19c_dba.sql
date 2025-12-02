select * from v$log;

-- 로그 정보 조회
select a.group#, a.sequence#, b.member, a.bytes/1024/1024 mb, a.status, a.first_change#, a.next_change#
from v$log a, v$logfile b 
where a.group# = b.group#;

-- 로그 그룹 추가
alter database add logfile group 4 '/u01/app/oracle/oradata/ORA19C/redo04.log' size 200m;
alter database add logfile group 5 '/u01/app/oracle/oradata/ORA19C/redo05.log' size 200m;

-- 로그 그룹 멤버 추가
alter database add logfile member 
	'/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo01.log' to group 1,
	'/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo02.log' to group 2,
	'/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo03.log' to group 3,
	'/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo04.log' to group 4,
	'/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo05.log' to group 5;
    
-- Redo Log Group 및 Member 추가
alter database add logfile group 6 (
    '/u01/app/oracle/oradata/ORA19C/redo06.log', 
    '/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo06.log') size 100m;
    
-- Redo Log Group 삭제
alter database drop logfile group 6;

-- Redo Log Group Member 삭제
alter database drop logfile member '/u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo01.log';

-- 로그 정보 조회
select a.group#, a.sequence#, b.member, a.bytes/1024/1024 mb, a.status, a.first_change#, a.next_change#
from v$log a, v$logfile b 
where a.group# = b.group#
order by 1;

alter database drop logfile member '/u01/app/oracle/oradata/ORA19C/redo01.log';

alter database drop logfile group 1;

alter database add logfile group 1 '/u01/app/oracle/oradata/ORA19C/redo01.log' size 50m;

alter database drop logfile group 2;

rm /u01/app/oracle/oradata/ORA19C/redo02.log /u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo02.log

alter database add logfile group 2 '/u01/app/oracle/oradata/ORA19C/redo02.log' size 50m;

alter database drop logfile group 3;

rm /u01/app/oracle/oradata/ORA19C/redo03.log /u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo03.log

alter database add logfile group 3 '/u01/app/oracle/oradata/ORA19C/redo03.log' size 50m;

alter database drop logfile group 4;

rm /u01/app/oracle/oradata/ORA19C/redo04.log /u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo04.log

-- 로그 정보 조회
select a.group#, a.sequence#, b.member, a.members, a.bytes/1024/1024 mb, a.status, a.first_change#, a.next_change#
from v$log a, v$logfile b 
where a.group# = b.group#
order by 1;

alter system switch logfile;
alter system checkpoint;
alter database drop logfile group 5;

rm /u01/app/oracle/fast_recovery_area/ORA19C/onlinelog/redo05.log /u01/app/oracle/oradata/ORA19C/redo05.log

-- 기본 블록 크기 조회
select * from v$parameter where name = 'db_block_size';

-- 테이블스페이스 조회
select * from dba_tablespaces;
select * from dba_data_files;

-- 테이블스페이스 생성
create tablespace userdata
datafile '/u01/app/oracle/oradata/ORA19C/userdata01.dbf' size 10m;

select tablespace_name, extent_management, segment_space_management from dba_tablespaces;

-- emp 테이블 삭제
drop table hr.emp purge;

-- emp 테이블 생성
create table hr.emp
tablespace userdata
as select * from hr.employees;

insert into hr.emp select * from hr.emp;
rollback;

truncate table hr.emp;

select count(*) from hr.emp;

select * from dba_tablespaces where tablespace_name = 'USERDATA';
select * from dba_segments where owner = 'HR' and segment_name = 'EMP';
select * from dba_extents where owner = 'HR' and segment_name = 'EMP';

select bytes/1024/1024 mb from dba_segments where owner = 'HR' and segment_name = 'EMP';

-- 테이블스페이스 삭제
drop tablespace userdata including contents and datafiles;

-- 테이블스페이스 생성
create tablespace userdata
datafile '/u01/app/oracle/oradata/ORA19C/userdata01.dbf' size 5m autoextend on;

select * from dba_data_files where tablespace_name = 'USERDATA';
select * from dba_tablespaces where tablespace_name = 'USERDATA';
select * from dba_segments where owner = 'HR' and segment_name = 'EMP';
select * from dba_extents where owner = 'HR' and segment_name = 'EMP';

-- emp 테이블 생성
create table hr.emp
tablespace userdata
as select * from hr.employees;

insert into hr.emp select * from hr.emp;
rollback;

truncate table hr.emp;

select count(*) from hr.emp;