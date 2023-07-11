--Lab 5
SELECT substr(grantee,1,15) grantee, owner,
substr(table_name,1,15) table_name, grantor,privilege FROM DBA_TAB_PRIVS
WHERE grantee='ELEARN_PROFESOR1';


GRANT ALL ON DBMS_CRYPTO TO ELEARN_APP_ADMIN;

-- Laborator 5 - exercitii
--1
drop context aplicatie_ctx_2;
create context aplicatie_ctx_2 using proced_aplicatie_ctx_2;

create or replace procedure proced_aplicatie_ctx_2 is
  v_ora number(3);
begin
  select to_number(to_char(sysdate, 'hh24')) into v_ora from dual;
  
  dbms_output.put_line('Este ora: ' || v_ora);
  
  if v_ora < 12 or v_ora > 20 then
    dbms_output.put_line('Sunteti in afara orelor de program.');
    dbms_session.set_context('aplicatie_ctx_2', 'ora_potrivita', 'nu');
  else 
    dbms_session.set_context('aplicatie_ctx_2', 'ora_potrivita', 'da');
  end if;
end;
/

exec proced_aplicatie_ctx_2;

create or replace trigger tr_after_logon
after logon on database
declare
  v_user varchar2(30);
begin
  v_user := sys_context('userenv', 'session_user');
  
  if lower(v_user) like '%elearn_profesor%' or lower(v_user) like '%elearn_asistent%' then
    proced_aplicatie_ctx_2;
  end if;
end;
/


select to_char(sysdate, 'hh24:mi:ss') from dual;