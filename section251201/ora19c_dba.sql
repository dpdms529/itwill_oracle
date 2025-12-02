show parameter fast_start_mttr_target

select * from v$parameter where name = 'fast_start_mttr_target';

alter system set fast_start_mttr_target = 600;

-- 체크포인트 정보를 alert_SID.log에 기록하는 파라미터
show parameter log_checkpoints_to_alert

select * from v$parameter where name = 'log_checkpoints_to_alert';

-- true인 경우에만 체크 포인트 정보를 기록 -> true로 설정하기
alter system set log_checkpoints_to_alert = true;

select checkpoint_change#, current_scn from v$database; -- 2467344
select name, checkpoint_change# from v$datafile; -- 2467344
select * from v$log;

-- control file 정보
select * from v$database;
select * from v$datafile;
select * from v$log;
select * from v$logfile;

select * from v$controlfile;
select issys_modifiable from v$parameter where name = 'control_files';