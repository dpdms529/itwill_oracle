DECLARE
    TYPE tab_char_type IS TABLE OF varchar2(10) INDEX BY pls_integer;
    v_city tab_char_type;
BEGIN
    v_city(1) := '서울';
    v_city(2) := '부산';
    v_city(3) := '광주';
    v_city(4) := '대구';
    
    dbms_output.put_line(v_city(1));
    dbms_output.put_line(v_city(2));
    dbms_output.put_line(v_city(3));
    dbms_output.put_line(v_city(4));
END;
/

-- 연관 배열 메소드
DECLARE
    TYPE tab_char_type IS TABLE OF varchar2(10) INDEX BY pls_integer;
    v_city tab_char_type;
BEGIN
    v_city(1) := '서울';
    v_city(2) := '부산';
    v_city(3) := '광주';
    v_city(4) := '대구';
    
    dbms_output.put_line('count : ' || v_city.count);
    dbms_output.put_line('first : ' || v_city.first);
    dbms_output.put_line('last : ' || v_city.last);
    dbms_output.put_line('next(1) : ' || v_city.next(1));
    dbms_output.put_line('prior(3) : ' || v_city.prior(3));
    
    v_city.delete(1,2);
    dbms_output.put_line('count : ' || v_city.count);
    
    if v_city.exists(4) then 
        dbms_output.put_line('exists');
    end if;
END;
/

DECLARE
    TYPE tab_char_type IS TABLE OF varchar2(10) INDEX BY pls_integer;
    v_city tab_char_type;
BEGIN
    v_city(4) := '서울';
    v_city(3) := '부산';
    v_city(2) := '광주';
    v_city(1) := '대구';
    
    dbms_output.put_line('count : ' || v_city.count);
    dbms_output.put_line('first : ' || v_city.first);
    dbms_output.put_line('last : ' || v_city.last);
    dbms_output.put_line('next(1) : ' || v_city.next(1));
    dbms_output.put_line('prior(3) : ' || v_city.prior(3));
END;
/

-- ORA-01403: no data found
DECLARE
    TYPE tab_char_type IS TABLE OF varchar2(10) INDEX BY pls_integer;
    v_city tab_char_type;
BEGIN
    v_city(1) := '서울';
    v_city(2) := '부산';
    v_city(3) := '광주';
    v_city(4) := '대구';
    
    v_city.delete(3);
    
    FOR i IN v_city.first..v_city.last LOOP
        dbms_output.put_line(v_city(i));
    END LOOP;
END;
/

-- 오류 해결
DECLARE
    TYPE tab_char_type IS TABLE OF varchar2(10) INDEX BY pls_integer;
    v_city tab_char_type;
BEGIN
    v_city(1) := '서울';
    v_city(2) := '부산';
    v_city(3) := '광주';
    v_city(4) := '대구';
    
    v_city.delete(3);
    
    FOR i IN v_city.first..v_city.last LOOP
        IF v_city.exists(i) THEN
            dbms_output.put_line(v_city(i));
        ELSE
            dbms_output.put_line('key-value가 존재하지 않습니다.');
        END IF;
    END LOOP;
END;
/

-- 같은 쿼리 반복
UPDATE hr.employees
SET salary = salary  * 1.1
WHERE employee_id = 100;

UPDATE hr.employees
SET salary = salary  * 1.1
WHERE employee_id = 110;

UPDATE hr.employees
SET salary = salary  * 1.1
WHERE employee_id = 120;

-- 1차원 배열 변수 사용
DECLARE
    TYPE tab_id_type IS TABLE OF number INDEX BY pls_integer;
    v_tab tab_id_type;
BEGIN
    v_tab(1) := 100;
    v_tab(2) := 110;
    v_tab(3) := 120;
    
    FOR i IN v_tab.first..v_tab.last LOOP
        UPDATE hr.employees
    SET salary = salary  * 1.1
    WHERE employee_id = v_tab(i);
    END LOOP;
    
    ROLLBACK;
END;
/

-- ORA-01403: no data found
DECLARE
    TYPE tab_id_type IS TABLE OF number INDEX BY pls_integer;
    v_tab tab_id_type;
BEGIN
    v_tab(1) := 100;
    v_tab(2) := 110;
    v_tab(3) := 120;
    v_tab(5) := 130;
    
    FOR i IN v_tab.first..v_tab.last LOOP
        UPDATE hr.employees
        SET salary = salary  * 1.1
        WHERE employee_id = v_tab(i);
    END LOOP;
    
    ROLLBACK;
END;
/

DECLARE
    TYPE tab_id_type IS TABLE OF number INDEX BY pls_integer;
    v_tab tab_id_type;
BEGIN
    v_tab(1) := 100;
    v_tab(2) := 110;
    v_tab(3) := 120;
    v_tab(5) := 130;
    
    FOR i IN v_tab.first..v_tab.last LOOP
        IF v_tab.exists(i) THEN
            UPDATE hr.employees
            SET salary = salary  * 1.1
            WHERE employee_id = v_tab(i);
            dbms_output.put_line(sql%rowcount || ' 행이 수정되었습니다.');
        ELSE
            dbms_output.put_line(i || ' 요소번호는 존재하지 않습니다.');
        END IF;
    END LOOP;

    ROLLBACK;
END;
/

-- [문제12] 배열 변수에 있는 100,101,102,103,104,200 사원들의 근무 년수를 출력하고 근무 년수가 20년 이상이면 salary를 10% 인상하는 프로그램을 작성해주세요.
DECLARE
    TYPE id_type IS TABLE OF number INDEX BY pls_integer;
    v_id id_type;
    v_year number;
    v_sal employees.salary%type;
    v_new_sal v_sal%type;
BEGIN
    v_id(1) := 100;
    v_id(2) := 101;
    v_id(3) := 102;
    v_id(4) := 103;
    v_id(5) := 104;
    v_id(6) := 200;
    
    FOR i in v_id.first..v_id.last LOOP
        IF v_id.exists(i) THEN
            SELECT trunc(months_between(sysdate, hire_date)/12), salary
            INTO v_year, v_sal
            FROM hr.employees
            WHERE employee_id = v_id(i);
            
            IF v_year >= 20 THEN
                UPDATE hr.employees
                SET salary = salary * 1.1
                WHERE employee_id = v_id(i);
                
                IF sql%found THEN
                    SELECT salary
                    INTO v_new_sal
                    FROM hr.employees
                    WHERE employee_id = v_id(i);
                    
                    dbms_output.put_line(v_id(i) || '번 사원의 근무 년수는 ' || v_year || '년이므로 급여 인상');
                    dbms_output.put_line(v_sal || ' -> ' || v_new_sal);
                ELSE
                    dbms_output.put_line(v_id(i) || '번 사원 급여 인상 실패 오류');
                END IF;
            ELSE
                dbms_output.put_line(v_id(i) || '번 사원의 근무 년수는 ' || v_year || '년이므로 급여 인상 불가');
            END IF;
            dbms_output.new_line();
        END IF;
    END LOOP;
    
    ROLLBACK;
END;
/

-- record 타입 선언
DECLARE
    TYPE rec_type IS RECORD(
        id number,
        name varchar2(30),
        mgr number,
        loc number
    );
    
    v_rec rec_type;
BEGIN
    SELECT *
    INTO v_rec 
    FROM hr.departments
    WHERE department_id = 10;
    
    dbms_output.put_line(v_rec.id || ' ' || v_rec.name || ' ' || v_rec.mgr || ' ' || v_rec.loc);
END;
/

desc departments;

-- %rowtype
DECLARE
    v_rec departments%rowtype;
BEGIN
    FOR i IN 1..5 LOOP
        SELECT *
        INTO v_rec 
        FROM hr.departments
        WHERE department_id = 10 * i;
    END LOOP;  
    
    dbms_output.put_line(v_rec.department_id || ' ' || v_rec.department_name || ' ' || v_rec.manager_id || ' ' || v_rec.location_id);
    
END;
/

-- %rowtype을 이용한 이차원 배열
DECLARE
    TYPE tab_type IS TABLE OF departments%rowtype INDEX BY pls_integer;
    v_tab tab_type;
BEGIN
    FOR i IN 1..5 LOOP
        SELECT *
        INTO v_tab(i)
        FROM hr.departments
        WHERE department_id = 10 * i;
    END LOOP;  
    
    FOR j IN v_tab.first..v_tab.last LOOP
        dbms_output.put_line(v_tab(j).department_id || ' ' || v_tab(j).department_name || ' ' || v_tab(j).manager_id || ' ' || v_tab(j).location_id);
    END LOOP;
    
END;
/

-- record 타입을 직접 선언한 이차원 배열
DECLARE
    TYPE rec_type IS RECORD(
        id number,
        name varchar2(30),
        mgr number,
        loc number
    );
    TYPE tab_type IS TABLE OF rec_type INDEX BY pls_integer;
    v_tab tab_type;
BEGIN
    FOR i in 1..5 LOOP
        SELECT *
        INTO v_tab(i)
        FROM hr.departments
        WHERE department_id = 10 * i;
    END LOOP;
    
    FOR j IN v_tab.first..v_tab.last LOOP
        dbms_output.put_line(v_tab(j).id || ' ' || v_tab(j).name || ' ' || v_tab(j).mgr || ' ' || v_tab(j).loc);
    END LOOP;
END;
/

-- [문제13] 배열변수안에 있는 사원번호(100,110,200)를 기준으로 그 사원의 last_name,hire_date,department_name 정보를 배열변수에 담아 놓은 후 화면에 출력하는 프로그램 작성해주세요.
DECLARE
    TYPE id_type IS TABLE OF number INDEX BY pls_integer;
    TYPE rec_type IS RECORD(
        last_name employees.last_name%type,
        hire_date employees.hire_date%type,
        department_name departments.department_name%type
    );
    TYPE tab_type IS TABLE OF rec_type INDEX BY pls_integer;
    v_id id_type;
    v_tab tab_type;
BEGIN
    v_id(1) := 100;
    v_id(2) := 110;
    v_id(3) := 200;
    
    FOR i IN v_id.first..v_id.last LOOP
        SELECT e.last_name, e.hire_date, d.department_name
        INTO v_tab(i)
        FROM hr.employees e, hr.departments d
        WHERE e.department_id = d.department_id
        AND e.employee_id = v_id(i);
    END LOOP;
    
    FOR j IN v_tab.first..v_tab.last LOOP
        dbms_output.put_line(v_tab(j).last_name || ' ' || v_tab(j).hire_date || ' ' || v_tab(j).department_name);
    END LOOP;
END;
/

-- nested table
-- index by table 방식
DECLARE
    TYPE id_type IS TABLE OF number INDEX BY pls_integer;
    v_id id_type;
BEGIN
    v_id(1) := 100;
    v_id(2) := 110;
    v_id(3) := 120;
    
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- nested table
DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120);
BEGIN
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- ORA-06533: Subscript beyond count
DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120, 130);
BEGIN
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
    dbms_output.put_line(v_id.count);
    v_id(5) := 140;
    dbms_output.put_line(v_id.count);
END;
/

-- extend
DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120, 130);
BEGIN
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
    dbms_output.put_line(v_id.count);
    v_id.extend;
    v_id(5) := 140;
    dbms_output.put_line(v_id.count);
    
    v_id.extend(2);
    v_id(6) := 150;
    v_id(7) := 160;
    dbms_output.put_line(v_id.count);
END;
/

DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    v_id.extend(3, 1); -- 1번 요소 값을 3번 복사
    
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    v_id(2) := 200; -- 요소 값 수정
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- 요소 삭제
DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    v_id.delete(v_id.last);
    v_id.delete(v_id.count);
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- trim : 배열 안에 제일 끝에 있는 요소를 삭제하는 메소드
DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    v_id.trim;
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- BEGIN 절에서 배열 초기화
DECLARE
    TYPE id_type IS TABLE OF number;
    v_id id_type;
BEGIN
    v_id := id_type(100, 110, 120, 130, 140, 150);
    
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- varrray
DECLARE
    TYPE id_type IS VARRAY(6) OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- ORA-06532: Subscript outside of limit
DECLARE
    TYPE id_type IS VARRAY(5) OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- ORA-06533: Subscript beyond count
DECLARE
    TYPE id_type IS VARRAY(10) OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    dbms_output.put_line(v_id.count);
    v_id(7) := 160;
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

DECLARE
    TYPE id_type IS VARRAY(10) OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    dbms_output.put_line(v_id.count);
    v_id.extend; -- 새로운 값을 입력하려고 할 때 공간을 확장해야 함
    v_id(7) := 160;
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- PLS-00306: wrong number or types of arguments in call to 'DELETE'
DECLARE
    TYPE id_type IS VARRAY(10) OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    v_id.delete(6);
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/

-- trim
DECLARE
    TYPE id_type IS VARRAY(10) OF number;
    v_id id_type := id_type(100, 110, 120, 130, 140, 150);
BEGIN
    v_id.trim(2);
    FOR i IN v_id.first..v_id.last LOOP
        dbms_output.put_line(v_id(i));
    END LOOP;
END;
/