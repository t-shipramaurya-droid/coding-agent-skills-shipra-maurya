# D6 — Observability (metrics + Grafana)

Prometheus + Grafana stack for **I4 convert service** with structured JSON logs and `/metrics`.

## Run order

### Local proof (no Docker)

```bash
chmod +x scripts/*.sh
./scripts/prove-local.sh
```

Writes:
- `artifacts/metrics-snapshot.txt`
- `artifacts/panel-data.json` (Grafana-style query result)

### Full stack (Docker)

```bash
./scripts/run-stack.sh
```

| URL | Purpose |
|-----|---------|
| http://127.0.0.1:8000/metrics | Prometheus scrape target |
| http://127.0.0.1:9090 | Prometheus UI |
| http://127.0.0.1:3000 | Grafana (`admin` / `admin`) |

Load traffic: `./scripts/load-traffic.sh`

Teardown: `docker compose down -v`

## Dashboard panel

**Query:** `sum(rate(convert_requests_total[1m])) by (from_currency, to_currency, status)`

Provisioned in Grafana as **Convert request rate (D6 panel)**.

## Code changes

See `../I4-convert-pair/service/app/observability.py` and `app/main.py`.
