# Execution Summary — PM4-6558 (without Docker)

**Last updated:** 2026-06-17  
**Machine:** macOS — Docker Desktop not installed; Postgres not installed locally.

This document records **what was run locally** vs **what is proven via CI / artifacts**.

---

## Quick verify (one command)

```bash
cd PM4-6558-assignment
chmod +x scripts/verify-assignment.sh
./scripts/verify-assignment.sh
```

---

## Exercise run matrix

| Exercise | Local run | Proof artifact |
|----------|-----------|----------------|
| B4 FastAPI | `pytest` in `artifacts/B4-fastapi` | `COMPLETED.md` |
| B5 Node.js | `npm test` in `artifacts/B5-nodejs` | `COMPLETED.md` |
| B6 Rust | `cargo test` in `artifacts/B6-rust-logcounter` | `COMPLETED.md` |
| I4 convert pair | pytest + npm test | `I4-convert-pair/README.md` |
| I5 Dockerize | ⏭️ No local Docker | **D3 CI `docker-build` job** + I4 uvicorn/curl proof |
| A3 fraud-score | `cargo test` + service pytest | `A3-fraud-score/README.md` |
| D1 Terraform | `terraform test` (if installed) | `D1-terraform/README.md` |
| D2 compose stack | **`scripts/test-stack-local.sh`** (memory store) | `evidence/D/D2-compose-stack.md` |
| D3 CI | `run-ci-local.sh` + `demo-failure.sh` | `artifacts/failure-demo.log` |
| D4 Kubernetes | `validate.sh` (kubeconform) | `D4-kubernetes/README.md` |
| D6 observability | `prove-local.sh` (uvicorn + /metrics) | `artifacts/metrics-snapshot.txt`, `panel-data.json` |

---

## D2 — two paths

| Path | Command | When |
|------|---------|------|
| **Local (no Docker)** | `./artifacts/D2-compose-stack/scripts/test-stack-local.sh` | Default on this laptop |
| **Full stack** | `./artifacts/D2-compose-stack/scripts/test-stack.sh` | When Docker Desktop is available |

Local path uses `FRAUD_STORE=memory` — same API + worker + Rust engine flow; Postgres replaced by in-memory seed data for machines without Docker/Postgres.

---

## I5 / D3 — Docker proof without local Docker

- **I5 Dockerfile:** `artifacts/I4-convert-pair/service/Dockerfile`
- **Service proof without container:** I4 uvicorn + `curl /health` + Node CLI
- **Container build proof:** GitHub Actions job `docker-build` in `artifacts/D3-ci/.github/workflows/convert-service-ci.yml` — builds image, runs container, curls `/health` on ubuntu-latest runners

---

## Gaps (honest)

| Item | Status |
|------|--------|
| I5 `docker build` on laptop | ⏭️ Skipped — no Docker |
| D2 `docker compose` full stack | ⏭️ Skipped — use `test-stack-local.sh` |
| D4 `kind` cluster live deploy | ⏭️ Skipped — YAML validated offline |
| D6 Grafana/Prometheus compose | ⏭️ Skipped — `prove-local.sh` + dashboard JSON |

---

## Real FO work (outside assignment folder)

| Ticket | Status |
|--------|--------|
| PM4-6500 Testcontainers IT | ✅ PR #14 merged to `stage` on `eq-order-hold-consumer` |
