#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Setting up EVE Frontier Club deployment..."

# Create secrets directory
mkdir -p secrets

# Generate database password
if [ ! -f secrets/db_password.txt ]; then
  openssl rand -base64 48 > secrets/db_password.txt
  echo "Generated database password."
fi

# Generate passwords.yaml
if [ ! -f secrets/passwords.yaml ]; then
  DB_PASS=$(openssl rand -base64 48 | tr -d '\n')
  JWT_PEPPER=$(openssl rand -hex 32 | tr -d '\n')
  EMAIL_PEPPER=$(openssl rand -hex 32 | tr -d '\n')

  cat > secrets/passwords.yaml << EOF
database:
  password: ${DB_PASS}

jwtRefreshTokenHashPepper: ${JWT_PEPPER}
emailSecretHashPepper: ${EMAIL_PEPPER}
EOF
  echo "Generated passwords.yaml."
fi

# Set permissions
chmod 600 secrets/*

# Copy .env.example to .env if it doesn't exist
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from template."
fi

echo ""
echo "Setup complete. Next steps:"
echo "1. Review and edit .env if needed"
echo "2. Ensure Traefik is running with the correct network"
echo "3. Run ./scripts/deploy.sh to start the stack"
