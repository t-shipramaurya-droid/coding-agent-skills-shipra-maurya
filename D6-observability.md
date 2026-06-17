# D6 — Observability Bolt-on

**Ticket:** PM4-6558  
**Service:** I4 convert (`I4-convert-pair/service`)  
**Stack:** `D6-observability/` (Prometheus + Grafana compose)

---

## 1. Deliverables

| Requirement | Artifact |
|-------------|----------|
| Code diff (logs + metrics) | `app/observability.py`, `app/main.py` |
| Prometheus + Grafana compose | `D6-observability/docker-compose.yml` |
| Load script | `scripts/load-traffic.sh` |
| Dashboard panel JSON | `artifacts/panel-data.json` |
| README run order | `D6-observability/README.md` |

---

## 2. Code changes

### Structured JSON logging

```json
{"timestamp":"...","event":"convert_success","from_currency":"USD","to_currency":"EUR","amount":10.0}
```

### Prometheus metrics (`GET /metrics`)

| Metric | Type | Labels |
|--------|------|--------|
| `http_requests_total` | Counter | method, path, status |
| `http_request_duration_seconds` | Histogram | method, path |
| `convert_requests_total` | Counter | from_currency, to_currency, status |

---

## 3. Local proof (verified — no Docker)

```bash
cd PM4-6558-assignment/D6-observability
./scripts/prove-local.sh
```

**Results:**
- 40 convert requests generated
- `artifacts/metrics-snapshot.txt` — full Prometheus exposition
- `artifacts/panel-data.json` — Grafana-style query vector
- pytest **9/9 passed** (incl. 2 metrics tests)

**Sample panel data (`artifacts/panel-data.json`):**

```json
{
  "status": "success",
  "data": {
    "result": [
      {"metric": {"from_currency": "USD", "status": "success", "to_currency": "EUR"}, "value": [0, "21.0"]},
      {"metric": {"from_currency": "USD", "status": "success", "to_currency": "INR"}, "value": [0, "11.0"]},
      {"metric": {"from_currency": "EUR", "status": "success", "to_currency": "USD"}, "value": [0, "8.0"]}
    ]
  }
}
```

**Grafana panel query:** `sum(rate(convert_requests_total[1m])) by (from_currency, to_currency, status)`

---

## 4. Full stack (Docker)

```bash
./scripts/run-stack.sh
# Grafana http://127.0.0.1:3000 admin/admin
# Dashboard: I4 Convert Service → Convert request rate (D6 panel)
docker compose down -v
```

---

## 5. Assignment checklist

| Item | Done |
|------|------|
| Structured logging + /metrics | ✅ |
| Prometheus + Grafana compose + provisioning | ✅ |
| Load script | ✅ |
| Panel JSON with live data | ✅ `panel-data.json` |
| README | ✅ |

**D\* series complete:** D1–D6 ✅
