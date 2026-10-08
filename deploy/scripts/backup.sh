#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/evefrontier_club_${TIMESTAMP}.sql.gz"

mkdir -p "${BACKUP_DIR}"

echo "Creating database backup..."
docker compose exec -T postgres pg_dump -U evefrontier evefrontier_club | gzip > "${BACKUP_FILE}"

echo "Backup saved to: ${BACKUP_FILE}"
