#!/bin/bash
if [ "$1" = '/docker-entrypoint.sh' ]; then
    mv /docker-entrypoint-initdb_original.d/*  /docker-entrypoint-initdb.d/
    exec "$@"
fi
