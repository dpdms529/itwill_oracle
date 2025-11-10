-- 복습
SELECT e.last_name, e.hire_date, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.employee_id = 100;

-- PLS-00428: an INTO clause is expected in this SELECT statement
BEGIN
    SELECT e.last_name, e.hire_date, d.department_name
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id
    AND e.employee_id = 100;
END;
/

-- scalar data type
DECLARE
    /* Scalar Data Type */
    v_last_name hr.employees.last_name%type;
    v_hire_date hr.employees.hire_date%type;
    v_department_name hr.departments.department_name%type;
BEGIN
    SELECT e.last_name, e.hire_date, d.department_name
    INTO v_last_name, v_hire_date, v_department_name
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id
    AND e.employee_id = 100;
    
    dbms_output.put_line(v_last_name || ' ' || v_hire_date || ' ' || v_department_name);
END;
/

-- record
DECLARE
    /* Record Type */
    TYPE rec_type IS RECORD(
        last_name hr.employees.last_name%type,
        hire_date hr.employees.hire_date%type,
        department_name hr.departments.department_name%type
    );
    v_rec rec_type;
BEGIN
    SELECT e.last_name, e.hire_date, d.department_name
    INTO v_rec
    FROM hr.employees e, hr.departments d
    WHERE e.department_id = d.department_id
    AND e.employee_id = 100;
    
    dbms_output.put_line(v_rec.last_name || ' ' || v_rec.hire_date || ' ' || v_rec.department_name);
END;
/

-- index by table
DECLARE
    /* 1차원 연관 배열 */
    TYPE id_type IS TABLE OF number INDEX BY pls_integer;
    v_id id_type;
    
    /* Record Type */
    TYPE rec_type IS RECORD(
        last_name hr.employees.last_name%type,
        hire_date hr.employees.hire_date%type,
        department_name hr.departments.department_name%type
    );
    /* 2차원 배열 */
    TYPE tab_type IS TABLE OF rec_type INDEX BY pls_integer;
    v_tab tab_type;
BEGIN
    v_id(1) := 100;
    v_id(2) := 101;
    v_id(3) := 102;
    
    FOR i in v_id.first..v_id.last LOOP
        SELECT e.last_name, e.hire_date, d.department_name
        INTO v_tab(i)
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = d.department_id
        AND e.employee_id = v_id(i);
        
        dbms_output.put_line(v_tab(i).last_name || ' ' || v_tab(i).hire_date || ' ' || v_tab(i).department_name);
    END LOOP;  
END;
/

-- nexted table
DECLARE
    /* 1차원 Nested Table */
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 101, 102);
    
    /* Record Type */
    TYPE rec_type IS RECORD(
        last_name hr.employees.last_name%type,
        hire_date hr.employees.hire_date%type,
        department_name hr.departments.department_name%type
    );
    /* 2차원 배열 */
    TYPE tab_type IS TABLE OF rec_type INDEX BY pls_integer;
    v_tab tab_type;
BEGIN
    FOR i in v_id.first..v_id.last LOOP
        SELECT e.last_name, e.hire_date, d.department_name
        INTO v_tab(i)
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = d.department_id
        AND e.employee_id = v_id(i);
        
        dbms_output.put_line(v_tab(i).last_name || ' ' || v_tab(i).hire_date || ' ' || v_tab(i).department_name);
    END LOOP;  
END;
/

-- varray
DECLARE
    /* 1차원 VARRAY */
    TYPE id_type IS VARRAY(3) OF number;
    v_id id_type := id_type(100, 101, 102);
    
    /* Record Type */
    TYPE rec_type IS RECORD(
        last_name hr.employees.last_name%type,
        hire_date hr.employees.hire_date%type,
        department_name hr.departments.department_name%type
    );
    /* 2차원 배열 */
    TYPE tab_type IS TABLE OF rec_type INDEX BY pls_integer;
    v_tab tab_type;
BEGIN
    FOR i in v_id.first..v_id.last LOOP
        SELECT e.last_name, e.hire_date, d.department_name
        INTO v_tab(i)
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = d.department_id
        AND e.employee_id = v_id(i);
        
        dbms_output.put_line(v_tab(i).last_name || ' ' || v_tab(i).hire_date || ' ' || v_tab(i).department_name);
    END LOOP;  
END;
/

-- 명시적 커서
-- ORA-01422: exact fetch returns more than requested number of rows
DECLARE
    v_name varchar2(30);
BEGIN
    SELECT last_name
    INTO v_name
    FROM hr.employees
    WHERE department_id = 20;
    
    dbms_output.put_line(v_name);
END;
/

-- 명시적 커서 사용
DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT last_name, salary
        FROM hr.employees
        WHERE department_id = 20;    
    
    v_name varchar2(30);
    v_sal number;
BEGIN
    /* 2. CURSOR OPEN */
    OPEN emp_cur;
    
    /* 3. FETCH */
    LOOP
        FETCH emp_cur INTO v_name, v_sal;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_name || ' ' || v_sal);
    END LOOP;
    
    dbms_output.put_line(emp_cur%rowcount || '행이 인출되었습니다.');
    
    /* 4. CURSOR CLOSE */
    CLOSE emp_cur;
END;
/

-- ORA-01001: invalid cursor
-- 커서를 OPEN 하지 않은 상태에서 FETCH를 수행하면 발생하는 오류
DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT last_name, salary
        FROM hr.employees
        WHERE department_id = 20;    
    
    v_name varchar2(30);
    v_sal number;
BEGIN
    /* 2. CURSOR OPEN */
    IF NOT emp_cur%isopen THEN
        OPEN emp_cur;
    END IF;
    
    /* 3. FETCH */
    LOOP
        FETCH emp_cur INTO v_name, v_sal;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_name || ' ' || v_sal);
    END LOOP;
    
    dbms_output.put_line(emp_cur%rowcount || '행이 인출되었습니다.');
    
    /* 4. CURSOR CLOSE */
    IF emp_cur%isopen THEN
        CLOSE emp_cur;
        dbms_output.put_line('emp_cur가 close되었습니다.');
    END IF;
END;
/

DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT e.last_name, e.salary, d.department_name
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = 20
        AND d.department_id = 20;
    
    /* Scalar Type 변수 선언 */
    v_name varchar2(30);
    v_sal number;
    v_dept_name varchar2(30);
BEGIN
    /* 2. CURSOR OPEN */
    IF NOT emp_cur%isopen THEN
        OPEN emp_cur;
    END IF;
    
    /* 3. FETCH */
    LOOP
        FETCH emp_cur INTO v_name, v_sal, v_dept_name;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_name || ' ' || v_sal || ' ' || v_dept_name);
    END LOOP;
    
    dbms_output.put_line(emp_cur%rowcount || '행이 인출되었습니다.');
    
    /* 4. CURSOR CLOSE */
    IF emp_cur%isopen THEN
        CLOSE emp_cur;
        dbms_output.put_line('emp_cur가 close되었습니다.');
    END IF;
END;
/

-- RECORD 사용
DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT e.employee_id, e.last_name, e.salary, d.department_name
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = 20
        AND d.department_id = 20;
    
    /* Record Type 선언 */
    TYPE rec_type IS RECORD(
        id number,
        name varchar2(30),
        sal number,
        dept_name varchar2(30)
    );
    v_rec rec_type;
BEGIN
    /* 2. CURSOR OPEN */
    OPEN emp_cur;
    
    /* 3. FETCH */
    LOOP
        FETCH emp_cur INTO v_rec;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_rec.id || ' ' || v_rec.name || ' ' || v_rec.sal || ' ' || v_rec.dept_name);
    END LOOP;
    
    dbms_output.put_line(emp_cur%rowcount || '행이 인출되었습니다.');
    
    /* 4. CURSOR CLOSE */
    CLOSE emp_cur;
END;
/

-- %rowtype
DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT e.employee_id, e.last_name, e.salary, d.department_name
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = 20
        AND d.department_id = 20;
    
    /* FETCH에서 사용해야 할 레코드 타입 변수, 커서를 기반으로 하는 레코드 타입의 변수 */
    v_rec emp_cur%rowtype;
BEGIN
    /* 2. CURSOR OPEN */
    OPEN emp_cur;
    
    /* 3. FETCH */
    LOOP
        FETCH emp_cur INTO v_rec;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name || ' ' || v_rec.salary || ' ' || v_rec.department_name);
    END LOOP;
    
    dbms_output.put_line(emp_cur%rowcount || '행이 인출되었습니다.');
    
    /* 4. CURSOR CLOSE */
    CLOSE emp_cur;
END;
/

-- 별칭
DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT e.employee_id id, e.last_name name, e.salary sal, d.department_name dept_name
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = 20
        AND d.department_id = 20;
    
    /* FETCH에서 사용해야 할 레코드 타입 변수, 커서를 기반으로 하는 레코드 타입의 변수 */
    v_rec emp_cur%rowtype;
BEGIN
    /* 2. CURSOR OPEN */
    OPEN emp_cur;
    
    /* 3. FETCH */
    LOOP
        FETCH emp_cur INTO v_rec;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_rec.id || ' ' || v_rec.name || ' ' || v_rec.sal || ' ' || v_rec.dept_name);
    END LOOP;
    
    dbms_output.put_line(emp_cur%rowcount || '행이 인출되었습니다.');
    
    /* 4. CURSOR CLOSE */
    CLOSE emp_cur;
END;
/

-- FOR LOOP
DECLARE
    /* 1. 커서 선언 */
    CURSOR emp_cur IS
        SELECT e.employee_id, e.last_name, e.salary, d.department_name
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = 20
        AND d.department_id = 20;
BEGIN
    FOR v_rec IN emp_cur LOOP
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name || ' '  || v_rec.salary || ' ' || v_rec.department_name);
    END LOOP;

END;
/

-- subquery
BEGIN
    FOR v_rec IN (SELECT e.employee_id, e.last_name, e.salary, d.department_name
                    FROM hr.employees e, hr.departments d
                    WHERE e.department_id = 20
                    AND d.department_id = 20) LOOP
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name || ' '  || v_rec.salary || ' ' || v_rec.department_name);
    END LOOP;
END;
/

-- [문제14] 2006년도에 입사한 사원들의 근무 도시이름별로 급여의 총액, 평균을 출력하세요.
/*
<화면출력>
Seattle 도시에 근무하는 사원들의 총액급여는 ￦10,400 이고 평균급여는 ￦5,200 입니다.
South San Francisco 도시에 근무하는 사원들의 총액급여는 ￦37,800 이고 평균급여는 ￦2,907 입니다.
Southlake 도시에 근무하는 사원들의 총액급여는 ￦13,800 이고 평균급여는 ￦6,900 입니다.
Oxford 도시에 근무하는 사원들의 총액급여는 ￦59,100 이고 평균급여는 ￦8,442 입니다.
*/

SELECT l.city, to_char(sum(e.salary), 'FML999,999') sum_sal, to_char(trunc(avg(e.salary)), 'FML999,999') avg_sal
FROM hr.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND hire_date between to_date('20060101', 'yyyymmdd') and to_date('20070101', 'yyyymmdd')-1/24/60/60
GROUP BY city;

DECLARE
    CURSOR cur IS 
        SELECT l.city, to_char(sum(e.salary), 'FML999,999') sum_sal, to_char(trunc(avg(e.salary)), 'FML999,999') avg_sal
        FROM hr.employees e, hr.departments d, hr.locations l
        WHERE e.department_id = d.department_id
        AND d.location_id = l.location_id
        AND hire_date between to_date('20060101', 'yyyymmdd') and to_date('20070101', 'yyyymmdd')-1/24/60/60
        GROUP BY city;
BEGIN
    FOR v_rec IN cur LOOP
        dbms_output.put_line(v_rec.city || ' 도시에 근무하는 사원들의 총액급여는 ' || v_rec.sum_sal || ' 이고 평균급여는 ' || v_rec.avg_sal || ' 입니다.');
    END LOOP;
END;
/

-- 실행계획 공유 불가
DECLARE
    CURSOR emp_80 IS
        SELECT employee_id, last_name, job_id
        FROM hr.employees
        WHERE department_id = 80
        AND job_id = 'SA_MAN';
        
    CURSOR emp_50 IS
        SELECT employee_id, last_name, job_id
        FROM hr.employees
        WHERE department_id = 50
        AND job_id = 'ST_MAN';
        
    v_rec emp_80%rowtype;
BEGIN
    OPEN emp_80;
    LOOP
        FETCH emp_80 INTO v_rec;
        EXIT WHEN emp_80%notfound;
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name || ' ' || v_rec.job_id);
    END LOOP;
    CLOSE emp_80;
    
    FOR v_rec1 IN emp_50 LOOP
        dbms_output.put_line(v_rec1.employee_id || ' ' || v_rec1.last_name || ' ' || v_rec1.job_id);
    END LOOP;
END;
/

-- parameter
DECLARE
    CURSOR emp_cur(p_id number, p_job varchar2) IS
        SELECT employee_id, last_name, job_id
        FROM hr.employees
        WHERE department_id = p_id
        AND job_id = p_job;
        
    v_rec emp_cur%rowtype;
BEGIN
    OPEN emp_cur(80, 'SA_MAN');
    LOOP
        FETCH emp_cur INTO v_rec;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name || ' ' || v_rec.job_id);
    END LOOP;
    CLOSE emp_cur;
    
    FOR v_rec1 IN emp_cur(50, 'ST_MAN') LOOP
        dbms_output.put_line(v_rec1.employee_id || ' ' || v_rec1.last_name || ' ' || v_rec1.job_id);
    END LOOP;
END;
/


DECLARE
    TYPE rec_type IS RECORD (id number, job varchar(30));
    TYPE id_type IS TABLE OF rec_type := ();
    CURSOR emp_cur(p_id number, p_job varchar2) IS
        SELECT employee_id, last_name, job_id
        FROM hr.employees
        WHERE department_id = p_id
        AND job_id = p_job;
        
    v_rec emp_cur%rowtype;
BEGIN
    OPEN emp_cur(80, 'SA_MAN');
    LOOP
        FETCH emp_cur INTO v_rec;
        EXIT WHEN emp_cur%notfound;
        dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name || ' ' || v_rec.job_id);
    END LOOP;
    CLOSE emp_cur;
    
    FOR v_rec1 IN emp_cur(50, 'ST_MAN') LOOP
        dbms_output.put_line(v_rec1.employee_id || ' ' || v_rec1.last_name || ' ' || v_rec1.job_id);
    END LOOP;
END;
/
