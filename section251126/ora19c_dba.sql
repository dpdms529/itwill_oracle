-- 인스턴스 정보
select * from v$instance;

-- 데이터베이스 정보
select * from v$database;

-- 데이터 파일 정보
select * from v$datafile;
select * from dba_data_files;

-- 임시 파일 정보
select * from v$tempfile;
select * from dba_temp_files;

-- 로그 정보
select * from v$log;
select * from v$logfile;

-- 세션 정보
select * from v$session;
select * from v$session where username = 'HR';

-- 초기 파라미터 정보
select * from v$parameter;

-- 파라미터 값 변경
alter system set 파라미터 = 값 scope = ;
alter session set 파라미터 = 값;

select * from v$parameter where name = 'nls_date_format';
-- 세션 레벨에서 파라미터 값을 변경할 수 있는 파라미터
select * from v$parameter where isses_modifiable = 'TRUE';
-- 시스템 레벨에서만 변경 가능한 파라미터
select * from v$parameter where isses_modifiable = 'FALSE';
-- static parameter
select * from v$parameter where issys_modifiable = 'FALSE';
-- dynamic parameter
select * from v$parameter where issys_modifiable in ('IMMEDIATE', 'DEFERRED');

select * from v$parameter where name = 'processes';

show parameter processes;

select name, value, issys_modifiable from v$parameter where name = 'processes';

alter system set processes = 150;

select * from v$parameter where name = 'open_cursors';

select name, value, default_value, issys_modifiable from v$parameter where name = 'open_cursors';

-- scope 모두 가능
alter system set open_cursors = 100 scope = spfile;
alter system set open_cursors = 100 scope = memory;
alter system set open_cursors = 100 scope = both;

-- deferred 
select * from v$parameter where issys_modifiable = 'DEFERRED';

alter session set sort_area_size = 1048576;
alter system set sort_area_size = 1048576;

select name, value, default_value, issys_modifiable from v$parameter where name = 'open_cursors';

select name, value, default_value, issys_modifiable from v$parameter where issys_modifiable = 'FALSE'
order by name;

alter system set open_cursors = 300 scope = memory;

show parameter open_cursors;

show parameter spfile;