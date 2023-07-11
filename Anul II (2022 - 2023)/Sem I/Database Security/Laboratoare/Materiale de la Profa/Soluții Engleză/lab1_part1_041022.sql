--1
create or replace procedure encrypt1(text in varchar2, encrypted_text out varchar2) as
   key varchar2(8) := '12345678';
   raw_text raw(100);
   raw_key raw(100);
   op_mode pls_integer;
begin
   raw_text := utl_i18n.string_to_raw(text, 'AL32UTF8');
   raw_key := utl_i18n.string_to_raw(key, 'AL32UTF8');
   
   op_mode := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
   
   encrypted_text := dbms_crypto.encrypt(raw_text, op_mode, raw_key);
   
   dbms_output.put_line('Encryption result: ' || encrypted_text);

end;
/

--Test
variable encryption_result varchar2(200);
execute encrypt1('Plain Text', :encryption_result);
print encryption_result;

--Test 2 (with anonymous block)
declare
  result varchar2(200);
begin
   encrypt1('Plain Text', result);
   dbms_output.put_line('Test result: ' || result); 
end;
/

--2
create or replace procedure decrypt1(encrypted_text in varchar2, decrypted_text out varchar2) as
   key varchar2(8) := '12345678';
   --raw_text raw(100);
   raw_key raw(100);
   op_mode pls_integer;
begin
   
   raw_key := utl_i18n.string_to_raw(key, 'AL32UTF8');
   
   op_mode := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
   
   decrypted_text := utl_i18n.raw_to_char(dbms_crypto.decrypt(encrypted_text, op_mode, raw_key), 'AL32UTF8');
   
   dbms_output.put_line('Decryption result: ' || decrypted_text);

end;
/

--Test
variable decryption_result varchar2(200);
execute decrypt1(:encryption_result, :decryption_result);
print decryption_result;

--Test 2 (with anonymous block)
declare
  encrypt_result varchar2(200);
  decrypt_result varchar2(200);
begin
   encrypt1('Plain Text', encrypt_result);
   decrypt1(encrypt_result, decrypt_result); 
   dbms_output.put_line('Test result: ' || decrypt_result); 
end;
/

