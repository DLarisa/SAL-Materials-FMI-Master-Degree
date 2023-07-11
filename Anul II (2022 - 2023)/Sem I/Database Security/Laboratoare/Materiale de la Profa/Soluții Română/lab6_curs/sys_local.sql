-- Lab 6
create user usertest22 identified by usertest22;
grant connect, resource to usertest22;
alter user usertest22 quota unlimited on users;

create or replace directory direxp22 as 'D:\tmp\secbd';
grant read, write on directory direxp22 to usertest22;

desc all_context;