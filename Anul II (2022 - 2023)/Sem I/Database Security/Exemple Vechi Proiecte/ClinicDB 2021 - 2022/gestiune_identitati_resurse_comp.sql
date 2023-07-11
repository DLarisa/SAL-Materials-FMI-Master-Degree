-- First create a pluggable database which will hold only the database from this project
-- To create a pluggable database on another PC, replace E:\Alex\DatabaseSecurity\OracleDB19c with the installation folder of ORACLE
-- Apart from creating the pluggable database, the below command also creates an admin for this pluggable database (it automatically receives connect rights)
-- This admin will be used as the app administrator for our clinic
create pluggable database clinicpdb admin user clinic_admin identified by clinic_admin
FILE_NAME_CONVERT=('E:\Alex\DatabaseSecurity\OracleDB19c\oradata\ORCL\pdbseed', 'E:\Alex\DatabaseSecurity\OracleDB19c\oradata\ORCL\clinicpdb');

-- Open the pluggable database and connect to it
alter session set container=clinicpdb;
alter pluggable database clinicpdb open;
show con_name;

-- The commands from the following section will be runned under sys

-- Create Tablespace for this database
CREATE TABLESPACE clinic DATAFILE 'clinic.dbf' SIZE 100M AUTOEXTEND ON ONLINE;

-- Create the user accounts for our actants
-- For each account we grant 'create session' permission to allow authentification
-- The rest of roles and permisions will be detailed in the 'privs_roles.sql' script

create user clinic_patient1 identified by patient;
grant create session to clinic_patient1;

create user clinic_patient2 identified by patient;
grant create session to clinic_patient2;

create user clinic_patient3 identified by patient;
grant create session to clinic_patient3;

create user clinic_doctor1 identified by doctor;
grant create session to clinic_doctor1;

create user clinic_doctor2 identified by doctor;
grant create session to clinic_doctor2;

create user clinic_chief3 identified by doctor;
grant create session to clinic_chief3;

create user clinic_guest identified by guest;
grant create session to clinic_guest;


-- We assigned quota values for all users
alter user clinic_admin quota unlimited on clinic;
alter user clinic_admin quota unlimited on system;
alter user clinic_doctor1 quota 10M on clinic;
alter user clinic_doctor2 quota 10M on clinic;
alter user clinic_chief3 quota 10M on clinic;
alter user clinic_patient1 quota 0M on clinic;
alter user clinic_patient2 quota 0M on clinic;
alter user clinic_patient3 quota 0M on clinic;
alter user clinic_guest quota 0M on clinic;

select * from dba_ts_quotas where username like 'CLINIC%';

-- We create profiles for our users and assigned them
create profile clinic_profile_guest limit
  sessions_per_user 3
  idle_time 5
  connect_time 30;
  
create profile clinic_profile_doctor_chief_patient limit
  cpu_per_call 6000
  sessions_per_user 1
  password_life_time 90
  failed_login_attempts 5;

alter user clinic_guest profile  clinic_profile_guest;
alter user clinic_doctor1 profile clinic_profile_doctor_chief_patient; 
alter user clinic_doctor2 profile clinic_profile_doctor_chief_patient; 
alter user clinic_chief3 profile clinic_profile_doctor_chief_patient; 
alter user clinic_patient1 profile clinic_profile_doctor_chief_patient; 
alter user clinic_patient2 profile clinic_profile_doctor_chief_patient;
alter user clinic_patient3 profile clinic_profile_doctor_chief_patient;


select * from dba_profiles where lower(profile) like 'clinic%';

-- Adapt the procedure from lab with resource management to our Clinic Database
CREATE OR REPLACE PROCEDURE CLINIC_consummer_plan AS 
  N NUMBER :=0; 
BEGIN  
  DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA();  
  DBMS_RESOURCE_MANAGER.CREATE_PLAN(PLAN => 'CLINIC_PLAN',
                    COMMENT => 'This is a plan for the digital clinic application'); 
  --consumer groups  
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'mgmt', COMMENT => 'Groups the sessions of the users who administer the application');     
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'doctors', COMMENT => 'Groups the sessions of the medical staff'); 
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'patients', COMMENT => 'Groups the sessions of the patients'); 
 
  -- The others group will be created only if it does not already exists            
  SELECT COUNT(*) INTO n 
  FROM DBA_RSRC_CONSUMER_GROUPS 
  WHERE CONSUMER_GROUP='OTHER_GROUPS';  
  
  IF n=0 THEN   
    DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'OTHER_GROUPS', COMMENT => 'This groups the rest of the users');  
  END IF; 
 
  --static mappings of the users to the consumer groups; the users cannot be mapped on the group OTHER_GROUPS  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_ADMIN', 'mgmt');
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_DOCTOR1', 'doctors');
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_DOCTOR2', 'doctors');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_CHIEF3', 'doctors');
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_PATIENT1', 'patients');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_PATIENT2', 'patients');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_PATIENT3', 'patients');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'CLINIC_GUEST', 'patients');  

  --plan directives for each consumer group  
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'CLINIC_PLAN', GROUP_OR_SUBPLAN => 'mgmt', 
                              COMMENT => 'plan directive for the management group', MGMT_P1 => 20); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'CLINIC_PLAN', GROUP_OR_SUBPLAN => 'doctors',        
                              COMMENT => 'plan directive for the staff group', MGMT_P1 => 35);    
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'CLINIC_PLAN', GROUP_OR_SUBPLAN => 'patients',        
                              COMMENT => 'plan directive for patients group', MGMT_P1 => 35); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'CLINIC_PLAN', GROUP_OR_SUBPLAN => 'OTHER_GROUPS',        
                              COMMENT => 'plan directive for the rest of the world', MGMT_P1 => 10); 
 
  DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA();  
  DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA(); 

END; 
/

execute CLINIC_CONSUMMER_PLAN;

select * from DBA_RSRC_CONSUMER_GROUPS where consumer_group in ('MGMT', 'DOCTORS', 'PATIENTS');
