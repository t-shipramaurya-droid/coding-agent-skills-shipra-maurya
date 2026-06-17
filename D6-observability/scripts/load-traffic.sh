#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:8000}"
REQUESTS="${REQUESTS:-40}"

echo "==> Load traffic to ${BASE_URL} (${REQUESTS} convert requests)"

for i in $(seq 1 "${REQUESTS}"); do
  from="USD"
  to="EUR"
  if [ $((i % 3)) -eq 0 ]; then to="INR"; fi
  if [ $((i % 5)) -eq 0 ]; then from="EUR"; to="USD"; fi
  curl -sf -X POST "${BASE_URL}/convert" \
    -H "Content-Type: application/json" \
    -d "{\"amount\":${i},\"from_currency\":\"${from}\",\"to_currency\":\"${to}\"}" >/dev/null
done

curl -sf "${BASE_URL}/health" >/dev/null
echo "OK — generated ${REQUESTS} convert requests + health check"
