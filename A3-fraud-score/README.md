# A3 — Polyglot Mini Fraud-Score System

**Assignment:** PM4-6558 · FastAPI + Node worker + Rust engine

Three components:

| Component | Path | Role |
|-----------|------|------|
| **FastAPI** | `service/` | Ingest transactions, expose pending queue, store scores |
| **Node worker** | `worker/` | Poll pending → call Rust CLI → submit score |
| **Rust engine** | `engine/` | Compute `risk_score` + `risk_level` from JSON stdin |

**Data contract:** see [CONTRACT.md](./CONTRACT.md)

---

## Run order (three terminals)

### 0 — One-time setup

```bash
# Rust engine
cd A3-fraud-score/engine && cargo build

# FastAPI
cd ../service
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# Node worker — no npm deps (Node 18+ fetch)
```

### Terminal 1 — FastAPI (port 8100)

```bash
cd A3-fraud-score/service
source .venv/bin/activate
uvicorn app.main:app --reload --port 8100
```

### Terminal 2 — Ingest a transaction

```bash
curl -X POST http://127.0.0.1:8100/transactions \
  -H 'Content-Type: application/json' \
  -d '{"amount":750,"currency":"USD","user_id":"user-9","merchant_id":"M100"}'

curl http://127.0.0.1:8100/transactions/pending
```

### Terminal 3 — Node worker (process once)

```bash
cd A3-fraud-score/worker
FRAUD_API_URL=http://127.0.0.1:8100 node src/run-once.js
# auto-builds ../engine/target/debug/fraud-score if needed
# tx-0001: score=35 level=LOW  (example)

curl http://127.0.0.1:8100/transactions/tx-0001
```

---

## Tests

```bash
# Rust unit tests (core scoring)
cd engine && cargo test

# FastAPI API tests
cd service && source .venv/bin/activate && pytest -q

# Node worker (+ builds Rust if needed)
cd worker && npm test
```

---

## Architecture

```text
Client → POST /transactions → FastAPI (PENDING)
                ↓
Node worker → GET /transactions/pending
                ↓
         Rust fraud-score (stdin JSON → stdout score)
                ↓
Node worker → POST /transactions/{id}/score → FastAPI (SCORED)
```

---

## Agent suggested vs manually verified

| Item | Verify |
|------|--------|
| `cargo test` | 3 Rust tests |
| `pytest -q` | 3 FastAPI tests |
| `npm test` | Node + Rust subprocess |
| Full E2E | Terminals 1–3 above (API must be running) |

Optional E2E script (API running): `bash scripts/e2e.sh`
