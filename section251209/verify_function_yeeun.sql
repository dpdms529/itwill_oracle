CREATE OR REPLACE FUNCTION verify_function_yeeun
(username varchar2,
new_password varchar2,
old_password varchar2)
RETURN boolean
IS
    m integer;
    differ integer;
    reverse_user varchar2(50);
    db_name varchar2(50);
BEGIN
    IF length(new_password) < 8 THEN
        raise_application_error(-20001, '비밀번호는 8글자 이상이어야 합니다.');
    END IF;
    
    IF NLS_LOWER(new_password) = NLS_LOWER(username) THEN
        raise_application_error(-20002, '비밀번호가 유저명과 같습니다.');
    END IF;
    
    IF regexp_like(NLS_LOWER(new_password), '^' || NLS_LOWER(username) || '[0-9]{1,4}$') then
        raise_application_error(-20003, '비밀번호가 유저명과 유사합니다.');
    END IF;
    
    FOR i in REVERSE 1..length(username) LOOP
     reverse_user := reverse_user || substr(username, i, 1);
    END LOOP;
    IF NLS_LOWER(new_password) = NLS_LOWER(reverse_user) THEN
        raise_application_error(-20003, '비밀번호가 유저명과 유사합니다.');
    END IF;
    
    SELECT name INTO db_name FROM sys.v$database;
    IF NLS_LOWER(db_name) = NLS_LOWER(new_password) THEN
        raise_application_error(-20004, '비밀번호가 DB명과 같습니다.');
    END IF;
    
    IF regexp_like(NLS_LOWER(new_password), '^' || NLS_LOWER(db_name) || '[0-9]{1,4}$') then
        raise_application_error(-20005, '비밀번호가 DB명과 유사합니다.');
    END IF;
    
    IF NLS_LOWER(new_password) IN ('welcome1', 'database1', 'account1', 'user1234', 'password1', 'oracle123', 'computer1', 'abcdefg1', 'change_on_install','happy1234') THEN
        raise_application_error(-20006, '비밀번호가 너무 간단합니다.');
    END IF;
    
    IF regexp_like(NLS_LOWER(new_password), '^(oracle|itwill)[0-9]{1,4}$') then
        raise_application_error(-20007, '비밀번호가 너무 간단합니다.');
    END IF;
    
    IF not regexp_like(new_password, '^.*[0-9].*$') then
        raise_application_error(-20008, '비밀번호는 숫자를 하나 이상 포함해야 합니다.');
    END IF;
    
    IF not regexp_like(new_password, '^.*[a-zA-Z].*') then
        raise_application_error(-20009, '비밀번호는 영문자를 하나 이상 포함해야 합니다.');
    END IF;
    
    IF not regexp_like(new_password, '^.*[A-Z].*') then
        raise_application_error(-20010, '비밀번호는 대문자를 하나 이상 포함해야 합니다.');
    END IF;
    
    IF not regexp_like(new_password, '^.*[~!#$%^&*()_+=-].*$') then
        raise_application_error(-20011, '비밀번호는 특수문자를 하나 이상 포함해야 합니다.');
    END IF;
    
    IF old_password IS NOT NULL THEN
        differ := abs(length(old_password) - length(new_password));
        IF differ < 3 THEN
            IF length(new_password) < length(old_password) THEN
                m := length(new_password);
            ELSE
                m := length(old_password);
            END IF;
            
            FOR i IN 1..m LOOP
                IF substr(new_password,i,1) != substr(old_password,i,1) THEN
                    differ := differ + 1;
                END IF;
            END LOOP;

            IF differ < 3 THEN
                raise_application_error(-20012, 'Password should differ from the old password by at least 3 characters');
             END IF;
        END IF;
    END IF;
    RETURN true;
END verify_function_yeeun;
/

begin
    if verify_function_yeeun('insa', 'yeeuN!123', 'oracle4567') then
        dbms_output.put_line('good');
    else
        dbms_output.put_line('bad');
    end if;
end;
/