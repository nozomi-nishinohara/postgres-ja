#!/bin/bash

. /usr/libutils.sh

postgresql_slave_init_db () {
    local POSTGRESQL_RECOVERY_FILE=${PGDATA}/recovery.conf
    echo "master backup"
    local -r backup_args=("-D" "$PGDATA" "-U" "$POS_REPLICATION_USER" "-h" "$MASTER_HOST" "-p" "$MASTER_PORT" "-X" "stream" "-w" "-v" "-P" "--wal-method=fetch" "--checkpoint=fast" "--write-recovery-conf")
    local -r backup_cmd=(pg_basebackup)
    PGPASSWORD=${POS_REPLICATION_PASSWORD} "${backup_cmd[@]}" "${backup_args[@]}"
    # cp /usr/share/postgresql/11/recovery.conf.sample $POSTGRESQL_RECOVERY_FILE
    # chmod 600 "$POSTGRESQL_RECOVERY_FILE"
    # postgresql_set_property "standby_mode" "$POSTGRESQL_RECOVERY_FILE"
    # postgresql_set_property "primary_conninfo" "host=${MASTER_HOST} port=${MASTER_PORT} user=${POS_REPLICATION_USER} password=${POS_REPLICATION_PASSWORD} application_name=${POSTGRESQL_CLUSTER_APP_NAME}"
}

REPLICA=${REPLICA:-""}
if [ "$REPLICA" = 'master' ]; then
    replication_user=${POS_REPLICATION_USER:-"replication_user"}
    replication_password=${POS_REPLICATION_PASSWORD:-"replication_password"}
    
    if [ "${replication_user}" != '' -a "${replication_password}" != '' ]; then
        echo "CREATE ROLE ${replication_user} LOGIN REPLICATION PASSWORD '${replication_password}';" > /docker-entrypoint-initdb_original.d/0.create_user.sql
    fi
    mv /docker-entrypoint-initdb_original.d/*  /docker-entrypoint-initdb.d/
    elif [ "${REPLICA}" = 'slave' ]; then
    wait-for-it.sh
    postgresql_slave_init_db
fi

if [ "$1" = '/docker-entrypoint.sh' ]; then
    exec "$@"
fi
