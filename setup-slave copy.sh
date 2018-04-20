#!/bin/sh
#wait-for-it.sh dbmaster:3306 -- echo "masterdb is up"

if [ ! -z ${LOGNUM+x} ] && [ ! -z ${LOGPOS+x} ]; then
wait-for-it.sh dbslave:3306 -s -- mysql\
     -hdbslave\
     -uroot\
     -pmysqladmin\
     -e "change master to master_host=\"dbmaster\",\
                          master_user=\"repl\",\
                          master_password=\"slavepass\",\
                          master_log_file=\"mysql-bin.${LOGNUM}\",\
                          master_log_pos=${LOGPOS};"\
     -vvv


else
wait-for-it.sh dbslave:3306 -s -- mysql\
     -hdbslave\
     -uroot\
     -pmysqladmin\
     -e "change master to master_host=\"dbmaster\",\
                          master_user=\"repl\",\
                          master_password=\"slavepass\",\
                          master_auto_position=1;"\
     -vvv

fi

wait-for-it.sh dbslave:3306 -s -- mysql\
     -hdbslave\
     -uroot\
     -pmysqladmin\
     -e "START SLAVE;"\
     -vvv

#wait-for-it.sh dbslave:3306 -s -- mysql\
#     -hdbslave\
#     -uroot\
#     -pmysqladmin\
#     -e "SET @@global.read_only=OFF;"\
#     -vvv

wait-for-it.sh dbslave:3306 -s -- mysql\
     -hdbslave\
     -uroot\
     -pmysqladmin\
     -e "SHOW SLAVE STATUS\G"\
     -vvv
