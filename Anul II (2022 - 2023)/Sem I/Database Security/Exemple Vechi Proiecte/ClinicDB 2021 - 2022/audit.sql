
--- STANDARD AUDIT

-- These commands should be run under sys from the cdb$root container
alter session set container=cdb$root;
alter system set audit_trail = db,extended scope=spfile;
select value from v$parameter where name='audit_trail';-- should be db, extended
show parameter audit_trail; 

-- After this command a reboot of the database should be performed (shutdown immediate + startup)

alter session set container=clinicpdb;

alter pluggable database clinicpdb open;
-- Pornim auditarea pentru a primi informatii legate de instructiunile SELECT lansate de toti utilizatori
audit select table;

-- Run as admin
select * from doctors;
-- Run as patient2
select * from clinic_admin.appointments;
-- Run as chief3
select * from clinic_admin.procedures;


-- Look into the table to see the audited data
select obj$name, sqltext, userid, ntimestamp#
from aud$
where obj$name in ('APPOINTMENTS', 'PROCEDURES', 'DOCTORS')
order by ntimestamp# desc;

-- Stop the standard audit using this command
noaudit select table;


-- TRIGGER AUDIT
create table tab_audit_emp (
  id_secv number(4) primary key,
  user_ varchar2(20),
  session_ number(10),
  host_ varchar2(100),
  timp date);

create sequence secv_aud_emp start with 1 increment by 1;  
  
-- We will monitor appointments as an example for trigger audit
-- Any insert or update on the table will be registered 
create or replace trigger monitor_appointments
after insert or update on clinic_admin.appointments
for each row
begin
  insert into tab_audit_emp values(secv_aud_emp.nextval, sys_context('userenv', 'session_user'),
                                   sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'),
                                   sysdate);
end;
/

-- AUDIT TABLE IS CREATED AND EMPTY
select * from tab_audit_emp;

-- run from clinic_admin
INSERT INTO appointments VALUES(10, 20, 2, 100, sysdate-5, 12);
rollback;

-- AUDIT IS REGISTERED HERE
select * from tab_audit_emp;

--- AUDIT POLICY
-- Run the following commands under sys unless specified otherwise
create or replace procedure proc_audit_alert (
  object_schema varchar2, object_name varchar2, policy_name varchar2)
as
begin
  dbms_output.put_line('Tried to insert a new procedure');
end;
/

create or replace procedure proc_audit_mgr as
begin
  dbms_fga.add_policy (
    object_schema => 'CLINIC_ADMIN',
    object_name => 'PROCEDURES',
    policy_name => 'policy_procedure_insert',
    enable => false,
    statement_types => 'INSERT',
    handler_module => 'PROC_AUDIT_ALERT');
end;
/

execute proc_audit_mgr;

-- Will not be audited
INSERT INTO procedures VALUES(150, 'Operatie de apendicita', 'Interventie chirurgicala pentru extragerea apendicelui', 20, 200);
rollback;

-- This enables the policy
begin 
  dbms_fga.enable_policy( object_schema => 'clinic_admin',
    object_name => 'PROCEDURES',
    policy_name => 'policy_procedure_insert');
end;
/

-- run as clinic_admin
-- This time we will see that the insert will be registered
INSERT INTO procedures VALUES(150, 'Operatie de apendicita', 'Interventie chirurgicala pentru extragerea apendicelui', 100, 200);
rollback;

