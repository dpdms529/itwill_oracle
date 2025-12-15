select name from v$datafile;
select name from v$tempfile;
select * from dba_tablespaces;

drop tablespace insa_tbs including contents and datafiles;
drop tablespace insa_temp including contents and datafiles;

select name from v$controlfile;

select * from v$log;
select member from v$logfile;

select name, log_mode from v$database;
archive log list

-- 현재 데이터베이스의 checkpoint 발생한 시점 scn 정보
select checkpoint_change# from v$database;
select checkpoint_change#, current_scn from v$database; -- 2822872	2843479
select checkpoint_change#, current_scn from v$database; -- 2822872	2843485
select checkpoint_change#, scn_to_timestamp(checkpoint_change#) from v$database;

select name, checkpoint_change# from v$datafile;

select * from v$log;

select f.file_name
from dba_extents e, dba_data_files f
where e.file_id = f.file_id
and e.segment_name = 'EMP'
and e.owner = 'HR';

select * from v$database;
select name, creation_change#,checkpoint_change# from v$datafile;
/u01/app/oracle/oradata/ORA19C/system01.dbf	2845590
/u01/app/oracle/oradata/ORA19C/sysaux01.dbf	2845590
/u01/app/oracle/oradata/ORA19C/undotbs01.dbf	2845590
/u01/app/oracle/oradata/ORA19C/users01.dbf	2845590

SELECT
    file#,
    creation_change#,
    checkpoint_change#,
    resetlogs_change#
FROM v$datafile_header;

select l.group#, member, l.status, first_change#, next_change# from v$log l, v$logfile f where l.group# = f.group#;
3	/u01/app/oracle/oradata/ORA19C/redo03.log	CURRENT	2822872	18446744073709551615 <<- 2845590
2	/u01/app/oracle/oradata/ORA19C/redo02.log	INACTIVE	2797846	2822872
1	/u01/app/oracle/oradata/ORA19C/redo01.log	INACTIVE	2767903	2797846

select checkpoint_change#, scn_to_timestamp(checkpoint_change#) from v$database;
2845590	25/12/15 16:00:14.000000000

