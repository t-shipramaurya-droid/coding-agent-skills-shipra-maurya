# PM4-6558 — Coding Agent Skills Assignment

**Candidate:** Shipra Maurya (`t-shipra.maurya@pmltp.com`)  
**Jira:** [PM4-6558](https://paytmmoney.atlassian.net/browse/PM4-6558)  
**Parent initiative:** PM4-6057 — AI Learning | Coding agent skills  
**Assignment reference:** [What can you do using a coding agent?](https://docs.google.com/document/d/1Y23tu2ePPexkBhh_G0RCK1fNio_NQ3EZuTbgWa_UyPA/edit)  
**Status:** All exercises complete · Jira submitted for review · Google Doc self-eval filled

---

## Executive summary

This repository is my **submission evidence** for the Paytm Money coding-agent skills assignment. I used Cursor + agent skills to:

1. **Read unfamiliar repos** (inventory, API maps, ER diagrams, flow traces, tests)
2. **Build greenfield services** in Python, Node.js, and Rust
3. **Operate safely in production-adjacent code** (small fixes, PR review, modernization)
4. **Run parallel agent workflows** (worktrees, multi-language systems)
5. **Produce infra/DevOps artifacts** (Terraform, Docker Compose, CI, Kubernetes, observability)
6. **Apply learnings on real FO work** — Testcontainers integration tests for `eq-order-hold-consumer` (PM4-6500)

Every exercise has a **write-up markdown file**, **runnable code** (where applicable), and notes on **what the agent suggested vs what I manually verified**. See [`learnings.md`](learnings.md) for gaps, recommendations, and honest limitations.

**Visual proof:** Four PNG screenshots in [`docs/screenshots/`](docs/screenshots/) document live pytest runs and D6 observability (details below).

---

## Verification screenshots

These images are committed to the repo so HR/evaluators can see **manual verification** at a glance. Reproduce any capture using the commands in the table.

| File | What it proves | How it was captured |
|------|----------------|---------------------|
| [`01-pytest-all-green.png`](docs/screenshots/01-pytest-all-green.png) | **I4 + D6 tests pass** — 9/9 pytest (API, converter, metrics) | `cd I4-convert-pair/service && pytest -v` |
| [`02-d6-panel-data-json.png`](docs/screenshots/02-d6-panel-data-json.png) | **D6 panel data** — JSON with USD→EUR (21), USD→INR (11), EUR→USD (8) | `D6-observability/artifacts/panel-data.json` |
| [`03-d6-prove-local-terminal.png`](docs/screenshots/03-d6-prove-local-terminal.png) | **D6 full pipeline** — load 40 requests, metrics snapshot, 2 pytest passed | `cd D6-observability && ./scripts/prove-local.sh` |
| [`04-d6-metrics-grep.png`](docs/screenshots/04-d6-metrics-grep.png) | **Prometheus counters** — raw `convert_requests_total` lines (21+11+8=40) | `grep convert_requests_total D6-observability/artifacts/metrics-snapshot.txt` |

### 1 — All tests green (I4 convert + D6 metrics)

![9 pytest tests passed including test_metrics.py](docs/screenshots/01-pytest-all-green.png)

*Covers `test_convert_api.py`, `test_converter.py`, and `test_metrics.py` — proves `/metrics` endpoint and convert logic.*

### 2 — D6 dashboard panel data (JSON artifact)

![panel-data.json with status success and currency pair metrics](docs/screenshots/02-d6-panel-data-json.png)

*Grafana/Prometheus-style query result for `sum(rate(convert_requests_total[1m]))` — D6 requirement without Docker/Grafana.*

### 3 — D6 prove-local script (end-to-end)

![prove-local.sh: uvicorn, 40 convert requests, metrics written, tests passed](docs/screenshots/03-d6-prove-local-terminal.png)

*Single script: start service → generate traffic → scrape `/metrics` → emit panel JSON → verify with pytest.*

### 4 — Raw Prometheus metrics (grep)

![grep convert_requests_total showing EUR USD INR counts](docs/screenshots/04-d6-metrics-grep.png)

*Direct exposition from `/metrics` — counters match the 40-request load script.*

> **Tip for evaluators:** Start with screenshots 1 and 3, then open [`D6-observability.md`](D6-observability.md) for the full write-up.

---

## How to navigate this repo (for evaluators)

| Start here | Purpose |
|------------|---------|
| **This README** | Overview + index + **screenshots** |
| [`docs/screenshots/`](docs/screenshots/) | PNG proof: pytest green, D6 metrics (4 images) |
| [`learnings.md`](learnings.md) | What worked, gaps, verification matrix, full checklist |
| `B*.md` / `I*.md` / `A*.md` / `D*.md` | One doc per exercise with proof commands |
| Runnable subfolders | `B4-fastapi/`, `I4-convert-pair/`, `A3-fraud-score/`, `D1-terraform/`, etc. |

**Suggested review order (15 min skim → 45 min deep):**

1. Scroll **Verification screenshots** above (4 PNGs)
2. Read `learnings.md`
3. Skim exercise index table below
4. Optionally re-run one verify command

---

## Exercise index (24/24 complete)

### Eval: Basics → covered by exercises below

| Self-eval skill | Exercises |
|-----------------|-----------|
| Repo discovery | B1 |
| Data model | I1 |
| API mapping | B2 |
| Flow tracing | I2 |
| Testing | B3 |
| FastAPI / Node / Rust build | B4, B5, B6 |
| Parallel work | A1, A2 |
| Agent vs manual verification | I3, I6, all `*.md` |

### B — Repo reader & builder

| ID | Topic | Artifact | Quick verify |
|----|-------|----------|--------------|
| B1 | Repo inventory | [`B1-repo-inventory.md`](B1-repo-inventory.md) | Read-only |
| B2 | API endpoint map | [`B2-api-endpoint-map.md`](B2-api-endpoint-map.md) | Read-only |
| B3 | Test discovery | [`B3-test-discovery.md`](B3-test-discovery.md) | `gradle test` in eq-nudge-info-service |
| B4 | FastAPI greenfield | [`B4-fastapi/`](B4-fastapi/) | `pytest -v` |
| B5 | Node.js greenfield | [`B5-nodejs/`](B5-nodejs/) | `npm test` |
| B6 | Rust CLI | [`B6-rust-logcounter/`](B6-rust-logcounter/) | `cargo test` |

### I — Intermediate

| ID | Topic | Artifact | Quick verify |
|----|-------|----------|--------------|
| I1 | ER diagram | [`I1-er-diagram.md`](I1-er-diagram.md) | Mermaid in doc |
| I2 | End-to-end flow | [`I2-end-to-end-flow.md`](I2-end-to-end-flow.md) | Sequence diagram |
| I3 | Small safe change | [`I3-small-safe-change.md`](I3-small-safe-change.md) | Branch in eq-order-hold-consumer* |
| I4 | FastAPI + Node CLI | [`I4-convert-pair/`](I4-convert-pair/) | `pytest` + `npm test` |
| I5 | Dockerize | [`I5-dockerize.md`](I5-dockerize.md) + [`I4-convert-pair/service/Dockerfile`](I4-convert-pair/service/Dockerfile) | `docker build` (optional) |
| I6 | Bug diagnosis | [`I6-bug-diagnosis.md`](I6-bug-diagnosis.md) | `pytest` in I4 service |

*I3/A4/D5 code changes live in Bitbucket `eq-order-hold-consumer` — links in exercise docs.

### A — Advanced

| ID | Topic | Artifact | Quick verify |
|----|-------|----------|--------------|
| A1 | Parallel plan | [`A1-parallel-plan.md`](A1-parallel-plan.md) | Read-only |
| A2 | Parallel worktrees | [`A2-parallel-worktrees.md`](A2-parallel-worktrees.md) | Read-only |
| A3 | Fraud-score system | [`A3-fraud-score/`](A3-fraud-score/) | cargo + pytest + npm |
| A4 | Repo modernization | [`A4-modernization.md`](A4-modernization.md) | `gradle test` after driver change* |
| A5 | Agent PR review | [`A5-pr-review.md`](A5-pr-review.md) | PM4-6500 PR #14 |
| A6 | Performance | [`A6-performance.md`](A6-performance.md) | `node benchmark/bench-scoring.mjs` |

### D — Infra & DevOps

| ID | Topic | Artifact | Quick verify |
|----|-------|----------|--------------|
| D1 | Terraform | [`D1-terraform/`](D1-terraform/) | `./scripts/tf-verify.sh` |
| D2 | docker-compose stack | [`D2-compose-stack/`](D2-compose-stack/) | `./scripts/test-stack.sh` (Docker) |
| D3 | CI pipeline | [`D3-ci/`](D3-ci/) | `./scripts/run-ci-local.sh` |
| D4 | Kubernetes | [`D4-kubernetes/`](D4-kubernetes/) | `./scripts/validate.sh` |
| D5 | Reproducible bootstrap | [`D5-reproducible-env.md`](D5-reproducible-env.md) | `make bootstrap` in eq-order-hold-consumer* |
| D6 | Observability | [`D6-observability/`](D6-observability/) | `./scripts/prove-local.sh` |

---

## Real FO delivery (beyond the assignment doc)

| Item | Link / location |
|------|-----------------|
| be-plan PM4-6500 | [Confluence — Implementation plan](https://paytmmoney.atlassian.net/wiki/spaces/PM/pages/748716084) |
| Integration tests PR | Bitbucket PR #14 on `eq-order-hold-consumer` → `stage` |
| A5 code review | [`A5-pr-review.md`](A5-pr-review.md) — **Approve** with non-blocking follow-ups |

---

## Environment & honest limitations

| Constraint | How I handled it |
|------------|------------------|
| No Docker on laptop | I5/D2/D4/D6: full artifacts + offline validation; Docker scripts included for evaluators with Docker |
| Gradle wrapper SSL | D5 bootstrap uses sdkman Java 21 + Gradle 8.10.2 |
| Agent claims | Every exercise doc separates **agent suggested** vs **manually verified** |

---

## Quick verification commands (copy-paste)

```bash
# B4 FastAPI
cd B4-fastapi && python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt && pytest -v

# I4 convert pair
cd I4-convert-pair/service && pip install -r requirements.txt && pytest -q
cd ../client && npm test

# A3 fraud score
cd A3-fraud-score/engine && cargo test
cd ../service && pytest -q
cd ../worker && npm test

# D1 Terraform
cd D1-terraform && ./scripts/tf-verify.sh

# D3 CI (local simulation)
cd D3-ci && ./scripts/run-ci-local.sh

# D6 Observability (no Docker)
cd D6-observability && ./scripts/prove-local.sh
```

---

## Repo structure

```
PM4-6558-assignment/
├── README.md                 ← you are here
├── learnings.md              ← gaps, verification, checklist
├── docs/
│   └── screenshots/          ← PNG verification proof (see README § Screenshots)
│       ├── 01-pytest-all-green.png
│       ├── 02-d6-panel-data-json.png
│       ├── 03-d6-prove-local-terminal.png
│       └── 04-d6-metrics-grep.png
├── B1…B6, I1…I6, A1…A6, D1…D6 *.md
├── B4-fastapi/               ← greenfield Python
├── B5-nodejs/                ← greenfield Node
├── B6-rust-logcounter/       ← greenfield Rust
├── I4-convert-pair/          ← polyglot pair + Dockerfile
├── A3-fraud-score/           ← FastAPI + Node + Rust
├── D1-terraform/             ← S3 + Lambda + API GW
├── D2-compose-stack/         ← Postgres + API + worker
├── D3-ci/                    ← GitHub Actions workflow
├── D4-kubernetes/            ← K8s manifests
└── D6-observability/         ← Prometheus + Grafana + metrics
```

---

## Contact

**Shipra Maurya** · t-shipra.maurya@pmltp.com  
Jira: PM4-6558 · Submitted for review
