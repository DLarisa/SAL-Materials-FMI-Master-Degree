--------------------------     SYS_LOCAL     --------------------------
----- Mascarea Datelor
create or replace directory direxp_sal as 'C:\Users\Larisa\Desktop\mascare';
grant read, write on directory direxp_sal to clinica_admin;



--------------------------     CLINICA_ADMIN     --------------------------
-- Mascare nume și nr_tel
create or replace package pack_masking is
    function f_masking_nume(nume varchar2) return varchar2;
    function f_masking_mail(mail varchar2) return varchar2;
end;
/

create or replace package body pack_masking is
  type t_tabind is table of number index by pls_integer;
  v_tabind t_tabind;

  function f_masking_nume (nume varchar2) return varchar2 is
    v_nume varchar2(100);
    v_len number;
  begin
        v_nume := substr(nume, 1, 1);
        select length(nume) into v_len from dual;
        v_nume := rpad(v_nume, v_len, '*'); -- we keep only the first
        --character and we fill with "* " up to the --original string’s length
        return v_nume;
  end f_masking_nume;
  
  function f_masking_mail (mail varchar2) return varchar2 is
    v_mail varchar2(100);
    pozitie number;
  begin
        pozitie := instr(mail, '@');
        v_mail := rpad(substr(mail, 1, 1), pozitie, '*') || substr(mail, pozitie);
        return v_mail;
  end f_masking_mail;
end;
/

select pack_masking.f_masking_nume('Test') from dual;
select pack_masking.f_masking_mail('Test@mail.com') from dual;
/*
expdp clinica_admin/admin@orclpdb schemas=clinica_admin remap_data=clinica_admin.pacient.nume:pack_masking.f_masking_nume remap_data=clinica_admin.pacient.mail:pack_masking.f_masking_mail directory=DIREXP_SAL dumpfile=EXPORT_FILE.dmp
impdp clinica_admin/admin@orclpdb directory=DIREXP_SAL dumpfile= EXPORT_FILE.DMP TABLES=pacient remap_table=pacient:pacient_masked
*/