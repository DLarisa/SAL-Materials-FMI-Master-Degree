-- First we assign permissions to admin directly
grant create any table to clinic_admin; -- admin creates all tables
grant create any index to clinic_admin;
grant create sequence to clinic_admin;
grant execute on dbms_crypto to clinic_admin; -- for encryption
grant create any procedure to clinic_admin;
grant create trigger to clinic_admin;
-- This is used only for testing purposes (to test the masking functions)
grant execute on clinic_admin.pack_masking to clinic_admin;

-- Create the roles
create role doctor;
create role chief;
create role patient;
create role guest;

-- Grant permissions on tables to users
--grant select, insert, update, delete on doctors to chief;
-- Role doctor
grant select on clinic_admin.doctors to doctor;
grant select on clinic_admin.patients to doctor;
grant select on clinic_admin.sections to doctor;
grant select on clinic_admin.procedures to doctor;
grant select on clinic_admin.appointments to doctor;


-- Role chief
grant select, update on clinic_admin.doctors to chief;
grant select on clinic_admin.patients to chief;
grant select on clinic_admin.sections to chief;
grant select, update, insert on clinic_admin.procedures to chief;
grant select on clinic_admin.appointments to chief;


-- Role patient
grant select on clinic_admin.doctors to patient;
grant select on clinic_admin.patients to patient;
grant select on clinic_admin.sections to patient;
grant select on clinic_admin.procedures to patient;
grant select, insert, update on clinic_admin.appointments to patient;

grant select on clinic_doctor1.prescriptions to patient;
grant select on clinic_chief3.prescriptions to patient;


-- User admin
grant select, insert, update on clinic_admin.doctors to clinic_admin;
grant insert, update on clinic_admin.patients to clinic_admin;
grant select, insert, update on clinic_admin.sections to clinic_admin;
grant select on clinic_admin.procedures to clinic_admin;


-- Role guest
grant select on clinic_admin.sections to guest;
grant select on clinic_admin.procedures to guest;


-- Assign special permissions on the prescription tables
grant select, update, insert, delete on clinic_doctor1.prescriptions to clinic_admin with grant option;
grant select, update, insert, delete on clinic_doctor2.prescriptions to clinic_admin with grant option;
grant select, update, insert, delete on clinic_chief3.prescriptions to clinic_admin with grant option;

grant select, update, insert, delete on clinic_doctor1.prescriptions to clinic_doctor1 with grant option;
grant select, update, insert, delete on clinic_chief3.prescriptions to clinic_chief3 with grant option;


-- Assign users to their designated role
GRANT doctor to clinic_doctor1;
GRANT doctor to clinic_doctor2;
GRANT chief to clinic_chief3;
GRANT patient to clinic_patient1;
GRANT patient to clinic_patient2;
GRANT patient to clinic_patient3;
GRANT guest to clinic_guest;


