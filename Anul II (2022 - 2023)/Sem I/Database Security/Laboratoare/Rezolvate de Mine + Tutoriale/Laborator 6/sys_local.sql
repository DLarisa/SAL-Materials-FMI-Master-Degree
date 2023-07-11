/**************   Laborator 6   **************/
SET SERVEROUTPUT ON;
SET ECHO OFF;
SET VERIFY OFF;



/*** Ex1 ***/
create user user_test identified by user_test;
grant connect, resource to user_test;
alter user user_test quota unlimited on users;

create or replace directory direxp_sal as 'C:\Users\Larisa\Desktop\dbsec';
grant read, write on directory direxp_sal to user_test;