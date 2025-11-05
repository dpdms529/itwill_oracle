-- [문제1] 숫자값을 입력받고 입력값이 양수인지, 음수인지, 0인지를 출력하는 프로그램을 작성하세요
DECLARE
    num number := :b_num;        
BEGIN
    IF num > 0 THEN
        dbms_output.put_line('양수');
    ELSIF num < 0 THEN
        dbms_output.put_line('음수');
    ELSE
        dbms_output.put_line('0');
    END IF;
END;
/

-- 중첩 IF문
DECLARE
    num number := :b_num;        
BEGIN
    IF num > 0 THEN
        dbms_output.put_line('양수');
    ELSE
        IF num < 0 THEN
            dbms_output.put_line('음수');
        ELSE
            dbms_output.put_line('0');
        END IF;
    END IF;
END;
/

-- case 표현식
DECLARE
    num number := :b_num;        
    result varchar2(10);
BEGIN
    result := CASE 
                    WHEN num > 0 THEN '양수'
                    WHEN num < 0 THEN '음수'
                    ELSE '0'
                END;
    dbms_output.put_line(result);                
END;
/

-- case문
DECLARE
    num number := :b_num;        

BEGIN
    CASE 
        WHEN num > 0 THEN
            dbms_output.put_line('양수');
        WHEN num < 0 THEN
            dbms_output.put_line('음수');
        ELSE
            dbms_output.put_line('0');
    END CASE;
END;
/

-- loop
DECLARE
    v_cnt number := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_cnt);
        v_cnt := v_cnt + 1;
    END LOOP;
END;
/

-- ORA-20000: ORU-10027: buffer overflow, limit of 20000 bytes

DECLARE
    v_cnt number := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_cnt);
        IF v_cnt = 10 THEN
            EXIT;
        END IF;
        v_cnt := v_cnt + 1;
    END LOOP;
    dbms_output.put_line('종료');
END;
/

-- [문제2] 1~10까지 출력하는 프로그램을 작성해주세요. 단 4, 8번은 출력하지 마세요.
DECLARE
    v_cnt number := 1;
BEGIN
    LOOP
        IF v_cnt = 10 THEN
            EXIT;
        END IF;
        
        IF v_cnt != 4 AND v_cnt != 8 THEN
            dbms_output.put_line(v_cnt);    
        END IF;
        
        v_cnt := v_cnt + 1;
    END LOOP;
END;
/

-- EXIT WHEN 조건절 : 조건절이 TRUE이면 반복문 종료
-- CONTINUE
DECLARE
    v_cnt number := 1;
BEGIN
    LOOP
        IF v_cnt = 4 OR v_cnt = 8 THEN
            v_cnt := v_cnt + 1;
            CONTINUE;
        ELSE
            dbms_output.put_line(v_cnt);    
        END IF;
        v_cnt := v_cnt + 1;
        EXIT WHEN v_cnt > 10;
    END LOOP;
END;
/

-- CONTINUE WHEN
DECLARE
    v_cnt number := 0;
BEGIN
    LOOP
        v_cnt := v_cnt + 1;
        CONTINUE WHEN v_cnt = 4 OR v_cnt = 8;
        dbms_output.put_line(v_cnt);
        EXIT WHEN v_cnt = 10;
    END LOOP;
END;
/

-- [문제3] 1~10까지 홀수만 출력하는 프로그램이 작성해주세요.
DECLARE
    v_num number := 1;
BEGIN
    LOOP
        EXIT WHEN v_num = 10;
        
        IF mod(v_num, 2) = 1 THEN
            dbms_output.put_line(v_num);
        END IF;
        
        v_num := v_num + 1;
    END LOOP;
END;
/

DECLARE
    v_num number := 0;
BEGIN
    LOOP
        EXIT WHEN v_num = 10;
        v_num := v_num + 1;
        CONTINUE WHEN mod(v_num, 2) = 0;
        dbms_output.put_line(v_num);
    END LOOP;
END;
/

-- [문제4] 2단을 출력해주세요.
DECLARE
    v_dan number := 2;
    v_num number := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
        v_num := v_num + 1;
        EXIT WHEN v_num = 10;
    END LOOP;
END;
/
-- [문제5] 구구단을 출력해주세요.(2단 ~ 9단)
DECLARE
    v_dan number := 2;
    v_num number;
BEGIN
    LOOP
        v_num := 1;
        LOOP
            dbms_output.put_line(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
            v_num := v_num + 1;
            EXIT WHEN v_num = 10;
        END LOOP;
        dbms_output.put_line('');
        v_dan := v_dan + 1;
        EXIT WHEN v_dan = 10;
    END LOOP;
END;
/

-- [문제6] 1 ~ 5를 가로 방향으로 출력하세요.
DECLARE
    v_num number := 1;
    v_result varchar2(10);
BEGIN
    LOOP
        v_result := v_result || ' ' || v_num;
        EXIT WHEN v_num = 5;
        v_num := v_num + 1;
    END LOOP;
    dbms_output.put_line(v_result);
END;
/

DECLARE
    v_num number := 1;
BEGIN
    LOOP
        dbms_output.put(v_num);
        EXIT WHEN v_num = 5;
        v_num := v_num + 1;
    END LOOP;
    dbms_output.new_line();
END;
/

-- [문제7] 구구단을 아래 화면과 같이 출력해주세요.
DECLARE
    v_dan number;
    v_num number := 1;
BEGIN
    LOOP
        v_dan := 2;
        LOOP
            dbms_output.put(v_dan || ' * ' || v_num || ' = ' || rpad(v_dan * v_num, 5));
            EXIT WHEN v_dan = 9;
            v_dan := v_dan + 1;
        END LOOP;
        dbms_output.new_line();
        EXIT WHEN v_num = 9;
        v_num := v_num + 1;
    END LOOP;
END;
/

-- while
DECLARE
    i number := 1;
BEGIN
    WHILE i <= 10 LOOP
        dbms_output.put_line(i);
        i := i + 1;
    END LOOP;
END;
/

DECLARE
    i number := 10;
BEGIN
    WHILE i > 0 LOOP
        dbms_output.put_line(i);
        i := i - 1;
    END LOOP;
END;
/

-- [문제8] WHILE LOOP 문을 이용해서 구구단을 출력해주세요.(2~9단)
DECLARE
    v_dan number := 2;
    v_num number;
BEGIN
    WHILE v_dan < 10 LOOP
        v_num := 1;
        
        WHILE v_num < 10 LOOP
            dbms_output.put_line(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
            v_num := v_num + 1;
        END LOOP;
        
        v_dan := v_dan + 1;
    END LOOP;
END;
/

DECLARE
    v_dan number;
    v_num number := 1;
BEGIN
    WHILE v_num < 10 LOOP
        v_dan := 2;
        
        WHILE v_dan < 10 LOOP
            dbms_output.put(v_dan || ' * ' || v_num || ' = ' || rpad(v_dan * v_num, 5));
            v_dan := v_dan + 1;
        END LOOP;
        
        dbms_output.new_line();
        v_num := v_num + 1;
    END LOOP;
END;
/

-- FOR LOOP
BEGIN
    FOR i IN 1..10 LOOP
        dbms_output.put_line(i);
    END LOOP;
END;
/

BEGIN
    FOR i IN REVERSE 1..10 LOOP
        dbms_output.put_line(i);
    END LOOP;
END;
/

-- [문제9] FOR LOOP문을 이용해서 구구단을 출력해주세요.(2~9단)
BEGIN
    FOR dan IN 2..9 LOOP
        FOR i IN 1..9 LOOP
            dbms_output.put_line(dan || ' * ' || i || ' = ' || dan * i);
        END LOOP;
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..9 LOOP
        FOR dan IN 2..9 LOOP
            dbms_output.put(dan || ' * ' || i || ' = ' || rpad(dan * i, 5));
        END LOOP;
        dbms_output.new_line();
    END LOOP;
END;
/