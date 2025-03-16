## Database Backup and Restoration

This directory contains PostgreSQL database backup files and restoration scripts.

## Preparation

Before starting the restoration process, you must place the `backup_file.sql` file inside the `/backup` folder. This file is necessary for the restoration process to work correctly.

## Authentication Information

The credentials below must exactly match the environment variables defined in the `.env` file used when creating the container:

```plaintext
POSTGRES_DB=${POSTGRES_DB}      # Ex: postgres_db
POSTGRES_USER=${POSTGRES_USER}    # Ex: postgres
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  # Ex: postgres
```

> **Important**: Replace the above variables with the same values defined in your `.env` file. The restoration process will only work if the credentials match the container settings.

## Accessing the Container

Before executing the restoration commands, you need to enter the Docker container and access the backup folder:

```plaintext
# Enter the data-stack-db container
docker exec -it data-stack-db bash

# Navigate to the backup folder
cd /backup
```

### Manual Restoration
If you prefer to restore manually, follow these steps:

1. Create the backup user:

```plaintext
PGPASSWORD=postgres_pw psql -U postgres_user -h 127.0.0.1 -p 5432 -d postgres_db_v2 -c "CREATE ROLE backup-user WITH LOGIN SUPERUSER PASSWORD 'backup-user';"
```

2. Create the backup database:

```plaintext
PGPASSWORD=postgres_pw psql -U postgres_user -h 127.0.0.1 -p 5432 -d postgres_db_v2 -c "CREATE DATABASE backup-db OWNER backup-user;"
```

3. Restore the backup file:

```plaintext
PGPASSWORD=backup-user psql -U backup-user -d backup-db -h 127.0.0.1 -p 5432 -f ./backup_file.sql
```