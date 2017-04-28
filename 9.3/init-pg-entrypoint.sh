#!/bin/bash -e

echo "$(date): Mount ramfs..."
mount -t ramfs ramfs $PGDATA

exec docker-entrypoint.sh "$@"
