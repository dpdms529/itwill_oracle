select name, value, default_value, issys_modifiable from v$parameter;

select name, value, default_value, issys_modifiable from v$parameter where name = 'sort_area_size';

select * from v$sgastat where pool = 'shared pool';
select count(*) from v$sgastat where pool = 'shared pool';

select * from dba_data_files;
select * from dba_segments;

-- 딕셔너리 테이블
select * from dba_segments where tablespace_name = 'SYSTEM';

-- 유저 정보 딕셔너리 테이블 뷰
select * from dba_users;
-- 실제 유저 딕셔너리 테이블
select * from user$;

-- 객체 정보 딕셔너리 테이블 뷰
select * from dba_objects where owner = 'HR';
-- 객체 정보 딕셔너리 테이블
select * from obj$;

-- 테이블 정보 딕셔너리 테이블 뷰
select * from dba_tables where owner = 'HR';
-- 테이블 정보 딕셔너리 테이블
select * from tab$;
-- 컬럼 정보 딕셔너리 테이블 뷰
select * from dba_tab_columns where owner = 'HR';
-- 컬럼 정보 딕셔너리 테이블
select * from col$;