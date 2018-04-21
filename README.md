[Dockerfile](https://github.com/AppleFoxUser42/dbslave_setup)  
NOTE: DOES NOT WORK WITH `mysql:latest` as that uses MySQL 8 which has problems with passwort authentication on commandline.  
See the setup-slave.sh in the repo.  
This Container acts as setup script to turn a MySQL/Percona/MariaDB container into a database replication slave.  
Tags:  
alpine -- uses alpine linux image.  
stable -- uses mysql:5.7  
latest -- uses mysql:latest  
  
ENVIRONMENT VARIABLES:
`DB_ROOT_USER`  -- defaults to root  
`DB_ROOT_PASS`  
`DB_PORT`  -- defaults to the standard 3306  
`DB_MAXSCALE_USER` -- optional when used with MariaDB Maxscale  
`DB_MAXSCALE_PASS` -- optional when used with MariaDB Maxscale  
`DB_HOSTNAME`  
`DB_MASTER_HOSTNAME`  
`DB_SLAVE_DB_FILTER`-- optional allows to replicate given database/s only.  
`DB_SLAVE_USER`  
`DB_SLAVE_PASS`  
`LOGNUM` -- optional. If set uses BINLOG instead of GTID  
`LOGPOS` -- optional. If set uses BINLOG instead of GTID  
see:   
https://dev.mysql.com/doc/refman/5.7/en/replication-howto.html  
https://dev.mysql.com/doc/refman/5.7/en/replication-gtids.html


If `DB_MAXSCALE_USER` and `DB_MAXSCALE_PASS` are set the set user will get created  on the slave and given the permissions required by MariaDB Maxscale
see: https://mariadb.com/kb/en/mariadb-enterprise/mariadb-maxscale-22-mariadb-maxscale-configuration-usage-scenarios/#service
