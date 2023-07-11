drop trigger tr_insert_update_user;
drop trigger TR_INSERT_USER;
drop trigger TR_UPDATE_USER;
create or replace trigger tr_insert_update_user
before insert or update on c##agency_admin.employee
for each row
declare
  v_poate varchar2(4);
begin
  v_poate := sys_context('aplicatie_ctx', 'lang_ro');
  if (v_poate = 'nu') then
    dbms_output.put_line ('Nu aveti voie sa inserati nume si prenume fara diacritice');
    :new.first_name := null;
    :new.last_name := null;
  end if;
end;
/

CREATE OR REPLACE TRIGGER TR_INSERT_USER
BEFORE INSERT ON c##agency_admin.employee
FOR EACH ROW
DECLARE
v_poate VARCHAR2(4);
BEGIN
v_poate:=SYS_CONTEXT ('APLICATIE_CTX', 'LANG_RO');
IF v_poate='NU' THEN
DBMS_OUTPUT.PUT_LINE('NU AVETI VOIE SA INSERATI FIRST_NAME/_NAME FARA
DIACRITICE!');
:NEW.first_name:=NULL;
:NEW.last_name:=NULL;
END IF;
END;
/



CREATE OR REPLACE TRIGGER TR_UPDATE_USER
BEFORE UPDATE ON c##agency_admin.employee
FOR EACH ROW
DECLARE
v_poate VARCHAR2(4);
BEGIN
v_poate:=SYS_CONTEXT ('APLICATIE_CTX', 'LANG_RO');
IF v_poate='NU' THEN
DBMS_OUTPUT.PUT_LINE('NU AVETI VOIE SA INSERATI FIRST_NAME/_NAME FARA
DIACRITICE!');
:new.first_name := null;
:new.last_name := null;
END IF;
END;
/


SELECT USERENV('LANGUAGE') "Language" FROM DUAL;
-- utilizator se deconecteaza
desc employee;
INSERT INTO employee (id, first_name, last_name, birth_date, manager_id, department_id, job_id) --manager
VALUES (22, 'Manager', 'Ionescu', TO_DATE('1995-01-18', 'YYYY-MM-DD'),null,3,1);
