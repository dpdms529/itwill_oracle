SELECT * 
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'))
PIVOT (max(cnt) FOR year in ('2001' "2001", '2002' "2002", '2003' "2003", '2004' "2004", '2005' "2005", '2006' "2006", '2007' "2007", '2008' "2008"));

SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'))
PIVOT (max(cnt) FOR year in (select to_char(hire_date, 'yyyy') from hr.employees));

SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'))
PIVOT XML (max(cnt) FOR year in (select to_char(hire_date, 'yyyy') from hr.employees));

SELECT XMLSERIALIZE(CONTENT year_xml as clob indent size = 2) as xml_text
from (
SELECT *
FROM (SELECT to_char(hire_date, 'yyyy') year, count(*) cnt
        FROM hr.employees
        GROUP BY to_char(hire_date, 'yyyy'))
PIVOT xml (max(cnt) FOR year in (select to_char(hire_date, 'yyyy') from hr.employees))
);




        