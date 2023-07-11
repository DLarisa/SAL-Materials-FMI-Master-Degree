alter pluggable database orclpdb open;

desc dba_users;

show con_name;

alter session set container = orclpdb;

select username, account_status, lock_date
from dba_users
where lower(username) like '%elearn%';

alter user elearn_profesor1 identified by profesor1;