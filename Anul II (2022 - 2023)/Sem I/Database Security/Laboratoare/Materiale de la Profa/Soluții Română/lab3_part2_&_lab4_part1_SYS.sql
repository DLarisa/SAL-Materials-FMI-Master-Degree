--Lab 3, partea 2
--5
show con_name;
alter session set container=orclpdb;

CREATE OR REPLACE PROCEDURE ELEARN_plan_consum AS 
  N NUMBER :=0; 
BEGIN  
  DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA(); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN(PLAN => 'ELEARN_plan1',
                    COMMENT => 'Acesta este un plan pentru aplicatia e-learning'); 
  --grupuri de consum  
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'management', COMMENT => 'Acesta grupeaza sesiunile utilizatorilor care administreaza aplicatia sau catalogul');     
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'tutori', COMMENT => 'Acesta grupeaza sesiunile utilizatorilor care predau'); 
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'receptori', COMMENT => 'Acesta grupeaza sesiunile utilizatorilor care asimileaza informatii'); 
 
  --se va crea doar daca nu exista deja            
  SELECT COUNT(*) INTO n 
  FROM DBA_RSRC_CONSUMER_GROUPS 
  WHERE CONSUMER_GROUP='OTHER_GROUPS';  
  
  IF n=0 THEN   
    DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(CONSUMER_GROUP => 'OTHER_GROUPS', COMMENT => 'Acesta grupeaza RESTUL LUMII');  
  END IF; 
 
  --mapari statice utilizatori pe grupuri consum, nu pot fi mapati pe grupul OTHER_GROUPS  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_APP_ADMIN', 'management');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'OPS$AzureAD\LetitiaMarin', 'management'); 
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_profesor1', 'tutori');  
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_asistent3', 'tutori'); 
 
  DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING(DBMS_RESOURCE_MANAGER.ORACLE_USER, 'ELEARN_student1', 'receptori');  
 
  --directivele de plan pentru fiecare grup de consum  
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'management', 
                              COMMENT => 'directiva de plan pt gr management', MGMT_P1 => 20); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'tutori',        
                              COMMENT => 'directiva de plan pt gr tutori', MGMT_P1 => 30);    
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'receptori',        
                              COMMENT => 'directiva de plan pt gr receptori', MGMT_P1 => 40); 
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'ELEARN_plan1', GROUP_OR_SUBPLAN => 'OTHER_GROUPS',        
                              COMMENT => 'directiva de plan pt gr restul lumii', MGMT_P1 => 10); 
 
  DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA();  
  DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA(); 

END; 
/

execute elearn_plan_consum;

desc dba_rsrc_consumer_groups;
select * from dba_rsrc_consumer_groups;

desc dba_users;

select username, INITIAL_RSRC_CONSUMER_GROUP
from dba_users
where lower(username) like '%elearn%';

desc dba_rsrc_plan_directives;

select distinct u.username, d.group_or_subplan, d.mgmt_p1, plan
from dba_rsrc_plan_directives d left join dba_users u on (d.group_or_subplan = u.INITIAL_RSRC_CONSUMER_GROUP)
order by u.username nulls last;

--Lab4
grant create role to elearn_app_admin;
drop role sel_tema;
drop role update_tema;
