# Exercise evidence index

Proof write-ups for PM4-6558 — **what was done**, **on which repo**, and **how it was verified**.

| Type | Location |
|------|----------|
| **Write-ups (this folder)** | Narrative + commands + agent vs manual |
| **Runnable code** | [`../artifacts/`](../artifacts/) |
| **Screenshots** | [`../docs/screenshots/`](../docs/screenshots/) |

---

## B — Repo reader & builder

| ID | Write-up | Target repo / artifact | Runnable |
|----|----------|------------------------|----------|
| B1 | [B1-repo-inventory.md](B/B1-repo-inventory.md) | **eq-nudge-info-service** (Bitbucket) | — |
| B2 | [B2-api-endpoint-map.md](B/B2-api-endpoint-map.md) | eq-nudge-info-service | — |
| B3 | [B3-test-discovery.md](B/B3-test-discovery.md) | eq-nudge-info-service | — |
| B4 | — | Greenfield FastAPI | [artifacts/B4-fastapi](../artifacts/B4-fastapi/) |
| B5 | — | Greenfield Node.js | [artifacts/B5-nodejs](../artifacts/B5-nodejs/) |
| B6 | — | Greenfield Rust CLI | [artifacts/B6-rust-logcounter](../artifacts/B6-rust-logcounter/) |

---

## I — Intermediate

| ID | Write-up | Target repo / artifact | Runnable |
|----|----------|------------------------|----------|
| I1 | [I1-er-diagram.md](I/I1-er-diagram.md) | eq-nudge-info-service | — |
| I2 | [I2-end-to-end-flow.md](I/I2-end-to-end-flow.md) | eq-nudge-info-service | — |
| I3 | [I3-small-safe-change.md](I/I3-small-safe-change.md) | **eq-order-hold-consumer** (branch `assignment/PM4-6558-I3`) | Bitbucket |
| I4 | [I4-polyglot-pair.md](I/I4-polyglot-pair.md) | Built in assignment | [artifacts/I4-convert-pair](../artifacts/I4-convert-pair/) |
| I5 | [I5-dockerize.md](I/I5-dockerize.md) | I4 service Dockerfile | [artifacts/I4-convert-pair/service](../artifacts/I4-convert-pair/service/) |
| I6 | [I6-bug-diagnosis.md](I/I6-bug-diagnosis.md) | I4 convert service (seeded bug) | [artifacts/I4-convert-pair/service](../artifacts/I4-convert-pair/service/) |

---

## A — Advanced

| ID | Write-up | Target repo / artifact | Runnable |
|----|----------|------------------------|----------|
| A1 | [A1-parallel-plan.md](A/A1-parallel-plan.md) | eq-order-hold-consumer (PM4-6500 plan) | — |
| A2 | [A2-parallel-worktrees.md](A/A2-parallel-worktrees.md) | eq-order-hold-consumer (worktrees) | — |
| A3 | [A3-fraud-score-system.md](A/A3-fraud-score-system.md) | Polyglot mini-system | [artifacts/A3-fraud-score](../artifacts/A3-fraud-score/) |
| A4 | [A4-modernization.md](A/A4-modernization.md) | eq-order-hold-consumer (MySQL driver) | Bitbucket branch |
| A5 | [A5-pr-review.md](A/A5-pr-review.md) | eq-order-hold-consumer PR #14 (**merged**) | — |
| A6 | [A6-performance.md](A/A6-performance.md) | A3 fraud-score worker | [artifacts/A3-fraud-score](../artifacts/A3-fraud-score/) |

---

## D — Infra & DevOps

| ID | Write-up | Target artifact | Runnable |
|----|----------|-----------------|----------|
| D1 | [D1-terraform.md](D/D1-terraform.md) | S3 + Lambda + API GW | [artifacts/D1-terraform](../artifacts/D1-terraform/) |
| D2 | [D2-compose-stack.md](D/D2-compose-stack.md) | Postgres + API + worker | [artifacts/D2-compose-stack](../artifacts/D2-compose-stack/) |
| D3 | [D3-ci.md](D/D3-ci.md) | GitHub Actions for I4 | [artifacts/D3-ci](../artifacts/D3-ci/) |
| D4 | [D4-kubernetes.md](D/D4-kubernetes.md) | K8s manifests for I4 | [artifacts/D4-kubernetes](../artifacts/D4-kubernetes/) |
| D5 | [D5-reproducible-env.md](D/D5-reproducible-env.md) | eq-order-hold-consumer bootstrap | Bitbucket Makefile |
| D6 | [D6-observability.md](D/D6-observability.md) | Metrics + Grafana stack | [artifacts/D6-observability](../artifacts/D6-observability/) |

---

## External repos (not in this GitHub repo)

| Repo | Exercises |
|------|-----------|
| eq-nudge-info-service | B1, B2, B3, I1, I2 |
| eq-order-hold-consumer | I3, A1, A2, A4, A5, D5, PM4-6500 |

Link Bitbucket PRs/branches from the write-up in each evidence file.
