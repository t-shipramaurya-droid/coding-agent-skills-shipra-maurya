# Basics Self-Eval (PM4-6558 — Shipra Maurya)

Answer **yes / no / partial** honestly. Evidence from completed learning tasks in this repo.

| Category | Question | Self-Eval | Evidence |
|----------|----------|-----------|----------|
| Repo discovery | Can you inspect an unfamiliar repo and produce a class/service/module inventory in 30 minutes? | **yes** | [`evidence/B/B1-repo-inventory.md`](evidence/B/B1-repo-inventory.md) — eq-nudge-info-service inventory |
| Data model | Can you produce an ER diagram from code, migrations, ORM models, or schema files in 45 minutes? | **yes** | [`evidence/I/I1-er-diagram.md`](evidence/I/I1-er-diagram.md) — Mermaid ER + source file citations |
| API mapping | Can you map all API endpoints to handlers/controllers in 30 minutes? | **yes** | [`evidence/B/B2-api-endpoint-map.md`](evidence/B/B2-api-endpoint-map.md) — controllers → routes |
| Flow tracing | Can you trace one endpoint/event/cron flow end-to-end across files in 45 minutes? | **yes** | [`evidence/I/I2-end-to-end-flow.md`](evidence/I/I2-end-to-end-flow.md) — sequence diagram + file path |
| Testing | Can you identify the test framework, relevant test files, and exact test command for a module in 30 minutes? | **yes** | [`evidence/B/B3-test-discovery.md`](evidence/B/B3-test-discovery.md) — JUnit 5, 45 classes, `gradle test` output |
| Greenfield build | Can you build a small FastAPI service from scratch with tests in 60 minutes? | **yes** | [`artifacts/B4-fastapi/`](artifacts/B4-fastapi/) — 4/4 pytest; POST/GET transactions + balance |
| Node.js build | Can you build a small Node.js service/CLI with tests in 60 minutes? | **yes** | [`artifacts/B5-nodejs/`](artifacts/B5-nodejs/) — 3/3 npm test; same transaction API as B4 |
| Rust build | Can you build a small Rust CLI/library with tests in 60 minutes? | **yes** | [`artifacts/B6-rust-logcounter/`](artifacts/B6-rust-logcounter/) — 3/3 cargo test; INFO/WARN/ERROR counts |
| Parallel work | Can you split a task across multiple worktrees or agent sessions safely? | **yes** | [`evidence/A/A1-parallel-plan.md`](evidence/A/A1-parallel-plan.md), [`evidence/A/A2-parallel-worktrees.md`](evidence/A/A2-parallel-worktrees.md) — 2 lanes merged, zero conflicts |
| Verification | Can you separate what the agent suggested from what you manually verified? | **yes** | [`learnings.md`](learnings.md) § Agent suggested vs manually verified; per-task docs (I3, I6, A4, A5) |

---

**Date completed:** 2026-06-17

**Notes:**

- All **24 exercises** (B1–B6, I1–I6, A1–A6, D1–D6) documented in this repo; see [`README.md`](README.md) exercise index.
- **Real FO work:** PM4-6500 Testcontainers ITs ([`evidence/A/A5-pr-review.md`](evidence/A/A5-pr-review.md)), be-plan on Confluence, I3/A4/D5 on `eq-order-hold-consumer`.
- **Docker/compose/kind** (I5, D2, D4, D6 full stack): artifacts + offline validation; see [`learnings.md`](learnings.md) — no Docker admin on laptop.
- **Cursor usage:** setup + prompts in README § [How to use this agent](README.md#how-to-use-this-agent); assignment workflow in § [How I used Cursor](README.md#how-i-used-cursor).
- **Reusable skills:** [`.cursor/skills/`](.cursor/skills/) — 16 skills (read + Advanced A1–A6).
- **Screenshots:** pytest + D6 metrics in [`docs/screenshots/`](docs/screenshots/).
