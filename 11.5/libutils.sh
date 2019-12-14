POSTGRESQL_CONF_FILE="$PGDATA"/postgresql.conf

postgresql_set_property() {
    local -r property="${1:?missing property}"
    local -r value="${2}"
    local -r conf_file="${3:-$POSTGRESQL_CONF_FILE}"
    sed -i "s?^#*\s*${property}\s*=.*?${property} = '${value}'?g" "$conf_file"
}
