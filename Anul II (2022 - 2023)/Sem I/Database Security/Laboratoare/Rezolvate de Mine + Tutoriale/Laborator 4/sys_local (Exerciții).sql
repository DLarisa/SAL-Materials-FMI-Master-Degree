/**************   Laborator 4   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;

/* Pt când se blochează sesiunea: ORA-00054: resource busy and acquire with NOWAIT specified

select object_name, s.sid, s.serial#, p.spid 
from v$locked_object l, dba_objects o, v$session s, v$process p
where l.object_id = o.object_id and l.session_id = s.sid and s.paddr = p.addr;
alter system kill session 'SID, SERIAL';

*/



/*** Ex1 ***/
-- Privilegiul de a crea roluri
grant create role to elearn_app_admin;

--- Pentru a vedea rolurile și userii cu privilegii
select *
from dba_role_privs
where grantee like 'ELEARN%';