--1.2
CREATE TABLE CURS
(id number(6) primary key,
denumire varchar2(30) NOT NULL, an_studiu number(1) NOT NULL,
semestru number(1) NOT NULL, nr_credite number(1) NOT NULL,
forma_evaluare VARCHAR2(10) DEFAULT 'EXAMEN',
ore_curs number(2) DEFAULT 28, ore_laborator number(2) DEFAULT 14,
ore_seminar number(2) DEFAULT 0);

ALTER TABLE CURS drop column ore_seminar;
DROP TABLE CURS ; -- apoi o recreeaza
INSERT INTO CURS VALUES (1,'SECURITATEA BAZELOR DE DATE',6,1,5,'E',28,14,0);

--1.3
CREATE TABLE ELEARN_profesor1.FEEDBACK
( id number(6) primary key, mesaj varchar2(200), timp date);

select owner, object_name from all_objects where owner like '%ELEARN%'; -- comanda trebuie data din schema lui SYS

ALTER TABLE ELEARN_profesor1.FEEDBACK drop column timp;
DROP TABLE ELEARN_profesor1.FEEDBACK ;

INSERT INTO ELEARN_profesor1.FEEDBACK VALUES (1, 'materia este foarte interesanta si utila', SYSDATE);

--2.1
GRANT SELECT,INSERT,UPDATE ON ELEARN_APP_ADMIN.CURS TO ELEARN_profesor1;

ALTER TABLE ELEARN_profesor1.FEEDBACK drop column timp;

ALTER TABLE ELEARN_profesor1.FEEDBACK add cod_student NUMBER(4);
ALTER TABLE ELEARN_profesor1.FEEDBACK add timp date;

--2.2
CREATE TABLE ELEARN_profesor2.FEEDBACK
( id number(6) primary key,
mesaj varchar2(200), cod_student number(4),
timp date);
CREATE TABLE ELEARN_asistent3.FEEDBACK
( id number(6) primary key,
mesaj varchar2(200), cod_student number(4),
timp date);

desc ELEARN_profesor2.FEEDBACK; -- eroare

CREATE OR REPLACE VIEW VIZ_FEEDB AS
SELECT MESAJ,COD_STUDENT,'PROF1' AS cod_prof
FROM ELEARN_profesor1.FEEDBACK
UNION
SELECT MESAJ,COD_STUDENT,'PROF2' AS cod_prof
FROM ELEARN_profesor2.FEEDBACK
UNION
SELECT MESAJ,COD_STUDENT,'ASIST3' AS cod_prof
FROM ELEARN_asistent3.FEEDBACK;

GRANT SELECT ON ELEARN_APP_ADMIN.VIZ_FEEDB TO ELEARN_student1;

CREATE OR REPLACE TRIGGER TR_FEEDB
INSTEAD OF INSERT ON VIZ_FEEDB
FOR EACH ROW
BEGIN
IF :NEW.COD_PROF='PROF1' THEN
INSERT INTO ELEARN_profesor1.FEEDBACK
VALUES(SYSDATE- TO_DATE('2000-01-01', 'yyyy-mm-dd'),
:NEW.MESAJ,101,SYSDATE);
END IF;
IF :NEW.COD_PROF='PROF2' THEN
INSERT INTO ELEARN_profesor2.FEEDBACK
VALUES(SYSDATE- TO_DATE('2000-01-01', 'yyyy-mm-dd'),
:NEW.MESAJ,101,SYSDATE);
END IF;
IF :NEW.COD_PROF='ASIST3' THEN
INSERT INTO ELEARN_asistent3.FEEDBACK
VALUES(SYSDATE- TO_DATE('2000-01-01', 'yyyy-mm-dd'),
:NEW.MESAJ,101,SYSDATE); END IF;
END;
/

GRANT INSERT ON ELEARN_APP_ADMIN.VIZ_FEEDB
TO ELEARN_student1;

--2.3
CREATE OR REPLACE PROCEDURE DELETE_SPAM(key1 VARCHAR2, key2
VARCHAR2 default 'reclama', key3 VARCHAR2 default
'publicitate') AS
BEGIN
DELETE FROM ELEARN_profesor1.FEEDBACK
WHERE MESAJ LIKE '%'||key1||'%' OR MESAJ LIKE '%'||key2||'%'
OR MESAJ LIKE '%'||key3||'%';
DBMS_OUTPUT.PUT_LINE('Au fost sterse:'||SQL%ROWCOUNT||' mesaje de tip spam din tabela profesorului 1');
COMMIT;
END;
/

execute delete_spam('avantajos');

GRANT EXECUTE ON ELEARN_APP_ADMIN.DELETE_SPAM TO
ELEARN_asistent3;


