create role sgbd3_role not identified;
grant alter session to sgbd3_role;
grant create database link to sgbd3_role;
grant create session to sgbd3_role;
grant create procedure to sgbd3_role;
grant create sequence to sgbd3_role;
grant create table to sgbd3_role;
grant create trigger to sgbd3_role;
grant create type to sgbd3_role;
grant create synonym to sgbd3_role;
grant create view to sgbd3_role;
grant create job to sgbd3_role;
grant create materialized view to sgbd3_role;
grant execute on sys.dbms_lock to sgbd3_role;
grant execute on sys.owa_opt_lock to sgbd3_role;

create user cb identified by oracle account unlock;
alter user cb quota unlimited on users;
grant sgbd3_role to cb;

create user cc identified by oracle account unlock;
alter user cc quota unlimited on users;
grant sgbd3_role to cc;