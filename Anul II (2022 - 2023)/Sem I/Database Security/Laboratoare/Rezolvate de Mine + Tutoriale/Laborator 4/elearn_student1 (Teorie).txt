-- Teorie
--2.2
SELECT * FROM ELEARN_APP_ADMIN.FEEDB_VIEW WHERE student_id=1;

-- După ce a primit privilegii de insert
INSERT INTO ELEARN_APP_ADMIN.FEEDB_VIEW VALUES('AN INTERESTING COURSE',101,'PROF1');
commit;