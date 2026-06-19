#!/usr/bin/env bash
# End-to-end integration: requires uvicorn + cargo-built engine
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_URL="${FRAUD_API_URL:-http://127.0.0.1:8100}"

cd "$ROOT/engine" && cargo build -q
cd "$ROOT/service" && python3 -m pytest -q

echo "Posting sample transaction..."
curl -sf -X POST "$API_URL/transactions" \
  -H 'Content-Type: application/json' \
  -d '{"amount":750,"currency":"USD","user_id":"user-9","merchant_id":"M100"}' >/dev/null

echo "Running worker once..."
FRAUD_API_URL="$API_URL" FRAUD_ENGINE_PATH="$ROOT/engine/target/debug/fraud-score" \
  node "$ROOT/worker/src/run-once.js"

echo "Checking scored transaction..."
curl -sf "$API_URL/transactions/tx-0001" | grep -q '"status":"SCORED"' && echo "E2E OK"
