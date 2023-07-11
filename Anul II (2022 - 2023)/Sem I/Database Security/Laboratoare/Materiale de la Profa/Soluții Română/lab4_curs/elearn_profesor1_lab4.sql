select * from session_privs;
select * from tab;

ALTER TABLE ELEARN_profesor1.FEEDBACK drop column timp;
DROP TABLE ELEARN_profesor1.FEEDBACK ;

INSERT INTO ELEARN_profesor1.FEEDBACK VALUES (1, 'materia este foarte interesanta si utila', SYSDATE);

--2.1
INSERT INTO ELEARN_APP_ADMIN.CURS VALUES (2,'RETELE DE CALCULATOARE',3, 2,5,'E',28,28,0);

DELETE FROM FEEDBACK;

commit;

desc ELEARN_profesor1.FEEDBACK;

SELECT ID, SUBSTR(MESAJ,1,20) MESAJ, COD_STUDENT,TIMP FROM FEEDBACK;
