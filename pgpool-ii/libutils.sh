pgpool_set_property() {
    local -r property="${1:?missing property}"
    local -r value="${2}"
    local -r conf_file="${3:-$PGPOOL_CONF_FILE}"
    sed -i "s?^#*\s*${property}\s*=.*?${property} = '${value}'?g" "$conf_file"
    # echo "${property} = '${value}'"
}
