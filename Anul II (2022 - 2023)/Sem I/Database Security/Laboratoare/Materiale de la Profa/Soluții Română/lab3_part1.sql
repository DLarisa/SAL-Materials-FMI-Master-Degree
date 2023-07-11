--Lab 3
--1
select value from v$parameter where name='os_authent_prefix';
show parameter os_authent_prefix;

show con_name;
alter session set container=orclpdb;

show parameter remote_os_authent;

alter pluggable database orclpdb open;

--drop user "OPS$AzureAD\LetitiaMarin";
create user "OPS$AzureAD\LetitiaMarin" identified externally;
grant create session to "OPS$AzureAD\LetitiaMarin";

--sau, cf cerintei: creez cont local in Windows (numit ELEARN_CAT) => nume user BD = OPS$<domeniu>\ELEARN_CAT

-- care sunt utilizatorii BD? => interogare pe DD al BD
desc dba_users;
select username, AUTHENTICATION_TYPE 
from dba_users;

--creare utilizatori locali pentru aplicatia de elearning:
--drop user elearn_app_admin;
create user elearn_app_admin identified by parolaadmin password expire;
grant create session to elearn_app_admin;

--drop user elearn_student1;
create user elearn_student1 identified by parolastudent password expire;
grant create session to elearn_student1;

drop user elearn_student2;
create user elearn_student2 identified by parolastudent password expire;
grant create session to elearn_student2;

--drop user elearn_student3;
create user elearn_student3 identified by parolastudent password expire;
grant create session to elearn_student3;

--drop user elearn_profesor1;
create user elearn_profesor1 identified by parolaprof password expire;
grant create session to elearn_profesor1;

create user elearn_profesor2 identified by parolaprof password expire;
grant create session to elearn_profesor2;

create user elearn_asistent3 identified by parolaasist password expire;
grant create session to elearn_asistent3;

--drop user elearn_guest;
create user elearn_guest identified by guest;
grant create session to elearn_guest;

desc dba_users;
select username, AUTHENTICATION_TYPE, ACCOUNT_STATUS, EXPIRY_DATE, CREATED
from dba_users
order by created desc;

--2
desc v$session;
select USERNAME, status, osuser
from v$session
where username like '%ELEARN%';

drop sequence elearn_seq_conex;
create sequence elearn_seq_conex start with 1 increment by 1;

--drop table elearn_audit_conex;
create table elearn_audit_conex (
  id_conex number(6) primary key,
  user_ varchar2(30),
  session_ number(8),
  auth_meth varchar2(40),
  identity_ varchar2(100),
  host_ varchar2(30),
  login_time date,
  logout_time date);
  
create or replace trigger elearn_audit_conex_trigger
after logon on database
begin
  if user like '%ELEARN%' then
     insert into elearn_audit_conex 
     values(elearn_seq_conex.nextval, user, sys_context('userenv', 'sessionid'),
            sys_context('userenv', 'authentication_method'),
            sys_context('userenv', 'authenticated_identity'),
            sys_context('userenv', 'host'), sysdate, null);
     commit;       
  end if;
end;
/

create or replace trigger elearn_audit_deconex_trigger
before logoff on database
begin
  if user like '%ELEARN%' then
    update elearn_audit_conex
    set logout_time = sysdate
    where user_ = user
    and session_ = sys_context('userenv', 'sessionid');
    commit;
  end if;
end;
/

select t.*, to_char(login_time, 'dd/mm/yyyy hh24:mi:ss') as "Ora login",
            to_char(logout_time, 'dd/mm/yyyy hh24:mi:ss')as "Ora logout"
from elearn_audit_conex t;

select USERNAME, status, osuser
from v$session
where username like '%ELEARN%';

--3
alter user elearn_app_admin quota unlimited on users;
alter user "OPS$AzureAD\LetitiaMarin" quota 10M on users;
alter user elearn_profesor1 quota 2M on users;
alter user elearn_profesor2 quota 2M on users;
alter user elearn_asistent3 quota 2M on users;
alter user elearn_student1 quota 0M on users;
alter user elearn_guest quota 0M on users;

desc dba_ts_quotas;
select * from dba_ts_quotas;

--4
--drop profile elearn_profil_guest;
create profile elearn_profil_guest limit
  sessions_per_user 3
  idle_time 3
  connect_time 5;

--drop profile elearn_profil_prof_stud;
create profile elearn_profil_prof_stud limit
  cpu_per_call 6000
  sessions_per_user 1
  password_life_time 7
  failed_login_attempts 3;
  
desc dba_profiles; 
select * from dba_profiles where lower(profile) like '%elearn%';

desc dba_users;
select username, profile from dba_users where lower(username) like '%elearn%' ;

alter user elearn_profesor1 profile elearn_profil_prof_stud; 
alter user elearn_profesor2 profile elearn_profil_prof_stud; 
alter user elearn_asistent3 profile elearn_profil_prof_stud; 
alter user elearn_student1 profile elearn_profil_prof_stud; 
alter user elearn_student2 profile elearn_profil_prof_stud; 

show parameter resource_limit;
alter system set resource_limit=true;

select username, account_status
from dba_users where lower(username) like '%elearn%' ;

alter user elearn_profesor1 account unlock;
