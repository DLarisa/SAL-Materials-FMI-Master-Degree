--1
select value from v$parameter where name='audit_trail';

show parameter audit_trail;

alter system set audit_trail=db,extended scope=spfile;

select value from v$parameter where name='audit_trail';

--pt ca scope=spfile => trebuie repornit Oracle pentru ca valoarea audit_trail sa fie modificata efectiv
-- => shutdown immediate & startup in SQL Plus

select value from v$parameter where name='audit_trail';

audit select table;

desc dba_stmt_audit_opts;

select audit_option, success, failure from dba_stmt_audit_opts;

show con_name;

alter session set container=orclpdb;

alter pluggable database orclpdb open;

alter user hr identified by hr account unlock;

--informatii bd pluggable
desc v$pdbs;
select name, open_mode from v$pdbs;

show con_name;

desc aud$;

select obj$name, userid, sqltext, ntimestamp#
from aud$
order by ntimestamp# desc;

select audit_option, success, failure from dba_stmt_audit_opts;

audit select table;

select obj$name, userid, sqltext, ntimestamp#
from aud$
order by ntimestamp# desc;

--HR a lansat o comanda SELECT. Daca informatia de audit lipseste:
-- 1. verificam optiunile de audit
-- 2. reconectam user-ul sau repornim BD pluggable

--Raport: Sa se afiseze numarul de comenzi select executate:
-- de fiecare utilizator, pentru fiecare tabel;
-- de fiecare utilizator, indiferent de tabel;
-- numarul total de comenzi select, indiferent de utilizator si tabel.
-- Se vor lua in considerare doar tbelele denumite employees, regions, departments.
select userid, obj$creator, obj$name, count(*)
from aud$
where lower(obj$name) in ('employees', 'regions', 'countries')
group by rollup(userid, (obj$creator, obj$name));

noaudit select table;

select obj$name, userid, sqltext, ntimestamp#
from aud$
order by ntimestamp# desc;

-- hr lanseaza o comanda select si aceasta este inca auditata => auditul este inca activ
-- => trebuie reconectat user-ul sau repornita BD pluggable 
alter pluggable database orclpdb close immediate;
alter pluggable database orclpdb open;


--2
show parameter audit_trail;

alter system set audit_trail=xml, extended scope=spfile;

alter session set container=cdb$root;
show con_name;
alter system set audit_trail=xml, extended scope=spfile;

show parameter audit_trail;
select value from v$parameter where name='audit_trail';

show con_name;

alter session set container=orclpdb;
alter pluggable database orclpdb open;
select audit_option, success, failure from dba_stmt_audit_opts;

audit select, insert, update, delete on hr.employees whenever not successful;

select audit_option, success, failure from dba_stmt_audit_opts;

desc dba_obj_audit_opts;

select object_name, object_type, owner, sel, ins, upd, del from dba_obj_audit_opts
where lower(object_name) = 'employees';

show parameter audit;

noaudit all;
noaudit all on default;
noaudit all on hr.employees;
