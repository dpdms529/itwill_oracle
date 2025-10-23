SELECT /*+ gather_plan_statistics */ e.last_name, e.job_id, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.department_id = 20;

------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                   |      1 |        |      2 |00:00:00.01 |       4 |
|   1 |  NESTED LOOPS                |                   |      1 |      2 |      2 |00:00:00.01 |       4 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  3 |    INDEX UNIQUE SCAN         | DEPT_ID_PK        |      1 |      1 |      1 |00:00:00.01 |       1 |
|   4 |   TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |      1 |      2 |      2 |00:00:00.01 |       2 |
|*  5 |    INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |      1 |      2 |      2 |00:00:00.01 |       1 |
------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("D"."DEPARTMENT_ID"=20)
   5 - access("E"."DEPARTMENT_ID"=20)

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SELECT /*+ gather_plan_statistics */ e.employee_id, e.salary, j.grade_level
FROM hr.employees e, hr.job_grades j
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;

------------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |            |      1 |        |     50 |00:00:00.01 |      13 |       |       |          |
|   1 |  MERGE JOIN          |            |      1 |      2 |     50 |00:00:00.01 |      13 |       |       |          |
|   2 |   SORT JOIN          |            |      1 |      6 |      2 |00:00:00.01 |       7 | 73728 | 73728 |          |
|*  3 |    TABLE ACCESS FULL | JOB_GRADES |      1 |      6 |      6 |00:00:00.01 |       7 |       |       |          |
|*  4 |   FILTER             |            |      2 |        |     50 |00:00:00.01 |       6 |       |       |          |
|*  5 |    SORT JOIN         |            |      2 |    107 |    133 |00:00:00.01 |       6 | 73728 | 73728 |          |
|   6 |     TABLE ACCESS FULL| EMPLOYEES  |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter("J"."HIGHEST_SAL">0)
   4 - filter("E"."SALARY"<="J"."HIGHEST_SAL")
   5 - access("E"."SALARY">="J"."LOWEST_SAL")
       filter("E"."SALARY">="J"."LOWEST_SAL")

SELECT /*+ gather_plan_statistics */ d.department_name 부서이름, sum(e.salary) 급여총액, avg(e.salary) 급여평균
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.hire_date between to_date('20060101','yyyymmdd') and to_date('20070101', 'yyyymmdd') - 1/24/60/60
GROUP BY d.department_name;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SELECT /*+ gather_plan_statistics */ department_id, avg(salary)
FROM hr.employees
GROUP BY department_id
HAVING avg(salary) = (SELECT min(avg(salary))
                        FROM hr.employees
                        GROUP BY department_id);
                        
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |           |      1 |        |      1 |00:00:00.01 |      12 |       |       |          |
|*  1 |  FILTER              |           |      1 |        |      1 |00:00:00.01 |      12 |       |       |          |
|   2 |   HASH GROUP BY      |           |      1 |      1 |     12 |00:00:00.01 |       6 |   894K|   894K| 1718K (0)|
|   3 |    TABLE ACCESS FULL | EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|   4 |   SORT AGGREGATE     |           |      1 |      1 |      1 |00:00:00.01 |       6 |       |       |          |
|   5 |    SORT GROUP BY     |           |      1 |      1 |     12 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|   6 |     TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(SUM("SALARY")/COUNT("SALARY")=)

