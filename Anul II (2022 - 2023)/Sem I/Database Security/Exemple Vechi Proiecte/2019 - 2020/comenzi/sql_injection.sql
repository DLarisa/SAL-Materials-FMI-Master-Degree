ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:NONE';

CREATE OR REPLACE PROCEDURE P_criptare(text IN VARCHAR2, cheiee IN VARCHAR2, text_criptat OUT VARCHAR2)
AS
    raw_sir RAW(100);
    raw_parola RAW(100);
    rezultat RAW(100);
    mod_operare NUMBER;
    cheie RAW(100);
BEGIN
    raw_sir := utl_i18n.string_to_raw(text, 'AL32UTF8');
    cheie := utl_i18n.string_to_raw(cheiee,'AL32UTF8');
   -- raw_parola := utl_i18n.string_to_raw(cheie, 'AL32UTF8');
     raw_parola := cheie;
    
    mod_operare := DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_ZERO + DBMS_CRYPTO.CHAIN_ECB;
    
    rezultat := DBMS_CRYPTO.ENCRYPT(raw_sir, mod_operare, raw_parola);
   
    text_criptat := RAWTOHEX(rezultat);
END;
/

create or replace  procedure P_decriptare(password_criptat IN varchar2, cheie IN VARCHAR2,
                              password_decriptat OUT varchar2)
as
    raw_sir RAW(100);
    raw_parola RAW(100);
    rezultat RAW(100);
    mod_operare NUMBER;
begin
    raw_sir := HEXTORAW(password_criptat);
    raw_parola := utl_i18n.string_to_raw(cheie, 'AL32UTF8');
    
    mod_operare := DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.PAD_ZERO + DBMS_CRYPTO.CHAIN_ECB;
    
    rezultat := DBMS_CRYPTO.DECRYPT(raw_sir, mod_operare, raw_parola);
    
    
    password_decriptat := utl_i18n.raw_to_char(rezultat, 'AL32UTF8');
end;
/

CREATE OR REPLACE TRIGGER T_criptare_credentials
BEFORE INSERT OR UPDATE  on credential
FOR EACH ROW
declare  
   cheie_criptare_email varchar(20):= '12345678';
   cheie_criptare_password varchar(20) :='123456789';
    rez_criptare_password VARCHAR2(100);
    rez_criptare_email VARCHAR2(100);
    key_id number(10);
    
begin
   if inserting then  
       P_criptare(:new.password,utl_i18n.string_to_raw(cheie_criptare_password,'AL32UTF8'), rez_criptare_password);
       P_criptare(:new.email,utl_i18n.string_to_raw(cheie_criptare_email,'AL32UTF8'), rez_criptare_email);
       dbms_output.put_line('Password encrypted is : ' || rez_criptare_password); 
       dbms_output.put_line('Email encrypted is : ' || rez_criptare_email); 
       :new.password := rez_criptare_password;
       :new.email := rez_criptare_email; 
       insert into key(email_key, password_key)  values (cheie_criptare_email, cheie_criptare_password);
       select MAX(id) into key_id from key;
       :new.key_id := key_id;
   end if;
   if updating then
         dbms_output.put_line('updating');
        select email_key into cheie_criptare_email from key where id = :new.id;
        select password_key into cheie_criptare_password from key where id = :new.id;
        P_criptare(:new.password,cheie_criptare_password, rez_criptare_password);
        P_criptare(:new.email,cheie_criptare_email, rez_criptare_email);
        :new.email := rez_criptare_email;
        :new.password := rez_criptare_password;
   end if;
end;
/
--drop trigger criptare_credentials;
--ALTER TRIGGER criptare_date_conectare ENABLE;
insert into credential(id, email, password, employee_id) values (102,'employee@gmail.com','employee_password',2);
insert into credential(id, email, password, employee_id) values (103,'employeee@gmail.com','employee_passwordd',2);
UPDATE credential cr SET password = 'alt passowrd' WHERE cr.id = 19;

select *
from credential;
select *
from key;

CREATE OR REPLACE PROCEDURE VERIFICA_LOGIN (P_EMAIL
VARCHAR2,P_PASSWORD VARCHAR2) AS
v_ok NUMBER(2) :=-1;
email_criptat varchar2(100);
password_criptat varchar2(100);
BEGIN
P_criptare(P_EMAIL,'0123456789', password_criptat);
P_criptare(P_PASSWORD,'12345678', email_criptat);

EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM credential WHERE
email='''||email_criptat||''' AND password =''' ||password_criptat ||''INTO v_ok;

IF v_ok=0 THEN
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A ESUAT');
ELSE
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A REUSIT');
END IF;
END;


-- tipuri de atac
EXEC VERIFICA_LOGIN('employee@gmail.com','employee_password');
-- cunoastem userul dar nu cunoastem parola
EXEC VERIFICA_LOGIN('employee@gmail.com''--','Parola222222222222222222');

EXEC VERIFICA_LOGIN('ABRACADABRA99'' OR 1=1 --','HOCUS-POCUS');








-- VARIANTA DE PROTEJARE PRIN CONCATENARE

CREATE OR REPLACE PROCEDURE VERIFICA_LOGIN_SAFE (P_NUMEUSER
VARCHAR2,P_PAROLA VARCHAR2) AS
v_ok NUMBER(2) :=-1;
email_criptat varchar2(100);
password_criptat varchar2(100);
BEGIN
P_criptare(P_EMAIL,'0123456789', password_criptat);
P_criptare(P_PASSWORD,'12345678', email_criptat);
SELECT COUNT(*) INTO v_ok FROM CREDENTIAL WHERE email=email_criptat
AND password=password_criptat;
IF v_ok=0 THEN
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A ESUAT');
ELSE
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A REUSIT');
END IF;
END;
/


-- VARIANTA 2 RESCRIERE PENTRU PROTECTIE
CREATE OR REPLACE PROCEDURE VERIFICA_LOGIN_SAFE2 (P_NUMEUSER
VARCHAR2,P_PAROLA VARCHAR2) AS
v_ok NUMBER(2) :=-1;
email_criptat varchar2(100);
password_criptat varchar2(100);

BEGIN
P_criptare(P_EMAIL,'0123456789', password_criptat);
P_criptare(P_PASSWORD,'12345678', email_criptat);
EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM CREDENTIAL WHERE
email=:numeus AND password=:parol' INTO v_ok USING
email_criptat,password_criptat;
IF v_ok=0 THEN
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A ESUAT');
ELSE
DBMS_OUTPUT.PUT_LINE('VERIFICAREA A REUSIT');
END IF;
END;
/
