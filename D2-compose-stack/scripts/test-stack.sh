#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

COMPOSE="${COMPOSE:-docker compose}"

echo "==> Teardown (remove volumes)"
${COMPOSE} down -v --remove-orphans

echo "==> Build and start stack"
${COMPOSE} up -d --build

echo "==> Run E2E tests"
"${ROOT}/scripts/e2e-test.sh"

echo "==> Service interaction logs (last 30 lines each)"
${COMPOSE} logs --tail=30 db api worker

echo "==> D2 test-stack complete — all green"
