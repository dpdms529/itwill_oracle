SELECT * FROM user_tab_privs;

desc hr.update_proc;

exec hr.update_proc(200);

COMMIT;

SELECT * FROM user_tab_privs;

SELECT * FROM hr.emp_details;

INSERT INTO hr.emp_details(id, sal, dept_id, dept_name) VALUES(300, 2000, 60, 'IT');

COMMIT;

UPDATE hr.emp_details
SET sal = sal * 1.1
WHERE id = 300;

DELETE FROM hr.emp_details WHERE id = 300;

COMMIT;

SELECT * FROM hr.emp_details;