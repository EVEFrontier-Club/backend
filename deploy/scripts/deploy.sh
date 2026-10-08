#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Pulling latest images..."
docker compose pull

echo "Restarting services..."
docker compose up -d

echo "Cleaning up old images..."
docker image prune -f

echo "Deployment complete."
