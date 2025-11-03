GRANT CREATE PUBLIC SYNONYM TO hr;

GRANT DROP PUBLIC SYNONYM TO hr;

SELECT * FROM dba_objects WHERE owner = 'HR' AND object_name = 'EMP';
SELECT * FROM dba_tables WHERE owner = 'HR' AND table_name = 'EMP';
SELECT * FROM dba_data_files WHERE tablespace_name = 'USERS';

SELECT * FROM dba_segments WHERE owner = 'HR' AND segment_name = 'EMP';
SELECT * FROM dba_extents WHERE owner = 'HR' AND segment_name = 'EMP';

-- rowid µðÄÚµù
SELECT rowid,
       dbms_rowid.rowid_object(rowid)   AS data_object_id,
       dbms_rowid.rowid_relative_fno(rowid) AS file_id,
       dbms_rowid.rowid_block_number(rowid) AS block_id,
       dbms_rowid.rowid_row_number(rowid)   AS slot_id
FROM hr.emp;