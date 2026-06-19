# I4 — Polyglot Service Pair (FastAPI + Node CLI)

**Ticket:** PM4-6558  
**Location:** `PM4-6558-assignment/artifacts/I4-convert-pair/`  
**Builds on:** B4 (FastAPI patterns), B5 (Node.js patterns)

---

## Deliverables checklist

| Requirement | Artifact |
|-------------|----------|
| FastAPI `/convert` endpoint | `service/app/main.py` |
| Node CLI client | `client/src/cli.js` |
| Hardcoded rates | `service/app/converter.py` |
| Input validation | Pydantic models + CLI arg checks |
| Service tests | `service/tests/` — 7 tests |
| Client tests | `client/tests/client.test.js` — 7 tests |
| Two-terminal README | `artifacts/I4-convert-pair/README.md` |

---

## Test results (verified)

**Service:**

```bash
cd artifacts/I4-convert-pair/service && .venv/bin/pytest -q
# 7 passed
```

**Client:**

```bash
cd artifacts/I4-convert-pair/client && npm test
# 7 pass
```

---

## API contract

**POST `/convert`**

Request:

```json
{ "amount": 100, "from_currency": "USD", "to_currency": "INR" }
```

Response:

```json
{
  "amount": 100,
  "from_currency": "USD",
  "to_currency": "INR",
  "rate": 83.0,
  "converted_amount": 8300.0
}
```

---

## Agent suggested vs manually verified

| Item | Agent | Manual |
|------|-------|--------|
| Conversion formula (USD pivot) | Implemented in `converter.py` | ✅ pytest `test_usd_to_inr` |
| Pydantic 422 on bad amount | FastAPI validation | ✅ `test_convert_rejects_invalid_amount` |
| CLI mock HTTP tests | `mockFetch` injection | ✅ npm test |
| Live two-terminal E2E | Documented in README | ⏳ Run uvicorn + `node src/cli.js 100 USD INR` |

---

## Next on ladder

| Exercise | Status |
|----------|--------|
| I4 | ✅ |
| I5 — Dockerize and run | Pending |
