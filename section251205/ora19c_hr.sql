update hr.employees
set salary = salary * 1.1
where employee_id = 110;

rollback;