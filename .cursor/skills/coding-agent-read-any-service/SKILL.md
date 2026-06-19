---
name: coding-agent-read-any-service
description: >-
  Orchestrates repo-read skills from the Paytm coding-agent curriculum on any
  imported service. Runs inventory, API map, and test discovery (B1–B3); optional
  ER diagram and flow trace (I1–I2). Use when onboarding an unfamiliar repo,
  PM4-6558-style analysis, or user says "read this service" / "repo discovery".
  For full B1–I2 + index README use coding-agent-full-onboard instead.
---

# Read any imported service (coding-agent curriculum)

Run **read-only analysis** on any repo the user points at. Skills map to [What can you do using a coding agent?](https://docs.google.com/document/d/1Y23tu2ePPexkBhh_G0RCK1fNio_NQ3EZuTbgWa_UyPA/edit) — the tasks that work on **any** service, not greenfield builds.

## When to use

- User imports/clones a service and wants quick understanding
- PM4-6558 B1–B3 or I1–I2 on a new repo
- Before making a safe change (I3) — run this pack first

## Inputs

| Input | Required | Default |
|-------|----------|---------|
| Repo path | Yes | Current workspace root |
| Output dir | No | `<repo>/docs/agent-read/` |
| Flow entry point | For I2 only | User picks one endpoint/event/cron |

## Skill pack (invoke individually or in order)

| Skill | Exercise | Time target | Output file |
|-------|----------|-------------|-------------|
| `repo-inventory` | B1 | 30 min | `evidence/B/B1-repo-inventory.md` |
| `api-endpoint-map` | B2 | 30 min | `evidence/B/B2-api-endpoint-map.md` |
| `test-discovery` | B3 | 15 min | `evidence/B/B3-test-discovery.md` |
| `er-diagram-from-repo` | I1 | 45 min | `evidence/I/I1-er-diagram.md` |
| `flow-trace` | I2 | 45 min | `evidence/I/I2-end-to-end-flow.md` |

**Full pack + index:** use `coding-agent-full-onboard` (runs all five + `README.md`).

**After read pack:** `safe-change-in-repo` (I3), `bug-diagnosis` (I6), `pr-adversarial-review` (A5).

Supporting rule (always on): `.cursor/rules/agent-verification.mdc`

## Default workflow

1. Confirm repo path exists and is the service root (has build file: `build.gradle`, `pom.xml`, `package.json`, `Cargo.toml`, `pyproject.toml`, etc.).
2. Detect stack (Java/Spring, Node, Python, Rust, Go) — do not assume Spring.
3. Run in order: **repo-inventory** → **api-endpoint-map** → **test-discovery**.
4. Ask user if they want **I1** (ER) and **I2** (one flow); run only if yes or user asked for full pack.
5. Write all artifacts under output dir; add index `README.md` linking each file.
6. End with **Agent suggested vs manually verified** — run at least the test command from B3 yourself.

## Prompt template for user

```
Read this service using coding-agent-read-any-service.
Repo: /path/to/service-name
Output: docs/agent-read/
Also run I2 on: GET /api/v1/example
```

## Not in this pack (separate skills)

| Exercise | Skill |
|----------|-------|
| B4–B6 greenfield | Manual / language templates |
| I3 safe change | `safe-change-in-repo` |
| I6 bug diagnosis | `bug-diagnosis` |
| A5 PR review | `pr-adversarial-review` |
| I4–A3 polyglot systems | Multi-repo build |
| A1–A2 parallel worktrees | Git workflow |
| D1–D6 infra | Platform artifacts |

Reference implementations: `PM4-6558-assignment/evidence/B/B1-repo-inventory.md` through `evidence/I/I2-end-to-end-flow.md`.
