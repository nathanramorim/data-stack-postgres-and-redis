# Database Stack Setup Guide

This guide will help you set up and run a database stack that includes PostgreSQL and Redis in separate containers within the same network.

## Prerequisites

- Docker and Docker Compose installed on your system
- Basic understanding of Docker and database concepts

## Setup Instructions

1. **Clone the Repository**
   Clone or download this repository to your local machine.

2. **Environment Configuration**
   - Copy the `.env.example` file to create a new `.env` file:
     ```bash
     cp .env.example .env
     ```
   - Update the environment variables in `.env` with your desired values:
     - PostgreSQL Configuration:
       - `POSTGRES_DB`: Database name
       - `POSTGRES_USER`: Database user
       - `POSTGRES_PASSWORD`: Database password
       - `PGDATA`: Data directory path
     - Redis Configuration:
       - `REDIS_PASSWORD`: Redis password

3. **Create Docker Network**
   Create an external Docker network that will be used by the database stack:
   ```bash
   docker network create app-network
   ```

4. **Starting the Services**
   Run the following command to build and start both PostgreSQL and Redis services:
   ```bash
   docker-compose -f docker-compose.db.yml up -d --build
   ```

5. **Verify Services**
   Check if the services are running:
   ```bash
   docker-compose -f docker-compose.db.yml ps
   ```

## Service Information

### PostgreSQL
- Container name: data-stack-postgres
- Port: 5433 (host) -> 5432 (container)
- Default database: as specified in POSTGRES_DB
- Default user: as specified in POSTGRES_USER
- Password: as specified in POSTGRES_PASSWORD
- Volume: data-bd (persists PostgreSQL data)
- Dockerfile: postgres.Dockerfile

### Redis
- Container name: data-stack-redis
- Port: 6379
- Password: as specified in REDIS_PASSWORD
- Volume: redis-data (persists Redis data)
- Dockerfile: redis.Dockerfile

Both services are connected through the 'app-network' Docker network, allowing them to communicate with each other while maintaining separation of concerns.

## Stopping the Services

To stop all services:
```bash
docker-compose -f docker-compose.db.yml down
```

To stop and remove all data volumes:
```bash
docker-compose -f docker-compose.db.yml down -v
```

## Architecture Overview

The stack now uses a modular approach with separate containers:
- PostgreSQL runs in its own container with its configuration
- Redis runs in its own container with its configuration
- Both services share the same network but are independently scalable
- Each service has its own persistent volume for data storage

## Troubleshooting

1. If services fail to start, check:
   - Port conflicts (5433 for PostgreSQL, 6379 for Redis)
   - Environment variables in .env file
   - Docker daemon status
   - Individual container logs using `docker logs data-stack-postgres` or `docker logs data-stack-redis`

2. For database restore issues:
   - Review container logs for specific errors
   - Ensure proper permissions on backup files
   - Check that the backup file is in the correct format for the target database

3. **Permission Denied Errors**:
   - If you encounter a "Permission denied" error when creating directories (e.g., `/data/` for Redis):
     - Ensure the volume directory on the host has the correct permissions.
     - Run the following command to fix permissions:
       ```bash
       sudo chown -R 1001:1001 /path/to/redis-data
       ```
     - Replace `/path/to/redis-data` with the actual path to the Redis volume on your host system.