--------------------------     SYS_LOCAL     --------------------------
----- Contextul Aplicației
create context clinica_context using procedura_clinica_context;
create or replace procedure procedura_clinica_context is
  v_hour number(3);
begin
    select to_number(to_char(sysdate, 'hh24')) into v_hour from dual;
    dbms_output.put_line('Hour: ' || v_hour);
    
    if v_hour < 8 or v_hour > 20 then
        dbms_output.put_line ('Nu se pot face programari in afara orelor de lucru!');
        dbms_session.set_context('clinica_context', 'attr_hour', 'NU');
    else
        dbms_session.set_context('clinica_context', 'attr_hour', 'DA');
    end if; 
end;
/
execute procedura_clinica_context;

-- Asistentele și Pacienții la login primesc acest context automat
create or replace trigger tr_after_logon
after logon on database
declare
  v_user varchar2(30);
begin
    v_user := sys_context('userenv', 'session_user');
    if lower(v_user) like '%asistenta%' or lower(v_user) like '%pacient%' then
        procedura_clinica_context;
    end if;
end;
/




--------------------------     CLINICA_ADMIN     --------------------------
----- Contextul Aplicației
-- Asistentele și Pacienții nu au voie să facă programari dacă contextul e NU
create or replace trigger tr_before_insert 
before insert on consultatie
begin
    if sys_context('clinica_context', 'attr_hour') = 'NU' then
        dbms_output.put_line('Nu se pot face programari - INSERT!');
        raise_application_error(-20009, 'You cannot insert into table CONSULTATIE right now!');
    end if;  
end;
/

create or replace trigger tr_before_update
before update on consultatie
begin
    if sys_context('clinica_context', 'attr_hour') = 'NU' then
        dbms_output.put_line('Nu se pot face programari - UPDATE!');
        raise_application_error(-20009, 'You cannot insert into table CONSULTATIE right now!');
    end if;  
end;
/



--------------------------     PACIENT1     --------------------------
-- Contextul aplicației 
insert into clinica_admin.consultatie values (12, sysdate, 14, 13, 25, 202);
update clinica_admin.consultatie set id_procedura = 101 where id_consultatie = 11;
rollback;








----------- SQL Injection
--------------------------     CLINICA_ADMIN     --------------------------
-- SQL Injection
create or replace procedure vede_consultatiile(cnp varchar2) as
    type t_table is table of consultatie%rowtype;
    v_table t_table;
begin
    execute immediate 'select c.* from consultatie c, pacient p where c.id_pacient = p.id_pacient and p.cnp = ' || cnp
    bulk collect into v_table;
    for i in 1..v_table.count loop
        dbms_output.put_line('Consultatii in data ' || v_table(i).data_consultatie || ', la ora ' || v_table(i).ora);
    end loop;
end;
/
grant execute on vede_consultatiile to pacient;



--------------------------     PACIENT1     --------------------------
-- SQL Injection
-- Comportament Normal (Cerere Onesta)
execute clinica_admin.vede_consultatiile('1234567890');
-- Injecție
execute clinica_admin.vede_consultatiile('2 union select * from consultatie');