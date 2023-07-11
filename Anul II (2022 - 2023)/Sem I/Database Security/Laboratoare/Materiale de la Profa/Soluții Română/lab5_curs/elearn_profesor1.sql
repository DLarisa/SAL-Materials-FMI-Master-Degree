EXEC ELEARN_APP_ADMIN.PROC_CURSOR_DINAM('SELECT * FROM ELEARN_APP_ADMIN.REZOLVA');

EXEC ELEARN_APP_ADMIN.PROC_CURSOR_DINAM('DECLARE v_id NUMBER(4); BEGIN DELETE FROM ELEARN_APP_ADMIN.REZOLVA;COMMIT; SELECT id_stud INTO v_id FROM ELEARN_APP_ADMIN.REZOLVA WHERE ID_STUD=1 AND ID_TEMA=2; END; ');

select * from elearn_app_admin.rezolva;

select * from session_privs;

delete from elearn_app_admin.rezolva;

--ex 1
select * from elearn_app_admin.rezolva;

update elearn_app_admin.rezolva
set nota=9, id_corector=1
where id_tema=1 and id_stud=2;

rollback;