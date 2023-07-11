--------------------------     CLINICA_ADMIN     --------------------------
----- Tabel care va reține cheile generate de algoritmul pseudo-random
drop table chei;
create table chei (
    id_chei      number,
    cheie        raw(16) not null,
    nume_tabel   varchar2(30) not null,
    constraint pk_chei primary key (id_chei)
);
-- Va reține datele criptate ale unui pacient
drop table pacient_criptat;
create table pacient_criptat (
    id_pacient       varchar2(100),
    prenume          varchar2(100) not null,
    cnp              varchar2(100) not null,
    sex              varchar2(100) not null,
    integritate      varchar2 (100),
    constraint pacient_criptat_pk primary key (id_pacient)
);

-- Procedura va crea un tabel nou care va reține datele criptate cu AES și un hash al datelor tot criptat cu AES
create or replace procedure criptare_pacient as
  cheie_crypt raw(16);
  operation_mode pls_integer;
  
  -- cursorul care parcurge liniile tabelului PACIENT
  cursor c is select * from pacient;

  raw_id raw(100);
  raw_prenume raw(100);
  raw_cnp raw(100);
  raw_sex raw(100);
  raw_integritate raw(500);
  
  encrypt_id raw(100);
  encrypt_prenume raw(100);
  encrypt_cnp raw(100);
  encrypt_sex raw(100);
  encrypt_integritate raw(500);
  
  concat_val varchar2(500);
  raw_concat_val raw(500);
begin
    cheie_crypt := dbms_crypto.randombytes(16);
    insert into chei values (1, cheie_crypt, 'PACIENT');
    
    operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
    
    for i in c loop
        raw_id := utl_i18n.string_to_raw(i.id_pacient, 'AL32UTF8');
        raw_prenume := utl_i18n.string_to_raw(i.prenume, 'AL32UTF8');
        raw_cnp := utl_i18n.string_to_raw(i.cnp, 'AL32UTF8');
        raw_sex := utl_i18n.string_to_raw(i.sex, 'AL32UTF8');
        
        encrypt_id := dbms_crypto.encrypt(raw_id, operation_mode, cheie_crypt);
        encrypt_prenume := dbms_crypto.encrypt(raw_prenume, operation_mode, cheie_crypt);
        encrypt_cnp := dbms_crypto.encrypt(raw_cnp, operation_mode, cheie_crypt);
        encrypt_sex := dbms_crypto.encrypt(raw_sex, operation_mode, cheie_crypt);
        
        concat_val := i.id_pacient || i.prenume || i.cnp || i.sex;
        raw_concat_val := utl_i18n.string_to_raw(concat_val);
        raw_integritate := dbms_crypto.hash(raw_concat_val, dbms_crypto.hash_md5);
        encrypt_integritate := dbms_crypto.encrypt(raw_integritate, operation_mode, cheie_crypt);
        
        insert into pacient_criptat values (encrypt_id, encrypt_prenume, encrypt_cnp, encrypt_sex, encrypt_integritate);
    end loop;
    commit;
end;
/
execute criptare_pacient;
select * from pacient_criptat;

-- Facem procedura inversa, de decriptare
drop table pacient_decriptat;
create table pacient_decriptat (
    id_pacient       varchar2(100),
    prenume          varchar2(100) not null,
    cnp              varchar2(100) not null,
    sex              varchar2(100) not null,
    constraint pacient_deriptat_pk primary key (id_pacient)
);

create or replace procedure decriptare_pacient as
  cheie_derypt raw(16);
  operation_mode pls_integer;
  
  -- cursorul care parcurge liniile tabelului PACIENT
  cursor c is select * from pacient_criptat;

  raw_id raw(100);
  raw_prenume raw(100);
  raw_cnp raw(100);
  raw_sex raw(100);
  raw_integritate raw(500);
  
  decrypt_id varchar2(100);
  decrypt_prenume varchar2(100);
  decrypt_cnp varchar2(100);
  decrypt_sex varchar2(100);
  decrypt_integritate raw(500);
  
  concat_val varchar2(500);
  raw_concat_val raw(500);
begin
    select cheie into cheie_derypt from chei where id_chei = 1;
    operation_mode := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;
    
    for i in c loop
        raw_id := dbms_crypto.decrypt(i.id_pacient, operation_mode, cheie_derypt);
        raw_prenume := dbms_crypto.decrypt(i.prenume, operation_mode, cheie_derypt);
        raw_cnp := dbms_crypto.decrypt(i.cnp, operation_mode, cheie_derypt);
        raw_sex := dbms_crypto.decrypt(i.sex, operation_mode, cheie_derypt);
    
        decrypt_id := utl_i18n.raw_to_char(raw_id, 'AL32UTF8');
        decrypt_prenume := utl_i18n.raw_to_char(raw_prenume, 'AL32UTF8');
        decrypt_cnp := utl_i18n.raw_to_char(raw_cnp, 'AL32UTF8');
        decrypt_sex := utl_i18n.raw_to_char(raw_sex, 'AL32UTF8');
        
        concat_val := decrypt_id || decrypt_prenume || decrypt_cnp || decrypt_sex;
        raw_concat_val := utl_i18n.string_to_raw(concat_val);
        raw_integritate := dbms_crypto.hash(raw_concat_val, dbms_crypto.hash_md5);
        decrypt_integritate := dbms_crypto.decrypt(i.integritate, operation_mode, cheie_derypt);
        
		-- Verificare Integritate
        if (raw_integritate = decrypt_integritate) then
            insert into pacient_decriptat values (decrypt_id, decrypt_prenume, decrypt_cnp, decrypt_sex);
        else
            dbms_output.put_line('Integrity failed at id: ' || decrypt_id);
        end if;
    end loop;
    commit;
end;
/
execute decriptare_pacient;
select * from pacient_decriptat;
select * from pacient;



/* Nu știu de ce nu mă lasă să fac decriptarea pe un tabel întreg. Tot primesc eroare de NLS. 
Dar am zis să las și aceast cod comentat, poate îmi puteți spune ce făceam greșit, pentru că mă chinui
de câteva zile fără succes. =))) Mulțumesc!

-- Procedura de înlocuire a CNP din tabela PACIENT cu date criptate
create or replace procedure encryptdes(id_pacient_in number) as
  secret_key varchar2(8) := '12345678';
  linie_tabel pacient%rowtype;
  
  raw_cnp      raw(100);
  raw_key      raw(100);
  operation_mode      pls_integer;
  encrypt_cnp     varchar2(100);
begin
    select * into linie_tabel from pacient where id_pacient = id_pacient_in;
    raw_cnp := utl_i18n.string_to_raw(linie_tabel.cnp, 'AL32UTF8');
    raw_key := utl_i18n.string_to_raw(secret_key, 'AL32UTF8');
    operation_mode := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
    encrypt_cnp  := dbms_crypto.encrypt(raw_cnp, operation_mode, raw_key);
    
    update pacient
    set cnp = encrypt_cnp
    where id_pacient = id_pacient_in;
    --commit;
end;
/
execute encryptdes(10);
select * from pacient;

-- Procedura de Decriptare
create or replace procedure decryptdes(id_pacient_in number) as
  secret_key varchar2(8) := '12345678';
  linie_tabel pacient%rowtype;
  
  raw_cnp      raw(100);
  raw_key      raw(100);
  operation_mode      pls_integer;
  decrypt_cnp     varchar2(100);
begin
    select * into linie_tabel from pacient where id_pacient = id_pacient_in;
    raw_key := utl_i18n.string_to_raw(secret_key, 'AL32UTF8');
    operation_mode := dbms_crypto.encrypt_des + dbms_crypto.pad_zero + dbms_crypto.chain_ecb;
    raw_cnp  := dbms_crypto.decrypt(linie_tabel.cnp, operation_mode, raw_key);
    decrypt_cnp := utl_i18n.raw_to_char(raw_cnp, 'AL32UTF8');
    
    update pacient
    set cnp = decrypt_cnp
    where id_pacient = id_pacient_in;
    --commit;
end;
/
execute decryptdes(10);
select * from pacient;


-- Procedură pentru a cripta toate datele existente din tabel PACIENT
create or replace procedure criptare_tabel as
  cursor c is select * from pacient;
begin
    for i in c loop
        encrypt3des(i.id_pacient);
    end loop;
end;
/
execute criptare_tabel;

-- Procedură pentru a decripta toate datele existente din tabel PACIENT
create or replace procedure decriptare_tabel as
  cursor c is select * from pacient;
begin
    for i in c loop
        decrypt3des(i.id_pacient);
    end loop;
end;
/
execute decriptare_tabel;

-- Trigger Insert (când se adauga un nou pacient, criptam datele lui)
create or replace trigger before_insert_crypt 
before insert on pacient
begin
    decriptare_tabel;
end;
/

create or replace trigger after_insert_crypt 
after insert on pacient
begin
    criptare_tabel;
end;
/
*/