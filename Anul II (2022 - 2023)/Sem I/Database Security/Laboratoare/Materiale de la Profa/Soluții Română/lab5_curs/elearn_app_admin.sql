--2.1
select * from session_privs;
select * from session_roles;

create table student(id number primary key,
  nume varchar2(30), prenume varchar2(30), 
  anul number, specializare varchar2(3), grupa number);
create table materie(id number primary key,
        denumire varchar2(20));
create table examen (id number primary key, cod_materie number,
      dataex date,
      constraint fk_ex2 foreign key(cod_materie) 
      references materie(id));
      
create table evaluare (cod_student number not null,
    cod_examen number not null,nota number(4,2) default -1,
    constraint pk_ev1 primary key (cod_student,cod_examen),
    constraint fk_ev1 foreign key (cod_student) references student(id), 
    constraint fk_ex1 foreign key (cod_examen) references examen(id));
insert into student values (1,'A','Abc',2,'Inf',231);
insert into student values(2,'B','Bbc',2,'Inf',231);
insert into materie values(1,'Algebra');
insert into examen values(1,1,sysdate-700);
insert into examen values(2,1,sysdate-300);
insert into evaluare values(1,1,3);
insert into evaluare values(2,1,10);
insert into evaluare values(1,2,9);

commit;

CREATE OR REPLACE PROCEDURE PROC_CDINAM(cerere_sql VARCHAR2) AS
TYPE tip_ref_c IS REF CURSOR;
ref_c tip_ref_c;
v_sir VARCHAR2(200);
BEGIN
OPEN ref_c FOR cerere_sql;
LOOP
FETCH ref_c INTO v_sir;
EXIT WHEN ref_c%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('STUDENTUL: '||v_sir);
END LOOP;
CLOSE ref_c;
END;
/

grant execute on proc_cdinam to elearn_asistent3;


--2.2
create table rezolva (
  id_tema number(4),
  id_stud number(4),
  data_upload date,
  nota number(4,2),
  id_corector number(4),
  primary key(id_tema, id_stud));

insert into rezolva (id_tema, id_stud, nota) values (10, 1, 9);
insert into rezolva (id_tema, id_stud, nota) values (11, 2, 10);
commit;

CREATE OR REPLACE PROCEDURE
PROC_CURSOR_DINAM(cerere_sql VARCHAR2)
AS
TYPE vector IS TABLE OF ELEARN_APP_ADMIN.REZOLVA%ROWTYPE;
v_vector vector;
BEGIN
EXECUTE IMMEDIATE(cerere_sql) BULK COLLECT INTO v_vector;
FOR i IN 1..v_vector.COUNT LOOP
DBMS_OUTPUT.PUT_LINE('STUDENTUL:'||v_vector(i).ID_STUD
|| ' LA TEMA:'||v_vector(i).ID_TEMA||' ARE NOTA:'
|| NVL(v_vector(i).NOTA,0));
END LOOP;
END;
/

GRANT EXECUTE ON PROC_CURSOR_DINAM TO ELEARN_profesor1;

select * from elearn_app_admin.rezolva;

CREATE OR REPLACE PROCEDURE
PROC_CURSOR_DINAM(cerere_sql VARCHAR2) AUTHID CURRENT_USER
AS
TYPE vector IS TABLE OF ELEARN_APP_ADMIN.REZOLVA%ROWTYPE;
v_vector vector;
BEGIN
EXECUTE IMMEDIATE(cerere_sql) BULK COLLECT INTO v_vector;
FOR i IN 1..v_vector.COUNT LOOP
DBMS_OUTPUT.PUT_LINE('STUDENTUL:' || v_vector(i).ID_STUD || ' LA TEMA:' || v_vector(i).ID_TEMA || ' ARE NOTA:' || NVL(v_vector(i).NOTA,0));
END LOOP;
END;
/

GRANT EXECUTE ON PROC_CURSOR_DINAM TO ELEARN_profesor1;


INSERT INTO REZOLVA (ID_TEMA,ID_STUD,DATA_UPLOAD) VALUES(1,2,SYSDATE-3);
INSERT INTO REZOLVA (ID_TEMA,ID_STUD,DATA_UPLOAD) VALUES(2,1,SYSDATE-7);
COMMIT;

select * from rezolva;

grant select on rezolva to elearn_profesor1;

CREATE OR REPLACE PROCEDURE
PROC_CURSOR_DINAM(cerere_sql VARCHAR2) AUTHID CURRENT_USER
AS
TYPE vector IS TABLE OF ELEARN_APP_ADMIN.REZOLVA%ROWTYPE;
v_vector vector;
este_ok NUMBER(1) :=0;
BEGIN
IF REGEXP_LIKE(cerere_sql,'SELECT [A-Za-z0-9*]+ [^;]') THEN
este_ok:=1;
END IF;
IF este_ok = 1 THEN BEGIN
EXECUTE IMMEDIATE(cerere_sql) BULK COLLECT INTO v_vector;
FOR i IN 1..v_vector.COUNT LOOP
DBMS_OUTPUT.PUT_LINE('STUDENTUL:'||v_vector(i).ID_STUD ||'LA TEMA:'||v_vector(i).ID_TEMA||' ARE NOTA:' || NVL(v_vector(i).NOTA,0));
END LOOP;
END;
ELSE
DBMS_OUTPUT.PUT_LINE('Comanda contine cod suspect a fi malitios. Sunt permise doar interogari de date');
END IF;
END;
/

GRANT EXECUTE ON PROC_CURSOR_DINAM TO ELEARN_profesor1;

GRANT DELETE ON ELEARN_APP_ADMIN.REZOLVA TO ELEARN_profesor1;

REVOKE DELETE ON ELEARN_APP_ADMIN.REZOLVA FROM ELEARN_profesor1;

--3
create table utilizator (
  id number(4) primary key,
  tip varchar2(15) default 'STUDENT',
  nume varchar2(20) not null,
  prenume varchar2(20) not null,
  numeuser varchar2(20) not null,
  an_intrare date not null,
  an_iesire date);

create table cursant (
  id number(4) primary key,
  an_studiu number(1) not null,
  reluare_studii number(1),
  intrerupere_studii number(1),
  foreign key(id) references utilizator(id));

insert into utilizator values(1, 'STUDENT', 'Nume1', 'Prenume1', 'ELEARN_student2', sysdate - 300, null);
insert into utilizator values(2, 'STUDENT', 'Nume2', 'Prenume2', 'ELEARN_student3', sysdate - 1200, null);

insert into cursant values(1, 1, 0, 0);
insert into cursant values(2, 3, 0, 0);

commit;

ALTER TABLE UTILIZATOR ADD PAROLA VARCHAR2(32);

CREATE OR REPLACE FUNCTION criptare1(textclar IN VARCHAR2)
RETURN VARCHAR2 AS
raw_sir RAW(20);
raw_parola RAW(20);
rezultat RAW(20);
parola VARCHAR2(20) := '12345678';
mod_operare NUMBER;
textcriptat VARCHAR2(32);
BEGIN
raw_sir:=utl_i18n.string_to_raw(textclar,'AL32UTF8'); raw_parola :=utl_i18n.string_to_raw(parola,'AL32UTF8');
mod_operare := DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_ZERO + DBMS_CRYPTO.CHAIN_ECB;
rezultat := DBMS_CRYPTO.ENCRYPT(raw_sir, mod_operare,raw_parola);
--dbms_output.put_line(rezultat);
textcriptat := RAWTOHEX(rezultat);
RETURN textcriptat;
END;
/

UPDATE UTILIZATOR
SET PAROLA=criptare1('Parola1')
WHERE ID=1;
UPDATE UTILIZATOR
SET PAROLA=criptare1('Parola2')
WHERE ID=2;

select * from utilizator;

CREATE OR REPLACE PROCEDURE
VERIFICA_LOGIN (P_NUMEUSER VARCHAR2,P_PAROLA VARCHAR2) AS
v_ok NUMBER(2) :=-1;
BEGIN
EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM UTILIZATOR WHERE NUMEUSER='''||P_NUMEUSER||''' AND PAROLA=criptare1('''||P_PAROLA||''')' INTO v_ok;
DBMS_OUTPUT.PUT_LINE('SELECT COUNT(*) FROM UTILIZATOR WHERE NUMEUSER='''||P_NUMEUSER||''' AND PAROLA=criptare1('''||P_PAROLA||''')');
IF v_ok=0 THEN
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A ESUAT');
ELSE
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A REUSIT');
END IF;
END;
/

EXEC VERIFICA_LOGIN('ELEARN_student2','Parola1');
EXEC VERIFICA_LOGIN('ELEARN_student2','Parola2');
EXEC VERIFICA_LOGIN('ELEARN_student2''--','Parola2');
EXEC VERIFICA_LOGIN('ABRACADABRA99'' OR 1=1 --','HOCUS-POCUS');

CREATE OR REPLACE PROCEDURE
VERIFICA_LOGIN_SAFE (P_NUMEUSER VARCHAR2,P_PAROLA VARCHAR2) AS
v_ok NUMBER(2) :=-1;
BEGIN
SELECT COUNT(*) INTO v_ok FROM UTILIZATOR WHERE NUMEUSER=P_NUMEUSER AND PAROLA=criptare1(P_PAROLA);
IF v_ok=0 THEN
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A ESUAT');
ELSE
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A REUSIT');
END IF;
END;
/

EXEC VERIFICA_LOGIN_SAFE('ELEARN_student2','Parola1');
EXEC VERIFICA_LOGIN_SAFE('ELEARN_student2','Parola2');
EXEC VERIFICA_LOGIN_SAFE('ELEARN_student2''--','Parola2');
EXEC VERIFICA_LOGIN_SAFE('ABRACADABRA99'' OR 1=1 --','HOCUS-POCUS');

CREATE OR REPLACE PROCEDURE
VERIFICA_LOGIN_SAFE2 (P_NUMEUSER VARCHAR2,P_PAROLA VARCHAR2) AS
v_ok NUMBER(2) :=-1;
BEGIN
EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM UTILIZATOR WHERE
NUMEUSER=:numeus AND PAROLA=criptare1(:parol)' INTO v_ok USING P_NUMEUSER,P_PAROLA;
IF v_ok=0 THEN
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A ESUAT');
ELSE
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A REUSIT');
END IF;
END;
/

EXEC VERIFICA_LOGIN_SAFE2('ELEARN_student2','Parola1');
EXEC VERIFICA_LOGIN_SAFE2('ELEARN_student2','Parola2');
EXEC VERIFICA_LOGIN_SAFE2('ELEARN_student2''--','Parola2');
EXEC VERIFICA_LOGIN_SAFE2('ABRACADABRA99'' OR 1=1 --','HOCUS-POCUS');

--Exercitii
--1
create or replace trigger tr_insert_update_rezolva
before insert or update on elearn_app_admin.rezolva
for each row
declare
  v_poate varchar2(4);
begin
  v_poate := sys_context('aplicatie_ctx_2', 'ora_potrivita');
  if (v_poate = 'nu') then
    dbms_output.put_line ('Nu aveti voie sa acordati note in afara orelor de program');
    :new.nota := 99;
  end if;
end;
/

select * from rezolva;
grant select, update(nota, id_corector) on rezolva to elearn_profesor1;
grant select, update(nota, id_corector) on rezolva to elearn_profesor2;
grant select, update(nota, id_corector) on rezolva to elearn_asistent3;