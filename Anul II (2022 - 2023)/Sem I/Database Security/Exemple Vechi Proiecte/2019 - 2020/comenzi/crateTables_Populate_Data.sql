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
    start_date date,
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



-- POPULATE DATA

-- DEPARTMENT
insert into department(id, name) values(1,'support');
insert into department(id, name) values(2,'vanzari');
insert into department(id, name) values(3,'conducere');
insert into department(id, name) values(4,'IT');
insert into department(id, name) values(5,'administratie');

-- JOB
insert into job(id, name, salary, contract_id) values (1, 'manager', 1000, 1);
insert into job(id, name, salary, contract_id) values (2, 'programator', 2000, 2);
insert into job(id, name, salary, contract_id) values (3, 'administrator', 3000, 3);
insert into job(id, name, salary, contract_id) values (4, 'agent de turism', 1000, 4);
insert into job(id, name, salary, contract_id) values (5, 'economist', 2000, 5);
insert into job(id, name, salary, contract_id) values (6, 'resurse_umane', 3000, 6);
insert into job(id, name, salary, contract_id) values (7, 'proprietar firma', 2000, 7);
insert into job(id, name, salary, contract_id) values (8, 'angajat', 3000, 8);


-- EMPLOYEE
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --manager
VALUES (1, 'Manager', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),null,3,1);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --programator
VALUES (2, 'Programator', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,4,2);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --administrator
VALUES (3, 'Administrator', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,5,3);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --agent de turism
VALUES (4, 'Agent de turism', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,2,4);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --economist
VALUES (5, 'Economist', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,2,5);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --resurse_umane
VALUES (6, 'Resurse Umane', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,2,6);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --proprietar firma
VALUES (7, 'Proprietar Firma', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),null,3,7);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --angajat
VALUES (8, 'Angajat', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,1,8);


-- Job History
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (1,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 1, 1);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (2,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 2, 2);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (3,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 3, 3);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (4,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 4, 4);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (5,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 5, 5);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (6,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 6, 6);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (7,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 7, 7);
insert into job_history(id, start_date, end_date, job_id, employee_id)
values (8,TO_DATE('1995-01-18', 'YYYY-MM-DD'), null, 8, 8);

-- CONTRACT
INSERT INTO contract (id,contract_type, val, employee_id) --manager
VALUES (1, 'contract_manager', '1000',1);
INSERT INTO contract (id,contract_type, val, employee_id) --programator
VALUES (2, 'contract_programator', '1000',2);
INSERT INTO contract (id,contract_type, val, employee_id) --administrator
VALUES (3, 'contract_administrator', '1000',3);
INSERT INTO contract (id,contract_type, val, employee_id) --agent de turism
VALUES (4, 'contract_agent_de_turism', '1000',4);
INSERT INTO contract (id,contract_type, val, employee_id) --economist
VALUES (5, 'contract_economist', '1000',5);
INSERT INTO contract (id,contract_type, val, employee_id) --resurse umane
VALUES (6, 'contract_resurse_umane', '1000',6);
INSERT INTO contract (id,contract_type, val, employee_id) --proprietar firma
VALUES (7, 'contract_proprietar_firma', '1000',7);
INSERT INTO contract (id,contract_type, val, employee_id) --angajat
VALUES (8, 'contract_angajat', '1000',8);



-- Daily_hours
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(1, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 1);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(2, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 2);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(3, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 3);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(4, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 4);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(5, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 5);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(6, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 6);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(7, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 7);
insert into daily_hours(id, daily_date, working_hours, employee_id) 
values(8, TO_DATE('2019-01-18', 'YYYY-MM-DD'), 8, 8);




-- CREDENTIAL


insert into credential(id, email, password, employee_id) values (1,'manager@gmail.com','manager',1);
insert into credential(id, email, password, employee_id) values (2,'programator@gmail.com','programator',2);
insert into credential(id, email, password, employee_id) values (3,'administrator@gmail.com','administrator',3);
insert into credential(id, email, password, employee_id) values (4,'agent_de_turism@gmail.com','agent_de_turism',4);
insert into credential(id, email, password, employee_id) values (5,'economist@gmail.com','economist',5);
insert into credential(id, email, password, employee_id) values (6,'resurse_umane@gmail.com','resurse_umane',6);
insert into credential(id, email, password, employee_id) values (7,'proprietar_firma@gmail.com','proprietar_firma',7);
insert into credential(id, email, password, employee_id) values (8,'angajat@gmail.com','angajat',8);


-- LEAVE_REQUEST

insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (1,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 1);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (2,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 2);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (3,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 3);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (4,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 4);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (5,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 5);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (6,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 6);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (7,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 7);
insert into leave_request(id, start_date, end_date, numberOfDays, employee_id) values (8,TO_DATE('2019-01-18', 'YYYY-MM-DD'), TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1000, 8);



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
  