-- [문제17] get_annual_sal 함수를 생성해주세요.
SELECT
    employee_id,
    salary,
    commission_pct,
    salary * 12 + salary * 12 * commission_pct annual_salary_1,
    salary * 12 + salary * 12 * nvl(commission_pct, 0)commission_pct_annual_salary_2,
    get_annual_sal(salary, commission_pct) annual_salary_3,
    get_annual_sal(sal=>salary, comm=>commission_pct) annual_salary_4,
    get_annual_sal(sal=>salary) annual_salary_5,
    get_annual_sal(salary) annual_salary_6
FROM hr.employees;

CREATE OR REPLACE FUNCTION get_annual_sal(sal IN number, comm IN number := 0)
RETURN number
IS
BEGIN
    RETURN sal * 12 + sal * 12 * nvl(comm, 0);
END get_annual_sal;
/

desc get_annual_sal
/*
FUNCTION get_annual_sal RETURNS NUMBER
 Argument Name                  Type                    In/Out Default?
 ------------------------------ ----------------------- ------ --------
 SAL                            NUMBER                  IN
 COMM                           NUMBER                  IN     DEFAULT
 */
 
CREATE OR REPLACE FUNCTION query_call(p_id IN number)
RETURN number
IS
    v_sal number;
BEGIN
    SELECT salary
    INTO v_sal
    FROM hr.employees
    WHERE employee_id = p_id;
    
    RETURN v_sal;
EXCEPTION
    WHEN no_data_found THEN
        RETURN v_sal;
END query_call;
/

SELECT employee_id, query_call(employee_id) FROM hr.employees;

UPDATE hr.employees
SET salary = query_call(101) * 1.1
WHERE employee_id = 101;
-- ORA-04091: table HR.EMPLOYEES is mutating, trigger/function may not see it

CREATE OR REPLACE FUNCTION validate_comm(p_comm IN number)
RETURN boolean
IS
    v_comm number;
BEGIN
    SELECT max(commission_pct)
    INTO v_comm
    FROM hr.employees;
    
    IF p_comm > v_comm THEN
        RETURN FALSE;
    ELSE 
        RETURN TRUE;
    END IF;
END validate_comm;
/

desc validate_comm;
/*
FUNCTION validate_comm RETURNS BOOLEAN
 Argument Name                  Type                    In/Out Default?
 ------------------------------ ----------------------- ------ --------
 P_COMM                         NUMBER                  IN
*/

CREATE OR REPLACE PROCEDURE reset_comm(p_comm IN number)
IS
    v_comm number := 0.1;
BEGIN
    IF validate_comm(p_comm) THEN
        dbms_output.put_line('OLD : ' || v_comm);
        v_comm := p_comm;
        dbms_output.put_line('NEW : ' || v_comm);
    ELSE
        RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
    END IF;
END reset_comm;
/

desc rest_comm;
/*
PROCEDURE reset_comm
 Argument Name                  Type                    In/Out Default?
 ------------------------------ ----------------------- ------ --------
 P_COMM                         NUMBER                  IN
*/

-- package specification
CREATE OR REPLACE PACKAGE comm_pkg
IS
	g_comm number := 0.1;
    PROCEDURE reset_comm(p_comm IN number);
END comm_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY comm_pkg
IS
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean
    IS
        v_comm number;
    BEGIN
        SELECT max(commission_pct)
        INTO v_comm
        FROM hr.employees;
        
        IF p_comm > v_comm THEN
            RETURN FALSE;
        ELSE 
            RETURN TRUE;
        END IF;
    END validate_comm;
    
    PROCEDURE reset_comm(p_comm IN number)
    IS
    BEGIN
        IF validate_comm(p_comm) THEN
            dbms_output.put_line('OLD : ' || g_comm);
            g_comm := p_comm;
            dbms_output.put_line('NEW : ' || g_comm);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
        END IF;
    END reset_comm;
END comm_pkg;
/

SELECT * FROM user_procedures;
SELECT * FROM user_objects WHERE object_name = 'COMM_PKG';

-- 패키지 소스 조회
SELECT text FROM user_source WHERE name = 'COMM_PKG' AND type = 'PACKAGE' ORDER BY line;
SELECT text FROM user_source WHERE name = 'COMM_PKG' AND type = 'PACKAGE BODY' ORDER BY line;

-- package specification
CREATE OR REPLACE PACKAGE comm_pkg
IS
    PROCEDURE reset_comm(p_comm IN number);
END comm_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY comm_pkg
IS
    g_comm number := 0.1;
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean
    IS
        v_comm number;
    BEGIN
        SELECT max(commission_pct)
        INTO v_comm
        FROM hr.employees;
        
        IF p_comm > v_comm THEN
            RETURN FALSE;
        ELSE 
            RETURN TRUE;
        END IF;
    END validate_comm;
    
    PROCEDURE reset_comm(p_comm IN number)
    IS
    BEGIN
        IF validate_comm(p_comm) THEN
            dbms_output.put_line('OLD : ' || g_comm);
            g_comm := p_comm;
            dbms_output.put_line('NEW : ' || g_comm);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
        END IF;
    END reset_comm;
END comm_pkg;
/


-- package specification
CREATE OR REPLACE PACKAGE comm_pkg
IS
    PROCEDURE reset_comm(p_comm IN number);
END comm_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY comm_pkg
IS
    g_comm number := 0.1;
    
    PROCEDURE reset_comm(p_comm IN number)
    IS
    BEGIN
        IF validate_comm(p_comm) THEN
            dbms_output.put_line('OLD : ' || g_comm);
            g_comm := p_comm;
            dbms_output.put_line('NEW : ' || g_comm);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
        END IF;
    END reset_comm;
    
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean
    IS
        v_comm number;
    BEGIN
        SELECT max(commission_pct)
        INTO v_comm
        FROM hr.employees;
        
        IF p_comm > v_comm THEN
            RETURN FALSE;
        ELSE 
            RETURN TRUE;
        END IF;
    END validate_comm;
END comm_pkg;
/
/*
LINE/COL ERROR
-------- -----------------------------------------------------------------
8/9      PL/SQL: Statement ignored
8/12     PLS-00313: 'VALIDATE_COMM' not declared in this scope
*/

-- package specification
CREATE OR REPLACE PACKAGE comm_pkg
IS
    PROCEDURE reset_comm(p_comm IN number);
END comm_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY comm_pkg
IS
    g_comm number := 0.1;
    
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean;
    
    PROCEDURE reset_comm(p_comm IN number)
    IS
    BEGIN
        IF validate_comm(p_comm) THEN
            dbms_output.put_line('OLD : ' || g_comm);
            g_comm := p_comm;
            dbms_output.put_line('NEW : ' || g_comm);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, '기존 최고값을 넘을 수 없습니다');
        END IF;
    END reset_comm;
    
    FUNCTION validate_comm(p_comm IN number)
    RETURN boolean
    IS
        v_comm number;
    BEGIN
        SELECT max(commission_pct)
        INTO v_comm
        FROM hr.employees;
        
        IF p_comm > v_comm THEN
            RETURN FALSE;
        ELSE 
            RETURN TRUE;
        END IF;
    END validate_comm;
END comm_pkg;
/

-- package overloading
CREATE OR REPLACE PACKAGE pack_over
IS
    TYPE date_tab_type IS TABLE OF date INDEX BY pls_integer;
    TYPE num_tab_type IS TABLE OF number INDEX BY pls_integer;
    
    PROCEDURE init(tab OUT date_tab_type, n IN number);
    PROCEDURE init(tab OUT num_tab_type, n IN number);

END pack_over;
/

CREATE OR REPLACE PACKAGE BODY pack_over
IS
    PROCEDURE init(tab OUT date_tab_type, n IN number)
    IS
    BEGIN
        FOR i IN 1..n LOOP
            tab(i) := sysdate;
        END LOOP;
    END init;
    
    PROCEDURE init(tab OUT num_tab_type, n IN number)
    IS
    BEGIN
        FOR i IN 1..n LOOP
            tab(i) := i;
        END LOOP;
    END init;
END pack_over;
/

DECLARE
    date_tab pack_over.date_tab_type;
    num_tab pack_over.num_tab_type;
BEGIN
    pack_over.init(date_tab, 5);
    pack_over.init(num_tab, 10);
    
    FOR i IN date_tab.first..date_tab.last LOOP
        dbms_output.put_line(date_tab(i));
    END LOOP;
    
    FOR i IN num_tab.first..num_tab.last LOOP
        dbms_output.put_line(num_tab(i));
    END LOOP;
END;
/

-- [문제18] 사원을 조회하는 프로그램을 작성해주세요.
-- execute emp_find.find(100)
-- 100 King
-- execute emp_find.find('King')
-- 100 King
-- 156 King

SELECT * FROM hr.employees WHERE employee_id = 100;
SELECT * FROM hr.employees WHERE last_name = 'King';

-- 프로시저에서 출력
CREATE OR REPLACE PACKAGE emp_find
IS
    PROCEDURE find(id IN number);
    PROCEDURE find(name IN varchar2);
END emp_find;
/

CREATE OR REPLACE PACKAGE BODY emp_find
IS  
    PROCEDURE find(id IN number)
    IS
        v_emp employees%rowtype;
    BEGIN
        SELECT *
        INTO v_emp
        FROM hr.employees
        WHERE employee_id = id;
        
        dbms_output.put_line(v_emp.employee_id || ' ' ||v_emp.last_name);
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line(id || '번 사원은 존재하지 않습니다.');
    END find;
    
    PROCEDURE find(name IN varchar2)
    IS
        CURSOR emp_cur IS
            SELECT *
            FROM hr.employees
            WHERE last_name = initcap(name)
            ORDER BY 1;
        v_cnt number := 0;
    BEGIN
        FOR i IN emp_cur LOOP
            dbms_output.put_line(i.employee_id || ' ' || i.last_name);
            v_cnt := emp_cur%rowcount;
        END LOOP;
        
        IF v_cnt = 0 THEN
            dbms_output.put_line(name || ' 사원은 존재하지 않습니다.');
        END IF;
    EXCEPTION 
        WHEN others THEN
            dbms_output.put_line(sqlerrm);
    END find;
END emp_find;
/

execute emp_find.find(100);
execute emp_find.find('king');
execute emp_find.find(300);
execute emp_find.find('oracle');

-- 호출 프로그램에서 출력
CREATE OR REPLACE PACKAGE emp_find
IS
    TYPE emp_tab_type IS TABLE OF employees%rowtype INDEX BY pls_integer;
    
    PROCEDURE find(emp_tab OUT emp_tab_type, id IN number);
    PROCEDURE find(emp_tab OUT emp_tab_type, name IN varchar2);
END emp_find;
/

CREATE OR REPLACE PACKAGE BODY emp_find
IS
    PROCEDURE find(emp_tab OUT emp_tab_type, id IN number)
    IS
    BEGIN
        SELECT *
        INTO emp_tab(1)
        FROM hr.employees
        WHERE employee_id = id;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line(id || '번 사원은 존재하지 않습니다.');
    END find;
    
    PROCEDURE find(emp_tab OUT emp_tab_type, name IN varchar2)
    IS
        CURSOR emp_cur IS
            SELECT *
            FROM hr.employees
            WHERE last_name = initcap(name)
            ORDER BY 1;
            
        v_cnt number := 0;
    BEGIN
        FOR i IN emp_cur LOOP
            v_cnt := emp_cur%rowcount;
            emp_tab(v_cnt) := i;
        END LOOP;
        
        IF v_cnt = 0 THEN
            dbms_output.put_line(name || ' 사원은 존재하지 않습니다.');
        END IF;
    EXCEPTION 
        WHEN others THEN
            dbms_output.put_line(sqlerrm);
    END find;
END emp_find;
/

DECLARE
    v_emp_tab emp_find.emp_tab_type;
BEGIN
    emp_find.find(v_emp_tab, 100);
    
    FOR i IN v_emp_tab.first..v_emp_tab.last LOOP
        dbms_output.put_line(v_emp_tab(i).employee_id || ' ' || v_emp_tab(i).last_name);
    END LOOP;
    
    dbms_output.new_line();
    emp_find.find(v_emp_tab, 'king');
    
    FOR i IN v_emp_tab.first..v_emp_tab.last LOOP
        dbms_output.put_line(v_emp_tab(i).employee_id || ' ' || v_emp_tab(i).last_name);
    END LOOP;
    
    dbms_output.new_line();
    emp_find.find(v_emp_tab, 300);
    
    dbms_output.new_line();
    emp_find.find(v_emp_tab, 'oracle');
END;
/