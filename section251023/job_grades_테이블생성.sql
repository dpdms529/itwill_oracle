DROP TABLE hr.job_grades purge;
CREATE TABLE hr.job_grades
( grade_level varchar2(3),
  lowest_sal  number,
  highest_sal number);

INSERT INTO hr.job_grades VALUES ('A',1000,2999);
INSERT INTO hr.job_grades VALUES ('B',3000,5999);
INSERT INTO hr.job_grades VALUES ('C',6000,9999);
INSERT INTO hr.job_grades VALUES ('D',10000,14999);
INSERT INTO hr.job_grades VALUES ('E',15000,24999);
INSERT INTO hr.job_grades VALUES ('F',25000,40000);
commit;

SELECT * FROM hr.job_grades;