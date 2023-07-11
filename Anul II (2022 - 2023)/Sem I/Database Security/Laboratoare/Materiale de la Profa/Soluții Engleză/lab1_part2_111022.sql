--3
drop sequence seq_id_key;
drop table keys_table;
drop table employees_crypt;  

create sequence seq_id_key start with 1 increment by 1;

create table keys_table(
  id_key number constraint pk_keys_table primary key,
  key raw(16) not null, 
  table_name varchar2(30) not null);  
  
 create table employees_crypt (
  id number(4)  primary key,
  employee_id_crypt varchar2(100),
  salary_crypt varchar2(100));
  
create or replace procedure encrypt_even_odd as
  odd_key raw(16);
  even_key raw(16);
  
  operation_mode pls_integer;
  
  cursor c_crypt is select employee_id, salary from employees;
  
  raw_empid raw(100);
  raw_salary raw(100);
  
  result_empid raw(100);
  result_salary raw(100);
  
  cnt number := 1;
begin
  odd_key := dbms_crypto.randombytes(16);
  even_key := dbms_crypto.randombytes(16);
  
  dbms_output.put_line('Odd key: ' || odd_key);
  dbms_output.put_line('Even key: ' || even_key);
  
  insert into keys_table values(seq_id_key.nextval, odd_key, 'employees');
  insert into keys_table values(seq_id_key.nextval, even_key, 'employees');
  
  operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
  
  for rec in c_crypt loop
     raw_empid := utl_i18n.string_to_raw(rec.employee_id, 'AL32UTF8');
     raw_salary := utl_i18n.string_to_raw(rec.salary, 'AL32UTF8');
     
     if (mod(cnt, 2) =1 ) then
       result_empid := dbms_crypto.encrypt(raw_empid, operation_mode, odd_key);
       result_salary := dbms_crypto.encrypt(raw_salary, operation_mode, odd_key);
     else
       result_empid := dbms_crypto.encrypt(raw_empid, operation_mode, even_key);
       result_salary := dbms_crypto.encrypt(raw_salary, operation_mode, even_key);
     end if;
     
     insert into employees_crypt values(cnt, result_empid, result_salary);
     cnt := cnt + 1;
  end loop;
  commit;
end;
/

-- test
execute encrypt_even_odd;

select * from keys_table;

select * from employees_crypt;

--4
update employees_crypt
set salary_crypt = '1F4'
where rownum =1 ;

select * from employees_crypt;

rollback;

--5
drop table employees_decrypt;
create table employees_decrypt (
  empid_decrypt varchar2(100),
  sal_decrypt varchar2(100));
  
create or replace procedure decrypt_even_odd as
  odd_key raw(16);
  even_key raw(16);
  key raw(16);
  
  operation_mode pls_integer;
  
  cursor c_decrypt is select id, employee_id_crypt, salary_crypt from employees_crypt;
  
  raw_empid raw(100);
  raw_salary raw(100);
  
  result_empid raw(100);
  result_salary raw(100);
  
begin
  select key into odd_key from keys_table where id_key = 1;
  select key into even_key from keys_table where id_key = 2;
  
  operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
  
  for rec in c_decrypt loop
    if (mod(rec.id, 2) = 1) then
      key := odd_key;
    else
      key := even_key;
    end if;
    
    result_empid := dbms_crypto.decrypt(rec.employee_id_crypt, operation_mode, key);
    result_salary := dbms_crypto.decrypt(rec.salary_crypt, operation_mode, key);
    
    insert into employees_decrypt values (utl_i18n.raw_to_char(result_empid, 'AL32UTF8'), utl_i18n.raw_to_char(result_salary, 'AL32UTF8'));
    
  end loop;
  commit;  
end;
/

execute decrypt_even_odd;

select * from employees_decrypt;

desc employees_decrypt;


--6
create or replace function hash_md5 return varchar2 as
  rec employees%rowtype;
  concat_rec varchar2(500);
  raw_rec raw(500);
begin
  select * into rec from employees where employee_id = 104;
  concat_rec := rec.employee_id || rec.first_name || rec.last_name || rec.email 
             || rec.phone_number || rec.hire_date || rec.job_id || rec.salary || rec.commission_pct ||rec.manager_id || rec.department_id;
             
  dbms_output.put_line('Concatenated record: '|| concat_rec);
  
  raw_rec := utl_i18n.string_to_raw(concat_rec);
  
  return dbms_crypto.hash(raw_rec, dbms_crypto.hash_md5);
end;
/

--test
variable hash1 varchar2(500);
execute :hash1 := hash_md5;
print hash1;

update employees set salary = salary * 1.2
where employee_id = 104;

--test2
variable hash2 varchar2(500);
execute :hash2 := hash_md5;
print hash2;

rollback;