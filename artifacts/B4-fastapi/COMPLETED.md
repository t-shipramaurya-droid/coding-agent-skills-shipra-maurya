# B4 — FastAPI Transaction Service ✅

**Status:** Complete — 4/4 tests passing

## Proof

```bash
cd PM4-6558-assignment/artifacts/B4-fastapi
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
pytest -v
# 4 passed in 0.61s
```

## Deliverables

- [x] FastAPI app (`app/main.py`)
- [x] POST /transactions
- [x] GET /transactions
- [x] GET /balance
- [x] Input validation (Pydantic: amount > 0, type credit|debit, debit balance check)
- [x] 4 tests (≥3 required)
- [x] README with install/run/test commands
