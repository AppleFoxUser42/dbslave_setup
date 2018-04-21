#!/bin/sh
#ENVIRONMENT VARIABLES:
# $DB_MAXSCALE_USER
# $DB_MAXSCALE_PASS
# $DB_HOSTNAME
# $DB_MASTER_HOSTNAME
# $DB_PORT
# $DB_ROOT_USER
# $DB_ROOT_PASS
# $DB_SLAVE_USER
# $DB_SLAVE_PASS
#Default values:
DB_ROOT_USER=${DB_ROOT_USER:-root}
DB_PORT=${DB_PORT:-3128}


#wait-for-it.sh ${DB_MASTER_HOSTNAME}:${DB_PORT} -- echo "masterdb is up"

if [ ! -z ${DB_MAXSCALE_USER+x} ] && [ ! -z ${DB_MAXSCALE_PASS+x} ]; then
wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"CREATE USER '$DB_MAXSCALE_USER'@'%' IDENTIFIED BY '${DB_MAXSCALE_PASS}'; "

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SELECT ON mysql.user TO '$DB_MAXSCALE_USER'@'%';"
    
wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SELECT ON mysql.db TO '$DB_MAXSCALE_USER'@'%';"

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SELECT ON mysql.tables_priv to '$DB_MAXSCALE_USER'@'%';"

wait-for-it.sh $DB_HOSTNAME:${DB_PORT} -s -- mysql\
     -h$DB_HOSTNAME\
     -u$DB_ROOT_USER\
     -p$DB_ROOT_PASS\
     -vvv\
     -e"GRANT SHOW databases ON *.* to '$DB_MAXSCALE_USER'@'%';"
fi

if [ ! -z ${LOGNUM+x} ] && [ ! -z ${LOGPOS+x} ]; then
wait-for-it.sh ${DB_HOSTNAME}:${DB_PORT} -s -- mysql\
     -h${DB_HOSTNAME}\
     -u${DB_ROOT_USER}\
     -p${DB_ROOT_PASS}\
     -e "change master to master_host=\"${DB_MASTER_HOSTNAME}\",\
                          master_user=\"${DB_SLAVE_USER}\",\
                          master_password=\"${DB_SLAVE_PASS}\",\
                          master_log_file=\"mysql-bin.${LOGNUM}\",\
                          master_log_pos=${LOGPOS};"\
     -vvv


else
wait-for-it.sh ${DB_HOSTNAME}:${DB_PORT} -s -- mysql\
     -h${DB_HOSTNAME}\
     -u${DB_ROOT_USER}\
     -p${DB_ROOT_PASS}\
     -e "change master to master_host=\"${DB_MASTER_HOSTNAME}\",\
                          master_user=\"${DB_SLAVE_USER}\",\
                          master_password=\"${DB_SLAVE_PASS}\",\
                          master_auto_position=1;"\
     -vvv

fi

if [ ! -z ${DB_SLAVE_DB_FILTER+x} ]; then
wait-for-it.sh ${DB_HOSTNAME}:${DB_PORT} -s -- mysql\
     -h${DB_HOSTNAME}\
     -u${DB_ROOT_USER}\
     -p${DB_ROOT_PASS}\
     -e "CHANGE REPLICATION FILTER\
            REPLICATE_DO_DB = (${DB_SLAVE_DB_FILTER});"\
     -vvv
fi

wait-for-it.sh ${DB_HOSTNAME}:${DB_PORT} -s -- mysql\
     -h${DB_HOSTNAME}\
     -u${DB_ROOT_USER}\
     -p${DB_ROOT_PASS}\
     -e "START SLAVE;"\
     -vvv

#wait-for-it.sh ${DB_HOSTNAME}:${DB_PORT} -s -- mysql\
#     -h${DB_HOSTNAME}\
#     -u${DB_ROOT_USER}\
#     -p${DB_ROOT_PASS}\
#     -e "SET @@global.read_only=OFF;"\
#     -vvv

wait-for-it.sh ${DB_HOSTNAME}:${DB_PORT} -s -- mysql\
     -h${DB_HOSTNAME}\
     -u${DB_ROOT_USER}\
     -p${DB_ROOT_PASS}\
     -e "SHOW SLAVE STATUS\G"\
     -vvv
