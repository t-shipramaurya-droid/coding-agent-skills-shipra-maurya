#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_URL="${API_URL:-http://127.0.0.1:8100}"

echo "==> E2E against ${API_URL}"

wait_for_health() {
  for attempt in $(seq 1 40); do
    if curl -sf "${API_URL}/health" >/dev/null; then
      echo "API healthy (attempt ${attempt})"
      return 0
    fi
    sleep 2
  done
  echo "FAIL: API not healthy"
  exit 1
}

wait_for_health

pending_json="$(curl -sf "${API_URL}/transactions/pending")"
echo "Initial pending: ${pending_json}"

if ! echo "${pending_json}" | grep -q 'tx-seed-001'; then
  echo "FAIL: expected seeded tx-seed-001 in pending queue"
  exit 1
fi

echo "Waiting for worker to score seeded transactions..."
pending_count=999
for attempt in $(seq 1 45); do
  pending_json="$(curl -sf "${API_URL}/transactions/pending")"
  pending_count="$(python3 -c "import json,sys; print(len(json.loads(sys.argv[1])))" "${pending_json}")"
  if [ "${pending_count}" -eq 0 ]; then
    echo "All transactions scored (attempt ${attempt})"
    break
  fi
  sleep 2
done

if [ "${pending_count}" -ne 0 ]; then
  echo "FAIL: still ${pending_count} pending after timeout"
  exit 1
fi

tx1="$(curl -sf "${API_URL}/transactions/tx-seed-001")"
tx2="$(curl -sf "${API_URL}/transactions/tx-seed-002")"

echo "tx-seed-001: ${tx1}"
echo "tx-seed-002: ${tx2}"

echo "${tx1}" | grep -q '"status":"SCORED"' || { echo "FAIL: tx-seed-001 not SCORED"; exit 1; }
echo "${tx2}" | grep -q '"status":"SCORED"' || { echo "FAIL: tx-seed-002 not SCORED"; exit 1; }
echo "${tx1}" | grep -q '"risk_level":"LOW"' || { echo "FAIL: tx-seed-001 expected LOW"; exit 1; }
echo "${tx2}" | grep -q '"risk_level":"HIGH"' || { echo "FAIL: tx-seed-002 expected HIGH"; exit 1; }

echo "PASS — E2E stack test green"
