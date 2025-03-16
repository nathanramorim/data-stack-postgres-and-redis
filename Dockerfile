FROM alpine:3.14

# Platform specification for ARM64
ARG TARGETPLATFORM=linux/arm64

# Install PostgreSQL, Redis, and supervisor
RUN apk update && apk add --no-cache \
    postgresql \
    postgresql-contrib \
    redis \
    supervisor \
    bash

# Create necessary directories
RUN mkdir -p /var/lib/postgresql/data \
    && mkdir -p /data/redis \
    && mkdir -p /run/postgresql \
    && mkdir -p /var/log/supervisor

# Set permissions
RUN chown -R postgres:postgres /var/lib/postgresql /run/postgresql

# Default environment variables
ENV POSTGRES_DB=postgres_db \
    POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres \
    PGDATA=/var/lib/postgresql/data \
    REDIS_PASSWORD=12345678

# Copy initialization scripts
COPY ./config/init-postgres.sh /docker-entrypoint-initdb.d/
COPY ./config/init-redis.sh /docker-entrypoint-initdb.d/
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./config/entrypoint.sh /entrypoint.sh

RUN chmod +x /docker-entrypoint-initdb.d/init-postgres.sh \
    && chmod +x /docker-entrypoint-initdb.d/init-redis.sh \
    && chmod +x /entrypoint.sh

# Expose ports
EXPOSE 5432 6379

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]