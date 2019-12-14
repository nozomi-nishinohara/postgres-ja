. /usr/libutils.sh

postgresql_set_property "max_prepared_transactions" "${max_prepared_transactions:-1000}"
postgresql_set_property "max_connections" "${max_connections:-1000}"

postgresql_add_replication_to_pghba () {
    local replication_auth="trust"
    if [[ -n ${POS_REPLICATION_PASSWORD} ]]; then
        replication_auth="md5"
    fi
    echo "host      replication     all             0.0.0.0/0               ${replication_auth}" >> "$PGDATA"/pg_hba.conf
}

REPLICA=${REPLICA:-""}
if [ "$REPLICA" = 'master' ]; then
    postgresql_set_property "wal_level" "replica"
    postgresql_set_property "max_wal_senders" "10"
    postgresql_set_property "archive_mode" "on"
    postgresql_set_property "archive_command" ""
    postgresql_set_property "synchronous_commit" "off"
    postgresql_set_property "synchronous_standby_names" ""
    postgresql_add_replication_to_pghba
    elif [ "$REPLICA" = 'slave' ]; then
    postgresql_set_property "hot_standby" "on"
fi