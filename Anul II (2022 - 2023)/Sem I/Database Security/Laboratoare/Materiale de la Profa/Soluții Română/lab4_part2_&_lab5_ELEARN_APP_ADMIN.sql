--Laborator4 (continuare)
--3
create or replace procedure proc_notare(p_codStud number, p_codTema number, p_codCorector number, p_nota number)
is
  v_contor number(1) := 0;
begin
  select count(*) into v_contor
  from rezolva
  where id_stud = p_codStud 
  and id_tema = p_codTema;
  
  if v_contor = 0 then
    dbms_output.put_line('Eroare: nu sunt respectate conditiile de notare - studentul nu a depus tema');
  else
    select count(nota) into v_contor 
    from rezolva
    where id_stud = p_codStud 
    and id_tema = p_codTema;
    
    if v_contor > 0 then 
      dbms_output.put_line('Eroare: nu sunt respectate conditiile de notare - tema a fost deja notata.');
    else 
      update rezolva 
      set nota = p_nota, id_corector = p_codCorector
      where id_stud = p_codStud 
      and id_tema = p_codTema;
      commit;
    end if;  
  end if;
exception 
  when others then dbms_output.put_line('Eroare: ' || sqlerrm); 
end;
/

grant execute on proc_notare to elearn_profesor1, elearn_profesor2, elearn_asistent3;

select * from rezolva;

select * from utilizator;

--4
select * from student;

revoke insert on rezolva from elearn_student2;

create or replace procedure atrib_priv_stud is 
  cursor c is select numeuser, anul 
              from utilizator u join student s on (u.id = s.id)
              where upper(u.tip) = 'STUDENT';
begin
  for v_rec in c loop
    execute immediate 'grant insert(id_tema, id_stud, data_upload) on rezolva to ' ||v_rec.numeuser;
    
    if v_rec.anul = 3 or v_rec.anul = 5 then
      execute immediate 'revoke insert on rezolva from ' || v_rec.numeuser;
    end if;  
  end loop;
  
exception
  when others then dbms_output.put_line ('Eroare: ' || sqlerrm);
end;
/

execute atrib_priv_stud;

select * from rezolva;

delete from elearn_app_admin.rezolva where id_stud = 2 and id_tema=2;

commit;


--Laborator 5
--2
CREATE OR REPLACE PROCEDURE GASITI_PERICOLE(P_DATAUP VARCHAR2) AS
TYPE vector IS TABLE OF ELEARN_APP_ADMIN.REZOLVA%ROWTYPE;
v_vector vector;
BEGIN
EXECUTE IMMEDIATE 'SELECT * FROM REZOLVA WHERE TO_CHAR(DATA_UPLOAD,''DD-MM-YYYY HH24:MI:SS'') LIKE''%'||P_DATAUP||'%'''
BULK COLLECT INTO v_vector;
FOR i IN 1..v_vector.COUNT LOOP
DBMS_OUTPUT.PUT_LINE('STUDENTUL:' || v_vector(i).ID_STUD || 'LA TEMA:' || v_vector(i).ID_TEMA || 'UPLOADATA LA DATA: ' || v_vector(i).DATA_UPLOAD || ' ARE NOTA:' ||NVL(v_vector(i).NOTA,-1));
END LOOP;
END;
/

grant execute on gasiti_pericole to elearn_asistent3;

desc student;

--alter table student add (reluare_studii number(1));
--update student set reluare_studii = 1 where id = 2;
--commit;

select * from student;
select * from rezolva;

