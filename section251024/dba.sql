SELECT /*+ gather_plan_statistics*/ *
FROM hr.employees
WHERE salary > (SELECT min(salary)
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');               

------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |            |      1 |        |     50 |00:00:00.01 |       6 |
|*  1 |  TABLE ACCESS FULL            | EMPLOYEES  |      1 |     50 |     50 |00:00:00.01 |       6 |
|   2 |   SORT AGGREGATE              |            |      1 |      1 |      1 |00:00:00.01 |       2 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMPLOYEES  |      1 |      5 |      5 |00:00:00.01 |       2 |
|*  4 |     INDEX RANGE SCAN          | EMP_JOB_IX |      1 |      5 |      5 |00:00:00.01 |       1 |
------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("SALARY">)
   4 - access("JOB_ID"='IT_PROG')                    

SELECT /*+ gather_plan_statistics*/ *
FROM hr.employees
WHERE salary > any (SELECT salary
                    FROM hr.employees
                    WHERE job_id = 'IT_PROG');
                     
---------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |            |      1 |        |     50 |00:00:00.01 |       8 |       |       |          |
|   1 |  MERGE JOIN SEMI              |            |      1 |    105 |     50 |00:00:00.01 |       8 |       |       |          |
|   2 |   SORT JOIN                   |            |      1 |    107 |     50 |00:00:00.01 |       6 | 73728 | 73728 |          |
|   3 |    TABLE ACCESS FULL          | EMPLOYEES  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  4 |   SORT UNIQUE                 |            |     50 |      5 |     50 |00:00:00.01 |       2 | 73728 | 73728 |          |
|   5 |    TABLE ACCESS BY INDEX ROWID| EMPLOYEES  |      1 |      5 |      5 |00:00:00.01 |       2 |       |       |          |
|*  6 |     INDEX RANGE SCAN          | EMP_JOB_IX |      1 |      5 |      5 |00:00:00.01 |       1 |       |       |          |
---------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access(INTERNAL_FUNCTION("SALARY")>INTERNAL_FUNCTION("SALARY"))
       filter(INTERNAL_FUNCTION("SALARY")>INTERNAL_FUNCTION("SALARY"))
   6 - access("JOB_ID"='IT_PROG')
   
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));  

SELECT /*+ gather_plan_statistics */ *
FROM hr.employees e
WHERE salary > (SELECT avg(salary)
                FROM hr.employees
                WHERE department_id = e.department_id);
                
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |           |      1 |        |     38 |00:00:00.01 |      12 |       |       |          |
|*  1 |  HASH JOIN           |           |      1 |     17 |     38 |00:00:00.01 |      12 |  1114K|  1114K|  903K (0)|
|   2 |   VIEW               | VW_SQ_1   |      1 |     11 |     12 |00:00:00.01 |       6 |       |       |          |
|   3 |    HASH GROUP BY     |           |      1 |     11 |     12 |00:00:00.01 |       6 |   894K|   894K| 1721K (0)|
|   4 |     TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|   5 |   TABLE ACCESS FULL  | EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("ITEM_1"="E"."DEPARTMENT_ID")
       filter("SALARY">"AVG(SALARY)")       
       
SELECT /*+ gather_plan_statistics */ *
FROM hr.employees e, 
    (SELECT department_id, avg(salary) avg_salary
    FROM hr.employees
    GROUP BY department_id) a
WHERE e.salary > a.avg_salary
AND e.department_id = a.department_id;     

-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |           |      1 |        |     38 |00:00:00.01 |      12 |       |       |          |
|*  1 |  HASH JOIN           |           |      1 |     17 |     38 |00:00:00.01 |      12 |  1114K|  1114K|  879K (0)|
|   2 |   VIEW               |           |      1 |     11 |     12 |00:00:00.01 |       6 |       |       |          |
|   3 |    HASH GROUP BY     |           |      1 |     11 |     12 |00:00:00.01 |       6 |   894K|   894K| 1719K (0)|
|   4 |     TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|   5 |   TABLE ACCESS FULL  | EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPARTMENT_ID"="A"."DEPARTMENT_ID")
       filter("E"."SALARY">"A"."AVG_SALARY")
       
SELECT /*+ gather_plan_statistics */ *
FROM hr.employees e
WHERE exists (SELECT 'x'
                FROM hr.employees
                WHERE manager_id = e.employee_id);       
                
-----------------------------------------------------------------------------------------------
| Id  | Operation          | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                |      1 |        |     18 |00:00:00.01 |       9 |
|   1 |  NESTED LOOPS SEMI |                |      1 |     18 |     18 |00:00:00.01 |       9 |
|   2 |   TABLE ACCESS FULL| EMPLOYEES      |      1 |    107 |    107 |00:00:00.01 |       6 |
|*  3 |   INDEX RANGE SCAN | EMP_MANAGER_IX |    107 |     18 |     18 |00:00:00.01 |       3 |
-----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("MANAGER_ID"="E"."EMPLOYEE_ID")
 
                 
SELECT /*+ gather_plan_statistics */ *
FROM hr.employees e
WHERE not exists (SELECT 'x'
                FROM hr.employees
                WHERE manager_id = e.employee_id);    
                
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-----------------------------------------------------------------------------------------------
| Id  | Operation          | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                |      1 |        |     50 |00:00:00.01 |       7 |
|   1 |  NESTED LOOPS ANTI |                |      1 |     89 |     50 |00:00:00.01 |       7 |
|   2 |   TABLE ACCESS FULL| EMPLOYEES      |      1 |    107 |     66 |00:00:00.01 |       4 |
|*  3 |   INDEX RANGE SCAN | EMP_MANAGER_IX |     66 |     18 |     16 |00:00:00.01 |       3 |
-----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("MANAGER_ID"="E"."EMPLOYEE_ID")
   
   
   
SELECT /*+ gather_plan_statistics */ *
FROM hr.departments d
WHERE exists (SELECT 1
                FROM hr.employees
                WHERE department_id = d.department_id);      

--------------------------------------------------------------------------------------------------
| Id  | Operation          | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                   |      1 |        |     11 |00:00:00.01 |       9 |
|   1 |  NESTED LOOPS SEMI |                   |      1 |     10 |     11 |00:00:00.01 |       9 |
|   2 |   TABLE ACCESS FULL| DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |       6 |
|*  3 |   INDEX RANGE SCAN | EMP_DEPARTMENT_IX |     27 |     41 |     11 |00:00:00.01 |       3 |
--------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DEPARTMENT_ID"="D"."DEPARTMENT_ID")
                
                                            
SELECT /*+ gather_plan_statistics */ *
FROM hr.departments d
WHERE d.department_id in (SELECT department_id
                            FROM hr.employees);   

--------------------------------------------------------------------------------------------------
| Id  | Operation          | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                   |      1 |        |     11 |00:00:00.01 |       9 |
|   1 |  NESTED LOOPS SEMI |                   |      1 |     10 |     11 |00:00:00.01 |       9 |
|   2 |   TABLE ACCESS FULL| DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |       6 |
|*  3 |   INDEX RANGE SCAN | EMP_DEPARTMENT_IX |     27 |     41 |     11 |00:00:00.01 |       3 |
--------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("D"."DEPARTMENT_ID"="DEPARTMENT_ID")
                             
                            
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));       


SELECT /*+ gather_plan_statistics */
    count(case department_id when 10 then 1 end) "10",
    count(case department_id when 20 then 1 end) "20",
    count(case department_id when 30 then 1 end) "30",
    count(case department_id when 40 then 1 end) "40",
    count(case department_id when 50 then 1 end) "50",
    count(case department_id when 60 then 1 end) "60",
    count(case department_id when 70 then 1 end) "70",
    count(case department_id when 80 then 1 end) "80",
    count(case department_id when 90 then 1 end) "90",
    count(case department_id when 100 then 1 end) "100",
    count(case department_id when 110 then 1 end) "110",
    count(case when department_id is null then 1 end) "부서가 없는 사원"
FROM hr.employees;

------------------------------------------------------------------------------------------
| Id  | Operation          | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |      1 |        |      1 |00:00:00.01 |       6 |
|   1 |  SORT AGGREGATE    |           |      1 |      1 |      1 |00:00:00.01 |       6 |
|   2 |   TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |
------------------------------------------------------------------------------------------

SELECT /*+ gather_plan_statistics */
    count(decode(department_id, 10, 1)) "10",
    count(decode(department_id, 20, 1)) "20",
    count(decode(department_id, 30, 1)) "30",
    count(decode(department_id, 40, 1)) "40",
    count(decode(department_id, 50, 1)) "50",
    count(decode(department_id, 60, 1)) "60",
    count(decode(department_id, 70, 1)) "70",
    count(decode(department_id, 80, 1)) "80",
    count(decode(department_id, 90, 1)) "90",
    count(decode(department_id, 100, 1)) "100",
    count(decode(department_id, 110, 1)) "110",
    count(decode(department_id, null, 1)) "부서가 없는 사원"
FROM hr.employees;

------------------------------------------------------------------------------------------
| Id  | Operation          | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |      1 |        |      1 |00:00:00.01 |       6 |
|   1 |  SORT AGGREGATE    |           |      1 |      1 |      1 |00:00:00.01 |       6 |
|   2 |   TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |
------------------------------------------------------------------------------------------
 

SELECT /*+ gather_plan_statistics */
    min(decode(dept_id, 10, cnt)) "10", 
    min(decode(dept_id, 20, cnt)) "20", 
    min(decode(dept_id, 30, cnt)) "30", 
    min(decode(dept_id, 40, cnt)) "40", 
    min(decode(dept_id, 50, cnt)) "50", 
    min(decode(dept_id, 60, cnt)) "60",
    min(decode(dept_id, 70, cnt)) "70", 
    min(decode(dept_id, 80, cnt)) "80", 
    min(decode(dept_id, 90, cnt)) "90", 
    min(decode(dept_id, 100, cnt)) "100", 
    min(decode(dept_id, 110, cnt)) "110", 
    min(decode(dept_id, null, cnt)) "부서가 없는 사원"
FROM (SELECT department_id dept_id, count(*) cnt
        FROM hr.employees
        GROUP BY department_id);
        
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |           |      1 |        |      1 |00:00:00.01 |       6 |       |       |          |
|   1 |  SORT AGGREGATE      |           |      1 |      1 |      1 |00:00:00.01 |       6 |       |       |          |
|   2 |   VIEW               |           |      1 |     11 |     12 |00:00:00.01 |       6 |       |       |          |
|   3 |    HASH GROUP BY     |           |      1 |     11 |     12 |00:00:00.01 |       6 |  1115K|  1115K|  957K (0)|
|   4 |     TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------  

SELECT /*+ gather_plan_statistics */ *
FROM (SELECT department_id, salary
        FROM hr.employees)
PIVOT (sum(salary) FOR department_id IN (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, null "부서가 없는 사원"));

-------------------------------------------------------------------------------------------
| Id  | Operation           | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |           |      1 |        |      1 |00:00:00.01 |       6 |
|   1 |  VIEW               |           |      1 |      1 |      1 |00:00:00.01 |       6 |
|   2 |   SORT AGGREGATE    |           |      1 |      1 |      1 |00:00:00.01 |       6 |
|   3 |    TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |
-------------------------------------------------------------------------------------------

SELECT /*+ gather_plan_statistics */  * 
FROM (SELECT to_char(hire_date, 'yyyy') year
        FROM hr.employees)
PIVOT (count(*) FOR year in ('2001' "2001", '2002' "2002", '2003' "2003", '2004' "2004", '2005' "2005", '2006' "2006", '2007' "2007", '2008' "2008"));

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));  

-------------------------------------------------------------------------------------------
| Id  | Operation           | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |           |      1 |        |      1 |00:00:00.01 |       6 |
|   1 |  VIEW               |           |      1 |      1 |      1 |00:00:00.01 |       6 |
|   2 |   SORT AGGREGATE    |           |      1 |      1 |      1 |00:00:00.01 |       6 |
|   3 |    TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |
-------------------------------------------------------------------------------------------

SELECT /*+ gather_plan_statistics */  * 
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'))
PIVOT (max(cnt) FOR year in ('2001' "2001", '2002' "2002", '2003' "2003", '2004' "2004", '2005' "2005", '2006' "2006", '2007' "2007", '2008' "2008"));

------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |           |      1 |        |      1 |00:00:00.01 |       6 |       |       |          |
|   1 |  VIEW                 |           |      1 |      1 |      1 |00:00:00.01 |       6 |       |       |          |
|   2 |   SORT AGGREGATE      |           |      1 |      1 |      1 |00:00:00.01 |       6 |       |       |          |
|   3 |    VIEW               |           |      1 |     98 |      8 |00:00:00.01 |       6 |       |       |          |
|   4 |     HASH GROUP BY     |           |      1 |     98 |      8 |00:00:00.01 |       6 |  1096K|  1096K|  954K (0)|
|   5 |      TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

SELECT /*+ gather_plan_statistics */ 
    min(decode(year, '2001', cnt)) "2001",
    min(decode(year, '2002', cnt)) "2002",
    min(decode(year, '2003', cnt)) "2003",
    min(decode(year, '2004', cnt)) "2004",
    min(decode(year, '2005', cnt)) "2005",
    min(decode(year, '2006', cnt)) "2006",
    min(decode(year, '2007', cnt)) "2007",
    min(decode(year, '2008', cnt)) "2008"
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'));
        
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |           |      1 |        |      1 |00:00:00.01 |       6 |       |       |          |
|   1 |  SORT AGGREGATE      |           |      1 |      1 |      1 |00:00:00.01 |       6 |       |       |          |
|   2 |   VIEW               |           |      1 |     98 |      8 |00:00:00.01 |       6 |       |       |          |
|   3 |    HASH GROUP BY     |           |      1 |     98 |      8 |00:00:00.01 |       6 |  1096K|  1096K|  954K (0)|
|   4 |     TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------        
        
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));             
 