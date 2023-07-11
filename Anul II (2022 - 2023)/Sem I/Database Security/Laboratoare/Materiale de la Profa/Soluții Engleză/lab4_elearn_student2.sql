select * from session_privs;
select * from session_roles;
select * from user_tab_privs;
select * from user_col_privs;

--ok, because student2 is in undergraduate 1st year
insert into elearn_app_admin.solves (homework_id, student_id, upload_date) values (1, 1, sysdate);

--no privileges to select:
select homework_id, student_id, upload_date from elearn_app_admin.solves;
commit;