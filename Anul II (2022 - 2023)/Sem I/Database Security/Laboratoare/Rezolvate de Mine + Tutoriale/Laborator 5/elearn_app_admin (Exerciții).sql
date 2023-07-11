/**************   Laborator 5   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;



/*** Ex1 ***/
delete from solves;
commit;
select * from solves;
insert into solves(homework_id, student_id, upload_date) values (1, 2, sysdate);
insert into solves(homework_id, student_id, upload_date) values (2, 1, sysdate);

-- Profii/Asistenții nu au voie să dea note dacă contextul e NU
create or replace trigger tr_before_update 
before update on solves
begin
    if sys_context('app_ctx', 'attr_hour') = 'no' then
        dbms_output.put_line('Out of working hours!');
        raise_application_error(-20009, 'You cannot update table SOLVES right now!');
    end if;  
end;
/
grant select, update on solves to elearn_professor2;
-- mai elegant: execute elearn_app_admin_sla.proc_marking(1, 2, 3, 10); pt professor2
-- În cazul în care dorim sa facem update de aici, nu avem eroare pt ca app_admin nu începe cu ELEARN





/*** Ex2 ***/
CREATE OR REPLACE PROCEDURE FIND_DANGERS(P_UPLOAD_DATE VARCHAR2) AS
  TYPE t_table IS TABLE OF ELEARN_APP_ADMIN.SOLVES%ROWTYPE;
  v_table t_table;
BEGIN
    EXECUTE IMMEDIATE 'SELECT * FROM SOLVES WHERE TO_CHAR(UPLOAD_DATE,''DD-MM-YYYY HH24:MI:SS'') LIKE''%'||P_UPLOAD_DATE ||'%'''
    BULK COLLECT INTO v_table;
    
    FOR i IN 1..v_table.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('STUDENT:' || v_table(i).STUDENT_ID || ' HAS THE GRADE:' ||
        NVL(v_table(i).GRADE,-1)|| 'AT THE HOMEWORK:' || v_table(i).HOMEWORK_ID || 
        'UPLOADED ON: ' || v_table(i).UPLOAD_DATE);
    END LOOP;
END;
/
grant execute on FIND_DANGERS to elearn_professor2;