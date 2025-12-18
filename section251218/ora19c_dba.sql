create table hr.seg_new(id number) tablespace users;
select * from dba_segments
where owner = 'HR'
and segment_name = 'SEG_NEW';

select * from dba_extents
where owner = 'HR'
and segment_name = 'SEG_NEW';

select * from dba_tables
where owner = 'HR' 
and table_name = 'SEG_NEW';

select * from dba_tab_columns
where owner = 'HR' 
and table_name = 'SEG_NEW';

insert into hr.seg_new(id) values(1);

select isses_modifiable, issys_modifiable from v$parameter where name = 'deferred_segment_creation';

rollback;

drop table hr.seg_new purge;

-- immediate
create table hr.seg_new(id number) segment creation immediate tablespace users;

select * from dba_segments
where owner = 'HR'
and segment_name = 'SEG_NEW';

select * from dba_extents
where owner = 'HR'
and segment_name = 'SEG_NEW';

drop table hr.seg_new purge;

-- deferred
create table hr.seg_new(id number) segment creation deferred tablespace users;

select * from dba_segments
where owner = 'HR'
and segment_name = 'SEG_NEW';

select * from dba_extents
where owner = 'HR'
and segment_name = 'SEG_NEW';

drop table hr.seg_new purge;

-- deferred_segment_creation = false
alter session set deferred_segment_creation = false;

create table hr.seg_new(id number)tablespace users;

select * from dba_segments
where owner = 'HR'
and segment_name = 'SEG_NEW';

drop table hr.seg_new purge;

-- deferred_segment_creation = true
alter session set deferred_segment_creation = true;

create table hr.seg_new(id number)tablespace users;

select * from dba_segments
where owner = 'HR'
and segment_name = 'SEG_NEW';