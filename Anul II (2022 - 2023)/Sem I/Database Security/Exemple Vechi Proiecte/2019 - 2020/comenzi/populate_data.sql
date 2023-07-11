-- POPULATE DATA

-- DEPARTMENT
insert into department(id, name) values(1,'support');
insert into department(id, name) values(2,'vanzari');
insert into department(id, name) values(3,'conducere');

-- JOB
insert into job(id, name, salary) values (1, 'programator', 1000);
insert into job(id, name, salary) values (2, 'manager', 2000);
insert into job(id, name, salary) values (3, 'administrator', 3000);


-- ROLE
insert into role(id, role_type, description) values(1,'programator','simplu angajat');
insert into role(id, role_type, description) values(2,'manager', 'manager');
insert into role(id, role_type, description) values(3, 'administrator', 'administrator');


-- EMPLOYEE
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id, role_id) --manager
VALUES (1, 'Mihai', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,3,2,2);
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id, role_id) --programator
VALUES (2, 'Ion', 'Popescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),1,1,1,1);

INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id, role_id) --administrator
VALUES (3, 'Ion', 'Popescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),null,3,3,3);

-- CREDENTIAL
--ALTER TRIGGER criptare_credentials DISABLE;
insert into credential(id, email, password, employee_id) values (1,'employee@gmail.com','employee',2);
insert into credential(id, email, password, employee_id) values (2,'manager@gmail.com','manager',1);
insert into credential(id, email, password, employee_id) values (3,'administrator@gmail.com','administrator',3);
--ALTER TRIGGER criptare_credentials ENABLE;