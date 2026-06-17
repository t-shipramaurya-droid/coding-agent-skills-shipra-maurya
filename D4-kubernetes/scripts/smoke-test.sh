#!/usr/bin/env bash
# Curl proof against port-forwarded service (cluster must be running).
set -euo pipefail

NS=convert-service
PORT="${PORT:-18000}"

kubectl -n "${NS}" port-forward svc/convert-service "${PORT}:80" >/tmp/d4-pf.log 2>&1 &
PF_PID=$!
sleep 2

echo "==> GET /health"
curl -sf "http://127.0.0.1:${PORT}/health"
echo

echo "==> POST /convert"
curl -sf -X POST "http://127.0.0.1:${PORT}/convert" \
  -H 'Content-Type: application/json' \
  -d '{"amount":100,"from_currency":"USD","to_currency":"INR"}'
echo

kill "${PF_PID}" 2>/dev/null || true
echo "OK — curl proof complete"
