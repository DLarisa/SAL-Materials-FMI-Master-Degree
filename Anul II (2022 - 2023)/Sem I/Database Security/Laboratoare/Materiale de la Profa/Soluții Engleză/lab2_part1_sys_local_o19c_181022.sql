--Lab 2

--1
select value from v$parameter  where name='audit_trail';
show parameter audit_trail;

alter system set audit_trail=db,extended  scope=spfile;

show parameter audit_trail;

--as scope=spfile => Oracle instance must be restarted => shutdown immediate & startup

show parameter audit_trail;

audit select table;

desc dba_stmt_audit_opts;

select audit_option, success, failure from dba_stmt_audit_opts;

show con_name;

alter session set container=orclpdb;

show con_name;

alter user hr identified by hr account unlock; --NOK, pluggable database not open

--info on pluggable databases
desc v$pdbs; --NOK, because we are connected to the PDB
alter session set container=CDB$ROOT;
desc v$pdbs;

select name, open_mode from v$pdbs;

alter pluggable database orclpdb open;

alter session set container=orclpdb;

alter user hr identified by hr account unlock;

select audit_option, success, failure from dba_stmt_audit_opts;

audit select table;

select audit_option, success, failure from dba_stmt_audit_opts;

-- HR launched a query

desc aud$

select obj$name, userid, sqltext, ntimestamp#
from aud$
order by ntimestamp# desc;

select to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') from dual;

--Report: nb of queries executed:
-- - by each user, on each table
-- - by each user, no matter the table
-- - the total number of queries, no matter the user or table
-- Consider only the tables employees, regions, departments.

select userid, obj$creator, obj$name, count(*)
from aud$
where lower(obj$name) in ('employees', 'departments', 'regions')
group by rollup (userid, (obj$creator, obj$name));

select * from hr.regions;

create user test identified by test;
grant connect, resource to test;


--disable the audit in CDB$ROOT
alter session set container=CDB$ROOT;

show con_name;

select audit_option, success, failure from dba_stmt_audit_opts;

noaudit select table;

--disable audit in ORCLPDB
alter session set container=ORCLPDB;

show con_name;

select audit_option, success, failure from dba_stmt_audit_opts;

noaudit select table;

select userid, obj$creator, obj$name, count(*)
from aud$
where lower(obj$name) in ('employees', 'departments', 'regions')
group by rollup (userid, (obj$creator, obj$name));