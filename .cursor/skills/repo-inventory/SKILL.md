---
name: repo-inventory
description: >-
  B1 repo artifact inventory for any service — controllers, services, models,
  repos, jobs, configs in ~30 minutes. Use when user asks for repo discovery,
  module inventory, class map, or B1 on an unfamiliar codebase.
---

# Repo inventory (B1)

Produce a **class/service/module inventory** from code only. Works on any stack.

## Procedure

1. **Detect project type** from root files (`build.gradle`, `pom.xml`, `package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`, `requirements.txt`).
2. **Scan for layers** (names vary by stack):

   | Layer | Java/Spring | Node | Python | Rust |
   |-------|-------------|------|--------|------|
   | HTTP entry | `*Controller`, routes | `routes/`, `app.get` | `@app.get`, routers | `actix`, `axum` |
   | Business | `*Service`, `*Impl` | `services/` | `services/` | `lib.rs` modules |
   | Data | `*Repository`, JPA | `models/`, ORM | SQLAlchemy models | `repo` modules |
   | Jobs/consumers | `@KafkaListener`, `@Scheduled` | workers, consumers | Celery, scripts | binaries |
   | Config | `*Config`, `application*.yml` | `config/` | `settings.py` | `config.rs` |

3. **Count and list** major items — tables, not prose walls.
4. **Note** build tool, language version, context path / base URL if present.
5. **Cite paths** for every row (relative to repo root).

## Output template

Write to `<output-dir>/B1-repo-inventory.md`:

```markdown
# B1 — Repo Artifact Inventory: {service-name}

**Repo:** `{repo-path}` | **Time target:** 30 min

## Module layout
| Item | Value |
|------|-------|
| Type | {gradle module / monorepo package / etc.} |
| Build file | `{path}` |
| Runtime | {Java 21 / Node 20 / etc.} |
| Context path | `{if any}` |

## {Layer name} ({count})
| Class / module | Path | Purpose |
|----------------|------|---------|

## Config & utilities
| File | Purpose |

## Agent suggested vs manually verified
| Item | Agent | Manual |
|------|-------|--------|
| File counts | glob/search | ✅ spot-checked N paths |
```

## Verification

Spot-check 3–5 random paths from the inventory exist on disk. Record in the footer table.

## Reference

Example: `PM4-6558-assignment/B1-repo-inventory.md` (eq-nudge-info-service).
