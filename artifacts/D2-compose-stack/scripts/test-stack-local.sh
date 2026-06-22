#!/usr/bin/env bash
# Local E2E without Docker: memory-backed API + Rust engine + Node worker.
# For full Postgres path, use scripts/test-stack.sh (requires Docker).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_PORT="${API_PORT:-8100}"
API_URL="http://127.0.0.1:${API_PORT}"
LOG_DIR="${ROOT}/.local-run"
mkdir -p "$LOG_DIR"

cleanup() {
  [[ -n "${API_PID:-}" ]] && kill "$API_PID" 2>/dev/null || true
  [[ -n "${WORKER_PID:-}" ]] && kill "$WORKER_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo "==> Building Rust scoring engine..."
(cd "$ROOT/engine" && cargo build -q)

echo "==> Installing API dependencies..."
(cd "$ROOT/api" && python3 -m pip install -q -r requirements.txt)

echo "==> Starting API (FRAUD_STORE=memory) on ${API_URL}..."
(
  cd "$ROOT/api"
  export FRAUD_STORE=memory
  exec python3 -m uvicorn app.main:app --host 127.0.0.1 --port "$API_PORT"
) >"$LOG_DIR/api.log" 2>&1 &
API_PID=$!

for _ in $(seq 1 30); do
  if curl -sf "${API_URL}/health" >/dev/null 2>&1; then
    break
  fi
  sleep 0.5
done
curl -sf "${API_URL}/health" >/dev/null || {
  echo "API failed to start. See ${LOG_DIR}/api.log"
  exit 1
}

echo "==> Starting worker..."
(
  cd "$ROOT/worker"
  export FRAUD_API_URL="$API_URL"
  export FRAUD_ENGINE_PATH="$ROOT/engine/target/debug/fraud-score"
  export WORKER_POLL_MS=500
  exec node src/run-loop.js
) >"$LOG_DIR/worker.log" 2>&1 &
WORKER_PID=$!

echo "==> Running E2E assertions..."
API_URL="$API_URL" bash "$ROOT/scripts/e2e-test.sh"

echo ""
echo "Local stack E2E passed (memory store — no Docker/Postgres required)."
echo "Logs: ${LOG_DIR}/api.log, ${LOG_DIR}/worker.log"
