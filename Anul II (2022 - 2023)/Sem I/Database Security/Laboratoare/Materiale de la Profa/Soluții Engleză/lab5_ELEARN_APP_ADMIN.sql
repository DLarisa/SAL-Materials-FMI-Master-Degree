select * from solves;

update solves
set grade=null, corrector_id = null
where homework_id=2 and student_id=1;

commit;

create or replace trigger tr_before_update before update on solves
begin
  if sys_context('app_ctx', 'attr_hour') = 'no' then
    dbms_output.put_line('Out of working hours!');
    raise_application_error(-20009, 'You cannot update table SOLVES right now!');
  end if;  
end;
/

select * from solves;

update solves 
set upload_date = sysdate 
where upload_date is null;

commit;

CREATE OR REPLACE PROCEDURE FIND_DANGERS(
P_UPLOAD_DATE VARCHAR2) AS
TYPE t_table IS TABLE OF SOLVES%ROWTYPE;
v_table t_table;
BEGIN
EXECUTE IMMEDIATE 'SELECT * FROM SOLVES WHERE TO_CHAR(UPLOAD_DATE,''DD-MM-YYYY HH24:MI:SS'') LIKE''%'||P_UPLOAD_DATE ||'%'''
BULK COLLECT INTO v_table;
FOR i IN 1..v_table.COUNT LOOP
DBMS_OUTPUT.PUT_LINE('STUDENT:' || v_table(i).STUDENT_ID || ' HAS THE GRADE:' ||NVL(v_table(i).GRADE,-1)|| 'AT THE HOMEWORK:' || v_table(i).HOMEWORK_ID || 'UPLOADED ON: ' || v_table(i).UPLOAD_DATE);
END LOOP;
END;
/

grant execute on FIND_DANGERS to elearn_assistant3;

select * from student;

update student
set resume_studies = 1
where id=2;

commit;