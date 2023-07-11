--------------------------     SYS_LOCAL     --------------------------
----- Audit
-- Configurare mediu de lucru
-- Suntem în ORCLPDB
show con_name;
-- Ne mutam în CDB$ROOT;
alter session set container = CDB$ROOT;
-- Avem XML, EXTENDED
show parameter audit_trail;
-- Dorim să reținem datele audit-ului în BD, așa că trebuie sa ne setam DB, EXTENDED
alter system set audit_trail=db,extended scope=spfile;
-- Acum Avem DB, EXTENDED
show parameter audit_trail;
alter pluggable database orclpdb open;

-- Pentru a vedea auditul standard
select obj$name, sqltext, userid, ntimestamp#
from aud$
order by ntimestamp# desc;



--------------------------     CLINICA_ADMIN     --------------------------
----- Operații de Audit
-- Audit Standard
audit insert, delete, update on consultatie;
audit insert, delete, update on sef1.reteta;
audit insert, delete, update on doctor2.reteta;
audit insert, delete, update on doctor3.reteta;
audit insert, delete, update on doctor4.reteta;

-- Pentru a oprit auditul standard
noaudit insert, delete, update on consultatie;
noaudit insert, delete, update on sef1.reteta;
noaudit insert, delete, update on doctor2.reteta;
noaudit insert, delete, update on doctor3.reteta;
noaudit insert, delete, update on doctor4.reteta;



--------------------------     SEF1     --------------------------
-- Audit Standard
update reteta
set indicatii = 'Odihna'
where id_reteta = 2;
commit;
insert into doctor2.reteta values (1, null, 'OCT recomandat', null, 21, 1);
commit;



--------------------------     DOCTOR2     --------------------------
-- Audit Standard
delete from reteta where id_reteta = 1;
commit;



--------------------------     SYS_LOCAL     --------------------------
--- Trigger Audit 
-- Creare tabel audit
create sequence secventa_audit start with 1 increment by 1;
-- drop table audit_istoric;
create table audit_istoric (
    id_audit number,
    user_ varchar2(30),
    session_ number(10),
    host_ varchar2(100),
    time_ date,
    nume varchar2(20),
    constraint audit_pk primary key (id_audit)
);

-- Configurare Trigger (INSERT și UPDATE pe DOCTOR și SECȚIE)
create or replace trigger audit_trigger_doctor
after insert or update on clinica_admin.doctor
for each row
begin
    insert into audit_istoric values (secventa_audit.nextval, sys_context('userenv', 'session_user'),
                                      sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'),
                                      sysdate, 'DOCTOR');
end;
/

create or replace trigger audit_trigger_sectie
after insert or update on clinica_admin.sectie
for each row
begin
    insert into audit_istoric values (secventa_audit.nextval, sys_context('userenv', 'session_user'),
                                      sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'),
                                      sysdate, 'SECTIE');
end;
/

select * from audit_istoric;



--------------------------     CLINICA_ADMIN     --------------------------
-- Trigger audit
update sectie set id_sef = 31 where id_sectie = 400;
insert into doctor values (35, 'Vasilescu', 'Bianca', '0716369520', 'bvasilescu@clinica.com', 14, 18, 400);
commit;



--------------------------     SYS_LOCAL     --------------------------
--- Politica Audit
-- Handler
create or replace procedure audit_handler(object_schema varchar2, object_name varchar2, policy_name varchar2) as
begin
    dbms_output.put_line('Modififcare Procedura');
end;
/
-- Politica
create or replace procedure proc_audit as
begin
    dbms_fga.add_policy(
        object_schema => 'CLINICA_ADMIN',
        object_name => 'PROCEDURA',
        policy_name => 'politica_procedura',
        enable => false,
        statement_types => 'INSERT',
        handler_module => 'AUDIT_HANDLER'
    );
end;
/
execute proc_audit;
-- Trebuie activata mai întâi
begin
    dbms_fga.enable_policy(
        object_schema => 'CLINICA_ADMIN',
        object_name => 'PROCEDURA',
        policy_name => 'politica_procedura'
    );
end;
/
-- Detalii politici
select db_user, userhost, policy_name, timestamp, sql_text
from dba_fga_audit_trail
where db_user like 'CLINICA_ADMIN';



--------------------------     CLINICA_ADMIN     --------------------------
-- Politica Audit
insert into procedura values (106, 'Analize Test Sofer', 20, 100);
rollback;