#!/bin/bash

# Script to restart the data-stack with docker-compose
# Checks if stack is running and asks for confirmation before restarting

cd "$(dirname "$0")"

# Check if data-stack services are running
if docker ps --format '{{.Names}}' | grep -q "data-stack"; then
  echo "Data stack services are currently running."
  read -p "Do you want to stop and restart them? (y/n): " confirm
  
  if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo "Stopping and restarting data-stack services..."
    docker-compose -f docker-compose.db.yml down --remove-orphans
    docker-compose -f docker-compose.db.yml build --no-cache
    docker-compose -f docker-compose.db.yml up -d
    echo "Data stack services have been restarted."
  else
    echo "Operation cancelled."
  fi
else
  echo "Data stack services are not running. Starting them now..."
  docker-compose -f docker-compose.db.yml up -d
  echo "Data stack services have been started."
fi