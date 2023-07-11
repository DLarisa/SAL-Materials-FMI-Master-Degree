-- Schemă Tabele
drop table asistenta cascade constraints;
drop table pacient cascade constraints;
drop table doctor cascade constraints;
drop table sectie cascade constraints;
drop table procedura cascade constraints;
drop table consultatie cascade constraints;

----- Creare Tabele
-- Asistentă
create table asistenta (
    id_asistenta     number(5),
    nume             varchar2(30) not null,
    prenume          varchar2(30) not null,
    nr_tel           varchar2(12),
    mail             varchar2(30),
    constraint asistenta_pk primary key (id_asistenta)
);

-- Pacient
create table pacient (
    id_pacient       number(5),
    nume             varchar2(100) not null,
    prenume          varchar2(100) not null,
    cnp              varchar2(100) not null,
    nr_tel           varchar2(100),
    mail             varchar2(100),
    sex              varchar2(100) not null,
    varsta           number not null,
    constraint pacient_pk primary key (id_pacient)
);

-- Doctor
create table doctor (
    id_doctor        number(5),
    nume             varchar2(30) not null,
    prenume          varchar2(30) not null,
    nr_tel           varchar2(12),
    mail             varchar2(30),
    ora_inceput      number(2) not null,
    ora_final        number(2) not null,
    id_sectie        number not null,
    constraint doctor_pk primary key (id_doctor)
);

-- Secție
create table sectie (
    id_sectie        number(5),
    nume             varchar2(30) not null,
    id_sef           number not null,
    constraint sectie_pk primary key (id_sectie)
);

-- Procedura
create table procedura (
    id_procedura     number(5),
    nume             varchar2(30) not null,
    pret             number(5) not null,
    id_sectie        number not null,
    constraint procedura_pk primary key (id_procedura)
);

-- Consultație
create table consultatie (
    id_consultatie   number(5),
    data_consultatie date not null,
    ora              number(2) not null,
    id_pacient       number not null,
    id_doctor        number not null,
    id_procedura     number not null,
    constraint consultatie_pk primary key (id_consultatie)
);

-- Rețetă (Fiecare Doctor are un tabel de Rețete)
create table sef1.reteta (
    id_reteta        number(5),
    medicament       varchar2(30),
    indicatii        varchar2(100),
    reducere         number(2),
    id_doctor        number not null,
    id_consultatie   number not null,
    constraint reteta_pk primary key (id_reteta)
);

create table doctor2.reteta (
    id_reteta        number(5),
    medicament       varchar2(30),
    indicatii        varchar2(100),
    reducere         number(2),
    id_doctor        number not null,
    id_consultatie   number not null,
    constraint reteta_pk primary key (id_reteta)
);

create table doctor3.reteta (
    id_reteta        number(5),
    medicament       varchar2(30),
    indicatii        varchar2(100),
    reducere         number(2),
    id_doctor        number not null,
    id_consultatie   number not null,
    constraint reteta_pk primary key (id_reteta)
);

create table doctor4.reteta (
    id_reteta        number(5),
    medicament       varchar2(30),
    indicatii        varchar2(100),
    reducere         number(2),
    id_doctor        number not null,
    id_consultatie   number not null,
    constraint reteta_pk primary key (id_reteta)
);



----- Inserare de Date în Tabele
-- Asistentă
insert into asistenta values (1, 'Popescu', 'Mara', '0727686598', 'mpopescu@clinica.com');
insert into asistenta values (2, 'Vasilescu', 'Eugen', '0787444021', 'evasilescu@clinica.com');
insert into asistenta values (3, 'Rosca', 'Ionela', null, 'irosca@clinica.com');
insert into asistenta values (4, 'Constantinescu', 'Gabriela', '0741325854', null);
insert into asistenta values (5, 'Manole', 'Mihai', '0741418555', 'mmanole@clinica.com');
insert into asistenta values (6, 'Bechir', 'Claudia', null, null);
insert into asistenta values (7, 'Sin', 'Andrei', null, 'asin@clinica.com');

-- Pacient
insert into pacient values (10, 'Florescu', 'Cristian', '1234567890', '07452952031', 'cris@mail.com', 'M', 24);
insert into pacient values (11, 'Iacobei', 'Marina', '2485023256', '0785841325', 'marina@mail.com', 'F', 32);
insert into pacient values (12, 'Matei', 'Crina', '2843020014', '0788132140', 'cri@mail.com', 'F', 54);
insert into pacient values (13, 'Zimbru', 'Costel', '1582447100', '0755582320', 'z@mail.com', 'M', 66);
insert into pacient values (14, 'Dinescu', 'Iustin', '1240617402', '0712546328', 'test@mail.com', 'M', 47);
insert into pacient values (15, 'Duica', 'Lucretia', '2474742031', '0732020159', 'duica@mail.com', 'F', 80);
insert into pacient values (16, 'Caluiman', 'Barbu', '1854211741', '0743236950', 'barbu@mail.com', 'M', 30);

-- Doctor
insert into doctor values (20, 'Matei', 'Dan', '0785858320', 'dmatei@clinica.com', 8, 12, 100);
insert into doctor values (21, 'Bacovei', 'Amalia', null, 'abacovei@clinica.com', 12, 16, 100);
insert into doctor values (22, 'Traian', 'Delia', null, null, 16, 20, 100);
insert into doctor values (23, 'Bucur', 'George', '0785426321', null, 10, 14, 100);
insert into doctor values (24, 'Iocai', 'Virginia', '0744152103', 'viocai@clinica.com', 8, 12, 200);
insert into doctor values (25, 'Buftea', 'Vasile', null, 'vbuftea@clinica.com', 12, 16, 200);
insert into doctor values (26, 'Duica', 'Maria', null, null, 16, 20, 200);
insert into doctor values (27, 'Zimbir', 'Zoe', '0787474147', null, 9, 13, 200);
insert into doctor values (28, 'Guran', 'Ion', '0746530012', 'iguran@clinica.com', 8, 12, 300);
insert into doctor values (29, 'Doroftei', 'Aura', null, 'adoroftei@clinica.com', 12, 16, 300);
insert into doctor values (30, 'Ceata', 'Sonia', null, null, 16, 20, 400);
insert into doctor values (31, 'Leustean', 'Paul', '0747555222', null, 9, 13, 400);
insert into doctor values (32, 'Ducati', 'Elena', null, 'educati@clinica.com', 10, 14, 500);
insert into doctor values (33, 'Gavrisiu', 'Xenia', null, null, 14, 18, 500);
insert into doctor values (34, 'Tudor', 'Minodora', '0733202125', null, 7, 11, 500);

-- Secție
insert into sectie values (100, 'Oftalmologie', 20);
insert into sectie values (200, 'Cardiologie', 26);
insert into sectie values (300, 'Neurologie', 28);
insert into sectie values (400, 'Endocrionologie', 30);
insert into sectie values (500, 'Pneumologie', 33);

-- Procedura
insert into procedura values (101, 'Control Ochi', 95, 100);
insert into procedura values (102, 'Procedura Astigmatism', 350, 100);
insert into procedura values (103, 'Procedura Miopie', 500, 100);
insert into procedura values (104, 'Extractie corp strain', 700, 100);
insert into procedura values (105, 'OCT', 280, 100);
insert into procedura values (201, 'Electrocardiograma', 150, 200);
insert into procedura values (202, 'Control Inima', 70, 200);
insert into procedura values (301, 'EMG', 200, 300);
insert into procedura values (302, 'ENG', 270, 300);
insert into procedura values (303, 'Ecografie Doppler', 475, 300);
insert into procedura values (401, 'Ecografie Tiroida', 285, 400);
insert into procedura values (402, 'Interpretare Analize', 175, 400);
insert into procedura values (403, 'Ecografie Mamara', 485, 400);
insert into procedura values (404, 'Ecografie Pelvis', 300, 400);
insert into procedura values (501, 'Spirometrie', 255, 500);
insert into procedura values (502, 'Spirometrie cu test bronho.', 657, 500);
insert into procedura values (503, 'Consultatie', 145, 500);

-- Consultație
insert into consultatie values (1, sysdate-7, 12, 10, 21, 101);
insert into consultatie values (2, sysdate-5, 15, 10, 21, 105);
insert into consultatie values (3, sysdate-4, 14, 10, 21, 103);
insert into consultatie values (4, sysdate-20, 18, 11, 26, 202);
insert into consultatie values (5, sysdate-14, 17, 11, 26, 201);
insert into consultatie values (6, sysdate-15, 9, 12, 28, 303);
insert into consultatie values (7, sysdate-3, 8, 14, 34, 503);
insert into consultatie values (8, sysdate-1, 8, 14, 34, 502);
insert into consultatie values (9, sysdate-3, 14, 15, 33, 501);
insert into consultatie values (10, sysdate-2, 13, 16, 25, 202);
insert into consultatie values (11, sysdate-2, 14, 13, 25, 202);

-- Rețetă (Fiecare Doctor are un tabel de Rețete)
--- doctor 26 -> șef Cardio (200) -- sef1 dă insert în schema lui
insert into sef1.reteta values (1, null, 'Electrocardiograma recomandata', null, 26, 4);
insert into sef1.reteta values (2, 'CardioPlus', null, 10, 26, 5);
--- doctor 21 -> Oftalmologie (100) -- doctor2 dă insert în schema lui
insert into doctor2.reteta values (1, null, 'OCT recomandat', null, 21, 1);
insert into doctor2.reteta values (2, 'Picaturi Ochi Hidratare, Ocul+', 'Ochelari de soare in permanenta si odihna', null, 21, 3);
-- doctor 34 -> Pneumologie (500) -- doctor3 dă insert în schema lui
insert into doctor3.reteta values (1, 'Zabrac, CardioPlus, HelpCardio', 'Cate 2 pastile la fiecare masa', 10, 34, 8);
-- doctor 25 -> Cardio (200) -- doctor4 dă insert în schema lui
insert into doctor4.reteta values (1, null, null, null, 25, 10);
insert into doctor4.reteta values (2, 'CardioPlus', 'Revenire peste o luna la consultatie', null, 25, 11);

-- Commit
commit;



----- Constrângeri de FK
alter table doctor add (constraint sectie_fk foreign key (id_sectie) references sectie(id_sectie));
alter table sectie add (constraint sef_fk foreign key (id_sef) references doctor(id_doctor));
alter table procedura add (constraint sectie_procedura_fk foreign key (id_sectie) references sectie(id_sectie));
alter table consultatie add (constraint pacient_fk foreign key (id_pacient) references pacient(id_pacient));
alter table consultatie add (constraint doctor_fk foreign key (id_doctor) references doctor(id_doctor));
alter table consultatie add (constraint procedura_fk foreign key (id_procedura) references procedura(id_procedura));
/*
alter table sef1.reteta add (constraint sef1_doctor_fk foreign key (id_doctor) references doctor(id_doctor));
alter table sef1.reteta add (constraint sef1_consultatie_fk foreign key (id_consultatie) references consultatie(id_consultatie));
alter table doctor2.reteta add (constraint doctor2_doctor_fk foreign key (id_doctor) references doctor(id_doctor));
alter table doctor2.reteta add (constraint doctor2_consultatie_fk foreign key (id_consultatie) references consultatie(id_consultatie));
alter table doctor3.reteta add (constraint doctor3_doctor_fk foreign key (id_doctor) references doctor(id_doctor));
alter table doctor3.reteta add (constraint doctor3_consultatie_fk foreign key (id_consultatie) references consultatie(id_consultatie));
alter table doctor4.reteta add (constraint doctor4_doctor_fk foreign key (id_doctor) references doctor(id_doctor));
alter table doctor4.reteta add (constraint doctor4_consultatie_fk foreign key (id_consultatie) references consultatie(id_consultatie));
*/



----- Vizualizare Date din Tabele
select * from asistenta;
select * from pacient;
select * from doctor;
select * from sectie;
select * from procedura;
select * from consultatie;
-- Doar doctorii și pacienții pot face SELECT în aceste tabele
select * from sef1.reteta;
select * from doctor2.reteta;
select * from doctor3.reteta;
select * from doctor4.reteta;