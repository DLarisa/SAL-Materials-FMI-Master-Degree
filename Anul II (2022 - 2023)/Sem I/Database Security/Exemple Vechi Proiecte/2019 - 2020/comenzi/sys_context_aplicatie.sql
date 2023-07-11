create context aplicatie_ctx using proced_aplicatie_ctx;

create or replace procedure proced_aplicatie_ctx is
  v_lang varchar2(50);
begin
  select sys_context('userenv', 'language') into v_lang from dual;
  dbms_output.put_line(v_lang);
  if v_lang not like '%ROMANIAN%' then
    dbms_output.put_line('Pentru ca nu este setata limba romana 
    nu aveti voie sa modificati in campul de first_name si last_name utilizator');
    dbms_session.set_context('APLICATIE_CTX', 'lang_ro', 'nu');
   else 
    dbms_session.set_context('APLICATIE_CTX', 'lang_ro', 'da');
   end if; 
end;
/

execute proced_aplicatie_ctx();


CREATE OR REPLACE TRIGGER TR_AFTER_LOGON
AFTER LOGON
ON DATABASE
BEGIN
proced_aplicatie_ctx();
END;
/