--1
select value from v$parameter where name = 'os_authent_prefix';
show parameter os_authent_prefix;

show con_name;
alter session set container=orclpdb;

show parameter remote_os_authent;
--if false, then:
--alter session set container=cdb$root;
--alter system set remote_os_authent=true scope=spfile;
-- shutdown immediate & startup (if scope cannot be "both" or "memory")

alter pluggable database orclpdb open;
create user "OPS$AzureAD\LetitiaMarin" identified externally;
grant create session to "OPS$AzureAD\LetitiaMarin";

-- or, according to the requirement of the problem: we create a local account in Windows (named ELEARN_CAT) => DB username = OPS$<domain>\ELEARN_CAT

-- who are the database users? => query on the database's DD
desc dba_users;
select username, authentication_type from dba_users;

-- create local users for the elearning application:
create user elearn_app_admin identified by parolaadmin password expire;
grant create session to elearn_app_admin;

create user elearn_student1 identified by student password expire;
grant create session to elearn_student1;

create user elearn_student2 identified by student password expire;
grant create session to elearn_student2;

create user elearn_student3 identified by student password expire;
grant create session to elearn_student3;

create user elearn_professor1 identified by profesor password expire;
grant create session to elearn_professor1;

create user elearn_professor2 identified by profesor password expire;
grant create session to elearn_professor2;

create user elearn_assistant3 identified by asistent password expire;
grant create session to elearn_assistant3;

create user elearn_guest identified by guest password expire;
grant create session to elearn_guest;

desc dba_users;

select username, authentication_type, account_status, expiry_date, created from dba_users
order by created desc;

--2
desc v$session;
select username, status, osuser
from v$session
where username like 'ELEARN%';

create sequence elearn_seq_conex start with 1 increment by 1;
drop table elearn_audit_conex;
create table elearn_audit_conex (
  id_conex number(8) primary key,
  user_ varchar2(30),
  session_ number(8),
  auth_meth varchar2(40),
  identity varchar2(100),
  host_ varchar2(30),
  login_time date,
  logout_time date);
  
create or replace trigger elearn_audit_conex_trigger
after logon on database
begin
  if user like 'ELEARN%' then
    insert into elearn_audit_conex
    values(elearn_seq_conex.nextval, user, sys_context('userenv', 'sessionid'),
           sys_context('userenv', 'authentication_method'), 
           sys_context('userenv', 'authenticated_identity'),
           sys_context('userenv','host'), sysdate, null);
    commit;
 end if;   
end;
/

create or replace trigger elearn_audit_deconex_trigger
before logoff on database
begin
  if user like 'ELEARN%' then
     update elearn_audit_conex
     set logout_time = sysdate
     where user_ = user
     and session_ = sys_context('userenv', 'sessionid');
     commit;
  end if;   
end;
/

select t.*, to_char(login_time, 'dd/mm/yyyy hh24:mi:ss') as "Ora login",
       to_char(logout_time, 'dd/mm/yyyy hh24:mi:ss') as "Ora logout"
from elearn_audit_conex t;

