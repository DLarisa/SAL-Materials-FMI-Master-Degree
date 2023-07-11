drop table audit_job;
drop trigger audit_salary;
create sequence elearn_secv_conex start with 1 increment by 1;
create table audit_job (
  id number(8) primary key,
  utilizator varchar2(30),
  cod_sesiune number(8),
  metoda_authentif varchar2(40),
  identitate varchar2(100),
  host varchar2(30),
  timp_login date, 
  timp_logout date,
  old_salary number(4),
  new_salary number(4));
  
create or replace trigger audit_salary
before update on job
for each row
begin
    --old_salary := :old.salary;
    
    insert into audit_job
    values(elearn_secv_conex.nextval, user, sys_context('userenv', 'sessionid'),
           sys_context('userenv', 'authentication_method'),
           sys_context('userenv', 'authenticated_identity'),
           sys_context('userenv', 'host'), sysdate, null, :old.salary, :new.salary);
end;
/


update job j set j.salary = 30 where id = 1;

select *
from audit_job;

