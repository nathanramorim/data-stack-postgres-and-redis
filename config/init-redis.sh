#!/bin/sh
set -e

# Criar configuração do Redis
cat > /tmp/redis.conf <<EOF
bind 0.0.0.0
protected-mode yes
port 6379
requirepass "${REDIS_PASSWORD}"
daemonize no
supervised no
pidfile /tmp/redis.pid
dir /data
EOF

# Iniciar o Redis com a configuração
exec redis-server /tmp/redis.conf