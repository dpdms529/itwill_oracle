SELECT * FROM user_tab_privs;

SELECT * FROM hr.seq_test;
-- 접근 가능한 오브젝트 정보 조회
SELECT * FROM all_objects WHERE object_name = 'ID_SEQ';
-- 접근 가능한 시퀀스 정보 조회
SELECT * FROM all_sequences WHERE sequence_name = 'ID_SEQ';

INSERT INTO hr.seq_test(id, name, day) VALUES(hr.id_seq.nextval, 'owen', localtimestamp);
SELECT * FROM hr.seq_test;
COMMIT;

-- 권한 회수 후 실행시 오류 발생
INSERT INTO hr.seq_test(id, name, day) VALUES(hr.id_seq.nextval, 'james', localtimestamp);
-- ORA-00942: table or view does not exist

-- synonym 조회
SELECT * FROM user_tab_privs;
SELECT * FROM hr.emp_copy_2025;
SELECT * FROM hr.ec;
SELECT * FROM ec;

SELECT * FROM all_synonyms WHERE table_owner = 'HR' AND table_name = 'EMP_COPY_2025';

SELECT * FROM user_tab_privs;
SELECT * FROM hr.emp_copy_2025;
SELECT * FROM hr.ec;
SELECT * FROM ec;
