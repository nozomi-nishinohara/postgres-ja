#!/bin/bash
set -e

PGPOOL_CONF_DIR=/etc/pgpool-II
export PGPOOL_CONF_FILE=${PGPOOL_CONF_DIR}/pgpool.conf
# export PGPOOL_CONF_FILE=./pgpool.conf
cp -p ${PGPOOL_CONF_FILE} ${PGPOOL_CONF_FILE}.org
cp ${PGPOOL_CONF_FILE}.sample-stream ${PGPOOL_CONF_FILE}

. /usr/libutils.sh
# . ./libutils.sh

split() {
    local -a _dirs=();
    TEXT=${1:?missing velue}
    DELI=${2:-','}
    c_ifs=$IFS;
    IFS=$DELI;
    _dirs=$(echo $TEXT);
    IFS=$c_ifs;
    echo $_dirs;
}


pgpool_set_property "master_slave_mode" "on"
pgpool_set_property "master_slave_sub_mode" "stream"
pgpool_set_property "load_balance_mode" "on"
pgpool_set_property "listen_addresses" "*"
pgpool_set_property "port" "5432"
pgpool_set_property "sr_check_user" "${POS_REPLICATION_USER:?replication user no value}"
pgpool_set_property "sr_check_database" "${POS_REPLICATION_DATABASE:?replication database no value}"
pgpool_set_property "enable_pool_hba" "on"
pgpool_set_property "num_init_children" "${NUM_INIT_CHILDREN:-100}"
pgpool_set_property "max_pool" "${MAX_POOL:-4}"
pgpool_set_property "child_life_time" "${CHILD_LIFE_TIME:-10}"
pgpool_set_property "connection_life_time" "${CONNECTION_LIFE_TIME:-30}"
pgpool_set_property "client_idle_limit" "${CLIENT_IDLE_LIMIT:-0}"

backend_hostname=${BACKEND_HOSTNAME}
hosts=($(split $backend_hostname))
counter=0
for h in "${hosts[@]}"; do
    backend=($(split $h ':'))
    if [ $counter -eq 0 ]; then
        pgpool_set_property "backend_hostname${counter}" "${backend[0]}"
        pgpool_set_property "backend_port${counter}" "${backend[1]}"
        pgpool_set_property "backend_weight${counter}" "${backend[2]:-1}"
        pgpool_set_property "backend_data_directory${counter}" "/var/lib/postgresql/data"
        pgpool_set_property "backend_flag${counter}" "ALLOW_TO_FAILOVER"
    else
        cat << EOF >> $PGPOOL_CONF_FILE
backend_hostname${counter} = '${backend[0]}'
backend_port${counter} = '${backend[1]}'
backend_weight${counter} = ${backend[2]:-5}
backend_data_directory${counter} = '/var/lib/postgresql/data'
backend_flag${counter} = 'ALLOW_TO_FAILOVER'
EOF
    fi >> $PGPOOL_CONF_FILE
    counter=$(expr $counter + 1)
done

pcp_password=$(pg_md5 --u ${POS_REPLICATION_USER} ${POS_REPLICATION_PASSWORD:?replication user password no value})
cat << EOF >> ${PGPOOL_CONF_DIR}/pcp.conf
$POS_REPLICATION_USER:$pcp_password
EOF
cat << EOF >> ${PGPOOL_CONF_DIR}/pool_hba.conf
host    all         all         all        md5
EOF
pg_md5 --md5auth --username=${POSTGRES_USER} ${POSTGRES_PASSWORD}
pg_md5 --md5auth --username=${POS_REPLICATION_USER} ${POS_REPLICATION_PASSWORD}

wait-for-it.sh -h ${MASTER_HOST} -p ${MASTER_PORT}

exec "$@"