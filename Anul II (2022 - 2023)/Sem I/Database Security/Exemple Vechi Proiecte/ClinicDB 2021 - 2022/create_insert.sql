drop table doctors CASCADE CONSTRAINTS;
drop table patients CASCADE CONSTRAINTS;
drop table sections CASCADE CONSTRAINTS;
drop table procedures CASCADE CONSTRAINTS;
drop table appointments CASCADE CONSTRAINTS;
drop table clinic_doctor1.prescriptions CASCADE CONSTRAINTS;
drop table clinic_doctor2.prescriptions CASCADE CONSTRAINTS;
drop table clinic_chief3.prescriptions CASCADE CONSTRAINTS;


-- DOCTORS TABLE
CREATE TABLE doctors
    ( doctor_id      NUMBER NOT NULL
    , doctor_name    VARCHAR2(50) NOT NULL
    , pnc            VARCHAR2(13) NOT NULL
    , section_id     NUMBER
    , start_hour     NUMBER
    , end_hour       NUMBER
    , phone_number   VARCHAR2(10)
    , email          VARCHAR2(100)
    , CONSTRAINT     doctors_id_pk  PRIMARY KEY (doctor_id) 
    )
TABLESPACE clinic;


-- PATIENTS TABLE
CREATE TABLE patients
    ( patient_id    NUMBER NOT NULL
    , patient_name  VARCHAR2(50) NOT NULL
    , pnc           VARCHAR2(13) NOT NULL
    , sex           VARCHAR2(1) NOT NULL
    , age           NUMBER NOT NULL
    , phone_number  VARCHAR2(10)
    , email         VARCHAR2(100)
    , CONSTRAINT patients_id_pk PRIMARY KEY (patient_id)
    )
TABLESPACE clinic;


-- SECTIONS TABLE
CREATE TABLE sections
    ( section_id    NUMBER NOT NULL
    , section_name  VARCHAR2(50) NOT NULL
    , chief_id      NUMBER
    , CONSTRAINT sections_id_pk PRIMARY KEY (section_id)
    )
TABLESPACE clinic;


-- PROCEDURES TABLE
CREATE TABLE procedures
    ( procedure_id      NUMBER NOT NULL
    , procedure_name    VARCHAR2(50) NOT NULL
    , description_      VARCHAR2(200)
    , section_id        NUMBER NOT NULL
    , price             NUMBER NOT NULL
    , CONSTRAINT procedures_id_pk PRIMARY KEY (procedure_id)
    )
TABLESPACE clinic;

-- APPOINTMENTS TABLE
CREATE TABLE appointments
    ( appointment_id    NUMBER NOT NULL
    , patient_id        NUMBER NOT NULL
    , doctor_id         NUMBER NOT NULL
    , procedure_id      NUMBER NOT NULL
    , appointment_day   DATE
    , appointment_hour  NUMBER
    , CONSTRAINT appointments_id_pk PRIMARY KEY (appointment_id)
    )
TABLESPACE clinic;

-- PRESCRIPTIONS TABLE
CREATE TABLE clinic_doctor1.prescriptions
    ( prescription_id           NUMBER NOT NULL
    , appointment_id            NUMBER NOT NULL
    , details                   VARCHAR2(200) NOT NULL
    , available_until           DATE
    , compensation_percentage   NUMBER
    , CONSTRAINT prescriptions1_id_pk PRIMARY KEY (prescription_id)
    )
TABLESPACE clinic;

CREATE TABLE clinic_doctor2.prescriptions
    ( prescription_id           NUMBER NOT NULL
    , appointment_id            NUMBER NOT NULL
    , details                   VARCHAR2(200) NOT NULL
    , available_until           DATE
    , compensation_percentage   NUMBER
    , CONSTRAINT prescriptions2_id_pk PRIMARY KEY (prescription_id)
    )
TABLESPACE clinic;

CREATE TABLE clinic_chief3.prescriptions
    ( prescription_id           NUMBER NOT NULL
    , appointment_id            NUMBER NOT NULL
    , details                   VARCHAR2(200) NOT NULL
    , available_until           DATE
    , compensation_percentage   NUMBER
    , CONSTRAINT prescriptions3_id_pk PRIMARY KEY (prescription_id)
    )
TABLESPACE clinic;


-- INSERT DATA INTO TABLES
INSERT INTO patients VALUES(103, 'Maranda B Williams', '2981123025354', 'f', 23, '8609780558', 'hipolito2013@yahoo.com');
INSERT INTO patients VALUES(213, 'Marcia T Winfree', '2960629169635', 'f', 25, '5034797398', 'lesley1974@gmail.com');
INSERT INTO patients VALUES(323, 'Ruby W Czerwinski', '2980226326748', 'f', 23, '9512732518', null);
INSERT INTO patients VALUES(433, 'Donna S Marshall', '2980618074831', 'f', 23, '6099217807', null);
INSERT INTO patients VALUES(543, 'Henry J Baker', '1950222208470', 'm', 26, null, null);
INSERT INTO patients VALUES(653, 'Carlton C House', '1941205315872', 'm', 27, '3184777436', null);
INSERT INTO patients VALUES(763, 'Donnie E Toliver', '1930506263998', 'm', 28, '3184777436', 'leopoldo_vo4@yahoo.com');
INSERT INTO patients VALUES(873, 'Gregory S Witt', '1931208313860', 'm', 28, '6038899641', 'kenny_okeef10@yahoo.com');

INSERT INTO doctors VALUES(102, 'Linda J Bates', '2901208458780', null, 8, 14, '2083785445', 'lbates@clinique.com');
INSERT INTO doctors VALUES(212, 'Lynne M White', '2870106091579', 100, 8, 14, '4238857606', 'lwhite@clinique.com');
INSERT INTO doctors VALUES(322, 'Elsa J Langford', '2890811044977', 210, 10, 16, '5734086142', 'elangford@clinique.com');
INSERT INTO doctors VALUES(432, 'Bennie I Hovey', '1871105087296', 320, 10, 16, '4693419150', 'bhovey@clinique.com');
INSERT INTO doctors VALUES(542, 'Herbert E Palma', '1920102187651', 430, 12, 18, '9144494525', 'hpalma@clinique.com');
INSERT INTO doctors VALUES(652, 'Thomas I Turner', '1940702517794', 430, 12, 18, '9895517349', 'tturner@clinique.com');
INSERT INTO doctors VALUES(762, 'Donald J Tilley', '1900802304259', 540, 8, 14, '7702061803', 'dtilley@clinique.com');
INSERT INTO doctors VALUES(872, 'Justin L Roman', '1890401298134', 650, 8, 14, '6035018976', 'jroman@clinique.com');
INSERT INTO doctors VALUES(982, 'Margit J Slater', '2871023375292', 760, 10, 16, '5102911605', 'mslater@clinique.com');

INSERT INTO sections VALUES(100, 'Allergology', 212);
INSERT INTO sections VALUES(210, 'Dermatology', 322);
INSERT INTO sections VALUES(320, 'Endocrinology', 432);
INSERT INTO sections VALUES(430, 'Ophthalmology', 542);
INSERT INTO sections VALUES(540, 'Pulmonology', 762);
INSERT INTO sections VALUES(650, 'Neurology', 872);
INSERT INTO sections VALUES(760, 'Rheumatology', 982);

INSERT INTO procedures VALUES(101, 'Prick skin test with standard allergen set', '20 tests', 100, 300);
INSERT INTO procedures VALUES(211, 'Patch testing for cosmetics (patients products)', '20 tests', 100, 40);
INSERT INTO procedures VALUES(321, 'Electrocauterization', 'price per lesion', 210, 50);
INSERT INTO procedures VALUES(431, 'Thyroid ultrasound', null, 320, 200);
INSERT INTO procedures VALUES(541, 'Prescription of contact / glasses lenses', null, 430, 125);
INSERT INTO procedures VALUES(651, 'Pleural effusions examination, citology', 'needs CT imaging', 540, 30);
INSERT INTO procedures VALUES(761, 'Clinical examination', null, 650, 250);
INSERT INTO procedures VALUES(871, 'Check-up examination', 'within 30 days from the initial examination', 650, 100);
INSERT INTO procedures VALUES(981, 'Arthrocentesis - ultrasound guidance', null, 760, 175);

INSERT INTO appointments VALUES(104, 103, 212, 101, sysdate-1, 12);
INSERT INTO appointments VALUES(214, 543, 212, 211, sysdate+1, 13);
INSERT INTO appointments VALUES(324, 763, 432, 431, sysdate+5, 13);
INSERT INTO appointments VALUES(434, 213, 652, 541, sysdate+7, 12);
INSERT INTO appointments VALUES(544, 873, 762, 651, sysdate+8, 13);


-- doctor 212
INSERT INTO clinic_chief3.prescriptions VALUES(105, 104, 'Allergic rhinitis. Prescribed Cetirizine.', sysdate+14, 50); 

-- doctor 432
INSERT INTO clinic_doctor1.prescriptions VALUES(215, 324, 'Hypothyroidism. 50mg Euthyrox daily.', sysdate+28, 25); 

-- doctor 762
INSERT INTO clinic_doctor2.prescriptions VALUES(325, 544, 'Antibiotics for lung infection for 1 week.', sysdate+7, 25); 


commit;


-- SEE THE DATA FROM TABLES
select * from doctors;
select * from patients;
select * from sections;
select * from procedures;
select * from appointments;
select * from clinic_doctor1.prescriptions;
select * from clinic_doctor2.prescriptions;
select * from clinic_chief3.prescriptions;


-- ADDING FOREIGN KEY CONSTRAINTS
ALTER TABLE doctors ADD (CONSTRAINT doctor_section_fk FOREIGN KEY (section_id) REFERENCES sections(section_id));
ALTER TABLE sections ADD (CONSTRAINT section_doctor_fk FOREIGN KEY (chief_id) REFERENCES doctors(doctor_id));
ALTER TABLE procedures ADD (CONSTRAINT procedure_section_fk FOREIGN KEY (section_id) REFERENCES sections(section_id));
ALTER TABLE appointments ADD (CONSTRAINT appointment_doctor_fk FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id));
ALTER TABLE appointments ADD (CONSTRAINT appointment_patient_fk FOREIGN KEY (patient_id) REFERENCES patients(patient_id));
ALTER TABLE appointments ADD (CONSTRAINT appointment_procedure_fk FOREIGN KEY (procedure_id) REFERENCES procedures(procedure_id));
--ALTER TABLE clinic_doctor1.prescriptions ADD (CONSTRAINT d1_prescription_appointment_fk FOREIGN KEY (appointment_id) REFERENCES clinic_admin.appointments(appointment_id));
--ALTER TABLE clinic_doctor2.prescriptions ADD (CONSTRAINT d2_prescription_appointment_fk FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id));
--ALTER TABLE clinic_chief3.prescriptions ADD (CONSTRAINT c3_prescription_appointment_fk FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id));


