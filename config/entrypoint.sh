#!/bin/bash
set -e

# Create directories if they don't exist
mkdir -p "$PGDATA"
mkdir -p /data/redis

# Set proper permissions
chown -R postgres:postgres "$PGDATA"
chmod 700 "$PGDATA"

# Execute CMD
exec "$@"