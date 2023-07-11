-- Similar to the example in the lab, we will use the application context
-- to restrict appointments to be only made in the interval 8-22
create context app_ctx using proced_app_ctx;

create or replace procedure proced_app_ctx is
  v_hour number(3);
begin
  select to_number(to_char(sysdate, 'hh24')) into v_hour from dual;
  
  dbms_output.put_line('Hour: ' || v_hour);
  
  if v_hour < 8 or v_hour > 22 then
    dbms_output.put_line ('Out of working hours!');
    dbms_session.set_context('app_ctx', 'attr_hour', 'no');
  else
    dbms_session.set_context('app_ctx', 'attr_hour', 'yes');
  end if;  
end;
/

create or replace trigger tr_after_logon
after logon on database
declare
  v_user varchar2(30);
begin
  v_user := sys_context('userenv', 'session_user');
  
  if lower(v_user) like '%clinic_patient%' then
    proced_app_ctx;
  end if;
end;
/


-- We will restrict actions of users on the table appointments outside working hours
-- This is run under clinic_admin
create or replace trigger tr_before_update before update on appointments
begin
  if sys_context('app_ctx', 'attr_hour') = 'no' then
    dbms_output.put_line('Out of working hours!');
    raise_application_error(-20009, 'You cannot update table APPOINTMENTS right now!');
  end if;  
end;
/

select * from clinic_admin.appointments;
-- Running this outside the interval 8-22 does not allow a patient to change its appointments
update clinic_admin.appointments set appointment_day=sysdate+5 where appointment_id = 214;
rollback;


-- SQL Injection
CREATE OR REPLACE PROCEDURE SEE_APPOINTMENT(pnc varchar2) AS
    TYPE t_table IS TABLE OF APPOINTMENTS%ROWTYPE;
    v_table t_table;
BEGIN
--    dbms_output.put_line('select a.* from appointments a, patients p where a.patient_id = p.patient_id AND p.pnc=' || pnc);
    EXECUTE IMMEDIATE 'select a.* from appointments a, patients p where a.patient_id = p.patient_id AND p.pnc=' || pnc
    BULK COLLECT INTO v_table;
    FOR i IN 1..v_table.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('APPOINTMENT ON THE DATE ' || v_table(i).APPOINTMENT_DAY || ' AT HOUR ' || v_table(i).APPOINTMENT_HOUR);
    END LOOP;
END;
/

grant execute on see_appointment to patient;

-- A regular execution of the function
execute clinic_admin.see_appointment('2981123025354');
--execute clinic_admin.see_appointment('2; INSERT INTO clinic_chief3.prescriptions VALUES(1111, 1, ''Niste pastile pana la urmatoarea programare'', sysdate+100, 100)' );

-- An attempt to use SQL Injection to extract more informations then allowed
execute clinic_admin.see_appointment('2 union select 99 as appointment_id, 99 as pacient_id, 99 as doctor_id, 99 as procedure_id, appointment_day as appointment_day, appointment_hour as appointment_hour from appointments where appointment_hour > 0');