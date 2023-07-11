--3
show con_name;

alter session set container = orclpdb;
show con_name;

drop table tab_audit_emp;
create table tab_audit_emp (
  id_secv number(4) primary key,
  user_ varchar2(20),
  session_ number(10),
  host_ varchar2(100),
  timp date,
  delta_records number(5));
  
drop sequence secv_aud_emp;
create sequence secv_aud_emp start with 1 increment by 1;

create or replace trigger audit_employees_before
before delete on hr.employees
declare
  nr_rec_before number;
begin
  select count(*) into nr_rec_before from hr.employees;
  
  dbms_output.put_line('Nb records before delete: ' || nr_rec_before);
  
  insert into tab_audit_emp values(secv_aud_emp.nextval, sys_context('userenv', 'session_user'),
                       sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'),
                       sysdate, nr_rec_before);
end;
/

create or replace trigger audit_employees_after
after delete on hr.employees
declare
  nr_rec_after number;
  nr_rec_before number;
  current_session varchar2(100);
  id_rec_audit number;
begin
  select count(*) into nr_rec_after from hr.employees;
  
  dbms_output.put_line('Nb records after delete: ' || nr_rec_after);
  
  select sys_context('userenv', 'sessionid') into current_session from dual;
  
  select max(id_secv) into id_rec_audit from tab_audit_emp where session_ = current_session;
  
  select delta_records into nr_rec_before from tab_audit_emp 
  where id_secv = id_rec_audit;
  
  update tab_audit_emp
  set delta_records = nr_rec_before - nr_rec_after
  where id_secv = id_rec_audit;
  --commit;? --> NU  
end;
/

select * from tab_audit_emp;
grant select on tab_audit_emp to hr;

select t.*, to_char(timp, 'dd/mm/yyyy hh24:mi:ss') as Ora 
from sys.tab_audit_emp t;

select count(*) from hr.employees where department_id =100;

desc user_triggers;
select trigger_name, trigger_type, status
from user_triggers
where lower(trigger_name) like '%audit_employees%';

--4
create or replace trigger limit_salary
after insert or update of salary on hr.employees
for each row 
when (new.salary > 20000)
begin
  insert into tab_audit_emp values (secv_aud_emp.nextval, sys_context('userenv', 'session_user'),
                       sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'), sysdate,
                       -1);
end;
/

select t.*, to_char(timp, 'dd/mm/yyyy hh24:mi:ss') as Ora 
from sys.tab_audit_emp t;

--5
create or replace procedure proc_audit_alert (object_schema varchar2, object_name varchar2, 
                                              policy_name varchar2)
as
begin
  dbms_output.put_line('Incercare modificare sef departament');
end;
/

create or replace procedure proc_audit_mgr as
begin
  dbms_fga.add_policy(
    object_schema => 'HR',
    object_name => 'DEPARTMENTS',
    policy_name => 'policy_mgr_dept',
    enable => false,
    statement_types => 'UPDATE',
    handler_module => 'PROC_AUDIT_ALERT');
end;
/

desc all_audit_policies;

select object_schema, object_name, policy_name, enabled
from all_audit_policies;

execute proc_audit_mgr;

begin
  dbms_fga.enable_policy(object_schema => 'HR',
    object_name => 'DEPARTMENTS',
    policy_name => 'policy_mgr_dept');
end;
/

desc dba_fga_audit_trail;

select db_user, userhost, policy_name, to_char(timestamp, 'dd/mm/yyyy hh24:mi:ss') Time, sql_text
from dba_fga_audit_trail
order by timestamp desc;

begin
  dbms_fga.disable_policy(object_schema => 'HR',
    object_name => 'DEPARTMENTS',
    policy_name => 'policy_mgr_dept');
end;
/