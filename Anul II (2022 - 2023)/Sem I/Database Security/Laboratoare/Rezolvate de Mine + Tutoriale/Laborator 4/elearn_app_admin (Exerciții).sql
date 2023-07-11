/**************   Laborator 4   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;



/*** Ex1 ***/
drop table solves;
drop table homework;
----- Creare de tabele și inserare date
create table homework (
  id number(4) primary key,
  requirement varchar2(200) not null,
  id_course number(4),
  deadline date, 
  points number(4, 2),
  foreign key (id_course) references course(id)
);
insert into homework values (1, 'Cerinta1', 1, sysdate + 3, 0.25);
insert into homework values (2, 'Cerinta2', 1, sysdate + 6, 0.5);
commit;
create table solves (
   homework_id number(4) references homework(id),
   student_id number(4),
   upload_date date, 
   grade number(4, 2),
   corrector_id number(4),
   primary key (homework_id, student_id)
);


----- Metode de acordare Privilegii
-- Metoda 1
grant select on homework to elearn_professor1;
grant select on homework to elearn_professor2;
grant select on homework to elearn_assistent3;

revoke select on homework from elearn_professor1;


-- Metoda 2
create or replace view view_homework as
select id, requirement, id_course
from homework;

grant select on view_homework to elearn_professor1;
grant select on view_homework to elearn_professor2;
grant select on view_homework to elearn_assistent3;

revoke select on view_homework from elearn_professor1;


-- Metoda 3 (pt a putea crea rol, tb să avem drept de la sys)
/* Pt a lua efect, trebuie să ne deconectăm și reconectăm la sesiune utilizatorii. */
create role sel_homework;
grant select on homework to sel_homework;
grant sel_homework to elearn_professor1, elearn_professor2, elearn_assistent3;

revoke sel_homework from elearn_professor1;





/*** Ex2 ***/
----- Metode de acordare Privilegii
-- Metoda 1
grant update(deadline) on homework to elearn_professor1;
grant update(deadline) on homework to elearn_professor2;
grant update(deadline) on homework to elearn_assistent3;

grant select on homework to elearn_professor1;
grant select on homework to elearn_professor2;
grant select on homework to elearn_assistent3;

-- Chiar și după această comandă, poate face SELECT
revoke update on homework from elearn_assistent3;
revoke select on homework from elearn_assistent3;  -- ca să nu mai poate face SELECT

select * from homework;


-- Metoda 2
create or replace view view_homework as
select id, deadline
from homework;

grant update(deadline) on view_homework to elearn_professor1;
grant update(deadline) on view_homework to elearn_professor2;
grant update(deadline) on view_homework to elearn_assistent3;

grant select on view_homework to elearn_professor1;
grant select on view_homework to elearn_professor2;
grant select on view_homework to elearn_assistent3;

revoke update on view_homework from elearn_assistent3;


-- Metoda 3
grant update(deadline) on homework to sel_homework;
grant sel_homework to elearn_assistant3;  -- dacă nu avea sel_homework, altfel se actualizează automat

revoke sel_homework from elearn_app_admin;





/*** Ex3 ***/
desc solves;
insert into solves(homework_id, student_id, grade) values (1, 10, 9);
insert into solves(homework_id, student_id, grade) values (2, 20, 10);
insert into solves (homework_id, student_id, upload_date) values (1, 30, sysdate -3);
insert into solves (homework_id, student_id, upload_date) values (2, 40, sysdate -1);
commit;
select * from solves;

-- Procedura de notare
create or replace procedure proc_marking(pStudId number, pHomeworkId number, pCorrectorId number, pGrade number)
is
  vUpload number(1) := -1;
  vChecked number(1) := -1;
begin
    select count(*) into vUpload 
    from homework h right join solves s on (h.id = s.homework_id)
    where s.student_id = pStudId 
    and s.homework_id = pHomeworkId;
  
    select count(grade) into vChecked
    from solves s
    where s.student_id = pStudId 
    and s.homework_id = pHomeworkId;

    if (vUpload = 0) then
        dbms_output.put_line('Error: marking conditions are not fulfilled: the student did not upload the homework');
    else
        if (vChecked >= 1) then
            dbms_output.put_line('Error: marking conditions are not fulfilled: the homework has already been checked');
        else
            update solves s
            set grade  = pGrade, corrector_id = pCorrectorId
            where s.student_id = pStudId 
            and s.homework_id = pHomeworkId;
            commit;
        end if;
    end if;  
exception
  when others then  dbms_output.put_line('Error: ' || SQLERRM);
end;
/

-- Drepturi pt profi și asistent
grant execute on proc_marking to elearn_professor1, elearn_professor2, elearn_assistent3;
-- Revoke
revoke execute on proc_marking from elearn_assistent3;





/*** Ex4 ***/
--- Creare Tabele și Inserare Date
create table user_ (
  id number(5) primary key,
  type_ varchar2(15) default 'STUDENT',
  last_name varchar2(20) not null,
  first_name varchar2(20) not null,
  username varchar2(20) not null,
  date_in date,
  date_out date
);
  
create table student (
   id number(4) primary key,
   year_study number(1) not null,
   resume_studies number(1),
   interrupted_studies number(1),
   foreign key(id) references user_(id)
);
   
insert into user_ values (1, 'STUDENT', 'Name1', 'FirstName1', 'ELEARN_STUDENT2', sysdate - 300, null);  
insert into user_ values (2, 'STUDENT', 'Name2', 'FirstName2', 'ELEARN_STUDENT3', sysdate - 1200, null);
insert into student values(1, 1, 0, 0);
insert into student values(2, 3, 0, 0);
commit;
select * from student;



-- Privilegii pentru studenți (dacă nu sunt anul 3 și 5 pot să aibă insert în TEME_REZOLVATE)
create or replace procedure assign_privs_stud is
  cursor c is 
     select username, year_study
     from user_ u join student s on (u.id = s.id)
     where u.type_='STUDENT';       
begin
    for v_rec in c loop
        -- PL/SQL dinamic (pt că nu poate executa SQL în interior)
        execute immediate 'GRANT INSERT(homework_id, student_id, upload_date) on solves TO ' || v_rec.username;
        
        if v_rec.year_study = 3 or v_rec.year_study = 5 then
            execute immediate 'REVOKE INSERT on solves FROM ' || v_rec.username;
        end if;
    end loop;
exception
  when others then dbms_output.put_line('Error: ' || sqlerrm);   
end;
/
execute assign_privs_stud;
select * from solves;