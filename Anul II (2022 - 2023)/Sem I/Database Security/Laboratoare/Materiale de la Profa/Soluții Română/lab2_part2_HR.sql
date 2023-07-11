--3
select count(*) from employees where department_id =100;
delete from employees where department_id=100;

select t.*, to_char(timp, 'dd/mm/yyyy hh24:mi:ss') as Ora 
from sys.tab_audit_emp t;

commit;

select count(*) from employees where department_id =70;

delete from employees where department_id=70;

select t.*, to_char(timp, 'dd/mm/yyyy hh24:mi:ss') as Ora 
from sys.tab_audit_emp t;

rollback;

--4
select count(*) from employees where department_id =70;
update employees 
set salary = 25000 
--where department_id = 70;
where lower(first_name) like 's%';

select t.*, to_char(timp, 'dd/mm/yyyy hh24:mi:ss') as Ora 
from sys.tab_audit_emp t;
commit;

--5
select department_id, manager_id from departments;

update departments 
set manager_id=101
where department_id=130;

rollback;
