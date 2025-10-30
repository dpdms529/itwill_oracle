SELECT /*+ gather_plan_statistics */ *
FROM hr.oltp_emp o
WHERE exists (SELECT 'x'
                FROM hr.dw_emp
                WHERE employee_id = o.employee_id); 
                
--------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |          |      1 |        |      2 |00:00:00.01 |      10 |       |       |          |
|*  1 |  HASH JOIN SEMI    |          |      1 |      2 |      2 |00:00:00.01 |      10 |  1000K|  1000K| 1283K (0)|
|   2 |   TABLE ACCESS FULL| OLTP_EMP |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   3 |   TABLE ACCESS FULL| DW_EMP   |      1 |      2 |      2 |00:00:00.01 |       7 |       |       |          |
--------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPLOYEE_ID"="O"."EMPLOYEE_ID")                
                
SELECT /*+ gather_plan_statistics */ o.*
FROM hr.oltp_emp o, hr.dw_emp d
WHERE o.employee_id = d.employee_id;

--------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |          |      1 |        |      2 |00:00:00.01 |      10 |       |       |          |
|*  1 |  HASH JOIN         |          |      1 |      2 |      2 |00:00:00.01 |      10 |  1452K|  1452K|  800K (0)|
|   2 |   TABLE ACCESS FULL| DW_EMP   |      1 |      2 |      2 |00:00:00.01 |       7 |       |       |          |
|   3 |   TABLE ACCESS FULL| OLTP_EMP |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
--------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("O"."EMPLOYEE_ID"="D"."EMPLOYEE_ID")

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SELECT * FROM dba_constraints WHERE owner = 'HR' AND table_name = 'EMPLOYEES';
SELECT * FROM dba_cons_columns WHERE owner = 'HR' AND table_name = 'EMPLOYEES';

SELECT * FROM dba_indexes WHERE owner = 'HR' AND table_name = 'EMP';
SELECT * FROM dba_ind_columns WHERE index_owner = 'HR' AND table_name = 'EMP';