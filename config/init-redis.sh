#!/bin/bash
set -e

# Create Redis configuration file with password
cat > /etc/redis.conf <<EOF
bind 0.0.0.0
protected-mode yes
port 6379
requirepass "$REDIS_PASSWORD"
daemonize no
supervised no
pidfile /var/run/redis_6379.pid
dir /data/redis
EOF

# Start Redis with config file
exec redis-server /etc/redis.conf