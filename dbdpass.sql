create database slurm_acct_db;
create user 'testuser'@localhost identified by 'secretkey';
grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by 'secretkey' with grant option;
SHOW VARIABLES LIKE 'have_innodb';
quit;
