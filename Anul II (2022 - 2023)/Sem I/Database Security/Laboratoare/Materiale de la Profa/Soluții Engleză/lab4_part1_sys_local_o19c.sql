-- Teorie (în orclpdb, nu în root)
--1.1
GRANT CREATE SESSION TO ELEARN_APP_ADMIN; -- drep sesiune

--1.2
GRANT CREATE TABLE TO ELEARN_APP_ADMIN; -- drept creare tabel

--1.3 -- Privilegii Posibile
select name from
system_privilege_map where
name like '%ANY%' order by name;

-- Ambele pentru a putea crea tabele (constrângere de tabel și de cheie primară)
GRANT CREATE ANY TABLE TO ELEARN_APP_ADMIN;
GRANT CREATE ANY INDEX TO ELEARN_APP_ADMIN;

-- Ownerii tabelelor create (professor1 e owner ot feedback chiar dacă a fost creat de admin)
select owner, object_name from all_objects where owner like '%ELEARN%';
GRANT ALTER ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN;



--2
--2.2
-- Privilegii pentru view (pt că facem și select în acel view)
GRANT CREATE VIEW TO ELEARN_APP_ADMIN ;
GRANT SELECT ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT SELECT ON ELEARN_professor2.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT SELECT ON ELEARN_assistent3.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;


-- Privilegii trigger (pt că facem insert în acel trigger)
GRANT CREATE TRIGGER TO ELEARN_APP_ADMIN;
GRANT INSERT ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT INSERT ON ELEARN_professor2.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;
GRANT INSERT ON ELEARN_assistent3.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;



--2.3
-- Acordă privilegii de creare procedură lui admin
GRANT CREATE PROCEDURE TO ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN WITH GRANT OPTION;

-- Revocă drepturi și realocă
REVOKE DELETE ON ELEARN_professor1.FEEDBACK FROM ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN;


-- Detalii privilegii
desc dba_role_privs;
desc dba_tab_privs;
select grantee, owner, table_name, grantor, privilege, grantable
from dba_tab_privs
where lower(table_name) = 'feedback';


-- Roluri (conțin privilegii)
grant create role to elearn_app_admin;
SELECT * FROM DBA_role_privs WHERE grantee like '%ELEARN%';





-- Lab 4 
-- 2.3 case 2) revisited

REVOKE EXECUTE ON ELEARN_APP_ADMIN.DELETE_SPAM FROM
ELEARN_assistant3;

REVOKE DELETE ON ELEARN_professor1.FEEDBACK FROM ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN;
GRANT DELETE ON ELEARN_professor1.FEEDBACK TO ELEARN_APP_ADMIN with grant option;

alter user elearn_assistant3 identified by assistant3;

grant sel_homework to elearn_app_admin with admin option;