#!/bin/bash
mv /docker-entrypoint-initdb_original.d/*  /docker-entrypoint-initdb.d/
docker-entrypoint.sh "$@"