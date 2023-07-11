/**************   Laborator 2   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;





/*** Ex1 ***/
/* IMPORTANT: CONEXIUNE NOUĂ
   Name: sys_local
   Username: sys
   Role: SYSDBA
   Pass: ...
   SID: o12c
*/
----- Pentru a vedea unde sunt salvate informațiile referitoare la 'audit' (inițial avem DB)
-- Varianta 1
select value from v$parameter where name = 'audit_trail';
-- Varianta 2
show parameter audit_trail;


--- Setăm să avem audit DB,EXTENDED (adică să se rețină și textul comenzilor auditate)
alter system set audit_trail=db,extended scope=spfile;
/* !!!Ca să funcționeze, trebuie restartată instanța Oracle, după comanda de 'alter':
   În SQLPlus, rulăm comenzile:
      sys as sysdba ---> MEREU
      _parola_setată_
      
      shutdown immediate; ---> așteptăm puțin să se închidă
      startup;
      
    Acum putem să verificăm că s-a modificat 'audit_trail'.
*/


-- Pornim auditul
audit select table;
-- Descriere tabel
DESC dba_stmt_audit_opts;
-- Se auditează SELECT TABLE, atât pt success, cât și pt failure; pt fiecare activitate - o linie de audit
SELECT audit_option, success, failure 
FROM dba_stmt_audit_opts;

/* Suntem într-o bază de date container -> rădăcină (CDB$ROOT) și vrem să ne mutăm 
   în DB pluggable, unde avem schema 'hr' deja creată de Oracle și vrem să o activăm.
   (orclpdb conform pașilor de instalare)
*/
show con_name;
alter session set container = orclpdb;
-- Comanda nu va merge pentru că DB nu e deschisă
alter user hr identified by hr account unlock;

-- Dacă vrem să aflăm info despre conexiune (nume și dacă putem scrie în ea, spre ex)
alter session set container = CDB$ROOT;
desc v$pdbs;
SELECT name, open_mode
FROM v$pdbs; -- ORCLPDB este mounted, deci trebuie să o deschidem

--- Deschidem ORCLPDB, ca să luăm 'hr'
alter pluggable database orclpdb open;
SELECT name, open_mode
FROM v$pdbs; -- ORCLPDB este READ WRITE, deci putem să o folosim
alter session set container = orclpdb;
alter user hr identified by hr account unlock;
-- Verificăm dacă avem vreun audit activat: este gol aici
SELECT audit_option, success, failure 
FROM dba_stmt_audit_opts;
audit select table; -- am activat un audit


/* Conectăm pe 'hr': facem o conexiune nouă
   Conn Name: hr_local
   Username: hr
   Password: hr
   Service Name: orclpdb
   -----------------------------------
   În hr_local: SELECT * FROM EMPLOYEES;
   Și acum verificăm în sys_local dacă ne apare audit-ul.
*/
-- Informații despre auditul standard sunt în aud$
desc aud$;
SELECT obj$name, userid, sqltext, ntimestamp#
FROM aud$
ORDER BY ntimestamp# DESC;

/* -- Pentru a vedea timpul
SELECT TO_CHAR(sysdate, 'dd/mm/yyyy hh24:mi:ss') FROM dual;
*/

/* Raport al activităților - nr de comenzi executate:
   - de fiecare utilizator, pe fiecare tabel
   - de fiecare utilizator, indiferent de tabel
   - nr total de comenzi, indiferent de utilizator sau tabel
   Luăm în calcul doar tabelele EMPLOYEES, REGIONS, DEPARTMENTS.
*/
-- După comanda asta avem la count doar 1 (o singură comandă executată)
SELECT userid, obj$creator, obj$name, count(*)
FROM aud$
WHERE LOWER(obj$name) IN ('employees', 'departments', 'regions')
GROUP BY ROLLUP (userid, (obj$creator, obj$name)); 

/* Rulăm comanda de mai jos și în hr_local:
   SELECT * FROM regions;
   
   Acum, dacă rulăm SELECT-ul de mai sus, ar trebui să avem modificări la count.
   DAR, pe sys nu îl auditează (adică SELECT * FROM hr.regions).
*/
SELECT * FROM hr.regions;


/* Mai creăm un user.
   După ce rulăm cele 2 comenzi de mai jos, facem o conexiune nouă:
   Name/Username/Password: test
   Service Name: orclpdb
   -----------------------------------
   În hr_local:
   grant select on regions to test;
   -----------------------------------
   În test:
   SELECT * FROM hr.regions;
   -----------------------------------
   Rulăm ca să vedem dacă s-a modificat count-ul și da.
   -----------------------------------
   În test:
   SELECT * FROM hr.employees;
   -----------------------------------
   Rulăm ca să vedem dacă s-a modificat count-ul și da (numără și pe cele eșuate).
*/
create user test identified by test;
grant connect, resource to test;

SELECT userid, obj$creator, obj$name, count(*)
FROM aud$
WHERE LOWER(obj$name) IN ('employees', 'departments', 'regions')
GROUP BY ROLLUP (userid, (obj$creator, obj$name)); 


----- Stop audit în CDB$ROOT/ORCLPDB
-- Verificăm că suntem în CDB$ROOT și avem audit pornit
alter session set container = CDB$ROOT;
show con_name;
select audit_option, success, failure from dba_stmt_audit_opts;
-- STOP audit în CDB$ROOT
noaudit select table;
-- Verific și acum e gol
select audit_option, success, failure from dba_stmt_audit_opts;

-- Pt ORCLPDB
alter session set container = ORCLPDB;
show con_name;
noaudit select table;
select audit_option, success, failure from dba_stmt_audit_opts;

/* Facem un test. 
   În hr_local: SELECT department_name FROM departments;
   Dacă ne uităm în raport, s-a adăugat și acest audit.
   
   Pentru a evita asta, avem 2 opțiuni:
   - deconectăm și reconectăm pe 'hr_local';
   - repornesc baza de date pluggable (așa forțez pe toți utilizatorii cu sesiune activă să se reconecteze)
*/





/*** Ex2 ***/
----- Inițial
-- Vedem în ce conexiune ne aflăm
show con_name;
-- Vedem unde ne sunt salvate informațiile legate de audit (în DB, EXTENDED)
-- Vom dori să schimbăm și să le avem extern, în XML
show parameter audit_trail;
-- Detalii despre conexiune și dacă putem să îi aducem modificări (este READ WRITE, deci da)
SELECT name, open_mode FROM v$pdbs;
-- Ca să vedem ce audit am activat (detalii despre audit la nivel STATEMENTS)
SELECT audit_option, success, failure 
FROM dba_stmt_audit_opts;


-- Trebuie să fim în CDB$ROOT ca să schimbăm în XML
alter session set container = CDB$ROOT;
-- Schimbăm în XML,EXTENDED (ca să avem și textul comenzilor auditate) și RESTART instanța Oracle
alter system set audit_trail=xml,extended scope=spfile;
-- Acum avem XML,EXTENDED
show parameter audit_trail;


----- Pornim auditul (All failed DML commands on the HR.EMPLOYEES)
alter session set container = orclpdb; -- este mounted acum pt că am repornit instanța Oracle
SELECT name, open_mode FROM v$pdbs;
alter pluggable database orclpdb open; -- deschidem BD pluggable și acum avem READ, WRITE
-- Auditul se activează în ORCLPDB
audit select, insert, update, delete on hr.employees whenever not successful;
/*
SELECT audit_option, success, failure 
FROM dba_stmt_audit_opts; -- nu va merge pentru că este la nivel STATEMENTS, și noi vrem OBJECTS
*/
-- Ca să vedem ce audit am activat (detalii despre audit la nivel OBJECTS)
SELECT object_name, owner, sel, ins, upd, del 
FROM dba_obj_audit_opts
where lower(object_name) = 'employees';
-- Ca să vedem unde ni se salvează XML-urile
show parameter audit_file_dest;


/*
   În hr_local (hr/hr):
   select user from dual; -- verificăm să fim în BD bună
   --------------------------- Încercăm să facem comenzi eșuate, dar nu de sintaxă, ci de logică (nu că scriem noi o comandă greșit)
   desc employees; -- ca să vedem ce coloane nu pot fi null și trebuie să le declarăm
   insert into employees(employee_id, last_name, email, hire_date, job_id)
   values (100, 'test', 'test@gmail.com', sysdate, 'IT_PROG'); -- eroare pt că avem duplicat de id
   
   ---------------------------
   Încercăm să găsim în XML audit-ul eșuat: C:\Oracle19C\admin\o12c\adump ---> e în folder și ne ghidăm după ceas să vedem ce fișier e
*/


-- Oprim auditul
noaudit all on hr.employees;
SELECT object_name, owner, sel, ins, upd, del 
FROM dba_obj_audit_opts
where lower(object_name) = 'employees'; -- acum e gol
/*
   Auditul a fost oprit cu succes și a avut efect imediat. Auditul legat de obiect nu necesită
   repornirea sesiunii, cum aveam la Ex1 (audit de STATEMENTS). Deci aici nu trebuie să oprim 
   și reconectăm la hr_local.
*/





/*** Ex3 ***/
-- Avem grijă să nu fim în ROOT când lucrăm
show con_name;
--- Creăm tabelul de audit pentru TRIGGERS
CREATE TABLE tab_audit_emp(
    id number(5),
    user_ varchar2(50),
    session_ number(10),
    host_ varchar2(100),
    time_ date,
    delta_records number(5),
    constraint tab_audit_emp_pk primary key (id)
);
CREATE SEQUENCE seq_audit_del_emp START WITH 1 INCREMENT BY 1;


----- Creare TRIGGERS
-- Înainte de DELETE, inserează în tabel informațiile
CREATE OR REPLACE TRIGGER audit_del_employees_before
BEFORE DELETE ON hr.employees
DECLARE
  nr_rec_before number;
BEGIN
    select count(*) into nr_rec_before from hr.employees;
    dbms_output.put_line('Nr of records before delete: ' || nr_rec_before);
    
    dbms_output.put_line('SQL command: ' || sys_context('userenv', 'current_sql'));
    insert into tab_audit_emp values (seq_audit_del_emp.nextval, sys_context('userenv', 'session_user'),
                                      sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'),
                                      sysdate, nr_rec_before);
END;
/

-- După DELETE, actualizează 'delta_records' ca să conțină câte rânduri au fost șterse
CREATE OR REPLACE TRIGGER audit_del_employees_after
AFTER DELETE ON hr.employees
DECLARE
  nr_rec_after number;
  current_session varchar2(100);
  id_rec_audit number(5);
BEGIN
    select count(*) into nr_rec_after from hr.employees;
    dbms_output.put_line('Nr of records after delete: ' || nr_rec_after);
    
    select sys_context('userenv', 'sessionid') into current_session from dual;
    select max(id) into id_rec_audit 
    from tab_audit_emp
    where session_ = current_session;
    
    update tab_audit_emp 
    set delta_records = delta_records - nr_rec_after
    where id = id_rec_audit;
END;
/


-- Detalii despre TRIGGERS
desc user_triggers;
-- triggerii noștrii
select trigger_name, status
from user_triggers
where lower(trigger_name) like '%audit_del%';

-- momentan gol
SELECT * FROM tab_audit_emp;

/*
   În hr_local:
   DELETE FROM employees WHERE salary = (SELECT MIN(salary) FROM employees);
   commit; --- NEAPĂRAT, altfel nu e luat de trigger
*/
SELECT t.*, TO_CHAR(time_, 'dd/mm/yyyy hh24:mi:ss') "Time" FROM tab_audit_emp t;





/*** Ex4 ***/
-- Avem deja tabelul și secvența, de mai sus
-- Creare Trigger (el nu previne modificarea de salariu, doar înregistrează)
CREATE OR REPLACE TRIGGER limit_salary
AFTER INSERT OR UPDATE OF salary ON hr.employees
FOR EACH ROW
WHEN (NEW.salary > 20000)
BEGIN
    INSERT INTO tab_audit_emp VALUES (seq_audit_del_emp.nextval, sys_context('userenv', 'session_user'),
                                      sys_context('userenv', 'sessionid'), sys_context('userenv', 'host'),
                                      sysdate, -1);
END;
/

/*
   În hr_local:
   UPDATE employees 
   SET salary = 25000
   WHERE first_name like 'S%';
*/
SELECT t.*, TO_CHAR(time_, 'dd/mm/yyyy hh24:mi:ss') "Time" FROM tab_audit_emp t;





/*** Ex5 ***/
show con_name; -- tb să fim în ORCLPDB

-- Facem HANDLER-ul, care e o procedură (conform teoriei)
CREATE OR REPLACE PROCEDURE proc_audit_alert(object_schema varchar2, object_name varchar2, policy_name varchar2) AS
BEGIN
    dbms_output.put_line('Tried to modify manager id.');
END;
/


-- Facem POLICY-ul (putea să fie și bloc anonim, nu contează aici)
CREATE OR REPLACE PROCEDURE proc_audit_mgr AS
BEGIN
    dbms_fga.add_policy(
        object_schema => 'HR',
        object_name => 'DEPARTMENTS',
        policy_name => 'policy_mgr',
        enable => false,
        statement_types => 'UPDATE',
        handler_module => 'PROC_AUDIT_ALERT'
    );
END;
/
execute proc_audit_mgr;


-- Detalii despre Policies
desc all_audit_policies;
SELECT object_name, object_schema, policy_name, enabled
FROM all_audit_policies
WHERE object_name = 'DEPARTMENTS';


-- Detalii despre AUDIT-ul de POLICIES
desc dba_fga_audit_trail;
SELECT db_user, userhost, policy_name, timestamp, sql_text
FROM dba_fga_audit_trail;


/*
   În hr_local:
   UPDATE departments
   SET manager_id = 202
   WHERE department_id = 110;
   commit;
   -------------------------------
   Încă nu avem nimic în audit pentru că politica nu a fost activată.
*/

-- Varianta 1 de activare politică
BEGIN
    dbms_fga.enable_policy(
        object_schema => 'HR',
        object_name => 'DEPARTMENTS',
        policy_name => 'policy_mgr'
    );
END;
/
-- Varianta 2 de activare politică
/* execute dbms_fga.enable_policy(
        object_schema => 'HR',
        object_name => 'DEPARTMENTS',
        policy_name => 'policy_mgr'
); */

/*
   În hr_local:
   UPDATE departments
   SET manager_id = 205
   WHERE department_id = 110;
   -------------------------------
   Observăm că apare în audit fără commit;
*/