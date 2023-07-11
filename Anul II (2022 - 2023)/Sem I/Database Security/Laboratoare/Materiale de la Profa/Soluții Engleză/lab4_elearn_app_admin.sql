-- Teorie
--1.2
CREATE TABLE COURSE
(id number(6) primary key,
course_name varchar2(30) NOT NULL,
year_of_study number(1) NOT NULL, semester number(1) NOT NULL,
nb_credits number(1) NOT NULL,
assessment_type VARCHAR2(10) DEFAULT 'EXAM',
nb_course_hours number(2) DEFAULT 28,
nb_lab_hours number(2) DEFAULT 14,
nb_seminar_hours number(2) DEFAULT 0);

-- Ce privilegii avem
select * from session_privs;

ALTER TABLE COURSE drop column nb_seminar_hours;
DROP TABLE COURSE ; -- then re-create it
INSERT INTO COURSE VALUES (1,'DATABASE SECURITY', 6,1,5,'E',28,14,0);



--1.3
-- Creăm tabel în schema lui professor1
CREATE TABLE ELEARN_professor1.FEEDBACK
( id number(6) primary key, message varchar2(200), feedback_date date);


-- Nu are privilegii de alter, insert sau drop
ALTER TABLE ELEARN_professor1.FEEDBACK drop column feedback_date;
DROP TABLE ELEARN_professor1.FEEDBACK ;
CREATE TABLE ELEARN_professor1.FEEDBACK
(id number(6) primary key, message varchar2(200), feedback_date date);
INSERT INTO ELEARN_professor1.FEEDBACK VALUES (1, 'very interesting and useful subject', SYSDATE);
select * from ELEARN_professor1.FEEDBACK;



--2
--2.1
GRANT SELECT,INSERT,UPDATE ON ELEARN_APP_ADMIN.COURSE TO ELEARN_professor1;

ALTER TABLE ELEARN_professor1.FEEDBACK drop column feedback_date;

ALTER TABLE ELEARN_professor1.FEEDBACK add student_id NUMBER(4);
ALTER TABLE ELEARN_professor1.FEEDBACK add feedback_date date;

--2.2
CREATE TABLE ELEARN_professor2.FEEDBACK
( id number(6) primary key,
message varchar2(200), student_id number(4),
feedback_date date);
CREATE TABLE ELEARN_assistent3.FEEDBACK
( id number(6) primary key,
message varchar2(200), student_id number(4),
feedback_date date);


-- Mai întâi tb privilegii de view din sys
CREATE OR REPLACE VIEW FEEDB_VIEW AS
SELECT MESSAGE,STUDENT_ID,'PROF1' AS prof
FROM ELEARN_professor1.FEEDBACK
UNION
SELECT MESSAGE,STUDENT_ID,'PROF2' AS prof
FROM ELEARN_professor2.FEEDBACK
UNION
SELECT MESSAGE,STUDENT_ID,'ASIST3' AS prof
FROM ELEARN_assistent3.FEEDBACK;
-- Drept de view pt student1
GRANT SELECT ON ELEARN_APP_ADMIN.FEEDB_VIEW TO
ELEARN_student1;



-- Creăm trigger
CREATE OR REPLACE TRIGGER TR_FEEDB
INSTEAD OF INSERT ON FEEDB_VIEW
FOR EACH ROW
BEGIN
IF :NEW.PROF='PROF1' THEN
INSERT INTO ELEARN_professor1.FEEDBACK
VALUES(SYSDATE - TO_DATE('2000-01-01', 'yyyy-mm-dd'),
:NEW.MESSAGE,101,SYSDATE);
END IF;
IF :NEW.PROF='PROF2' THEN
INSERT INTO ELEARN_professor2.FEEDBACK
VALUES(SYSDATE - TO_DATE('2000-01-01', 'yyyy-mm-dd'),
:NEW.MESSAGE,101,SYSDATE);
END IF;
IF :NEW.PROF='ASIST3' THEN
INSERT INTO ELEARN_assistent3.FEEDBACK
VALUES(SYSDATE - TO_DATE('2000-01-01', 'yyyy-mm-dd'),
:NEW.MESSAGE,101,SYSDATE);
END IF;
END;
/

-- Privilegii de insert studentului
GRANT INSERT ON ELEARN_APP_ADMIN.FEEDB_VIEW
TO ELEARN_student1;




--2.3
-- După ce a primit privilegii de la sys
CREATE OR REPLACE PROCEDURE DELETE_SPAM(key1 VARCHAR2, key2 VARCHAR2 default 'advertisement', 
key3 VARCHAR2 default 'publicity') authid current_user AS
BEGIN
DELETE FROM ELEARN_professor1.FEEDBACK
WHERE MESSAGE LIKE '%'||key1||'%' OR MESSAGE LIKE '%'||key2||'%'
OR MESSAGE LIKE '%'||key3||'%';
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' spam mesages have been deleted from the professor 1''s table');
COMMIT;
END;
/
execute delete_spam('avantajos');
-- Drepturi pentru procedură și lui assitent3
grant execute on delete_spam to elearn_assistant3;




--Exercises
--1
drop table solves;
create table homework (
  id number(4) primary key,
  requirement varchar2(200) not null,
  id_course number(4),
  deadline date, 
  points number(4, 2),
  foreign key (id_course) references course(id));

create table solves (
   homework_id number(4) references homework(id),
   student_id number(4),
   upload_date date, 
   grade number(4, 2),
   corrector_id number(4),
   primary key (homework_id, student_id));
   
--insert into solves ( homework_id, student_id, upload_date) values (1, 2, sysdate - 3);
--insert into solves ( homework_id, student_id, upload_date) values (2, 1, sysdate - 7);

select * from tab;

insert into homework values(1, 'Recapitulare: Sa se rezolve... ', 1, sysdate + 3, 0.25);
insert into homework values(2, 'Introducere: Sa se scrie un program care... ', 1, sysdate + 6, 0.5);
commit;

--Method 1
grant select on homework to elearn_professor1;
grant select on homework to elearn_professor2;
grant select on homework to elearn_assistant3;

revoke select on homework from elearn_assistant3;

--Method 2
create or replace view view_homework as select id, requirement, id_course from homework;

grant select on view_homework to elearn_professor1;
grant select on view_homework to elearn_professor2;
grant select on view_homework to elearn_assistant3;

revoke select on view_homework from elearn_assistant3;

--Method 3
create role sel_homework;
grant select on homework to sel_homework;
grant sel_homework to elearn_professor1, elearn_professor2, elearn_assistant3;

revoke sel_homework from elearn_assistant3;

--2
select * from tab;

desc homework;

select * from homework;

--Method 1
grant update(deadline) on homework to elearn_professor1;
grant update(deadline) on homework to elearn_professor2;
grant update(deadline) on homework to elearn_assistant3;

-- needed in order to make the "update" work
grant select on homework to elearn_assistant3;

select * from homework;

revoke update on homework from elearn_assistant3;

--Method 2
create or replace view view_homework as select id, deadline from homework;
grant update(deadline) on view_homework to elearn_professor1;
grant update(deadline) on view_homework to elearn_professor2;
grant update(deadline) on view_homework to elearn_assistant3;

grant select on view_homework to elearn_assistant3;
--revoke select on view_homework from elearn_assistant3;

select * from view_homework;

revoke update on view_homework from elearn_assistant3;

-- Method 3
revoke select on homework from elearn_assistant3;

grant update(deadline) on homework to sel_homework;
grant sel_homework to elearn_assistant3;

revoke sel_homework from elearn_assistant3;

--3
desc solves;

select * from solves;
select * from homework;
insert into solves(homework_id, student_id, grade) values(1, 10, 9); 
insert into solves(homework_id, student_id, grade) values(2, 20, 10);

commit;

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

grant execute on proc_marking to elearn_professor1, elearn_professor2, elearn_assistant3;

select * from solves;

insert into solves (homework_id, student_id, upload_date) values (1, 30, sysdate -3);
insert into solves (homework_id, student_id, upload_date) values (2, 40, sysdate -1);
commit;

revoke execute on proc_marking from elearn_assistant3;

--4
create table user_ (
  id number(5) primary key,
  type_ varchar2(15) default 'STUDENT',
  last_name varchar2(20) not null,
  first_name varchar2(20) not null,
  username varchar2(20) not null,
  date_in date,
  date_out date);
  
create table student (
   id number(4) primary key,
   year_study number(1) not null,
   resume_studies number(1),
   interrupted_studies number(1),
   foreign key(id) references user_(id));
   
insert into user_ values (1, 'STUDENT', 'Name1', 'FirstName1', 'ELEARN_STUDENT2', sysdate -300, null);  
insert into user_ values (2, 'STUDENT', 'Name2', 'FirstName2', 'ELEARN_STUDENT3', sysdate -1200, null);

insert into student values(1,1, 0,0);
insert into student values(2,3, 0,0);

commit;

create or replace procedure assign_privs_stud is
   cursor c is 
        select username, year_study
        from user_ u join student s on (u.id = s.id)
        where u.type_='STUDENT';
             
begin
   for v_rec in c loop
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