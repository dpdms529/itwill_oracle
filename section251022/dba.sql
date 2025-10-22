select department_id, count(*)
from hr.employees
group by department_id;

SELECT /*+ gather_plan_statistics*/ department_id, sum(salary)
FROM hr.employees
GROUP BY department_id
HAVING department_id in (10, 20);

----------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |           |      1 |        |      2 |00:00:00.01 |       6 |       |       |          |
|*  1 |  FILTER             |           |      1 |        |      2 |00:00:00.01 |       6 |       |       |          |
|   2 |   HASH GROUP BY     |           |      1 |      1 |     12 |00:00:00.01 |       6 |   941K|   941K| 1739K (0)|
|   3 |    TABLE ACCESS FULL| EMPLOYEES |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(("DEPARTMENT_ID"=10 OR "DEPARTMENT_ID"=20))


select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SELECT /*+ gather_plan_statistics */ department_id, sum(salary)
FROM hr.employees
WHERE department_id in (10, 20)
GROUP BY department_id;

-------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |      1 |        |      2 |00:00:00.01 |       3 |
|   1 |  SORT GROUP BY NOSORT         |                   |      1 |      2 |      2 |00:00:00.01 |       3 |
|   2 |   INLIST ITERATOR             |                   |      1 |        |      3 |00:00:00.01 |       3 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |      2 |      3 |      3 |00:00:00.01 |       3 |
|*  4 |     INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |      2 |      3 |      3 |00:00:00.01 |       2 |
-------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access(("DEPARTMENT_ID"=10 OR "DEPARTMENT_ID"=20))
   
   
SELECT /*+ gather_plan_statistics */ e.employee_id, l.city
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id;

-----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |                   |      1 |        |     50 |00:00:00.01 |      18 |       |       |          |
|*  1 |  HASH JOIN               |                   |      1 |    106 |     50 |00:00:00.01 |      18 |  1134K|  1134K| 1268K (0)|
|*  2 |   HASH JOIN              |                   |      1 |     27 |     27 |00:00:00.01 |      12 |  1156K|  1156K| 1129K (0)|
|   3 |    VIEW                  | index$_join$_003  |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|*  4 |     HASH JOIN            |                   |      1 |        |     23 |00:00:00.01 |       6 |  1023K|  1023K| 1156K (0)|
|   5 |      INDEX FAST FULL SCAN| LOC_CITY_IX       |      1 |     23 |     23 |00:00:00.01 |       3 |       |       |          |
|   6 |      INDEX FAST FULL SCAN| LOC_ID_PK         |      1 |     23 |     23 |00:00:00.01 |       3 |       |       |          |
|   7 |    VIEW                  | index$_join$_002  |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|*  8 |     HASH JOIN            |                   |      1 |        |     27 |00:00:00.01 |       6 |  1096K|  1096K| 1275K (0)|
|   9 |      INDEX FAST FULL SCAN| DEPT_ID_PK        |      1 |     27 |     27 |00:00:00.01 |       3 |       |       |          |
|  10 |      INDEX FAST FULL SCAN| DEPT_LOCATION_IX  |      1 |     27 |     27 |00:00:00.01 |       3 |       |       |          |
|  11 |   VIEW                   | index$_join$_001  |      1 |    107 |     50 |00:00:00.01 |       6 |       |       |          |
|* 12 |    HASH JOIN             |                   |      1 |        |     50 |00:00:00.01 |       6 |  1096K|  1096K| 1270K (0)|
|  13 |     INDEX FAST FULL SCAN | EMP_DEPARTMENT_IX |      1 |    107 |    106 |00:00:00.01 |       3 |       |       |          |
|  14 |     INDEX FAST FULL SCAN | EMP_EMP_ID_PK     |      1 |    107 |     50 |00:00:00.01 |       3 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
