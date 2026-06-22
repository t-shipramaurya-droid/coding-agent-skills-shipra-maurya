# B5 — Node.js Transaction Service

Same transaction API as B4 (FastAPI), implemented in Node.js for the coding agent skills assignment.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Liveness check (`{"status":"ok"}`) |
| POST | `/transactions` | Create credit/debit transaction |
| GET | `/transactions` | List all transactions |
| GET | `/balance` | Current balance |

## Run

```bash
cd PM4-6558-assignment/artifacts/B5-nodejs
node src/server.js
```

Server starts on `http://localhost:3000`.

## Test

```bash
npm test
```

## Example

```bash
curl -X POST http://localhost:3000/transactions \
  -H 'Content-Type: application/json' \
  -d '{"amount": 50, "type": "credit"}'

curl http://localhost:3000/health
curl http://localhost:3000/balance
curl http://localhost:3000/transactions
```
