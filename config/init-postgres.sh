#!/bin/bash
set -e

# Initialize PostgreSQL if not already done
if [ ! -s "$PGDATA/PG_VERSION" ]; then
    echo "Initializing PostgreSQL database..."
    mkdir -p "$PGDATA"
    chmod 700 "$PGDATA"
    initdb -D "$PGDATA" --username="$POSTGRES_USER" --pwfile=<(echo "$POSTGRES_PASSWORD") --auth-host=md5 --auth-local=trust
    
    # Configure PostgreSQL to listen on all interfaces
    echo "listen_addresses='*'" >> "$PGDATA/postgresql.conf"
    echo "host all all all md5" >> "$PGDATA/pg_hba.conf"
    
    # Create database if specified
    if [ "$POSTGRES_DB" != "postgres" ]; then
        echo "Creating database $POSTGRES_DB..."
        postgres -D "$PGDATA" -c config_file="$PGDATA/postgresql.conf" &
        pid=$!
        for i in {30..0}; do
            if pg_isready -U "$POSTGRES_USER" -h localhost; then
                break
            fi
            sleep 1
        done
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres <<-EOSQL
            CREATE DATABASE "$POSTGRES_DB";
            GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_DB" TO "$POSTGRES_USER";
EOSQL
        kill $pid
        wait $pid
    fi
fi

# Start PostgreSQL
exec postgres -D "$PGDATA" -c config_file="$PGDATA/postgresql.conf"