--Laborator 1
--1
create or replace procedure criptare1(text in varchar2, text_criptat out varchar2) as
  raw_text raw(100);
  raw_cheie raw(100);
  cheie varchar2(8) := '12345678';
  mod_operare pls_integer;
begin
  raw_text := utl_i18n.string_to_raw(text, 'AL32UTF8');
  raw_cheie := utl_i18n.string_to_raw(cheie, 'AL32UTF8');
  
  mod_operare := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
  
  text_criptat := dbms_crypto.encrypt(raw_text, mod_operare, raw_cheie);
  
  dbms_output.put_line('Rezultat criptare: ' || text_criptat);
end;
/

--Varianta 1
variable rez_criptare varchar2(100);
execute criptare1('Text in clar', :rez_criptare);
print rez_criptare;

--Varianta 2 (cu bloc anonim)
declare
  rezultat varchar2(200);
begin
  criptare1('Text in clar', rezultat);
  dbms_output.put_line('Rezultat test: ' || rezultat);
end;
/

--2
create or replace procedure decriptare1(text_criptat in varchar2, text_decriptat out varchar2) as
  raw_text raw(100);
  raw_cheie raw(100);
  cheie varchar2(8) := '12345678';
  mod_operare pls_integer;
  rezultat raw(100);
begin
  raw_cheie := utl_i18n.string_to_raw(cheie, 'AL32UTF8');
  
  mod_operare := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
  
  rezultat := dbms_crypto.decrypt(text_criptat, mod_operare, raw_cheie);
  
  text_decriptat := utl_i18n.raw_to_char(rezultat);
  
  dbms_output.put_line('Rezultat decriptare: ' || text_decriptat);
end;
/

--Varianta 1
variable rez_decriptare varchar2(100);
execute decriptare1(:rez_criptare, :rez_decriptare);
print rez_decriptare;

--Varianta 2
declare
  rezultat_cript varchar2(200);
  rezultat_decript varchar2(200);
begin
  criptare1('Text in clar', rezultat_cript);
  decriptare1(rezultat_cript, rezultat_decript);
  dbms_output.put_line('Rezultat test: ' || rezultat_decript);
end;
/


