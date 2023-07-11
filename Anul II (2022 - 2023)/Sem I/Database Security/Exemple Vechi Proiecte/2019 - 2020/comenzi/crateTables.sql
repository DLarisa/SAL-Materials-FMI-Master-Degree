drop table  credential CASCADE CONSTRAINTS PURGE;
drop table key CASCADE CONSTRAINTS PURGE;
drop table  job_history CASCADE CONSTRAINTS PURGE;
drop table daily_hours CASCADE CONSTRAINTS PURGE;
drop table employee CASCADE CONSTRAINTS PURGE;
drop table contract CASCADE CONSTRAINTS PURGE;
drop table  job CASCADE CONSTRAINTS PURGE;
drop table  department CASCADE CONSTRAINTS PURGE;
drop table leave_request CASCADE CONSTRAINTS PURGE;
drop sequence s_key;
drop trigger t_key_id;
 
 create table leave_request(
    id number(4) PRIMARY KEY,
    start_dare date,
    end_date date,
    numberOfDays number(4),
    employee_id number(4));
    
CREATE TABLE department (
 id number(4) PRIMARY KEY,
 name varchar2(200));
    
 
create table credential (
  id number(4) PRIMARY KEY,
  email varchar2(100),
  password varchar2(100),
  employee_id number(4),
  key_id number(4));

 
 create table key(
    id number(4)  PRIMARY KEY,
    email_key raw(16),
    password_key raw(16)
 );
 
create table employee (
  id number(4) PRIMARY KEY,
  first_name varchar2(100),
  last_name varchar2(100),
  birth_date date,
  manager_id number(4),
  department_id number(4),
  job_id number(4));
  
  create table daily_hours (
  id number(4) PRIMARY KEY,
  daily_date date,
  working_hours number(4),
  employee_id number(4));
  
  
  create table job (
  id number(4) PRIMARY KEY,
  name varchar2(100),
  salary number(4),
  contract_id number(4));
  
  create table contract (
  id number(4) PRIMARY KEY,
  contract_type varchar2(100),
  val number(4),
  employee_id number(4));
  
  
  create table job_history (
  id number(4) PRIMARY KEY,
  start_date date,
  end_date date,
  job_id number(4),
  employee_id number(4));
  
  -- CREDENTIAL CONSTRAINTS
  alter table credential add constraint fk_employee_id FOREIGN KEY (employee_id) REFERENCES employee(id);
  alter table credential add constraint fk_key_id FOREIGN KEY (key_id) REFERENCES key(id);
  -- EMPLOYEE CONSTRAINTS
  alter table employee add constraint fk_employee_department FOREIGN KEY (department_id) REFERENCES department(id);
  alter table employee add constraint fk_employee_job FOREIGN KEY (job_id) REFERENCES job(id);
  
  -- JOB_HISTORY CONSTRAINTS
  alter table job_history add constraint fk_job_history_employee_id FOREIGN KEY (employee_id) references employee(id);
  
  -- Daily_Hours CONSTRAINTS
  alter table daily_hours add constraint fk_daily_hours_employee FOREIGN KEY (employee_id) references employee(id);
  
  -- Contract CONSTRAINTS
 alter table contract add constraint fk_contract FOREIGN KEY (employee_id) references employee(id);
 
 -- Leave_Request CONSTRAINTS
 alter table leave_request add constraint fk_leave_request FOREIGN KEY (employee_id) references employee(id);

  
 -- CREATE AUTO_INCREMENT FOR THE TABLES 
CREATE SEQUENCE S_KEY
START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE OR REPLACE TRIGGER T_KEY_ID
BEFORE INSERT
ON KEY
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
  if(:new.ID is null) then
  SELECT S_KEY.nextval
  INTO :new.ID
  FROM dual;
  end if;
END;
/