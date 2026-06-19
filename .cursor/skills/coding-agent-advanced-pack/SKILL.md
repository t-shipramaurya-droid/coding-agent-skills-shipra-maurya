---
name: coding-agent-advanced-pack
description: >-
  Orchestrates PM4-6558 Advanced exercises A1–A6 on any repo or greenfield
  folder. Routes to parallel plan/worktrees, polyglot build, modernization,
  PR review, or perf fix. Use for A1–A6 assignment work or supervising agents
  on larger tasks.
---

# Advanced agent operator pack (A1–A6)

Supervise **parallel agent work**, **system builds**, **modernization**, **PR review**, and **perf fixes**. Maps to assignment § Advanced.

## When to use

| Scenario | Skill |
|----------|-------|
| Split a feature across agent sessions | `parallel-worktree-plan` (A1) then `parallel-worktrees-execute` (A2) |
| Build FastAPI + Node + Rust mini-system | `polyglot-mini-system` (A3) |
| Modernize deps/config + one safe step | `repo-modernization` (A4) |
| Review agent/human PR | `pr-adversarial-review` (A5) ✅ already exists |
| Profile and fix a bottleneck | `performance-profile-fix` (A6) |

## Inputs

| Input | Required | Default |
|-------|----------|---------|
| Ticket / goal | Yes | — |
| Repo path | For A1/A2/A4/A5/A6 | Workspace root |
| Base branch | For git skills | `stage` / `main` |
| Output dir | No | `<repo>/docs/agent-advanced/` or assignment root |

## Execution order (typical FO ticket)

1. **Read first** — run `coding-agent-full-onboard` if repo is unfamiliar
2. **A1** — `parallel-worktree-plan` → decomposition + lane prompts
3. **A2** — `parallel-worktrees-execute` → two+ worktrees, merge, test
4. **A4** — optional `repo-modernization` if ticket touches deps
5. **A5** — `pr-adversarial-review` before merge
6. **A6** — only if perf issue identified

**A3** is standalone greenfield — not “read any service”; use when building a new polyglot demo/system.

## Prompt template

```
Use coding-agent-advanced-pack for ticket PM4-XXXX.

Repo: /path/to/service
Goal: <one sentence>
Start with A1 parallel plan, then A2 with 2 lanes.
Output: docs/agent-advanced/
```

## Skill map

| Skill | Exercise | Reusable on any repo? |
|-------|----------|------------------------|
| `parallel-worktree-plan` | A1 | ✅ any git repo + ticket |
| `parallel-worktrees-execute` | A2 | ✅ any git repo |
| `polyglot-mini-system` | A3 | ⚠️ builds new folder (template) |
| `repo-modernization` | A4 | ✅ any repo |
| `pr-adversarial-review` | A5 | ✅ any PR |
| `performance-profile-fix` | A6 | ✅ any service/script |

## Rules

- `agent-verification.mdc` — always on
- `java-spring-safe-change.mdc` — for A4 on Spring repos
- Lanes must touch **disjoint files** (A1/A2) to avoid merge chaos

## Reference artifacts

`PM4-6558-assignment/evidence/A/A1-parallel-plan.md` … `evidence/A/A6-performance.md`
