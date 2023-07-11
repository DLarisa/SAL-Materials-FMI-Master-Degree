-- Teorie
--2.3
-- După ce primește drepturi de la admin
execute elearn_app_admin.delete_spam('avantajos');
select * from session_privs;





--Exercises
--1
select * from elearn_app_admin.homework;
select * from elearn_app_admin.view_homework;

select * from elearn_app_admin.homework;

select * from elearn_app_admin.homework; --successful only after user reconnects

------
--2
select * from session_privs;
select * from session_roles;
select * from user_tab_privs;

select * from user_col_privs;

update elearn_app_admin.homework set deadline = deadline + 10 where id = 1;
commit;

-- still possible to read:
select * from elearn_app_admin.homework ;

--Method 2

update elearn_app_admin.view_homework set deadline = deadline + 10 where id = 1;

update elearn_app_admin.view_homework set id = 3 where id = 1;

select * from elearn_app_admin.view_homework;
commit;


--Method 3
update elearn_app_admin.homework set deadline = deadline + 10 where id = 1;
update elearn_app_admin.homework set deadline = deadline - 10 where id = 1;

select * from elearn_app_admin.homework ;

commit;

update elearn_app_admin.homework set deadline = deadline + 10 where id = 1;
select * from elearn_app_admin.homework ;

commit;

--3
select * from elearn_app_admin.solves;

execute elearn_app_admin.proc_marking(10,1, 3, 4);
execute elearn_app_admin.proc_marking(10,2, 3, 4);

execute elearn_app_admin.proc_marking(30,1, 3, 8);

--after revoke:
execute elearn_app_admin.proc_marking(40,2, 3, 10); -- NOK

