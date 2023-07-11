
--3
drop sequence secv_id_cheie;
drop table tabel_chei;
create sequence secv_id_cheie start with 1 increment by 1;

create table tabel_chei(
  id_cheie number constraint pk_tabel_chei primary key,
  cheie raw(16) not null,
  nume_tabel varchar2(30) not null);
  
drop table employees_cript;  
create table employees_cript  (
  id number(4)  primary key,
  employee_id_cript varchar2(100) primary key,
  salary_cript varchar2(100));
  
create or replace procedure criptare_par_impar as
  cheie_impar raw(16);
  cheie_par raw(16);
  
  mod_operare pls_integer;
  
  cursor c_criptare is select employee_id, salary from employees;
  
  raw_empid raw(100);
  raw_salary raw(10);
  
  contor number := 1;
  
  rezultat_empid raw(100);
  rezultat_salary raw(100);
begin
  cheie_impar := dbms_crypto.randombytes(16);
  cheie_par := dbms_crypto.randombytes(16);
  
  dbms_output.put_line('Cheie impar: ' || cheie_impar);
  dbms_output.put_line('Cheie par: ' || cheie_par);
  
  insert into tabel_chei values(secv_id_cheie.nextval, cheie_impar, 'employees');
  insert into tabel_chei values(secv_id_cheie.nextval, cheie_par, 'employees');
  
  mod_operare := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
  
  for rec in c_criptare loop
     raw_empid := utl_i18n.string_to_raw(rec.employee_id, 'AL32UTF8');
     raw_salary := utl_i18n.string_to_raw(rec.salary, 'AL32UTF8');
     
     if (mod(contor, 2) = 1) then
        rezultat_empid := dbms_crypto.encrypt(raw_empid, mod_operare, cheie_impar);
        rezultat_salary := dbms_crypto.encrypt(raw_salary, mod_operare, cheie_impar);
     else
        rezultat_empid := dbms_crypto.encrypt(raw_empid, mod_operare, cheie_par);
        rezultat_salary := dbms_crypto.encrypt(raw_salary, mod_operare, cheie_par);
     end if;
     
     insert into employees_cript values(contor, rezultat_empid, rezultat_salary);
     
     contor := contor + 1;

  end loop;
  
  commit;  
end;
/

execute criptare_par_impar;

select * from tabel_chei;

select * from employees_cript;

--4
update employees_cript
set salary_cript = '1F4'
where rownum = 1;

select * from employees_cript;

rollback;

--5
drop table employees_decript;
create table employees_decript (
  empid_decript varchar2(100),
  sal_decript varchar2(100));
  
create or replace procedure decriptare_par_impar as
  cheie_impar raw(16);
  cheie_par raw(16);
  cheie raw(100);
  
  mod_operare pls_integer;
  
  cursor c_decriptare is select id, employee_id_cript, salary_cript from employees_cript;
  
  contor number := 1;
  
  rezultat_empid raw(100);
  rezultat_salary raw(100);
  
begin
  select cheie into cheie_impar from tabel_chei where id_cheie = 1;
  select cheie into cheie_par from tabel_chei where id_cheie = 2;
  
  mod_operare := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
  
  for rec in c_decriptare loop
  if (mod(rec.id, 2) = 1) then
    cheie := cheie_impar;
  else
    cheie := cheie_par;
  end if;
  
  rezultat_empid := dbms_crypto.decrypt (rec.employee_id_cript, mod_operare, cheie);
  rezultat_salary := dbms_crypto.decrypt (rec.salary_cript, mod_operare, cheie);
  
  insert into employees_decript values (utl_i18n.raw_to_char(rezultat_empid, 'AL32UTF8'), utl_i18n.raw_to_char(rezultat_salary, 'AL32UTF8'));
  
  contor := contor + 1;
  end loop;
  
  commit;
end;
/

execute decriptare_par_impar;

select * from employees_decript;

--6
create or replace function rezum_md5 return varchar2 as
  rec employees%rowtype;
  rec_unit varchar2(500);
  
  raw_rec raw(500);
begin
  select * into rec from employees where employee_id = 104;
  
  rec_unit := rec.employee_id || rec.first_name || rec.last_name || rec.email || rec.phone_number 
              || rec.hire_date || rec.job_id || rec.salary || rec.commission_pct || rec.manager_id || rec.department_id;
              
  dbms_output.put_line('Inregistrare concatenata: ' || rec_unit);
  
  raw_rec := utl_i18n.string_to_raw(rec_unit, 'AL32UTF8');
  
  return dbms_crypto.hash(raw_rec, dbms_crypto.hash_md5);
end;
/

--test
variable rezumat1 varchar2(500);
execute :rezumat1 := rezum_md5;
print rezumat1;

update employees set salary = salary * 1.2 where employee_id=104;

-- test2
variable rezumat2 varchar2(500);
execute :rezumat2 := rezum_md5;
print rezumat2;


rollback;