-- shared pool 크기 조회
select * from v$parameter where name = 'shared_pool_size';
select sum(bytes)/1024/1024 mb from v$sgastat where pool = 'shared pool';
select * from v$sga_dynamic_components;

-- cache size 조회
select * from v$parameter where name like '%cache_size%';
select * from dba_data_files;

-- log_buffer
select * from v$parameter where name = 'log_buffer';

-- large_pool_size
select * from v$parameter where name = 'large_pool_size';

-- java_pool_size
select * from v$parameter where name = 'java_pool_size';

-- streams_pool_size
select * from v$parameter where name = 'streams_pool_size';

select * from v$parameter where name = 'db_writer_processes';

-- 로그 정보
-- 컨트롤 파일이 가지고 있음
-- status가 CURRENT 인 그룹에 해당하는 파일에 로그 작성
select * from v$log;
select * from v$logfile;