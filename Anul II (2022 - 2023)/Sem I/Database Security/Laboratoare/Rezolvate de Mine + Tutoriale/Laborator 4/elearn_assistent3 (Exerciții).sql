/**************   Laborator 4   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;





/*** Ex2 ***/
-- Privilegii Sistem
select * from session_privs;
-- Rolurile
select * from session_roles;
-- Privilegii pe obiect
select * from user_tab_privs;
-- Privilegii pe coloana tabelelor
select * from user_col_privs;


select * from elearn_app_admin.homework;


-- După ce a primit privilegii, testăm
update elearn_app_admin.homework 
set deadline = deadline + 10 
where id = 1; -- nu va merge fără privilegiul de select
commit;

update elearn_app_admin.view_homework 
set deadline = deadline + 10 
where id = 1;
commit;





/*** Ex3 ***/
select * from elearn_app_admin.solves; -- nu merge, chiar și cu drepturi

execute elearn_app_admin.proc_marking(10, 1, 3, 4); -- caz special
execute elearn_app_admin.proc_marking(10, 2, 3, 4); -- caz special
execute elearn_app_admin.proc_marking(30, 1, 3, 8); -- merge

--after revoke:
execute elearn_app_admin.proc_marking(40, 2, 3, 10); -- nu mai merge