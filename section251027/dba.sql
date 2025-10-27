SELECT /*+ gather_plan_statistics */
    to_char(hire_date, 'yyyy') year, 
    sum(case to_char(hire_date, 'q') when '1' then salary end) "1분기",
    sum(case to_char(hire_date, 'q') when '2' then salary end) "2분기",
    sum(case to_char(hire_date, 'q') when '3' then salary end) "3분기",
    sum(case to_char(hire_date, 'q') when '4' then salary end) "4분기"
FROM hr.employees
GROUP BY to_char(hire_date, 'yyyy')
ORDER BY year;

---------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |      1 |        |      8 |00:00:00.01 |       6 |       |       |          |
|   1 |  SORT GROUP BY     |           |      1 |     98 |      8 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|   2 |   TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
---------------------------------------------------------------------------------------------------------------------
 

SELECT /*+ gather_plan_statistics */
    year, 
    max(case q when '1' then 총액 end) "1분기",
    max(case q when '2' then 총액 end) "2분기",
    max(case q when '3' then 총액 end) "3분기",
    max(case q when '4' then 총액 end) "4분기"
FROM (SELECT to_char(hire_date, 'yyyy') year, to_char(hire_date, 'q') q, sum(salary) 총액
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'), to_char(hire_date, 'q'))
GROUP BY year
ORDER BY 1;

-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |           |      1 |        |      8 |00:00:00.01 |       6 |       |       |          |
|   1 |  SORT GROUP BY       |           |      1 |     98 |      8 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|   2 |   VIEW               |           |      1 |     98 |     25 |00:00:00.01 |       6 |       |       |          |
|   3 |    HASH GROUP BY     |           |      1 |     98 |     25 |00:00:00.01 |       6 |   915K|   915K| 1326K (0)|
|   4 |     TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SELECT /*+ gather_plan_statistics */ e.employee_id, e.department_id, d.department_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+)
ORDER BY 2;

SELECT /*+ gather_plan_statistics */ employee_id, department_id, (SELECT department_name 
                                    FROM hr.departments 
                                    WHERE department_id = e.department_id)
FROM hr.employees e
ORDER BY 2;

-- 1) 일반적인 형식
SELECT /*+ gather_plan_statistics */ d.department_name, sum(salary), avg(salary)
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY 1;

----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |      1 |        |     11 |00:00:00.01 |       8 |       |       |          |
|   1 |  SORT GROUP BY                |             |      1 |     27 |     11 |00:00:00.01 |       8 |  2048 |  2048 | 2048  (0)|
|   2 |   MERGE JOIN                  |             |      1 |    106 |    106 |00:00:00.01 |       8 |       |       |          |
|   3 |    TABLE ACCESS BY INDEX ROWID| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       2 |       |       |          |
|   4 |     INDEX FULL SCAN           | DEPT_ID_PK  |      1 |     27 |     27 |00:00:00.01 |       1 |       |       |          |
|*  5 |    SORT JOIN                  |             |     27 |    107 |    106 |00:00:00.01 |       6 | 15360 | 15360 |14336  (0)|
|   6 |     TABLE ACCESS FULL         | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
 

-- 2) inline view 이용
SELECT /*+ gather_plan_statistics */ d.department_name, sum, avg
FROM hr.departments d, (SELECT e.department_id, sum(salary) sum, avg(salary) avg
                        FROM hr.employees e
                        GROUP BY e.department_id) e
WHERE d.department_id = e.department_id
ORDER BY 1;        

------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |     11 |00:00:00.01 |      12 |       |       |          |
|   1 |  SORT GROUP BY      |             |      1 |    106 |     11 |00:00:00.01 |      12 |  2048 |  2048 | 2048  (0)|
|*  2 |   HASH JOIN         |             |      1 |    106 |    106 |00:00:00.01 |      12 |  1306K|  1306K|  873K (0)|
|   3 |    TABLE ACCESS FULL| EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|   4 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
 
        
-- 3) scalar subquery
SELECT /*+ gather_plan_statistics */ department_name, substr(sum_avg, 1, 10) sum, substr(sum_avg, 11) avg
FROM (SELECT department_name, (SELECT lpad(sum(salary), 10)||lpad(round(avg(salary)), 10) FROM hr.employees WHERE department_id = d.department_id) sum_avg
        FROM hr.departments d)
WHERE sum_avg is not null;

------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                   |      1 |        |     11 |00:00:00.01 |      18 |
|   1 |  SORT AGGREGATE              |                   |     27 |      1 |     27 |00:00:00.01 |      12 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |     27 |     10 |    106 |00:00:00.01 |      12 |
|*  3 |    INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |       3 |
|*  4 |  VIEW                        |                   |      1 |     27 |     11 |00:00:00.01 |      18 |
|   5 |   TABLE ACCESS FULL          | DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |       6 |
------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DEPARTMENT_ID"=:B1)

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));


SELECT /*+ gather_plan_statistics */ employee_id, job_id, salary
FROM hr.employees
UNION
SELECT employee_id, job_id, NULL
FROM hr.job_history;

-----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |                   |      1 |        |    117 |00:00:00.01 |      12 |       |       |          |
|   1 |  SORT UNIQUE             |                   |      1 |    117 |    117 |00:00:00.01 |      12 |  9216 |  9216 | 8192  (0)|
|   2 |   UNION-ALL              |                   |      1 |        |    117 |00:00:00.01 |      12 |       |       |          |
|   3 |    TABLE ACCESS FULL     | EMPLOYEES         |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|   4 |    VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  5 |     HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1034K (0)|
|   6 |      INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|   7 |      INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access(ROWID=ROWID)

SELECT /*+ gather_plan_statistics */ employee_id, job_id, salary
FROM hr.employees
UNION ALL
SELECT employee_id, job_id, NULL
FROM hr.job_history;

----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation               | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |                   |      1 |        |    117 |00:00:00.01 |      14 |       |       |          |
|   1 |  UNION-ALL              |                   |      1 |        |    117 |00:00:00.01 |      14 |       |       |          |
|   2 |   TABLE ACCESS FULL     | EMPLOYEES         |      1 |    107 |    107 |00:00:00.01 |       8 |       |       |          |
|   3 |   VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  4 |    HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K|  987K (0)|
|   5 |     INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|   6 |     INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access(ROWID=ROWID)

-- intersect
SELECT /*+ gather_plan_statistics */ employee_id
FROM hr.employees
INTERSECT
SELECT employee_id
FROM hr.job_history;

---------------------------------------------------------------------------------------------------
| Id  | Operation           | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                   |      1 |        |      7 |00:00:00.01 |       2 |
|   1 |  INTERSECTION       |                   |      1 |        |      7 |00:00:00.01 |       2 |
|   2 |   SORT UNIQUE NOSORT|                   |      1 |    107 |    107 |00:00:00.01 |       1 |
|   3 |    INDEX FULL SCAN  | EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       1 |
|   4 |   SORT UNIQUE NOSORT|                   |      1 |     10 |      7 |00:00:00.01 |       1 |
|   5 |    INDEX FULL SCAN  | JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       1 |
---------------------------------------------------------------------------------------------------
 

-- minus
SELECT /*+ gather_plan_statistics */ employee_id
FROM hr.employees
MINUS
SELECT employee_id
FROM hr.job_history;

---------------------------------------------------------------------------------------------------
| Id  | Operation           | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                   |      1 |        |     50 |00:00:00.01 |       2 |
|   1 |  MINUS              |                   |      1 |        |     50 |00:00:00.01 |       2 |
|   2 |   SORT UNIQUE NOSORT|                   |      1 |    107 |     54 |00:00:00.01 |       1 |
|   3 |    INDEX FULL SCAN  | EMP_EMP_ID_PK     |      1 |    107 |     55 |00:00:00.01 |       1 |
|   4 |   SORT UNIQUE NOSORT|                   |      1 |     10 |      5 |00:00:00.01 |       1 |
|   5 |    INDEX FULL SCAN  | JHIST_EMPLOYEE_IX |      1 |     10 |      8 |00:00:00.01 |       1 |
---------------------------------------------------------------------------------------------------
 
 
 
SELECT /*+ gather_plan_statistics */employee_id, e.last_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id(+)
UNION
SELECT employee_id, e.last_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id(+) = d.department_id;



-----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |             |      1 |        |    123 |00:00:00.01 |      20 |       |       |          |
|   1 |  SORT UNIQUE                   |             |      1 |    213 |    123 |00:00:00.01 |      20 | 11264 | 11264 |10240  (0)|
|   2 |   UNION-ALL                    |             |      1 |        |    229 |00:00:00.01 |      20 |       |       |          |
|*  3 |    HASH JOIN OUTER             |             |      1 |    107 |    107 |00:00:00.01 |      12 |  1079K|  1079K|  901K (0)|
|   4 |     TABLE ACCESS FULL          | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|   5 |     TABLE ACCESS FULL          | DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   6 |    MERGE JOIN OUTER            |             |      1 |    106 |    122 |00:00:00.01 |       8 |       |       |          |
|   7 |     TABLE ACCESS BY INDEX ROWID| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       2 |       |       |          |
|   8 |      INDEX FULL SCAN           | DEPT_ID_PK  |      1 |     27 |     27 |00:00:00.01 |       1 |       |       |          |
|*  9 |     SORT JOIN                  |             |     27 |    107 |    106 |00:00:00.01 |       6 | 15360 | 15360 |14336  (0)|
|  10 |      TABLE ACCESS FULL         | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   9 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
 
 

SELECT /*+ gather_plan_statistics */employee_id, e.last_name, d.department_name
FROM hr.employees e FULL OUTER JOIN hr.departments d
ON e.department_id = d.department_id;

--------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |             |      1 |        |    123 |00:00:00.01 |      14 |       |       |          |
|   1 |  VIEW                 | VW_FOJ_0    |      1 |    122 |    123 |00:00:00.01 |      14 |       |       |          |
|*  2 |   HASH JOIN FULL OUTER|             |      1 |    122 |    123 |00:00:00.01 |      14 |  1079K|  1079K| 1222K (0)|
|   3 |    TABLE ACCESS FULL  | DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   4 |    TABLE ACCESS FULL  | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       8 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
 

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE exists (SELECT 'x'
                FROM hr.job_history
                WHERE employee_id = e.employee_id
                and job_id = e.job_id);
                
----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation               | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |                   |      1 |        |      2 |00:00:00.01 |      12 |       |       |          |
|*  1 |  HASH JOIN SEMI         |                   |      1 |     10 |      2 |00:00:00.01 |      12 |  1134K|  1134K| 1225K (0)|
|   2 |   VIEW                  | index$_join$_001  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  3 |    HASH JOIN            |                   |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1246K (0)|
|   4 |     INDEX FAST FULL SCAN| EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN| EMP_JOB_IX        |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   6 |   VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  7 |    HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1005K (0)|
|   8 |     INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|   9 |     INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPLOYEE_ID"="E"."EMPLOYEE_ID" AND "JOB_ID"="E"."JOB_ID")
   3 - access(ROWID=ROWID)
   7 - access(ROWID=ROWID)
   
SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE exists (SELECT /*+ no_unnest */ 'x'
                FROM hr.job_history
                WHERE employee_id = e.employee_id
                and job_id = e.job_id);   
                
--------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                  |      1 |        |      2 |00:00:00.01 |     177 |       |       |          |
|*  1 |  FILTER                      |                  |      1 |        |      2 |00:00:00.01 |     177 |       |       |          |
|   2 |   VIEW                       | index$_join$_001 |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  3 |    HASH JOIN                 |                  |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1401K (0)|
|   4 |     INDEX FAST FULL SCAN     | EMP_EMP_ID_PK    |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN     | EMP_JOB_IX       |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|*  6 |   TABLE ACCESS BY INDEX ROWID| JOB_HISTORY      |    107 |      1 |      2 |00:00:00.01 |     171 |       |       |          |
|*  7 |    INDEX RANGE SCAN          | JHIST_JOB_IX     |    107 |      1 |     85 |00:00:00.01 |     107 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter( IS NOT NULL)
   3 - access(ROWID=ROWID)
   6 - filter("EMPLOYEE_ID"=:B1)
   7 - access("JOB_ID"=:B1)
                 
                 
                
SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE (employee_id, job_id) in (SELECT employee_id, job_id
                                FROM hr.job_history
                                WHERE employee_id = e.employee_id
                                and job_id = e.job_id);  
                                
----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation               | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |                   |      1 |        |      2 |00:00:00.01 |      12 |       |       |          |
|*  1 |  HASH JOIN SEMI         |                   |      1 |     10 |      2 |00:00:00.01 |      12 |  1134K|  1134K| 1237K (0)|
|   2 |   VIEW                  | index$_join$_001  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  3 |    HASH JOIN            |                   |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1532K (0)|
|   4 |     INDEX FAST FULL SCAN| EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN| EMP_JOB_IX        |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   6 |   VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  7 |    HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1268K (0)|
|   8 |     INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|   9 |     INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPLOYEE_ID"="EMPLOYEE_ID" AND "JOB_ID"="JOB_ID")
   3 - access(ROWID=ROWID)
   7 - access(ROWID=ROWID)
   
SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE (employee_id, job_id) in (SELECT /*+ no_unnest */employee_id, job_id
                                FROM hr.job_history
                                WHERE employee_id = e.employee_id
                                and job_id = e.job_id);    
                                 
--------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                  |      1 |        |      2 |00:00:00.01 |     177 |       |       |          |
|*  1 |  FILTER                      |                  |      1 |        |      2 |00:00:00.01 |     177 |       |       |          |
|   2 |   VIEW                       | index$_join$_001 |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  3 |    HASH JOIN                 |                  |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1509K (0)|
|   4 |     INDEX FAST FULL SCAN     | EMP_EMP_ID_PK    |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN     | EMP_JOB_IX       |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|*  6 |   TABLE ACCESS BY INDEX ROWID| JOB_HISTORY      |    107 |      1 |      2 |00:00:00.01 |     171 |       |       |          |
|*  7 |    INDEX RANGE SCAN          | JHIST_JOB_IX     |    107 |      1 |     85 |00:00:00.01 |     107 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter( IS NOT NULL)
   3 - access(ROWID=ROWID)
   6 - filter("EMPLOYEE_ID"=:B1)
   7 - access("JOB_ID"=:B1)
   
SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE not exists (SELECT 'x'
                FROM hr.job_history
                WHERE employee_id = e.employee_id
                and job_id = e.job_id);
----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation               | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |                   |      1 |        |    105 |00:00:00.01 |      12 |       |       |          |
|*  1 |  HASH JOIN ANTI         |                   |      1 |     97 |    105 |00:00:00.01 |      12 |  1134K|  1134K| 1235K (0)|
|   2 |   VIEW                  | index$_join$_001  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  3 |    HASH JOIN            |                   |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1536K (0)|
|   4 |     INDEX FAST FULL SCAN| EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN| EMP_JOB_IX        |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   6 |   VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  7 |    HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1272K (0)|
|   8 |     INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|   9 |     INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPLOYEE_ID"="E"."EMPLOYEE_ID" AND "JOB_ID"="E"."JOB_ID")
   3 - access(ROWID=ROWID)
   7 - access(ROWID=ROWID)
                
SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE (employee_id, job_id) not in (SELECT /*+ no_unnest */ employee_id, job_id
                                    FROM hr.job_history
                                    WHERE employee_id = e.employee_id
                                    and job_id = e.job_id); 
                                    
--------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                  |      1 |        |    105 |00:00:00.01 |     179 |       |       |          |
|*  1 |  FILTER                      |                  |      1 |        |    105 |00:00:00.01 |     179 |       |       |          |
|   2 |   VIEW                       | index$_join$_001 |      1 |    107 |    107 |00:00:00.01 |       8 |       |       |          |
|*  3 |    HASH JOIN                 |                  |      1 |        |    107 |00:00:00.01 |       8 |  1096K|  1096K| 1461K (0)|
|   4 |     INDEX FAST FULL SCAN     | EMP_EMP_ID_PK    |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN     | EMP_JOB_IX       |      1 |    107 |    107 |00:00:00.01 |       5 |       |       |          |
|*  6 |   TABLE ACCESS BY INDEX ROWID| JOB_HISTORY      |    107 |      1 |      2 |00:00:00.01 |     171 |       |       |          |
|*  7 |    INDEX RANGE SCAN          | JHIST_JOB_IX     |    107 |      1 |     85 |00:00:00.01 |     107 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter( IS NULL)
   3 - access(ROWID=ROWID)
   6 - filter("EMPLOYEE_ID"=:B1)
   7 - access("JOB_ID"=:B1)                                    
                                    
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));                                    
                                    
   
SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees 
UNION ALL
SELECT employee_id, job_id
FROM hr.job_history j
WHERE not exists (SELECT 'x'
                    FROM hr.employees
                    WHERE employee_id = j.employee_id
                    and job_id = j.job_id);
                    
-----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |                   |      1 |        |    115 |00:00:00.01 |      20 |       |       |          |
|   1 |  UNION-ALL               |                   |      1 |        |    115 |00:00:00.01 |      20 |       |       |          |
|   2 |   VIEW                   | index$_join$_001  |      1 |    107 |    107 |00:00:00.01 |       8 |       |       |          |
|*  3 |    HASH JOIN             |                   |      1 |        |    107 |00:00:00.01 |       8 |  1096K|  1096K| 1436K (0)|
|   4 |     INDEX FAST FULL SCAN | EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   5 |     INDEX FAST FULL SCAN | EMP_JOB_IX        |      1 |    107 |    107 |00:00:00.01 |       5 |       |       |          |
|*  6 |   HASH JOIN ANTI         |                   |      1 |      1 |      8 |00:00:00.01 |      12 |  1134K|  1134K|  987K (0)|
|   7 |    VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  8 |     HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1338K (0)|
|   9 |      INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|  10 |      INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|  11 |    VIEW                  | index$_join$_003  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|* 12 |     HASH JOIN            |                   |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1557K (0)|
|  13 |      INDEX FAST FULL SCAN| EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|  14 |      INDEX FAST FULL SCAN| EMP_JOB_IX        |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access(ROWID=ROWID)
   6 - access("EMPLOYEE_ID"="J"."EMPLOYEE_ID" AND "JOB_ID"="J"."JOB_ID")
   8 - access(ROWID=ROWID)
  12 - access(ROWID=ROWID)                    

SELECT /*+ gather_plan_statistics */ employee_id, job_id
FROM hr.employees e
WHERE not exists (SELECT 'x'
                    FROM hr.job_history j
                    WHERE employee_id = e.employee_id
                    and job_id = e.job_id)
UNION ALL
SELECT employee_id, job_id
FROM hr.job_history;   

-----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |                   |      1 |        |    115 |00:00:00.01 |      18 |       |       |          |
|   1 |  UNION-ALL               |                   |      1 |        |    115 |00:00:00.01 |      18 |       |       |          |
|*  2 |   HASH JOIN ANTI         |                   |      1 |     97 |    105 |00:00:00.01 |      12 |  1134K|  1134K| 1233K (0)|
|   3 |    VIEW                  | index$_join$_001  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  4 |     HASH JOIN            |                   |      1 |        |    107 |00:00:00.01 |       6 |  1096K|  1096K| 1525K (0)|
|   5 |      INDEX FAST FULL SCAN| EMP_EMP_ID_PK     |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   6 |      INDEX FAST FULL SCAN| EMP_JOB_IX        |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|   7 |    VIEW                  | index$_join$_002  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|*  8 |     HASH JOIN            |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1261K (0)|
|   9 |      INDEX FAST FULL SCAN| JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|  10 |      INDEX FAST FULL SCAN| JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|  11 |   VIEW                   | index$_join$_003  |      1 |     10 |     10 |00:00:00.01 |       6 |       |       |          |
|* 12 |    HASH JOIN             |                   |      1 |        |     10 |00:00:00.01 |       6 |  1096K|  1096K| 1195K (0)|
|  13 |     INDEX FAST FULL SCAN | JHIST_EMPLOYEE_IX |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
|  14 |     INDEX FAST FULL SCAN | JHIST_JOB_IX      |      1 |     10 |     10 |00:00:00.01 |       3 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPLOYEE_ID"="E"."EMPLOYEE_ID" AND "JOB_ID"="E"."JOB_ID")
   4 - access(ROWID=ROWID)
   8 - access(ROWID=ROWID)

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));