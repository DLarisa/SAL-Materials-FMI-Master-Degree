show con_name;
--Lab 5
--1
create context app_ctx using proced_app_ctx;

create or replace procedure proced_app_ctx is
  v_hour number(3);
begin
  select to_number(to_char(sysdate, 'hh24')) into v_hour from dual;
  
  dbms_output.put_line('Hour: ' || v_hour);
  
  if v_hour < 10 or v_hour > 20 then
    dbms_output.put_line ('Out of working hours!');
    dbms_session.set_context('app_ctx', 'attr_hour', 'no');
  else
    dbms_session.set_context('app_ctx', 'attr_hour', 'yes');
  end if;  
end;
/

select to_char(sysdate, 'hh24') from dual;

execute proced_app_ctx;

select sys_context('app_ctx', 'attr_hour') from dual;

create or replace trigger tr_after_logon
after logon on database
declare
  v_user varchar2(30);
begin
  v_user := sys_context('userenv', 'session_user');
  
  if lower(v_user) like '%elearn_professor%' or lower(v_user) like '%elearn_assistant%' then
    proced_app_ctx;
  end if;
end;
/