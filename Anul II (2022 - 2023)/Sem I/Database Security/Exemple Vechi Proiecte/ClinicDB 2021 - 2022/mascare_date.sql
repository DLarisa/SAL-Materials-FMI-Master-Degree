-- These commands should be runned as sys user
-- The path set here is where the data will be exported
create or replace directory direxp_clinic as 'E:\Alex\DatabaseSecurity\Project';
grant read, write on directory direxp_clinic to clinic_admin;

-- The following commands are runned by the clinic_admin user;
create or replace package pack_masking is
  function f_masking_id(id_ number) return number;
  function f_masking_name(name_ varchar2) return varchar2;
  function f_masking_pnc(pnc varchar2) return varchar2;
  function f_masking_phone(phone varchar2) return varchar2;
  function f_masking_email(email varchar2) return varchar2;
end;
/

create or replace package body pack_masking is
  type t_tabind is table of number index by pls_integer;
  v_tabind t_tabind;
  
    function f_masking_id (id_ number) return number is
    v_len number;
    v_min number;
    v_max number;
    v_seed VARCHAR2(100);
    v_new_id number;
  begin
    if v_tabind.exists(id_) then
    -- this is used to use the same value 
    -- for the foreign key from appointment table 
    -- as the primary key from doctors
        return v_tabind(id_); 
    else
        v_len:=length(to_char(id_));
        v_min:=to_number(rpad(substr(to_char(id_),1,1),v_len,'0'));
        v_max:=to_number(rpad(substr(to_char(id_),1,1),v_len,'9'));
        v_seed:=TO_CHAR(SYSTIMESTAMP,'YYYYDDMMHH24MISSFFFF');
        DBMS_RANDOM.seed (val => v_seed);
        v_new_id:=round(DBMS_RANDOM.value(low => v_min, high => v_max),0);
        v_tabind(id_):=v_new_id;
        return v_new_id;
    end if;
  end f_masking_id;
  
  function f_masking_name (name_ varchar2) return varchar2 is
    v_str varchar2(100) := '';
    v_substr varchar2(100);
    v_len number;
    v_len_substr number;
    p_end number;
    p_start number :=1;
    p_substr varchar2(100);
  begin
    v_len := LENGTH(name_);
    p_end := INSTR( name_, ' ', p_start );
    WHILE p_end > 0 LOOP
      p_substr := SUBSTR( name_, p_start, p_end - p_start );
      v_len_substr := p_end - p_start;
      v_substr := substr(p_substr, 1, 1);
      v_str := v_str || rpad(v_substr, v_len_substr, '*') || ' ';
      p_start := p_end + 1;
      p_end := INSTR( name_, ' ', p_start );
    END LOOP;
    IF p_start <= v_len + 1 THEN
      p_substr := SUBSTR( name_, p_start, v_len - p_start + 1 );
      v_len_substr := v_len - p_start + 1;
      v_substr := substr(p_substr, 1, 1);
      v_str := v_str || rpad(v_substr, v_len_substr, '*');
    END IF;
    return v_str;
  end f_masking_name;
  
  function f_masking_pnc(pnc varchar2) return varchar2 is
    v_len number;
    v_min number;
    v_max number;
    v_seed VARCHAR2(100);
    v_new_pnc number;
  begin
    v_len:=length(to_char(pnc));
    v_min:=to_number(rpad(substr(to_char(pnc),1,1),v_len,'0'));
    v_max:=to_number(rpad(substr(to_char(pnc),1,1),v_len,'9'));
    v_seed:= TO_CHAR(SYSTIMESTAMP,'YYYYDDMMHH24MISSFFFF');
    DBMS_RANDOM.seed (val => v_seed);
    v_new_pnc:= round(DBMS_RANDOM.value(low => v_min, high => v_max),0);
    return v_new_pnc;
  end f_masking_pnc;
  
  function f_masking_phone(phone varchar2) return varchar2 is
    v_len number;
    v_min number;
    v_max number;
    v_seed VARCHAR2(100);
    v_new_phone varchar2(10);
  begin
    v_len:=length(to_char(phone));
    dbms_output.put_line(substr(to_char(phone),1,3));
    v_min:=to_number(rpad(substr(to_char(phone),1,3),v_len,'0'));
    v_max:=to_number(rpad(substr(to_char(phone),1,3),v_len,'9'));
    v_seed:= TO_CHAR(SYSTIMESTAMP,'YYYYDDMMHH24MISSFFFF');
    DBMS_RANDOM.seed (val => v_seed);
    v_new_phone:= lpad(to_char(round(DBMS_RANDOM.value(low => v_min, high => v_max),0)), v_len, '0');
    return v_new_phone;
  end f_masking_phone;
  
  function f_masking_email (email varchar2) return varchar2 is
    v_str varchar2(100) := '';
    pos_arond number;
  begin
    pos_arond := INSTR(email, '@');
    v_str := rpad(substr(email, 1, 2), pos_arond-2, '*') || substr(email, pos_arond-2);
    return v_str;
  end f_masking_email;
  
  
end;
/

-- Calls for testing the functions from the masking package
select pack_masking.f_masking_name('Maranda B Williams') from dual;
select pack_masking.f_masking_pnc('1990420140136') from dual;
select pack_masking.f_masking_phone('0752102395') from dual;
select pack_masking.f_masking_email('kenny_okeef10@yahoo.com') from dual;
select pack_masking.f_masking_id(100) from dual;
-- la doua rulari consecutive se pastreaza aceeasi valoare pentru id
select pack_masking.f_masking_id(100) from dual;
-- for a different value we will always have a different output (even if first digit is similar)
select pack_masking.f_masking_id(120) from dual;


-- Pentru exportarea bazei de date, se va rula in cmd:
expdp clinic_admin/clinic_admin@clinicpdb tables=doctors,appointments,sections,procedures,patients remap_data=doctors.doctor_name:pack_masking.f_masking_name remap_data=doctors.doctor_id:pack_masking.f_masking_id remap_data=doctors.pnc:pack_masking.f_masking_pnc remap_data=doctors.phone_number:pack_masking.f_masking_phone remap_data=doctors.email:pack_masking.f_masking_email remap_data=sections.chief_id:pack_masking.f_masking_id remap_data=patients.patient_name:pack_masking.f_masking_name remap_data=patients.pnc:pack_masking.f_masking_pnc remap_data=patients.phone_number:pack_masking.f_masking_phone remap_data=patients.email:pack_masking.f_masking_email remap_data=appointments.doctor_id:pack_masking.f_masking_id directory=direxp_clinic dumpfile=EXPORT_FILE.dmp
-- To import the masked data into a database, we run in cmd the following command:
impdp clinic_admin/clinic_admin@clinicpdb directory=direxp_clinic dumpfile=EXPORT_FILE.DMP TABLES=doctors,appointments,sections,procedures,patients remap_table=doctors:doctors_masked remap_table=appointments:appointments_masked remap_table=sections:sections_masked remap_table=procedures:procedures_masked remap_table=patients:patients_masked remap_table=prescriptions:prescriptions_masked
-- Should allow user clinic_admin access to system tablespace