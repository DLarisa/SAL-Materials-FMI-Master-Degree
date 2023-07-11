show con_name;

select username, authentication_type, account_status, expiry_date, created from dba_users
order by created desc;

alter session set container=salpdb;

select * from elearn_audit_conex;
select t.*, to_char(login_time, 'dd/mm/yyyy hh24:mi:ss') as "Time login",
       to_char(logout_time, 'dd/mm/yyyy hh24:mi:ss') as "Time logout"
from elearn_audit_conex t;

--3
--alter session set container=cdb$root;
--alter session set container=orclpdb; -- the other PDB - we used both orclpdb and salpdb in this lab, but the goal is to keep only salpdb

alter user elearn_app_admin quota unlimited on users;
alter user elearn_professor1 quota 2M on users;
alter user elearn_professor2 quota 2M on users;
alter user elearn_assistant3 quota 2M on users;
alter user elearn_student1 quota 0M on users;
alter user elearn_student2 quota 0M on users;
alter user elearn_guest quota 0M on users;
alter user "OPS$AzureAD\LetitiaMarin" quota 10M on users;

desc dba_ts_quotas;
select * from dba_ts_quotas;

--4
create profile elearn_profile_guest limit
  sessions_per_user 3
  idle_time 3
  connect_time 5;
  
create profile elearn_profile_prof_stud limit
  cpu_per_call 6000
  sessions_per_user 1
  password_life_time 7
  failed_login_attempts 3;
  
alter user elearn_guest profile  elearn_profile_guest;
alter user elearn_professor1 profile elearn_profile_prof_stud; 
alter user elearn_professor2 profile elearn_profile_prof_stud; 
alter user elearn_assistant3 profile elearn_profile_prof_stud; 
alter user elearn_student1 profile elearn_profile_prof_stud; 
alter user elearn_student2 profile elearn_profile_prof_stud; 

desc dba_profiles;
select * from dba_profiles where lower(profile) like 'elearn%';

show parameter resource_limit;
alter system set resource_limit=true;

--5
CREATE OR REPLACE PROCEDURE ELEARN_plan_consum AS 
  N NUMBER :=0; 
BEGIN  
  DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA();  
  DBMS_RESOURCE_MANAGER.CREATE_PLAN(PLAN => 'ELEARN_plan1',
                    COMMENT => 'This is a plan for the e-learning application'); 
  --consumer groups  
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'mgmt', COMMENT => 'Groups the sessions of the users who administer the application or the catalog');     
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'tutors', COMMENT => 'Groups the sessions of the teaching users'); 
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'receivers', COMMENT => 'Groups the sessions of the students'); 
 
  --it will be created only if it does not already exists            
  SELECT COUNT(*) INTO n 
  FROM DBA_RSRC_CONSUMER_GROUPS 
  WHERE CONSUMER_GROUP='OTHER_GROUPS';  
  
  IF n=0 THEN   
    DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'OTHER_GROUPS', COMMENT => 'Acesta grupeaza RESTUL LUMII');  
  END IF; 
 
  --static mappings of the users to the consumer groups; the users cannot be mapped on the group OTHER_GROUPS  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_APP_ADMIN', 'mgmt');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'OPS$AzureAD\LetitiaMarin', 'mgmt'); 
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_professor1', 'tutors');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_assistant3', 'tutors'); 
 
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_student1', 'receivers');  
 
  --plan directives for each consumer group  
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'mgmt', 
                              COMMENT => 'plan directive for the management group', MGMT_P1 => 20); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'tutors',        
                              COMMENT => 'plan directive for tutors group', MGMT_P1 => 30);    
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'receivers',        
                              COMMENT => 'plan directive for receivers group', MGMT_P1 => 40); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'OTHER_GROUPS',        
                              COMMENT => 'plan directive for the rest of the world', MGMT_P1 => 10); 
 
  DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA();  
  DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA(); 

END; 
/

execute elearn_plan_consum;

desc DBA_RSRC_CONSUMER_GROUPS;
select * from DBA_RSRC_CONSUMER_GROUPS;

desc dba_users;

select username, INITIAL_RSRC_CONSUMER_GROUP from dba_users 
where lower(username) like '%elearn%';

desc dba_rsrc_plan_directives;
SELECT DISTINCT A.USERNAME,C.group_or_subplan, C.MGMT_P1,C.PLAN 
FROM DBA_RSRC_PLAN_DIRECTIVES C LEFT OUTER JOIN DBA_USERS A 
ON (C.group_or_subplan=A.INITIAL_RSRC_CONSUMER_GROUP) 
--WHERE C.PLAN LIKE '%ELEARN_%' 
ORDER BY A.USERNAME NULLS LAST; 