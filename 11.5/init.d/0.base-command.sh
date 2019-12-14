. /usr/libutils.sh

postgresql_set_property "max_prepared_transactions" "${max_prepared_transactions:-1000}"
postgresql_set_property "max_connections" "${max_connections:-1000}"