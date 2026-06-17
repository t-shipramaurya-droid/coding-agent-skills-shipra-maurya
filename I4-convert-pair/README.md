# I4 — FastAPI + Node CLI Currency Convert Pair

**Assignment:** PM4-6558 · Polyglot service pair (extends B4/B5 patterns)

Two-component system:
- **FastAPI service** — `POST /convert` with hardcoded FX rates
- **Node.js CLI** — calls the service and prints the result

## Hardcoded rates (via USD pivot)

| Currency | Rate (units per 1 USD) |
|----------|------------------------|
| USD | 1.0 |
| EUR | 0.92 |
| GBP | 0.79 |
| INR | 83.0 |

---

## Two-terminal run

### Terminal 1 — start FastAPI service

```bash
cd PM4-6558-assignment/I4-convert-pair/service
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Verify:

```bash
curl http://127.0.0.1:8000/health
curl -X POST http://127.0.0.1:8000/convert \
  -H 'Content-Type: application/json' \
  -d '{"amount": 100, "from_currency": "USD", "to_currency": "INR"}'
```

### Terminal 2 — run Node CLI client

```bash
cd PM4-6558-assignment/I4-convert-pair/client
node src/cli.js 100 USD INR
# 100 USD = 8300 INR (rate: 83)

node src/cli.js --amount 50 --from EUR --to USD
# 50 EUR = 54.35 USD (rate: 1.087)

# Optional: point at another host
CONVERT_API_URL=http://127.0.0.1:8000 node src/cli.js 10 GBP INR
```

---

## Tests

**Service (FastAPI):**

```bash
cd PM4-6558-assignment/I4-convert-pair/service
source .venv/bin/activate
pytest -q
```

**Client (Node):**

```bash
cd PM4-6558-assignment/I4-convert-pair/client
npm test
```

---

## Input validation

| Layer | Rule |
|-------|------|
| FastAPI (Pydantic) | `amount > 0`, currency codes 3 chars, normalized to uppercase |
| Converter | Supported currencies only: USD, EUR, GBP, INR |
| Node CLI | Positive numeric amount; usage error for missing args |

---

## Project layout

```
I4-convert-pair/
├── README.md
├── service/
│   ├── app/
│   │   ├── main.py       # POST /convert, GET /rates, GET /health
│   │   └── converter.py  # pure conversion logic (unit tested)
│   ├── tests/
│   └── requirements.txt
└── client/
    ├── src/
    │   ├── cli.js        # entrypoint
    │   └── client.js     # HTTP + arg parsing (unit tested)
    └── tests/
```

---

## Agent suggested vs manually verified

| Item | Agent | You should verify |
|------|-------|-------------------|
| pytest passes | Run in CI/local | `pytest -q` in `service/` |
| npm test passes | Run locally | `npm test` in `client/` |
| End-to-end two-terminal flow | Documented above | Start uvicorn + run CLI |
| EUR→USD math | Formula in converter.py | Spot-check with curl |

---

## Docker (I5)

Containerize and run the FastAPI service without a local venv.

### Build

```bash
cd PM4-6558-assignment/I4-convert-pair/service
docker build -t i4-convert-service:latest .
```

### Run

```bash
docker run --rm -p 8000:8000 --name i4-convert i4-convert-service:latest
```

### curl proof

```bash
curl http://127.0.0.1:8000/health
# {"status":"ok"}

curl -X POST http://127.0.0.1:8000/convert \
  -H 'Content-Type: application/json' \
  -d '{"amount": 100, "from_currency": "USD", "to_currency": "INR"}'
# {"amount":100.0,"from_currency":"USD","to_currency":"INR","rate":83.0,"converted_amount":8300.0}
```

### Node CLI against container

With the container running on port 8000:

```bash
cd PM4-6558-assignment/I4-convert-pair/client
node src/cli.js 100 USD INR
```

### Stop

```bash
docker stop i4-convert
```

The image includes a **HEALTHCHECK** on `/health` (Docker-level probe).
