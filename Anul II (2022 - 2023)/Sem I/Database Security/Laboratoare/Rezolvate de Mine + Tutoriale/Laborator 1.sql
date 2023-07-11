/**************   Laborator 1   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;


/*** Ex1 ***/
CREATE OR REPLACE PROCEDURE encryption1(plain_text in VARCHAR2, encrypted_text out VARCHAR2) AS
  secret_key VARCHAR2(8) := '12345678';
  raw_text RAW(100);
  raw_key RAW(100);
  operation_mode PLS_INTEGER;
BEGIN
    raw_text := utl_i18n.string_to_raw(plain_text, 'AL32UTF8');
    raw_key := utl_i18n.string_to_raw(secret_key, 'AL32UTF8');
    operation_mode := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
    
    encrypted_text := dbms_crypto.encrypt(raw_text, operation_mode, raw_key);
    dbms_output.put_line('Text Criptat: ' || encrypted_text);
END;
/

-- Variabilă de Legătură
VARIABLE encrypted_result VARCHAR2(100);
EXECUTE encryption1('Plain Text', :encrypted_result);
PRINT encrypted_result;

-- Bloc Anonim (cum e în cerință)
DECLARE
  encrypted_result VARCHAR2(100);
BEGIN
    encryption1('Plain Text', encrypted_result);
    dbms_output.put_line('Rezultat Criptat: ' || encrypted_result);
END;
/



/*** Ex2 ***/
CREATE OR REPLACE PROCEDURE decryption1(encrypted_text in VARCHAR2, decrypted_text out VARCHAR2) AS
  secret_key VARCHAR2(8) := '12345678';
  raw_key RAW(100);
  raw_decrypted_text RAW(100);
  operation_mode PLS_INTEGER;
BEGIN
    raw_key := utl_i18n.string_to_raw(secret_key, 'AL32UTF8');
    operation_mode := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
    raw_decrypted_text := dbms_crypto.decrypt(encrypted_text, operation_mode, raw_key);
    
    decrypted_text := utl_i18n.raw_to_char(raw_decrypted_text, 'AL32UTF8');
    dbms_output.put_line('Text Decriptat: ' || decrypted_text);
END;
/

-- Variabilă de Legătură
VARIABLE decrypted_result VARCHAR2(100);
EXECUTE decryption1(:encrypted_result, :decrypted_result);
PRINT decrypted_result;

-- Bloc Anonim (cum e în cerință)
DECLARE
  encrypted_result VARCHAR2(100);
  decrypted_result VARCHAR2(100);
BEGIN
    encryption1('Plain Text', encrypted_result);
    -- dbms_output.put_line('Rezultat Criptat: ' || encrypted_result);
    decryption1(encrypted_result, decrypted_result);
    dbms_output.put_line('Rezultat Decriptat: ' || decrypted_result);
END;
/



/*** Ex3 ***/
-- Luăm fișierele hr_create și hr_insert și le rulăm (din folderul "Model Diagramă HR")
DROP TABLE KEYS_TABLE;
DROP TABLE EMPLOYEES_CRYPT;
DROP SEQUENCE SEQ_ID_KEY;

-- Definire Tabele și Secvență
CREATE SEQUENCE SEQ_ID_KEY START WITH 1 INCREMENT BY 1;
CREATE TABLE KEYS_TABLE(
    id_key number(2),
    secret_key raw(16) not null,
    table_name varchar2(30) not null,
    constraint pk_keys_table primary key (id_key)
);
CREATE TABLE EMPLOYEES_CRYPT(
    id number(4) not null,
    employee_id_crypt varchar2(100),
    salary_crypt varchar2(100),
    constraint pk_employees_crypt primary key (id)    
);

CREATE OR REPLACE PROCEDURE ENCRYPT_EVEN_ODD AS
  odd_key raw(16);
  even_key raw(16);
  operation_mode pls_integer;
  
  -- cursorul care parcurge liniile tabelului EMPLOYEES
  CURSOR c_crypt IS 
    SELECT employee_id, salary 
    FROM employees;

  raw_employee_id raw(100);
  raw_salary raw(100);
  result_employee_id raw(100);
  result_salary raw(100);
  
  -- pentru a număra la ce rând suntem
  contor number(4) := 1;
BEGIN
    odd_key := dbms_crypto.randombytes(16);
    even_key := dbms_crypto.randombytes(16);
    dbms_output.put_line('Even key: ' || even_key);
    dbms_output.put_line('Odd key: ' || odd_key);
    
    INSERT INTO keys_table VALUES(seq_id_key.nextval, odd_key, 'employees');
    INSERT INTO keys_table VALUES(seq_id_key.nextval, even_key, 'employees');
    
    operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
    
    FOR i IN c_crypt LOOP
      raw_employee_id := utl_i18n.string_to_raw(i.employee_id, 'AL32UTF8');
      raw_salary := utl_i18n.string_to_raw(i.salary, 'AL32UTF8');
      
      IF (mod(contor, 2) = 1) THEN
        result_employee_id := dbms_crypto.encrypt(raw_employee_id, operation_mode, odd_key);
        result_salary := dbms_crypto.encrypt(raw_salary, operation_mode, odd_key);
      ELSE
        result_employee_id := dbms_crypto.encrypt(raw_employee_id, operation_mode, even_key);
        result_salary := dbms_crypto.encrypt(raw_salary, operation_mode, even_key);
      END IF;
      
      INSERT INTO employees_crypt VALUES (contor, result_employee_id, result_salary);
      contor := contor + 1;
    END LOOP;
    
    commit;
END;
/

EXECUTE ENCRYPT_EVEN_ODD;
SELECT * FROM keys_table;
SELECT * FROM employees_crypt;



/*** Ex4 ***/
UPDATE employees_crypt
SET salary_crypt = '0x1F4'
WHERE id = 1;
--SAU
UPDATE employees_crypt
SET salary_crypt = '0x1F4'
WHERE rownum = 1;
rollback;



/*** Ex5 ***/
DROP TABLE employees_decrypt;
CREATE TABLE employees_decrypt(
    id number(4),
    employee_id_decrypt varchar2(100),
    salary_decrypt varchar2(100),
    constraint pk_employees_decrypt primary key (id) 
);
  
CREATE OR REPLACE PROCEDURE DECRYPT_EVEN_ODD AS
  odd_key raw(16);
  even_key raw(16);
  secret_key raw(16);
  operation_mode pls_integer;
  
  CURSOR c_decrypt IS
    SELECT *
    FROM employees_crypt;

  raw_employee_id raw(100);
  raw_salary raw(100);
  result_employee_id varchar2(100);
  result_salary varchar2(100);
BEGIN
    SELECT secret_key INTO odd_key FROM keys_table WHERE id_key = 1;
    SELECT secret_key INTO even_key FROM keys_table WHERE id_key = 2;
    
    operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
    
    FOR i IN c_decrypt LOOP
      IF (mod(i.id, 2) = 1) THEN
        raw_employee_id := dbms_crypto.decrypt(i.employee_id_crypt, operation_mode, odd_key);
        raw_salary := dbms_crypto.decrypt(i.salary_crypt, operation_mode, odd_key);
      ELSE
        raw_employee_id := dbms_crypto.decrypt(i.employee_id_crypt, operation_mode, even_key);
        raw_salary := dbms_crypto.decrypt(i.salary_crypt, operation_mode, even_key);
      END IF;
      
      result_employee_id := utl_i18n.raw_to_char(raw_employee_id, 'AL32UTF8');
      result_salary := utl_i18n.raw_to_char(raw_salary, 'AL32UTF8');
      
      INSERT INTO employees_decrypt VALUES (i.id, result_employee_id, result_salary);
    END LOOP;
    
    commit;
END;
/

EXECUTE DECRYPT_EVEN_ODD;
SELECT * FROM employees_decrypt;
SELECT employee_id, salary FROM employees;



/*** Ex6 ***/
CREATE OR REPLACE FUNCTION HASH_MD5 
RETURN varchar2 AS
  linie employees%rowtype;
  concat_value varchar2(300);
  raw_value raw(300);
BEGIN
    SELECT * INTO linie FROM employees WHERE employee_id = 104; 
    concat_value := linie.employee_id || linie.first_name || linie.last_name || linie.email || linie.phone_number
                    || linie.hire_date || linie.job_id || linie.salary || linie.commission_pct || linie.manager_id || linie.department_id;
    dbms_output.put_line('Angajat 104: ' || concat_value);
    
    raw_value := utl_i18n.string_to_raw(concat_value, 'AL32UTF8');
    return dbms_crypto.hash(raw_value, dbms_crypto.hash_md5);
END;
/

-- Inițial
VARIABLE hash1 varchar2(300);
EXECUTE :hash1 := HASH_MD5;
PRINT hash1;

--Mărire 20% salariu
UPDATE employees
SET salary = salary * 1.2
WHERE employee_id = 104;

VARIABLE hash2 varchar2(300);
EXECUTE :hash2 := HASH_MD5;
PRINT hash2;

rollback;