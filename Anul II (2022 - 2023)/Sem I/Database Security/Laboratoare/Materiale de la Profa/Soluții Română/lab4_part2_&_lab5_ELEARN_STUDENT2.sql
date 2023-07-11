select * from session_privs;
select * from session_roles;
select * from user_tab_privs;
select * from user_col_privs;

--ok, pentru ca elearn_student2 este in an neterminal
insert into elearn_app_admin.rezolva(id_tema, id_stud, data_upload) values(2, 2, sysdate);

commit;

--nok - insufficient privileges
select id_tema, id_stud, data_upload from elearn_app_admin.rezolva;