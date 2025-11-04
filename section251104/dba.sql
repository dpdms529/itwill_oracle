SELECT *
FROM v$reserved_words
WHERE reserved = 'Y';

-- shared pool 메모리 비우기
ALTER SYSTEM FLUSH SHARED_POOL;

-- 
SELECT sql_id, sql_text, parse_calls, loads, executions, hash_value, plan_hash_value
FROM v$sql
WHERE sql_text like '%employees%'
AND sql_text not like '%v$sql%';

-- 실행 계획 조회
SELECT * FROM table(dbms_xplan.display_cursor('fsg55tcss0s6m'));
SELECT * FROM table(dbms_xplan.display_cursor('7s0rxjt3f50a9'));

---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |       |       |     1 (100)|          |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMPLOYEES     |     1 |    69 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | EMP_EMP_ID_PK |     1 |       |     0   (0)|          |
---------------------------------------------------------------------------------------------
