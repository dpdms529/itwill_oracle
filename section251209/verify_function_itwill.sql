
CREATE OR REPLACE FUNCTION verify_function_itwill
(username varchar2,
  new_password varchar2,
  old_password varchar2)
  RETURN boolean 
IS 
   m integer;
   differ integer;
   isdigit boolean;
   ischar  boolean;
   isupper boolean;
   isspecial boolean;
   db_name varchar2(40);
   digitarray varchar2(20);
   chararray varchar2(52);
   upperarray varchar2(26);
   specialarray varchar2(14);
   simple_password varchar2(10);
   reverse_user varchar2(32);

BEGIN 
   digitarray:= '0123456789';
   chararray:= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   upperarray:= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   specialarray:= '~!#$%^&*()-_=+';

   IF length(new_password) < 8 THEN
      raise_application_error(-20001, 'Password length less than 8');
   END IF;

   IF NLS_LOWER(new_password) = NLS_LOWER(username) THEN
     raise_application_error(-20002, 'Password same as or similar to user');
   END IF;
   FOR i IN 1..1000 LOOP
        IF NLS_LOWER(username)|| to_char(i) = NLS_LOWER(new_password) THEN
            raise_application_error(-20005, 'Password same as or similar to user name ');
        END IF;
    END LOOP;

  
   FOR i in REVERSE 1..length(username) LOOP
     reverse_user := reverse_user || substr(username, i, 1);
   END LOOP;
   IF NLS_LOWER(new_password) = NLS_LOWER(reverse_user) THEN
     raise_application_error(-20003, 'Password same as username reversed');
   END IF;

   
   SELECT name INTO db_name FROM SYS.v$database;
   IF NLS_LOWER(db_name) = NLS_LOWER(new_password) THEN
      raise_application_error(-20004, 'Password same as or similar to db name');
   END IF;
   FOR i IN 1..1000 LOOP
      IF NLS_LOWER(db_name)|| to_char(i) = NLS_LOWER(new_password) THEN
        raise_application_error(-20005, 'Password same as or similar to db name');
      END IF;
    END LOOP;

   IF NLS_LOWER(new_password) IN ('welcome1', 'database1', 'account1', 'user1234', 'password1', 'oracle123', 'computer1', 'abcdefg1', 'change_on_install','happy1234') THEN
      raise_application_error(-20006, 'Password too simple');
   END IF;


    simple_password := 'oracle';
    FOR i IN 1..1000 LOOP
      IF simple_password || to_char(i) = NLS_LOWER(new_password) THEN
        raise_application_error(-20007, 'Password too simple');
      END IF;
    END LOOP;

   simple_password := 'itwill';
    FOR i IN 1..1000 LOOP
      IF simple_password || to_char(i) = NLS_LOWER(new_password) THEN
        raise_application_error(-20007, 'Password too simple');
      END IF;
    END LOOP;
    
  
   isdigit:=FALSE;
   m := length(new_password);
   FOR i IN 1..10 LOOP 
      FOR j IN 1..m LOOP 
         IF substr(new_password,j,1) = substr(digitarray,i,1) THEN
            isdigit:=TRUE;
             GOTO findchar;
         END IF;
      END LOOP;
   END LOOP;

   IF isdigit = FALSE THEN
      raise_application_error(-20008, 'Password must contain at least one digit, one character');
   END IF;
  
   <<findchar>>
   ischar:=FALSE;
   FOR i IN 1..length(chararray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(new_password,j,1) = substr(chararray,i,1) THEN
            ischar:=TRUE;
             GOTO findupper;
         END IF;
      END LOOP;
   END LOOP;
   IF ischar = FALSE THEN
      raise_application_error(-20009, 'Password must contain at least one digit, and one character');
   END IF;
   
   <<findupper>>
   isupper:=FALSE;
   FOR i IN 1..length(upperarray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(new_password,j,1) = substr(upperarray,i,1) THEN
            isupper:=TRUE;
             GOTO findspecial;
         END IF;
      END LOOP;
   END LOOP;
   IF isupper = FALSE THEN
      raise_application_error(-20010, 'Password must contain at least one digit, and one character');
   END IF;
   
   <<findspecial>>
   isspecial:=FALSE;
   FOR i IN 1..length(specialarray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(new_password,j,1) = substr(specialarray,i,1) THEN
            isspecial:=TRUE;
             GOTO endsearch;
         END IF;
      END LOOP;
   END LOOP;
   IF isspecial = FALSE THEN
      raise_application_error(-20011, 'Password must contain at least one digit, and one character');
   END IF;

   <<endsearch>>
  
   IF old_password IS NOT NULL THEN
     differ := length(old_password) - length(new_password);

     differ := abs(differ);
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
   
   RETURN(TRUE);
END verify_function_itwill;
/

begin
    if verify_function_itwill('insa', 'Oracle1234!', 'oracle4567') then
        dbms_output.put_line('good');
    else
        dbms_output.put_line('bad');
    end if;
end;
/