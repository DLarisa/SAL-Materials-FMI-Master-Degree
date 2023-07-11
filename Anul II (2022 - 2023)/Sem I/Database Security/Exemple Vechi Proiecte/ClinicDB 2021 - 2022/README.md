# ClinicDB

This project models the activities from a medical clinic focussing on the security aspect of the database. The project files is split as such:
 - Report.pdf : describes the model of the data as well as the specific tasks that are solved across this project (including screenshots)
 - create_insert.sql : creates the tables of the database and inserts some example data
 - criptare.sql : contains functions that can be used to encrypt the sensitive data from the tables
 - audit.sql : contains methods for auditing the activities from the database
 - privs_roles.sql : describes the roles from application and their respective privilege; creates examples of users for each role
 - gestiune_identitati_resurse_comp.sql : establish the constraints for each role (memory, computational power, password life, etc.)
 - securitate_aplicatii.sql : offers an example of PL/SQL procedure which is vulnerable to SQL injection
 - mascare_date.sql : contains functions that can be used to mask data from the tables
