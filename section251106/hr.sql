SELECT last_name, salary, hire_date
FROM hr.employees
WHERE employee_id = 100;

BEGIN
    SELECT last_name, salary, hire_date
    FROM hr.employees
    WHERE employee_id = 100;
END;
/
--PLS-00428: an INTO clause is expected in this SELECT statement

-- 암시적 커서
DECLARE
    v_name varchar2(30);
    v_sal number;
    v_date date;
BEGIN
    SELECT last_name, salary, hire_date
    INTO v_name, v_sal, v_date
    FROM hr.employees
    WHERE employee_id = 100;
    
    dbms_output.put_line(v_name || ' ' || v_sal || ' ' || v_date);
END;
/

-- ORA-01403: no data found
DECLARE
    v_name varchar2(30);
    v_sal number;
    v_date date;
BEGIN
    SELECT last_name, salary, hire_date
    INTO v_name, v_sal, v_date
    FROM hr.employees
    WHERE employee_id = 300;
    
    dbms_output.put_line(v_name || ' ' || v_sal || ' ' || v_date);
END;
/

-- ORA-01422: exact fetch returns more than requested number of rows
DECLARE
    v_name varchar2(30);
    v_sal number;
    v_date date;
BEGIN
    SELECT last_name, salary, hire_date
    INTO v_name, v_sal, v_date
    FROM hr.employees
    WHERE department_id = 20;
    
    dbms_output.put_line(v_name || ' ' || v_sal || ' ' || v_date);
END;
/

desc hr.employees

-- %type
-- 테이블명.컬럼이름%TYPE : 테이블 컬럼의 데이터 타이과 사이즈를 사용하겠다는 의미
-- 변수%TYPE : 변수의 타입과 사이즈를 사용하겠다는 의미
DECLARE
    v_lname employees.last_name%type;
    v_fname v_lname%type;
    v_sal employees.salary%type;
    v_date employees.hire_date%type;
BEGIN
    SELECT last_name, first_name, salary, hire_date
    INTO v_lname, v_fname, v_sal, v_date
    FROM hr.employees
    WHERE employee_id = 100;
    
    dbms_output.put_line(v_lname || ' ' || ' ' || v_fname || ' ' || v_sal || ' ' || v_date);
END;
/

-- PL/SQL 블록에서 선언한 변수를 외부 SQL문장에서 사용 불가 -> 바인드 변수 사용
DECLARE
    v_avg number;
BEGIN
    SELECT avg(salary)
    INTO v_avg
    FROM hr.employees;
    
    dbms_output.put_line('전체 사원의 평균급여 : ' || round(v_avg));
END;
/

SELECT *
FROM hr.employees
WHERE salary > v_avg;

-- 바인드 변수 사용
var b_avg number

BEGIN
    SELECT avg(salary)
    INTO :b_avg
    FROM hr.employees;
    
    dbms_output.put_line('전체 사원의 평균급여 : ' || round(:b_avg));
END;
/

SELECT *
FROM hr.employees
WHERE salary > :b_avg;

-- [문제10] 사원 번호를 입력값으로 받아서 last_name, salary, hire_date 정보를 출력하는 프로그램을 작성하세요.
/*
이름 : KING
급여 : ￦24,000.00
입사일 : 2003년 6월 17일
*/
DECLARE
    v_last_name employees.last_name%type;
    v_salary employees.salary%type;
    v_hire_date employees.hire_date%type;
BEGIN
    SELECT last_name, salary, hire_date
    INTO v_last_name, v_salary, v_hire_date
    FROM hr.employees
    WHERE employee_id = :b_employee_id;
    
    dbms_output.put_line('이름 : ' || v_last_name);
    dbms_output.put_line('급여 : ' || to_char(v_salary, 'FML999G999D99'));
    dbms_output.put_line('입사일 : ' || to_char(v_hire_date, 'yyyy"년" fmmm"월" dd"일"'));
    dbms_output.put_line('입사일 : ' || to_char(v_hire_date, 'DL'));
    dbms_output.put_line('입사일 : ' || to_char(v_hire_date, 'DS'));
END;
/

-- DML(INSERT, UPDATE, DELETE ,MERGE)
DROP TABLE hr.test PURGE;

CREATE TABLE hr.test(id number, name varchar2(30), day date) TABLESPACE users;

INSERT INTO hr.test(id, name, day) VALUES(1, 'ORACLE', SYSDATE);

SELECT * FROM hr.test;

ROLLBACK;

BEGIN
    INSERT INTO hr.test(id, name, day) VALUES(1, 'ORACLE', SYSDATE);
END;
/

SELECT * FROM hr.test;

BEGIN
    INSERT INTO hr.test(id, name, day) VALUES(:b_id, :b_name, to_date(:b_day, 'yyyy-mm-dd'));
END;
/

SELECT * FROM hr.test;

ROLLBACK;

-- sql%rowcount : 영향을 받은 행수
BEGIN
    INSERT INTO hr.test(id, name, day)
    SELECT employee_id, last_name, hire_date
    FROM hr.employees;
    
    dbms_output.put_line(sql%rowcount || ' ' || ' 행이 입력되었습니다.');
END;
/

SELECT * FROM hr.test;
COMMIT;

UPDATE hr.test
SET day = sysdate
WHERE id = 300;

ROLLBACK;

BEGIN
    UPDATE hr.test
    SET day = sysdate
    WHERE id in (100, 200);
    
    dbms_output.put_line(sql%rowcount || ' 행이 수정되었습니다.');
    
    ROLLBACK;
END;
/

BEGIN
    UPDATE hr.test
    SET day = sysdate
    WHERE id = 300;
    
    IF sql%found THEN
        dbms_output.put_line(sql%rowcount || ' 행이 수정되었습니다.');
    ELSE
        dbms_output.put_line('사원이 존재하지 않습니다');
    END IF;
    
    ROLLBACK;
END;
/

BEGIN
    DELETE FROM hr.test WHERE day < to_date('2005-01-01', 'yyyy-mm-dd');
    
    IF sql%found THEN
        dbms_output.put_line(sql%rowcount || ' 행이 삭제되었습니다.');
    ELSE
        dbms_output.put_line('사원이 존재하지 않습니다');
    END IF;
    
    ROLLBACK;
END;
/

-- [문제11] 사원번호를 입력값으로 받아서 근속연수가 20년 이상이면 10% 인상급여로 수정하는 프로그램을 생성해주세요.
/*
100사원의 입사일은 2003-06-17 근속연수는 21년입니다.
100사원의 이전 급여는 24000, 수정된 급여는 26400
*/

drop table hr.emp purge;

create table emp
as
select * from employees;

SELECT to_char(hire_date, 'yyyy-mm-dd') "date", trunc(months_between(sysdate, hire_date) / 12) "year", salary "sal", salary * 1.1 "new_sal"
FROM hr.emp
WHERE employee_id = 100;

DECLARE
    v_date varchar(30);
    v_year number;
    v_sal emp.salary%type;
    v_new_sal v_sal%type;
BEGIN
    SELECT to_char(hire_date, 'yyyy-mm-dd'), trunc(months_between(sysdate, hire_date) / 12), salary
    INTO v_date, v_year, v_sal
    FROM hr.emp
    WHERE employee_id = :b_id;
    
    dbms_output.put_line(:b_id || '사원의 입사일은 ' || v_date || ' 근속연수는 ' || v_year || '년입니다.');
    
    IF v_year >= 20 THEN
        UPDATE hr.emp
        SET salary = salary * 1.1
        WHERE employee_id = :b_id;
        
        SELECT salary
        INTO v_new_sal
        FROM hr.emp
        WHERE employee_id = :b_id;
        
        dbms_output.put_line(:b_id || '사원의 이전 급여는 ' || v_sal || ', 수정된 급여는 ' || v_new_sal || '입니다.');
    ELSE
        dbms_output.put_line(:b_id || '사원의 급여는 수정할 수 없습니다.');
    END IF;
    ROLLBACK;
END;
/

-- 레코드 사용 전
DECLARE
    v_dept_id departments.department_id%type;
    v_dept_name departments.department_name%type;
    v_dept_mgr departments.manager_id%type;
    v_dept_loc departments.location_id%type;
BEGIN
    SELECT department_id, department_name, manager_id, location_id
    INTO v_dept_id, v_dept_name, v_dept_mgr, v_dept_loc
    FROM hr.departments
    WHERE department_id = 10;
    
    dbms_output.put_line('부서번호 : ' || v_dept_id);
    dbms_output.put_line('부서이름 : ' || v_dept_name);
    dbms_output.put_line('부서장 : ' || v_dept_mgr);
    dbms_output.put_line('부서위치 : ' || v_dept_loc);
END;
/

-- record
DECLARE
    /* 레코드 유형 선언, field 구성 */
    TYPE dept_record_type IS RECORD(
        dept_id departments.department_id%type,
        dept_name departments.department_name%type,
        dept_mgr departments.manager_id%type,
        dept_loc departments.location_id%type
    );
    
    v_rec dept_record_type;
    
BEGIN
    SELECT department_id, department_name, manager_id, location_id
    INTO v_rec
    FROM hr.departments
    WHERE department_id = 10;
    
    dbms_output.put_line('부서번호 : ' || v_rec.dept_id);
    dbms_output.put_line('부서이름 : ' || v_rec.dept_name);
    dbms_output.put_line('부서장 : ' || v_rec.dept_mgr);
    dbms_output.put_line('부서위치 : ' || v_rec.dept_loc);
END;
/

-- %rowtype
DECLARE
    v_rec departments%rowtype;
    
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.departments
    WHERE department_id = 10;
    
    dbms_output.put_line('부서번호 : ' || v_rec.department_id);
    dbms_output.put_line('부서이름 : ' || v_rec.department_name);
    dbms_output.put_line('부서장 : ' || v_rec.manager_id);
    dbms_output.put_line('부서위치 : ' || v_rec.location_id);
END;
/

DECLARE
    TYPE rec_type IS RECORD(
        sal number,
        minsal number default 1000,
        day date,
        rec employees%rowtype);
    v_rec rec_type;
BEGIN
    v_rec.sal := v_rec.minsal + 500;
    v_rec.day := sysdate;
    
    SELECT *
    INTO v_rec.rec
    FROM hr.employees
    WHERE employee_id = 100;
    
    dbms_output.put_line(v_rec.sal);
    dbms_output.put_line(v_rec.minsal);
    dbms_output.put_line(v_rec.day);
    dbms_output.put_line(v_rec.rec.last_name);
    dbms_output.put_line(trunc(months_between(v_rec.day, v_rec.rec.hire_date)/12));
END;
/

CREATE TABLE hr.retired_emp
AS
SELECT *
FROM hr.employees
WHERE 1 = 2;

SELECT * FROM hr.retired_emp;

-- 행 레벨 INSERT
DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 100;
    
    dbms_output.put_line(v_rec.last_name);
    
    INSERT INTO hr.retired_emp VALUES v_rec;
END;
/

SELECT * FROM hr.retired_emp;
rollback;
commit;

-- 행 레벨 UPDATE
DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 100;
    
    v_rec.first_name := upper(v_rec.first_name);
    v_rec.last_name := upper(v_rec.last_name);
    v_rec.commission_pct:= 0.1;
    v_rec.hire_date := sysdate;
    v_rec.department_id := 10;
    
    UPDATE hr.retired_emp
    SET first_name = v_rec.first_name, last_name = v_rec.last_name, ...
    WHERE employee_id = 100;
END;
/

SELECT * FROM hr.retired_emp;

DECLARE
    v_rec employees%rowtype;
BEGIN
    SELECT *
    INTO v_rec
    FROM hr.employees
    WHERE employee_id = 100;
    
    v_rec.first_name := upper(v_rec.first_name);
    v_rec.last_name := upper(v_rec.last_name);
    v_rec.commission_pct:= 0.1;
    v_rec.hire_date := sysdate;
    v_rec.department_id := 10;
    
    UPDATE hr.retired_emp
    SET row = v_rec
    WHERE employee_id = 100;
END;
/

SELECT * FROM hr.retired_emp;
ROLLBACK;
