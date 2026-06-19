#!/usr/bin/env bash
# Validates compose file syntax without starting services (requires Docker CLI).
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose config --quiet
echo "docker compose config: OK"
