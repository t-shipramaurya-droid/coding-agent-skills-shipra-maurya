# B4 — FastAPI Transaction Service

Small greenfield service for the coding agent skills assignment (PM4-6558).

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/transactions` | Create credit/debit transaction |
| GET | `/transactions` | List all transactions |
| GET | `/balance` | Current balance |

## Install

```bash
cd PM4-6558-assignment/artifacts/B4-fastapi
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run

```bash
uvicorn app.main:app --reload --port 8000
```

## Test

```bash
pytest -v
```

## Example

```bash
curl -X POST http://localhost:8000/transactions \
  -H 'Content-Type: application/json' \
  -d '{"amount": 100, "type": "credit", "description": "deposit"}'

curl http://localhost:8000/balance
curl http://localhost:8000/transactions
```
