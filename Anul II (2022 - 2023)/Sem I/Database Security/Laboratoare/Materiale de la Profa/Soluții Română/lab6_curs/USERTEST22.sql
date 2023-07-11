create table student (
  id number primary key,
  nume varchar2(30),
  prenume varchar2(30),
  anul number,
  specializare varchar2(3),
  grupa number);

create table materie (
  id number primary key,
  titlu varchar2(30));
  
create table tema (
  id number primary key,
  cod_materie number references materie(id),
  data_postare date,
  cod_prof number);

create table rezolva (
  cod_student number not null references student(id),
  cod_tema number not null references tema(id), 
  data_upload date,
  nota number(4,2),
  data_corectare date,
  primary key (cod_student, cod_tema));

insert into student values(135,'Avramescu','Anton',5,'Inf',531); 
insert into student values(212,'Antim','Tudor',5,'Inf',532);
insert into student values(314,'Tinca','Ana',5,'Inf',531);
insert into student values(411,'Caludescu','Aristida',5,'Inf',532);  

insert into materie values(1,'SecBD');
insert into tema values(1,1,SYSDATE-45,1);
insert into tema values(2,1,SYSDATE-30,1);
insert into tema values(3,1,SYSDATE+7,2);
insert into tema values(4,1,SYSDATE+28,1);
insert into rezolva values(135,1,sysdate-50,null,null);

insert into rezolva values(212,1,sysdate-45,null,null);
insert into rezolva values(135,2,sysdate-35,null,null);
insert into rezolva values(212,2,sysdate-35,null,null);
insert into rezolva values(314,2,sysdate-30,null,null);
insert into rezolva values(135,3,sysdate,null,null);
COMMIT;


select * from rezolva;
select * from student;

create or replace package pachet_mascare is
function f_mascare(sir varchar2) return varchar2;
function f_mascare(nr number) return number;
function f_mascaregrupa(nr number) return number;
end;
/
create or replace package body pachet_mascare is
type tip_tabind is table of number index by pls_integer;
v_tabind tip_tabind;
function f_mascare(sir varchar2) return varchar2 is
v_sir varchar2(100);
v_lung number;
begin
v_sir := substr(sir,1,1);
select length(sir) into v_lung from dual;
v_sir := rpad(v_sir,v_lung,'*'); -- se pastreaza doar
-- prima litera si apoi se pun stelute pana
-- la lungimea sirului original
return v_sir;
end f_mascare;
function f_mascare(nr number) return number is
lung number;
minnou number;
maxnou number;
l_seed VARCHAR2(100);
v_nrnou number;
begin
if v_tabind.exists(nr) then
return v_tabind(nr); --va fi folosit cand mascam cheia
--externa din tabelul REZOLVA
else
--generam un numar random care sa inceapa cu aceeasi
--cifra ca nr si sa aiba aceeasi lungime
lung:=length(to_char(nr));
dbms_output.put_line('lung='||lung);
minnou:=to_number(rpad(substr(to_char(nr),1,1),lung,'0'));
maxnou:=to_number(rpad(substr(to_char(nr),1,1),lung,'9'));
dbms_output.put_line('minnou='||minnou||' maxnou=' ||
maxnou);
l_seed:=TO_CHAR(SYSTIMESTAMP,'YYYYDDMMHH24MISSFFFF');
DBMS_RANDOM.seed (val => l_seed);
v_nrnou:=round(DBMS_RANDOM.value(
low => minnou, high => maxnou),0);
v_tabind(nr):=v_nrnou; return v_nrnou;
end if;
end f_mascare;
function f_mascaregrupa(nr number) return number is
v_nrnou number;
lung number;
begin
lung:=length(to_char(nr)); v_nrnou:=to_number(rpad(substr(to_char(nr),1,1),lung,'0'));
return v_nrnou;
end;
end;
/
-- Comanda expdp ce va fi rulata in cmd:
expdp usertest22/usertest22@orclpdb tables=student,rezolva remap_data=student.nume:pachet_mascare.f_mascare remap_data=student.prenume:pachet_mascare.f_mascare remap_data=student.grupa:pachet_mascare.f_mascaregrupa remap_data=student.id:pachet_mascare.f_mascare remap_data=rezolva.cod_student:pachet_mascare.f_mascare directory=DIREXP22 dumpfile=FISEXPORT.dmp 

-- Comanda impdp ce va fi rulata in cmd:
impdp usertest22/usertest22@orclpdb directory=DIREXP22 dumpfile=FISEXPORT.DMP TABLES=student,rezolva remap_table=student:stud1 remap_table=rezolva:rez1