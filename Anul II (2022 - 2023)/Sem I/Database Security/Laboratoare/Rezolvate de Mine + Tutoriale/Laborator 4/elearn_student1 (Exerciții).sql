/**************   Laborator 4   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;



/*** Ex4 ***/
--not ok, because student1 is in final year
insert into elearn_app_admin.solves (homework_id, student_id, upload_date) values (2, 2, sysdate);