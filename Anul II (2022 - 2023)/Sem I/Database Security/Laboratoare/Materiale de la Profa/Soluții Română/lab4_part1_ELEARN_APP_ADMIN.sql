--Laborator 4 - partea 2 (exercitii)
--1
drop table curs cascade constraints;
CREATE TABLE CURS
(id number(6) primary key,
denumire varchar2(30) NOT NULL,
an_studiu number(1) NOT NULL,
semestru number(1) NOT NULL,
nr_credite number(1) NOT NULL,
forma_evaluare VARCHAR2(10) DEFAULT 'EXAMEN',
ore_curs number(2) DEFAULT 28,
ore_laborator number(2) DEFAULT 14,
ore_seminar number(2) DEFAULT 0);

INSERT INTO CURS VALUES (1,'SECURITATEA BAZELOR DE DATE',6,1,5,'E',28,14,0);
INSERT INTO ELEARN_APP_ADMIN.CURS VALUES (2,'RETELE DE CALCULATOARE',3,2,5,'E',28,28,0);

drop table tema_casa cascade constraints;
create table tema_casa (
  id number(4) primary key,
  enunt varchar2(200) not null,
  id_curs number(4),
  deadline date,
  punctaj number(4, 2),
  foreign key(id_curs) references curs(id));

INSERT INTO TEMA_CASA VALUES(1,'Recapitulare: Sa se rezolve ...', 1,SYSDATE+3,0.25);
INSERT INTO TEMA_CASA VALUES(2,'Introducere: Sa se scrie un program care ...', 1,SYSDATE+6,0.5);
COMMIT;

--Varianta 1:
grant select on tema_casa to elearn_profesor1;
grant select on tema_casa to elearn_profesor2;
grant select on tema_casa to elearn_asistent3;

revoke select on tema_casa from elearn_asistent3;

--Varianta2:
create or replace view viz_tema as select id, enunt, id_curs from tema_casa;

grant select on viz_tema to elearn_profesor1;
grant select on viz_tema to elearn_profesor2;
grant select on viz_tema to elearn_asistent3;

revoke select on viz_tema from elearn_asistent3;

--Varianta 3:
select * from session_privs;
select * from session_roles;

drop role sel_tema;
create role sel_tema;
grant select on tema_casa to sel_tema;
grant sel_tema to elearn_profesor1, elearn_profesor2, elearn_asistent3;
--revoke sel_tema from elearn_asistent3; --avem nevoie de privilegiul "select" pentru problema 2

--2
--varianta 1:
grant update(deadline) on tema_casa to elearn_profesor1;
grant update(deadline) on tema_casa to elearn_profesor2;
grant update(deadline) on tema_casa to elearn_asistent3;

revoke update on tema_casa from elearn_asistent3;

select * from tema_casa;

--varianta 2
create or replace view viz_tema as select id, enunt, id_curs, deadline from tema_casa;

grant update(deadline) on viz_tema to elearn_profesor1;
grant update(deadline) on viz_tema to elearn_profesor2;
grant update(deadline) on viz_tema to elearn_asistent3;

--avem nevoie si de privilegiul "select" 
grant select on viz_tema to elearn_asistent3;
grant update(deadline) on tema_casa to elearn_asistent3;

revoke update on viz_tema from elearn_asistent3;

--varianta 3:
drop role update_tema;
create role update_tema;
grant update(deadline) on tema_casa to update_tema;

desc role_tab_privs;
select * from role_tab_privs where role='SEL_TEMA';
select * from role_tab_privs where role='UPDATE_TEMA';

select * from tema_casa;

grant update_tema to elearn_profesor1;
grant update_tema to elearn_profesor2;
grant update_tema to elearn_asistent3;