/**************   Laborator 3   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;



/*** Ex1 ***/
----- Utilizatori autentificați cu OS (Windows)
-- Pt a vedea care e prefixul de sistem (ne tb pt a obține numele user-ului)
SELECT VALUE FROM v$parameter WHERE NAME = 'os_authent_prefix';
show parameter os_authent_prefix;

show parameter remote_os_authent; -- false
-- Setăm următoarele comenzi și după shutdown immediate; și startup; (pt a avea TRUE)
alter session set container=cdb$root;
alter system set remote_os_authent=true scope=spfile;

-- deschidem ORCLPDB
alter session set container = orclpdb; -- este mounted acum pt că am repornit instanța Oracle
alter pluggable database orclpdb open; -- deschidem BD pluggable și acum avem READ, WRITE

/* 
   Creăm user autentificat cu OS
   În CMD: echo %USERDOMAIN%     și     echo %USERNAME%
   USER: "OPS$USERDOMAIN\USERNAME"
   -----------------------------------------------
   According to the requirement of the problem: we create a local account in Windows 
        (named ELEARN_CAT) => DB username = OPS$<domain>\ELEARN_CAT
*/
CREATE USER "OPS$LARISAD\Larisa" IDENTIFIED EXTERNALLY;
GRANT CREATE SESSION TO "OPS$LARISAD\Larisa";

-- Pt a vedea utilizatorii DB
desc dba_users;
SELECT username, account_status, authentication_type, created
FROM dba_users
ORDER BY created DESC;



----- Utilizatori autentificați local
--- Admin
/*
   Nu merge să ne conectăm în SQL Developer, 
   așa că folosim SQL Plus: elearn_app_admin@orclpdb/parolaadmin
   și tot avem eroare.
   ------------------------------------
   În C:\oracle_install\network\admin\tnsnames.ora, adaug:
       orclpdb =
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = orclpdb)
        )
      )
   -----------------------------------
   Și, în Services, restart la serviciile Oracle. E posibil să fim nevoiți să restartăm PC-ul.
   -----------------------------------
   În SQL Plus: elearn_app_admin@orclpdb/parolaadmin
   Și schimbăm parola: admin
*/
create user elearn_app_admin identified by parolaadmin password expire;
grant create session to elearn_app_admin;

-- Observăm că acum elearn_admin este open, cu parolă
SELECT username, account_status, authentication_type, created
FROM dba_users
ORDER BY created DESC;


--- Studenții
create user elearn_student1 identified by student1;
grant create session to elearn_student1;
create user elearn_student2 identified by student2;
grant create session to elearn_student2;
create user elearn_student3 identified by student3;
grant create session to elearn_student3;


-- Profesorii + Asistenții
create user elearn_professor1 identified by professor1;
grant create session to elearn_professor1;
create user elearn_professor2 identified by professor2;
grant create session to elearn_professor2;
create user elearn_assistent3 identified by assistent3;
grant create session to elearn_assistent3;


-- Musafiri
create user elearn_guest identified by guest;
grant create session to elearn_guest;





/*** Ex2 ***/
/*
    Detalii despre sesiunile deschise. 
    În SQL Plus, dacă avem deschis, ELEARN_APP_ADMIN, ne va apărea în tabel.
    Dacă am închis fereastra, atunci tabelul va fi gol.
    Sau putem crea conexiuni noi din SQL Developer.
*/
desc v$session;
SELECT username, status, osuser
FROM v$session
WHERE username LIKE 'ELEARN%';


-- Tabel și Secvența
CREATE SEQUENCE elearn_seq_conex START WITH 1 INCREMENT BY 1;
CREATE TABLE elearn_audit_conex(
    id_conex number(5),
    user_ varchar2(50),
    session_ number(8),
    auth_meth varchar2(40),
    identity_ varchar2(100),
    host_ varchar2(30),
    login_time date,
    logout_time date,
    constraint elearn_audit_conex_pk primary key (id_conex)
);


-- TRIGGERS
create or replace trigger elearn_audit_conex_trigger
after logon on database
BEGIN
    IF user like 'ELEARN%' THEN
        INSERT INTO elearn_audit_conex
        VALUES(elearn_seq_conex.nextval, user, sys_context('userenv', 'sessionid'),
               sys_context('userenv', 'authentication_method'), 
               sys_context('userenv', 'authenticated_identity'),
               sys_context('userenv','host'), sysdate, null);
        commit;
    END IF;   
END;
/

create or replace trigger elearn_audit_deconex_trigger
before logoff on database
BEGIN
    IF (user like 'ELEARN%') THEN
        UPDATE elearn_audit_conex 
        SET logout_time = sysdate
        WHERE user_ = user
        AND session_ = sys_context('userenv', 'sessionid');
        commit;
    END IF;
END;
/

SELECT t.*, TO_CHAR(login_time, 'dd/mm/yyyy hh24:mi:ss') AS "Login Time",
TO_CHAR(logout_time, 'dd/mm/yyyy hh24:mi:ss') AS "Logout Time"
FROM elearn_audit_conex t;





/*** Ex3 ***/
alter user elearn_app_admin quota unlimited on users;
alter user elearn_professor1 quota 2M on users;
alter user elearn_professor2 quota 2M on users;
alter user elearn_assistent3 quota 2M on users;
alter user elearn_student1 quota 0M on users;
alter user elearn_student2 quota 0M on users;
alter user elearn_student3 quota 0M on users;
alter user elearn_guest quota 0M on users;
alter user "OPS$LARISAD\Larisa" quota 10M on users;

-- Informații despre Quotas
desc dba_ts_quotas;
select * from dba_ts_quotas;





/*** Ex4 ***/
-- Guest Profile
create profile elearn_profile_guest limit
   sessions_per_user 3
   idle_time 3
   connect_time 5;
-- Students/Professor Profile
create profile elearn_profile_prof_stud limit
   cpu_per_call 6000
   sessions_per_user 1
   password_life_time 7
   failed_login_attempts 3;

-- Setăm conturile să respecte noile profile
alter user elearn_guest profile elearn_profile_guest;
alter user elearn_professor1 profile elearn_profile_prof_stud; 
alter user elearn_professor2 profile elearn_profile_prof_stud; 
alter user elearn_assistent3 profile elearn_profile_prof_stud; 
alter user elearn_student1 profile elearn_profile_prof_stud; 
alter user elearn_student2 profile elearn_profile_prof_stud; 
alter user elearn_student3 profile elearn_profile_prof_stud; 

desc dba_profiles;
select * from dba_profiles where lower(profile) like 'elearn%';

/*
    Putem testa: professor1 să introducem parola greșită de 3 ori și ne blochează contul.
    Dacă nu se aplică profilele: 
    show parameter resource_limit; -- tb să fie TRUE
    alter system set resource_limit = true;
*/

-- Deblocare cont blocat
alter user elearn_professor1 account unlock;





/*** Ex5 ***/
create or replace procedure elearn_cons_plan as
  n number := 0;
begin
    -- Creare zona de lucru și plan
    dbms_resource_manager.create_pending_area();
    dbms_resource_manager.create_plan(plan => 'ELEARN_PLAN1', comment => 'This is a cosumption plan for the e-learning app.');
    
    -- Grupuri de consum
    dbms_resource_manager.create_consumer_group(consumer_group => 'mngmt', comment => 'Groups the sessions of the users who administer the application or the catalog');     
    dbms_resource_manager.create_consumer_group(consumer_group => 'tutors', comment => 'Groups the sessions of the teaching users'); 
    dbms_resource_manager.create_consumer_group(consumer_group => 'receivers', comment => 'Groups the sessions of the students'); 
    
    -- va fi creat dacă nu există deja
    select count(*) into n
    from dba_rsrc_consumer_groups
    where consumer_group = 'OTHER_GROUPS';
    
    if n = 0 then
      dbms_resource_manager.create_consumer_group(consumer_group => 'OTHER_GROUPS', comment => 'For the rest of the users.'); 
    end if;
    
    -- Mapare între grupuri de consum și users (users nu pot fi OTHER_GROUPS)
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'ELEARN_APP_ADMIN', 'mngmt');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'ELEARN_PROFESSOR1', 'tutors');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'ELEARN_ASSISTENT3', 'tutors');
    dbms_resource_manager.set_consumer_group_mapping(dbms_resource_manager.oracle_user, 'ELEARN_STUDENT1', 'receivers');
    
    -- Planificare directive pentru fiecare grup de consum
    dbms_resource_manager.create_plan_directive(plan => 'ELEARN_PLAN1', group_or_subplan => 'mngmt', 
                              comment => 'Plan directive for the management group', MGMT_P1 => 20);
    dbms_resource_manager.create_plan_directive(plan => 'ELEARN_PLAN1', group_or_subplan => 'tutors', 
                              comment => 'Plan directive for the tutors group', MGMT_P1 => 30);
    dbms_resource_manager.create_plan_directive(plan => 'ELEARN_PLAN1', group_or_subplan => 'receivers', 
                              comment => 'Plan directive for the receivers group', MGMT_P1 => 40);
    dbms_resource_manager.create_plan_directive(plan => 'ELEARN_PLAN1', group_or_subplan => 'OTHER_GROUPS', 
                              comment => 'Plan directive for the other group', MGMT_P1 => 10);
    
    -- Validare zona de lucru
    dbms_resource_manager.validate_pending_area();
    dbms_resource_manager.submit_pending_area();
end;
/

execute elearn_cons_plan;

-- Grupuri de Consum
desc dba_rsrc_consumer_groups;
select * from dba_rsrc_consumer_groups;

-- Utilizatorii și grupurile de consum aferente
desc dba_users;
select username, initial_rsrc_consumer_group 
from dba_users 
where lower(username) like '%elearn%';

-- Users, Grupuri de Consum și Planul de Consum
desc dba_rsrc_plan_directives;
select distinct a.username, c.group_or_subplan, c.mgmt_p1,c.plan 
from dba_rsrc_plan_directives c 
left outer join dba_users a 
on (c.group_or_subplan = a.initial_rsrc_consumer_group) 
-- where c.plan like '%ELEARN_%' 
order by a.username nulls last; 