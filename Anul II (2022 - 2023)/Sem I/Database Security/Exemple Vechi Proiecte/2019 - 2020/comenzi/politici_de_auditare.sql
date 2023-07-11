create or replace procedure audit_salary as
begin
    dbms_fga.drop_policy(object_schema => 'c##agency_admin', object_name => 'JOB',
        policy_name => 'policy_job');
    dbms_fga.add_policy (
        object_schema => 'c##agency_admin',
        object_name => 'JOB',
        policy_name => 'policy_job',
        audit_column => 'salary',
        enable => false,
        statement_types => 'UPDATE');
        
    dbms_fga.enable_policy(object_schema => 'c##agency_admin',object_name => 'JOB', 
    policy_name => 'policy_job');
end;
/

execute audit_salary;
update job j set j.salary = 30 where id = 1;


-- Ne conectam ca sys si introducem urmatoarele comenzi:
select enabled, policy_name
from all_audit_policies
where object_name ='JOB';

desc dba_fga_audit_trail;

select db_user, userhost, policy_name, sql_text
from dba_fga_audit_trail;