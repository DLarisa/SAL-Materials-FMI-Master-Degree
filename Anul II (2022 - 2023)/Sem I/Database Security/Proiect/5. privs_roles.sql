--------------------------     SYS_LOCAL     --------------------------
-- Pentru a se loga și a acorda permisiunea de a de loga userilor
grant create session to clinica_admin with admin option;
-- Pentru a crea orice tabel (adminii crează pe toate, inclusiv REȚETA din schema doctorilor)
grant create any table to clinica_admin;
-- Are nevoie să acceseze PK
grant create any index to clinica_admin;
-- Acces creare roluri
grant create role to clinica_admin;


----- Roluri și Privilegii
-- Permisiuni Admin (tb sa permita la alți useri sa faca operții pe rețete)
grant select, update, insert, delete on sef1.reteta to clinica_admin with grant option;
grant select, update, insert, delete on doctor2.reteta to clinica_admin with grant option;
grant select, update, insert, delete on doctor3.reteta to clinica_admin with grant option;
grant select, update, insert, delete on doctor4.reteta to clinica_admin with grant option;





--------------------------     CLINICA_ADMIN     --------------------------
----- Roluri și Privilegii
-- Creare Roluri
create role doctor;
create role sef_sectie;
create role asistenta;
create role pacient;
create role public_general;

--- Alocare Permisiuni
-- Permisiune de Creare Sesiuni
grant create session to doctor;
grant create session to sef_sectie;
grant create session to asistenta;
grant create session to pacient;
grant create session to public_general;

-- Permisiuni Doctor
grant select on clinica_admin.doctor to doctor;
grant select on clinica_admin.pacient to doctor;
grant select on clinica_admin.sectie to doctor;
grant select on clinica_admin.procedura to doctor;
grant select on clinica_admin.consultatie to doctor;

-- Permisiuni Șef Secție
grant select, update on clinica_admin.doctor to sef_sectie;
grant select on clinica_admin.pacient to sef_sectie;
grant select on clinica_admin.sectie to sef_sectie;
grant select, update, insert on clinica_admin.procedura to sef_sectie;
grant select on clinica_admin.consultatie to sef_sectie;

-- Permisiuni Asistenta
grant select on clinica_admin.doctor to asistenta;
grant select on clinica_admin.sectie to asistenta;
grant select on clinica_admin.procedura to asistenta;
grant select, update, insert, delete on clinica_admin.consultatie to asistenta;

-- Permisiuni Pacient
grant select on clinica_admin.doctor to pacient;
grant select on clinica_admin.pacient to pacient;
grant select on clinica_admin.sectie to pacient;
grant select on clinica_admin.procedura to pacient;
grant select, update, insert, delete on clinica_admin.consultatie to pacient;
grant select on sef1.reteta to pacient;
grant select on doctor2.reteta to pacient;
grant select on doctor3.reteta to pacient;
grant select on doctor4.reteta to pacient;

-- Permisiuni Vizitator (Public General)
grant select on clinica_admin.doctor to public_general;
grant select on clinica_admin.sectie to public_general;
grant select on clinica_admin.procedura to public_general;

-- Permisiuni speciale pt tabel REȚETA (șefii de secție pot vedea toate rețetele colegilor din subordinea lor)
grant select, update, insert, delete on sef1.reteta to sef_sectie;
grant select, update, insert, delete on doctor2.reteta to sef_sectie;
grant select, update, insert, delete on doctor3.reteta to sef_sectie;
grant select, update, insert, delete on doctor4.reteta to sef_sectie;

--- Asignare Roluri userilor
grant doctor to doctor2;
grant doctor to doctor3;
grant doctor to doctor4;
grant sef_sectie to sef1;
grant asistenta to asistenta1;
grant asistenta to asistenta2;
grant asistenta to asistenta3;
grant pacient to pacient1;
grant pacient to pacient2;
grant pacient to pacient3;
grant public_general to vizitator;


-- Informații privilegii
select * from user_tab_privs;