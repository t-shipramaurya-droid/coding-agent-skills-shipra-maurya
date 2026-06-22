#!/usr/bin/env bash
# Local proof without Docker: uvicorn + load + /metrics + Prometheus query simulation.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVICE="${ROOT}/../I4-convert-pair/service"
ARTIFACTS="${ROOT}/artifacts"
BASE_URL="http://127.0.0.1:8000"
QUERY="sum(rate(convert_requests_total[1m])) by (from_currency, to_currency, status)"

mkdir -p "${ARTIFACTS}"
cd "${SERVICE}"

if [ -d .venv ]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate
fi

python3 -m pip install -q -r requirements-dev.txt

echo "==> Starting uvicorn"
python3 -m uvicorn app.main:app --host 127.0.0.1 --port 8000 >/tmp/d6-uvicorn.log 2>&1 &
UV_PID=$!

cleanup() {
  kill "${UV_PID}" 2>/dev/null || true
}
trap cleanup EXIT

for _ in $(seq 1 30); do
  if curl -sf "${BASE_URL}/health" >/dev/null; then break; fi
  sleep 1
done

if ! curl -sf "${BASE_URL}/health" >/dev/null; then
  echo "FAIL: service did not start — see /tmp/d6-uvicorn.log"
  tail -20 /tmp/d6-uvicorn.log || true
  exit 1
fi

"${ROOT}/scripts/load-traffic.sh"

curl -sf "${BASE_URL}/metrics" > "${ARTIFACTS}/metrics-snapshot.txt"
echo "==> Metrics snapshot written to artifacts/metrics-snapshot.txt"

python3 - <<'PY' "${ARTIFACTS}/metrics-snapshot.txt" "${ARTIFACTS}/panel-data.json"
import json, re, sys
metrics_path, out_path = sys.argv[1], sys.argv[2]
text = open(metrics_path).read()
series = []
label_re = re.compile(
    r'^convert_requests_total\{(.+)\} ([0-9.]+)$'
)
pair_re = re.compile(r'(\w+)="([^"]*)"')
for line in text.splitlines():
    m = label_re.match(line)
    if not m:
        continue
    labels = dict(pair_re.findall(m.group(1)))
    if labels:
        series.append({
            "metric": labels,
            "value": float(m.group(2)),
        })
payload = {
    "status": "success",
    "data": {
        "resultType": "vector",
        "result": [
            {"metric": s["metric"], "value": [0, str(s["value"])]}
            for s in series
        ],
    },
    "query": "sum(rate(convert_requests_total[1m])) by (from_currency, to_currency, status)",
    "note": "Instant vector from /metrics scrape (local proof without Prometheus)",
}
json.dump(payload, open(out_path, "w"), indent=2)
print(json.dumps(payload, indent=2))
PY

python3 -m pytest -q tests/test_metrics.py
echo "OK — D6 local observability proof complete"
