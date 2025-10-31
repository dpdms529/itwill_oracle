SELECT * FROM user_tab_privs;

SELECT * FROM hr.employees;

SELECT * FROM user_tab_privs;

SELECT * FROM hr.emp;

SELECT * FROM hr.emp_view;

SELECT * FROM all_objects WHERE object_name = 'EMP_VIEW';
SELECT * FROM all_views WHERE view_name = 'EMP_VIEW';
SELECT * FROM all_tables;

SELECT * FROM user_tab_privs;

SELECT * FROM hr.emp_view;

INSERT INTO hr.emp_view(id, name, dept_id) VALUES(300, 'ORACLE', 10);

SELECT * FROM hr.emp_view;

SELECT * FROM hr.emp_view WHERE id = 100;

UPDATE hr.emp_view
SET dept_id = 10
WHERE id = 100;

DELETE FROM hr.emp_view WHERE id = 101;

COMMIT;

desc hr.emp_view;

INSERT INTO hr.emp_view(id, dept_id) VALUES(400, 20);


INSERT INTO hr.emp_view(id, name, dept_id) VALUES(400, 'james', 20);

UPDATE hr.emp_view
SET name = 'my name is KING'
WHERE id = 100;

SELECT * FROM hr.emp_view;

INSERT INTO hr.emp_view(id, name, dept_id) VALUES (500, 'liam', 10);
COMMIT;

UPDATE hr.emp_view
SET dept_id = 50
WHERE id = 201;

DELETE FROM hr.emp_view WHERE id = 201;
rollback;

SELECT * FROM hr.emp_view;