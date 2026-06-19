---
name: polyglot-mini-system
description: >-
  A3 polyglot mini-system — FastAPI ingestion, Node worker, Rust CLI/library
  with data contract, tests, README run order. Use when building a multi-language
  system from scratch (fraud-score pattern), not for reading an existing repo.
---

# Polyglot mini-system (A3)

Build a **three-component system** — Python API + Node worker + Rust engine — with explicit data contract.

## When to use

- Assignment A3 or similar polyglot exercise
- Prototype where each language plays a natural role (API / async worker / compute)

## Default architecture (fraud-score pattern)

| Component | Stack | Role |
|-----------|-------|------|
| Service | FastAPI | Ingest, queue pending, store results |
| Worker | Node.js | Poll pending → call Rust → submit score |
| Engine | Rust CLI | JSON stdin → risk score stdout |

Adapt names/paths if user specifies different domain (not fraud).

## Procedure

1. **Write CONTRACT.md** — request/response JSON schemas between all three.
2. **Rust engine** — `cargo` project, stdin JSON, stdout JSON, 3+ tests, missing-input errors.
3. **FastAPI service** — POST ingest, GET pending/scores, validation, 3+ pytest tests.
4. **Node worker** — poll loop or one-shot CLI, calls Rust via spawn, 2+ tests or script verify.
5. **README** — three-terminal run order, curl examples.
6. **Integration path** — at least one end-to-end: ingest → worker → score visible via API.

## Output layout

```
{output-dir}/A3-{system-name}/
├── CONTRACT.md
├── README.md
├── service/          # FastAPI
├── worker/           # Node
└── engine/           # Rust
```

Plus `<output-dir>/A3-polyglot-system.md` summary with agent vs manual table.

## Verification (mandatory)

```bash
cd engine && cargo test
cd ../service && pytest -q
cd ../worker && npm test   # or node verify script
# Manual: start all three, one transaction E2E
```

## Rules

- Hardcoded business rules OK for assignment (like fixed exchange rates in I4).
- Document **run order** — worker fails if API/engine not up.
- Not for “onboard existing repo” — use `coding-agent-full-onboard` first if extending an existing service.

## Reference

`PM4-6558-assignment/artifacts/A3-fraud-score/`
