# D2 — docker-compose fraud stack

Multi-service stack: **PostgreSQL** + **FastAPI API** + **Node worker** (Rust scoring engine).

## Architecture

```
PostgreSQL (seed data)
    ↑ read/write
FastAPI API (:8100)
    ↑ HTTP poll + score submit
Node worker → Rust fraud-score CLI
```

## One-command E2E (assignment proof)

Requires **Docker Desktop** running.

```bash
cd PM4-6558-assignment/artifacts/D2-compose-stack
chmod +x scripts/*.sh
./scripts/test-stack.sh
```

This runs: `down -v` → `up --build` → E2E assertions → service logs.

## Teardown and clean re-up

```bash
./scripts/stack-down.sh          # down -v
./scripts/test-stack.sh          # fresh up from zero
```

## Manual steps

```bash
docker compose up -d --build
./scripts/e2e-test.sh
docker compose logs api worker db
docker compose down -v
```

## Seed data

Loaded via `db/init/02-seed.sql` on first Postgres start:

| ID | Amount | User | Merchant | Expected score |
|----|--------|------|----------|----------------|
| tx-seed-001 | 150 USD | user-1 | M100 | LOW |
| tx-seed-002 | 1200 USD | bad-user | M999 | HIGH |

## No Docker?

Validate compose syntax when Docker is installed:

```bash
./scripts/validate-compose.sh
```

Full E2E requires Docker (same pattern as I5 — artifacts + run when available).

## Services

| Service | Port | Dockerfile |
|---------|------|------------|
| db | 5433→5432 | postgres:16-alpine |
| api | 8100 | `api/Dockerfile` |
| worker | — | `worker/Dockerfile` (multi-stage Rust + Node) |
