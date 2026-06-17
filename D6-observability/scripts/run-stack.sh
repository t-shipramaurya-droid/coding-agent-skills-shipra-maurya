#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

command -v docker >/dev/null || { echo "docker required"; exit 1; }

docker compose down -v --remove-orphans
docker compose up -d --build

echo "Waiting for convert-service..."
for _ in $(seq 1 30); do
  if curl -sf http://127.0.0.1:8000/health >/dev/null; then break; fi
  sleep 2
done

"${ROOT}/scripts/load-traffic.sh"
sleep 10

QUERY='sum(rate(convert_requests_total[1m])) by (from_currency, to_currency, status)'
curl -sf "http://127.0.0.1:9090/api/v1/query?query=${QUERY}" \
  | tee "${ROOT}/artifacts/panel-data-prometheus.json"

echo "Grafana: http://127.0.0.1:3000 (admin/admin) — dashboard 'I4 Convert Service'"
echo "OK — D6 stack running"
