# Database Stack Setup Guide

This guide will help you set up and run a database stack that includes PostgreSQL and Redis using Docker Compose.

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

3. **Starting the Services**
   Run the following command to start the combined data stack with both PostgreSQL and Redis:
   ```bash
   docker-compose -f docker-compose.db.yml up -d
   ```

4. **Verify Services**
   Check if the services are running:
   ```bash
   docker-compose -f docker-compose.db.yml ps
   ```

## Service Information

### PostgreSQL
- Port: 5433 (host) -> 5432 (container)
- Default database: as specified in POSTGRES_DB
- Default user: as specified in POSTGRES_USER
- Password: as specified in POSTGRES_PASSWORD

### Redis
- Port: 6379
- Password: as specified in REDIS_PASSWORD



## Stopping the Services

To stop all services:
```bash
docker-compose -f docker-compose.db.yml down
```

To stop and remove all data volumes:
```bash
docker-compose -f docker-compose.db.yml down -v
```

## Troubleshooting

1. If services fail to start, check:
   - Port conflicts (5433 for PostgreSQL, 6379 for Redis)
   - Environment variables in .env file
   - Docker daemon status

2. For database restore issues:

   - Review container logs for specific errors