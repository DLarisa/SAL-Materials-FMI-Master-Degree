DROP SEQUENCE seq_id_key;
-- Creates the table that will hold the encryption keys
CREATE SEQUENCE seq_id_key START WITH 1 INCREMENT BY 1;


DELETE FROM keys_table;
CREATE TABLE keys_table
    ( id_key NUMBER
    , key raw(16) NOT NULL
    , table_name VARCHAR2(30) NOT NULL
    , CONSTRAINT id_key_pk PRIMARY KEY (id_key)
    )
TABLESPACE clinic;

DELETE FROM patients_encrypt;
-- Creates the tables that will hold the encryption data
CREATE TABLE patients_encrypt
    ( patient_id        VARCHAR2(100)
    , patient_name      VARCHAR2(100)
    , pnc               VARCHAR2(100)
    , sex               VARCHAR2(100)
    , age               VARCHAR2(100)
    , phone_number      VARCHAR2(100)
    , email             VARCHAR2(100)
    , integrity_check   VARCHAR2(100)
    , CONSTRAINT patients_encrypt_id_pk PRIMARY KEY (patient_id)
    )
TABLESPACE clinic;

CREATE OR REPLACE PROCEDURE encrypt_patients as
  encryption_key RAW(16);
  operation_mode PLS_INTEGER;
  CURSOR c_crypt IS SELECT * FROM patients;
  
  raw_id raw(100);
  raw_name raw(100);
  raw_pnc raw(100);
  raw_sex raw(100);
  raw_age raw(100);
  raw_phone raw(100);
  raw_email raw(100);
  raw_intcheck raw(100);
  
  result_id raw(100);
  result_name raw(100);
  result_pnc raw(100);
  result_sex raw(100);
  result_age raw(100);
  result_phone raw(100);
  result_email raw(100);
  result_intcheck raw(100);
  
  concat_rec varchar2(500);
  raw_rec raw(500);
  
begin
  encryption_key := dbms_crypto.randombytes(16);
  
  INSERT INTO keys_table VALUES(seq_id_key.nextval, encryption_key, 'patients');
  
  operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 
                  + dbms_crypto.chain_cbc;
  
  for rec in c_crypt loop
     concat_rec := rec.patient_id || rec.patient_name || rec.pnc || rec.sex 
                || rec.age || rec.phone_number || rec.email;
     
     raw_rec := utl_i18n.string_to_raw(concat_rec);
     raw_id := utl_i18n.string_to_raw(rec.patient_id, 'AL32UTF8');
     raw_name := utl_i18n.string_to_raw(rec.patient_name, 'AL32UTF8');
     raw_pnc := utl_i18n.string_to_raw(rec.pnc, 'AL32UTF8');
     raw_sex := utl_i18n.string_to_raw(rec.sex, 'AL32UTF8');
     raw_age := utl_i18n.string_to_raw(rec.age, 'AL32UTF8');
     raw_phone := utl_i18n.string_to_raw(rec.phone_number, 'AL32UTF8');
     raw_email := utl_i18n.string_to_raw(rec.email, 'AL32UTF8');
     raw_intcheck := dbms_crypto.hash(raw_rec, dbms_crypto.hash_md5);
     
     result_id := dbms_crypto.encrypt(raw_id, operation_mode, encryption_key);
     result_name := dbms_crypto.encrypt(raw_name, operation_mode, encryption_key);
     result_pnc := dbms_crypto.encrypt(raw_pnc, operation_mode, encryption_key);
     result_sex := dbms_crypto.encrypt(raw_sex, operation_mode, encryption_key);
     result_age := dbms_crypto.encrypt(raw_age, operation_mode, encryption_key);
     result_phone := dbms_crypto.encrypt(raw_phone, operation_mode, encryption_key);
     result_email := dbms_crypto.encrypt(raw_email, operation_mode, encryption_key);
     result_intcheck := dbms_crypto.encrypt(raw_intcheck, operation_mode, encryption_key);
     
     insert into patients_encrypt values(result_id, result_name, result_pnc, 
     result_sex, result_age, result_phone, result_email, result_intcheck);
  end loop;
  commit;
end;
/

execute encrypt_patients;

select * from keys_table;
select patient_id, pnc, phone_number, integrity_check from patients_encrypt;

DELETE FROM patients_decrypt;
-- Create a table that will hold the decrypted data
CREATE TABLE patients_decrypt
    ( patient_id    NUMBER NOT NULL
    , patient_name  VARCHAR2(50) NOT NULL
    , pnc           VARCHAR2(13) NOT NULL
    , sex           VARCHAR2(1) NOT NULL
    , age           NUMBER NOT NULL
    , phone_number  VARCHAR2(10)
    , email         VARCHAR2(100)
    , CONSTRAINT patients_decrypt_id_pk PRIMARY KEY (patient_id)
    )
TABLESPACE clinic;


create or replace procedure decrypt_patients as
  decryption_key raw(16);
  operation_mode pls_integer;
  CURSOR c_decrypt IS SELECT * FROM patients_encrypt;
  
  id_ varchar2(100);
  name_ varchar2(100);
  pnc varchar2(100);
  sex varchar2(100);
  age varchar2(100);
  phone varchar2(100);
  email varchar2(100);
  raw_intcheck raw(100);
  
  result_id raw(100);
  result_name raw(100);
  result_pnc raw(100);
  result_sex raw(100);
  result_age raw(100);
  result_phone raw(100);
  result_email raw(100);
  result_intcheck raw(100); 
  
  concat_rec varchar2(500);
  raw_rec raw(500);
  
begin
  select key into decryption_key from keys_table where id_key = 1;
  operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
  
  for rec in c_decrypt loop
  
    result_id := dbms_crypto.decrypt(rec.patient_id, operation_mode, decryption_key);
    result_name := dbms_crypto.decrypt(rec.patient_name, operation_mode, decryption_key);
    result_pnc := dbms_crypto.decrypt(rec.pnc, operation_mode, decryption_key);
    result_sex := dbms_crypto.decrypt(rec.sex, operation_mode, decryption_key);
    result_age := dbms_crypto.decrypt(rec.age, operation_mode, decryption_key);
    result_phone := dbms_crypto.decrypt(rec.phone_number, operation_mode, decryption_key);
    result_email := dbms_crypto.decrypt(rec.email, operation_mode, decryption_key);
    result_intcheck := dbms_crypto.decrypt(rec.integrity_check, operation_mode, decryption_key);

    id_ := utl_i18n.raw_to_char(result_id, 'AL32UTF8');
    name_ := utl_i18n.raw_to_char(result_name, 'AL32UTF8');
    pnc := utl_i18n.raw_to_char(result_pnc, 'AL32UTF8');
    sex := utl_i18n.raw_to_char(result_sex, 'AL32UTF8');
    age := utl_i18n.raw_to_char(result_age, 'AL32UTF8');
    phone := utl_i18n.raw_to_char(result_phone, 'AL32UTF8');
    email := utl_i18n.raw_to_char(result_email, 'AL32UTF8');

    concat_rec := id_ || name_ || pnc || sex || age || phone || email;
    raw_rec := utl_i18n.string_to_raw(concat_rec);
    raw_intcheck := dbms_crypto.hash(raw_rec, dbms_crypto.hash_md5);

    if (raw_intcheck = result_intcheck) then
        insert into patients_decrypt values (id_, name_, pnc, sex, age, phone, email);
    else
        dbms_output.put_line('Error encountered while decrypting patient with id: ' || id_);
    end if;
    
  end loop;
  commit;  
end;
/

execute decrypt_patients;

select * from patients_decrypt;
