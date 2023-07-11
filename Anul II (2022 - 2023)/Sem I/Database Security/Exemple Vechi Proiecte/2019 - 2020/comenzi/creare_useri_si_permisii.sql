-- Drop some Users
drop user c##employee1 CASCADE;
drop user c##employee2 CASCADE;
drop user c##employee3 CASCADE;
drop user c##employee4 CASCADE;

drop user c##agency_admin CASCADE;
drop user  c##agency_boss CASCADE;
drop user c##manager1 CASCADE;
drop user c##manager2 CASCADE;
drop user c##manager3 CASCADE;
drop user c##tourism_agent1 CASCADE;
drop user c##tourism_agent2 CASCADE;
drop user c##tourism_agent3 CASCADE;
drop user c##economist1 CASCADE;
drop user c##economist2 CASCADE;
drop user c##economist3 CASCADE;
drop user c##hr1 CASCADE;
drop user c##hr2 CASCADE;
drop user c##hr3 CASCADE;

drop role C##agency_manager;
drop role  C##agency_administrator;
drop role  C##tourism_agent;
drop role  C##agency_economist;
drop role  C##agency_hr;
drop role  C##agency_owner;
drop role  C##agency_employee;


-- Create User Employee
create user c##employee1 identified by "employee";
create user c##employee2 identified by "employee";
create user c##employee3 identified by "employee";
create user c##employee4 identified by "employee";

-- Create User Administrator
create user c##agency_admin identified by "admin";

-- Create User Angency Onwer
create user c##agency_boss identified by "owner";

-- Create User Manager
create user c##manager1 identified by "manager";
create user c##manager2 identified by "manager";
create user c##manager3 identified by "manager";

-- Create User Tourism Angent
create user c##tourism_agent1 identified by "tourism";
create user c##tourism_agent2 identified by "tourism";
create user c##tourism_agent3 identified by "tourism";

-- Create User Economist
create user c##economist1 identified by "economist";
create user c##economist2 identified by "economist";
create user c##economist3 identified by "economist";

-- Create User HR
create user c##hr1 identified by "hr";
create user c##hr2 identified by "hr";
create user c##hr3 identified by "hr";


-- Create Roles
CREATE ROLE C##agency_manager;
CREATE ROLE C##agency_administrator;
CREATE ROLE C##tourism_agent;
CREATE ROLE C##agency_economist;
CREATE ROLE C##agency_hr;
CREATE ROLE C##agency_owner;
CREATE ROLE C##agency_employee;

-- GIVE Roles to Users
GRANT C##agency_manager to c##manager1;
GRANT C##agency_manager to c##manager2;
GRANT C##agency_manager to c##manager3;
GRANT C##agency_administrator to c##agency_admin;
GRANT C##tourism_agent to c##tourism_agent1;
GRANT C##tourism_agent to c##tourism_agent2;
GRANT C##tourism_agent to c##tourism_agent3;
GRANT C##agency_economist to c##economist1;
GRANT C##agency_economist to c##economist2;
GRANT C##agency_economist to c##economist3;
GRANT C##agency_hr to c##hr1;
GRANT C##agency_hr to c##hr2;
GRANT C##agency_hr to c##hr3;
GRANT C##agency_hr to c##hr3;
GRANT C##agency_owner to c##agency_boss;
GRANT C##agency_employee to c##employee1;
GRANT C##agency_employee to c##employee2;
GRANT C##agency_employee to c##employee3;
GRANT C##agency_employee to c##employee4;


-- GRANT QUOTA: 100 admin, 10 owner, 50 rest of them
alter user c##manager1 quota 50M on USERS;
alter user c##manager2 quota 50M on USERS;
alter user c##manager3 quota 50M on USERS;
alter user c##tourism_agent1 quota 50M on USERS;
alter user c##tourism_agent2 quota 50M on USERS;
alter user c##tourism_agent3 quota 50M on USERS;
alter user c##economist1 quota 50M on USERS;
alter user c##economist2 quota 50M on USERS;
alter user c##economist3 quota 50M on USERS;
alter user c##hr1 quota 50M on USERS;
alter user c##hr2 quota 50M on USERS;
alter user c##hr3 quota 50M on USERS;
alter user  c##employee1 quota 50M on USERS;
alter user c##employee2 quota 50M on USERS;
alter user  c##employee3 quota 50M on USERS;
alter user  c##employee4 quota 50M on USERS;
alter user c##agency_admin quota 100M on USERS;
alter user c##agency_boss quota 10M on USERS;



-- Connection Rights
--grant CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK, CREATE MATERIALIZED VIEW,
--CREATE ANY PROCEDURE, CREATE PUBLIC SYNONYM, CREATE ROLE, CREATE SEQUENCE, CREATE SYNONYM,
--CREATE TABLE, CREATE TRIGGER, CREATE TYPE, CREATE VIEW, RESOURCE to C##agency_administrator;
--GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE to c##agency_admin;

-- Create Table Rights and Session rights
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##agency_manager;
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##agency_administrator;
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##tourism_agent;
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##agency_economist;
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##agency_hr;
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##agency_owner;
GRANT CREATE TABLE, CREATE VIEW, CREATE SESSION, ALTER SESSION, RESOURCE, CREATE ANY PROCEDURE TO C##agency_employee;


-- Grant all permisions to agency_administrator
--grant CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK, CREATE MATERIALIZED VIEW,
--CREATE PROCEDURE, CREATE PUBLIC SYNONYM, CREATE ROLE, CREATE SEQUENCE, CREATE SYNONYM,
--CREATE TABLE, CREATE TRIGGER, CREATE TYPE, CREATE VIEW to C##agency_administrator;

-- Grant Permisions for table Leave_Request
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.leave_request TO C##agency_manager;
--GRANT SELECT, INSERT, UPDATE         ON c##agency_admin.leave_request TO C##agency_administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.leave_request TO C##tourism_agent;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.leave_request TO C##agency_economist;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.leave_request TO C##agency_hr;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.leave_request TO C##agency_employee;

-- Grant Permisions for table Daily_Hours
GRANT SELECT, UPDATE, DELETE ON c##agency_admin.daily_hours TO C##agency_manager;
--GRANT SELECT, UPDATE,DELETE  ON C##agency_administrator.daily_hours TO C##agency_administrator;
GRANT SELECT, UPDATE, DELETE ON c##agency_admin.daily_hours TO C##tourism_agent;
GRANT SELECT, UPDATE, DELETE ON c##agency_admin.daily_hours TO C##agency_economist;
GRANT SELECT ON c##agency_admin.daily_hours TO C##agency_owner;
GRANT SELECT, UPDATE, DELETE ON c##agency_admin.daily_hours TO C##agency_employee;




-- Grant Permisions for table Job
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.job TO C##agency_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.job TO C##agency_owner;


-- Grant Permisions for table Contract
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.contract TO C##agency_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.contract  TO C##tourism_agent;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.contract TO C##agency_owner;


-- Grant Permisions for table CREDENTIAL
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.credential TO C##agency_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.leave_request TO C##agency_administrator;
GRANT INSERT, UPDATE, DELETE ON c##agency_admin.credential TO C##tourism_agent;
GRANT INSERT, UPDATE, DELETE ON c##agency_admin.credential TO C##agency_economist;
GRANT INSERT, UPDATE, DELETE ON c##agency_admin.credential TO C##agency_hr;
GRANT SELECT ON c##agency_admin.credential TO C##agency_owner;
GRANT INSERT, UPDATE, DELETE ON c##agency_admin.credential TO C##agency_employee;


-- Grant Permisions for table KEY
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.key TO C##agency_administrator;


-- Grant Permisions for table Employee
GRANT SELECT ON c##agency_admin.employee TO C##agency_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON c##agency_admin.employee TO C##agency_administrator;
GRANT SELECT ON c##agency_admin.employee TO C##tourism_agent;
GRANT SELECT ON c##agency_admin.employee TO C##agency_economist;
GRANT SELECT ON c##agency_admin.employee TO C##agency_hr;
GRANT SELECT ON c##agency_admin.employee TO C##agency_owner;
GRANT SELECT ON c##agency_admin.employee TO C##agency_employee;


grant ALL ON dbms_crypto TO C##agency_administrator;


GRANT EXECUTE ON dbms_crypto TO C##agency_manager;
GRANT EXECUTE ON dbms_crypto TO C##agency_administrator;
GRANT EXECUTE ON dbms_crypto TO C##tourism_agent;
GRANT EXECUTE ON dbms_crypto TO C##agency_economist;
GRANT EXECUTE ON dbms_crypto TO C##agency_hr;
GRANT EXECUTE ON dbms_crypto TO C##agency_owner;
GRANT EXECUTE ON dbms_crypto TO C##agency_employee;


GRANT EXECUTE ON dbms_fga TO C##agency_manager;
GRANT EXECUTE ON dbms_fga TO C##agency_administrator;
GRANT EXECUTE ON dbms_fga TO C##tourism_agent;
GRANT EXECUTE ON dbms_fga TO C##agency_economist;
GRANT EXECUTE ON dbms_fga TO C##agency_hr;
GRANT EXECUTE ON dbms_fga TO C##agency_owner;
GRANT EXECUTE ON dbms_fga TO C##agency_employee;
GRANT EXECUTE ON dbms_fga TO c##agency_admin;
