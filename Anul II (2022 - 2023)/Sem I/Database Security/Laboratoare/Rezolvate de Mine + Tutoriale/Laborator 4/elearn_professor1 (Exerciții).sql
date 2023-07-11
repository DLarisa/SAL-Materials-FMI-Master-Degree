/**************   Laborator 4   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;





/*** Ex1 ***/
-- Testăm dacă poate face SELECT pe homework, după acordarea privilegiilor
select * from elearn_app_admin.homework;
select * from elearn_app_admin.view_homework;
select * from elearn_app_admin.homework; -- trebuie disconnect și connect la sesiune pt a merge

-- Privilegii Sistem
select * from session_privs;
-- Rolurile
select * from session_roles;
-- Privilegii pe obiect
select * from user_tab_privs;
-- Privilegii pe coloana tabelelor
select * from user_col_privs;