#!/bin/bash
mv /docker-entrypoint-initdb_original.d/000.base-command.sh  /docker-entrypoint-initdb.d/000.base-command.sh
docker-entrypoint.sh "$@"