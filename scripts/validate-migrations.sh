#!/bin/bash
set -e

PROJECT_NAME="chitchatter-pro-validation"

echo "Building server image..."
docker compose -f docker-compose.yml -f docker-compose.validation.yml -p ${PROJECT_NAME} build server

echo "Starting database container..."
docker compose -f docker-compose.yml -f docker-compose.validation.yml -p ${PROJECT_NAME} up -d db

echo "Running migrations..."
docker compose -f docker-compose.yml -f docker-compose.validation.yml -p ${PROJECT_NAME} run --rm server npm run db:migrate

echo "Tearing down containers..."
docker compose -f docker-compose.yml -f docker-compose.validation.yml -p ${PROJECT_NAME} down -v
