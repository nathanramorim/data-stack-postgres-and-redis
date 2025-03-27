#!/bin/bash
set -e

# Create directories if they don't exist
[ ! -d "$PGDATA" ] && mkdir -p "$PGDATA"
[ ! -d /data/redis ] && mkdir -p /data/redis

# Set proper permissions
chown -R postgres:postgres "$PGDATA"
chmod 700 "$PGDATA"

# Execute CMD
exec "$@"