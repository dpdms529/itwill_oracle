SELECT * FROM dba_tables WHERE table_name = 'EMP';
SELECT * FROM dba_segments WHERE segment_name = 'EMP';
SELECT * FROM dba_extents WHERE segment_name = 'EMP';

SELECT * FROM dba_tablespaces;
SELECT * FROM dba_data_files;
SELECT * FROM dba_temp_files;

-- comment
-- ���̺� �ּ� Ȯ��
SELECT * FROM dba_tab_comments WHERE table_name = 'EMPLOYEES' AND owner = 'HR';

-- �÷� �ּ� Ȯ��
SELECT * FROM dba_col_comments WHERE table_name = 'EMPLOYEES' AND owner = 'HR';