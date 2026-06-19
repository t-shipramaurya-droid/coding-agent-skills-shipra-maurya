# Fraud Score Data Contract (A3)

## Transaction ingest (client → FastAPI)

`POST /transactions`

```json
{
  "amount": 250.0,
  "currency": "USD",
  "user_id": "user-42",
  "merchant_id": "M100"
}
```

Validation: `amount > 0`, non-empty `currency` (3 chars), `user_id`, `merchant_id`.

## Transaction record (FastAPI storage)

```json
{
  "transaction_id": "tx-0001",
  "amount": 250.0,
  "currency": "USD",
  "user_id": "user-42",
  "merchant_id": "M100",
  "status": "PENDING",
  "risk_score": null,
  "risk_level": null
}
```

## Score request (Node worker → Rust CLI stdin)

Same fields as ingest plus `transaction_id`:

```json
{
  "transaction_id": "tx-0001",
  "amount": 250.0,
  "currency": "USD",
  "user_id": "user-42",
  "merchant_id": "M100"
}
```

## Score response (Rust CLI stdout)

```json
{
  "transaction_id": "tx-0001",
  "risk_score": 35,
  "risk_level": "LOW",
  "reasons": ["amount_under_500"]
}
```

## Score submit (Node worker → FastAPI)

`POST /transactions/{transaction_id}/score`

Body = Rust score response (without requiring `reasons` in API persistence).

## Risk rules (Rust engine)

| Rule | Points |
|------|--------|
| Base | 10 |
| amount > 1000 | +45 |
| amount > 500 | +25 |
| merchant_id == `M999` (blocked) | +50 |
| user_id starts with `bad-` | +30 |

Levels: `0–39 LOW`, `40–69 MEDIUM`, `70+ HIGH` (cap score at 100).
