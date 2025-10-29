show user;

SELECT * FROM dba_sys_privs WHERE grantee = 'INSA';
SELECT * FROM dba_ts_quotas WHERE username = 'INSA';

ALTER USER insa QUOTA 10M ON users;
SELECT * FROM dba_ts_quotas WHERE username = 'INSA';

ALTER USER insa QUOTA unlimited ON users;
SELECT * FROM dba_ts_quotas WHERE username = 'INSA';

REVOKE create session FROM insa;
GRANT create session TO insa;

GRANT SELECT ON hr.employees TO insa;
SELECT * FROM dba_tab_privs WHERE grantee = 'INSA';

REVOKE SELECT ON hr.employees FROM insa;
SELECT * FROM dba_tab_privs WHERE grantee = 'INSA';

SELECT /*+ gather_plan_statistics */ *
FROM hr.emp
WHERE id IN (SELECT employee_id
                FROM hr.employees
                WHERE hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
                AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd'));
                
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |      1 |        |      6 |00:00:00.01 |      13 |       |       |          |
|*  1 |  HASH JOIN         |           |      1 |     16 |      6 |00:00:00.01 |      13 |  1517K|  1517K| 1028K (0)|
|*  2 |   TABLE ACCESS FULL| EMPLOYEES |      1 |     16 |      6 |00:00:00.01 |       6 |       |       |          |
|   3 |   TABLE ACCESS FULL| EMP       |      1 |    107 |    107 |00:00:00.01 |       7 |       |       |          |
---------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("ID"="EMPLOYEE_ID")
   2 - filter(("HIRE_DATE"<TO_DATE(' 2004-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND 
              "HIRE_DATE">=TO_DATE(' 2003-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss')))                
                
SELECT /*+ gather_plan_statistics */ *
FROM hr.emp e
WHERE exists(SELECT 'x'
                FROM hr.employees
                WHERE employee_id = e.id
                AND hire_date >= to_date('2003-01-01', 'yyyy-mm-dd')
                AND hire_date < to_date('2004-01-01', 'yyyy-mm-dd'));
                
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |      1 |        |      6 |00:00:00.01 |      13 |       |       |          |
|*  1 |  HASH JOIN SEMI    |           |      1 |     16 |      6 |00:00:00.01 |      13 |   972K|   972K| 1253K (0)|
|   2 |   TABLE ACCESS FULL| EMP       |      1 |    107 |    107 |00:00:00.01 |       7 |       |       |          |
|*  3 |   TABLE ACCESS FULL| EMPLOYEES |      1 |     16 |      6 |00:00:00.01 |       6 |       |       |          |
---------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPLOYEE_ID"="E"."ID")
   3 - filter(("HIRE_DATE"<TO_DATE(' 2004-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND 
              "HIRE_DATE">=TO_DATE(' 2003-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss')))                
                
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));                