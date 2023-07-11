-------------------      sys_local      ------------------- 
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;

-- Verificăm în ce conexiune ne aflăm (CDB$ROOT)
show con_name;
-- Ne mutăm în baza de date pluggable (orclpdb
alter session set container = orclpdb;
-- Verificăm să avem privilegii de READ/WRITE
select name, open_mode from v$pdbs;


-- Creăm userul clinica_admin și oferim privilegii
create user clinica_admin identified by clinica_admin password expire;
grant create session to clinica_admin;
grant create user to clinica_admin;
-- Verificăm dacă user-ul a fost creat cu succes
select username, account_status, authentication_type, created
from dba_users where username like 'CLINICA_ADMIN';
-- Verificăm dacă users creați de clinica_admin au fost creați cu succes
select username, account_status, authentication_type, created
from dba_users order by created desc;



-------------------      clinica_admin      ------------------- 
-- Creare users
create user sef1 identified by sef1;
create user doctor2 identified by doctor2;
create user doctor3 identified by doctor3;
create user doctor4 identified by doctor4;
create user asistenta1 identified by asistenta1;
create user asistenta2 identified by asistenta2;
create user asistenta3 identified by asistenta3;
create user pacient1 identified by pacient1;
create user pacient2 identified by pacient2;
create user pacient3 identified by pacient3;
create user vizitator identified by vizitator;



-------------------      sys_local      ------------------- 
----- Oferim resurse utilizatorilor
-- Memorie
alter user clinica_admin quota unlimited on users;
alter user vizitator quota 0M on users;
alter user asistenta1 quota 0M on users;
alter user asistenta2 quota 0M on users;
alter user asistenta3 quota 0M on users;
alter user pacient1 quota 0M on users;
alter user pacient2 quota 0M on users;
alter user pacient3 quota 0M on users;
alter user sef1 quota 5M on users;
alter user doctor2 quota 5M on users;
alter user doctor3 quota 5M on users;
alter user doctor4 quota 5M on users;
-- Vedem informațiile despre memoria alocată
select * from dba_ts_quotas where tablespace_name like 'USERS';


-- Profile (detalii sesiune, idle_time, failed_login_attempts, password_life_time, etc...)
create profile profil_vizitator limit
    sessions_per_user 3
    idle_time 5
    connect_time 30;
alter user vizitator profile profil_vizitator;

create profile profil_angajat limit
    sessions_per_user 1
    password_life_time 90
    failed_login_attempts 3
    cpu_per_call 6000
    idle_time 15;
alter user sef1 profile profil_angajat;
alter user doctor2 profile profil_angajat;
alter user doctor3 profile profil_angajat;
alter user doctor4 profile profil_angajat;
alter user asistenta1 profile profil_angajat;
alter user asistenta2 profile profil_angajat;
alter user asistenta3 profile profil_angajat;

create profile profil_pacient limit
    sessions_per_user 1
    failed_login_attempts 10
    cpu_per_call 6000
    idle_time 15;
alter user pacient1 profile profil_pacient;  
alter user pacient2 profile profil_pacient;
alter user pacient3 profile profil_pacient;
-- Vizualizare informații despre profile
select * from dba_profiles where profile like 'PROFIL%';
-- Deblocare cont blocat
alter user asistenta3 account unlock;


-- Plan de Consum CPU
create or replace procedure clinica_plan_cpu as
  nr number := 0;
begin
    -- Creare zona de lucru și plan
    dbms_resource_manager.create_pending_area();
    dbms_resource_manager.create_plan(plan => 'CLINICA_PLAN_CPU', comment => 'Plan de consumptie pentru clinica privata.');
    
    -- Grupuri de consum
    dbms_resource_manager.create_consumer_group(consumer_group => 'admin', comment => 'Grup de sesiune pt administratori bd.');     
    dbms_resource_manager.create_consumer_group(consumer_group => 'angajati', comment => 'Grup de sesiune pt angajati.'); 
    dbms_resource_manager.create_consumer_group(consumer_group => 'pacienti', comment => 'Grup de sesiune pt pacienti.');
    
    -- Va fi creat dacă nu există deja
    select count(*) into nr
    from dba_rsrc_consumer_groups
    where consumer_group = 'OTHER_GROUPS';
    
    if nr = 0 then
      dbms_resource_manager.create_consumer_group(consumer_group => 'OTHER_GROUPS', comment => 'Grup de sesiune pt vizitatori.'); 
    end if;
    
    -- Mapare între grupuri de consum și users (users nu pot fi OTHER_GROUPS)
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'clinica_admin', 'admin');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'sef1', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'doctor2', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'doctor3', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'doctor4', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'asistenta1', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'asistenta2', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'asistenta3', 'angajati');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'pacient1', 'pacienti');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'pacient2', 'pacienti');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'pacient3', 'pacienti');
    
    -- Planificare directive (CPU) pentru fiecare grup de consum
    dbms_resource_manager.create_plan_directive(plan => 'CLINICA_PLAN_CPU', group_or_subplan => 'admin', 
                              comment => 'Planificare directiva pt administratori.', MGMT_P1 => 30);
    dbms_resource_manager.create_plan_directive(plan => 'CLINICA_PLAN_CPU', group_or_subplan => 'angajati', 
                              comment => 'Planificare directiva pt angajati.', MGMT_P1 => 35);
    dbms_resource_manager.create_plan_directive(plan => 'CLINICA_PLAN_CPU', group_or_subplan => 'pacienti', 
                              comment => 'Planificare directiva pt pacienti.', MGMT_P1 => 25);
    dbms_resource_manager.create_plan_directive(plan => 'CLINICA_PLAN_CPU', group_or_subplan => 'OTHER_GROUPS', 
                              comment => 'Planificare directiva pt vizitatori.', MGMT_P1 => 10);
    
    -- Validare zona de lucru și submit
    dbms_resource_manager.validate_pending_area();
    dbms_resource_manager.submit_pending_area();
end;
/
execute clinica_plan_cpu;
-- Pentru a vedea userii, grupul de sesiune și planul de consum
select distinct a.username, c.group_or_subplan, c.mgmt_p1,c.plan 
from dba_rsrc_plan_directives c 
left outer join dba_users a 
on (c.group_or_subplan = a.initial_rsrc_consumer_group) 
order by a.username nulls last; 