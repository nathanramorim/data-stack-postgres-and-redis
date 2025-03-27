FROM alpine:3.14

# Platform specification for ARM64
ARG TARGETPLATFORM=linux/arm64

# Install PostgreSQL
RUN apk update && apk add --no-cache \
    postgresql \
    postgresql-contrib \
    bash

# Create necessary directories
RUN mkdir -p /var/lib/postgresql/data \
    && mkdir -p /run/postgresql

# Set permissions
RUN chown -R postgres:postgres /var/lib/postgresql /run/postgresql

# Default environment variables
ENV POSTGRES_DB=postgres_db \
    POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres \
    PGDATA=/var/lib/postgresql/data

# Copy initialization script
COPY ./config/init-postgres.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

# Expose PostgreSQL port
EXPOSE 5432

USER postgres
CMD ["/docker-entrypoint.sh"]