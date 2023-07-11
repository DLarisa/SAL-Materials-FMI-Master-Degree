--1
select * from elearn_app_admin.tema_casa;

select * from elearn_app_admin.viz_tema;

select * from session_privs;
select * from session_roles;

--trebuie deconectat si reconectat ca sa i se aplice rolul creat intre timp de elearn_app_admin
select * from elearn_app_admin.tema_casa;

--2
--utilizatorul poate exercita privilegiul update doar daca il detine inca si pe cel de "select"!
update elearn_app_admin.tema_casa
set deadline=sysdate + 14
where id=1;

rollback;
select * from elearn_app_admin.tema_casa;