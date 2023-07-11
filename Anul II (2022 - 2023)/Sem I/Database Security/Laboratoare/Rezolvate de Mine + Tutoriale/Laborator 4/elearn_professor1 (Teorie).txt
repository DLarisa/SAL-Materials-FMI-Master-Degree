-- Teorie
--1
-- Vedem ce privilegii avem
select * from session_privs;
-- Vedem ce tabele avem
select * from tab;

-- Poate modifica pt că e owner
ALTER TABLE ELEARN_professor1.FEEDBACK drop column feedback_date;
DROP TABLE ELEARN_professor1.FEEDBACK ;
INSERT INTO ELEARN_professor1.FEEDBACK VALUES (1, 'very interesting and useful subject', SYSDATE);
commit;
select * from ELEARN_professor1.FEEDBACK ;



--2
--2.1
INSERT INTO ELEARN_APP_ADMIN.COURSE VALUES (2,'NETWORKING',3, 2,5,'E',28,28,0);
commit;
-- delete from feedback; (nu mai tb dacă am pus deja commit;)

desc feedback;

select * from feedback;

--2
select * from user_tab_privs;
select * from session_roles;