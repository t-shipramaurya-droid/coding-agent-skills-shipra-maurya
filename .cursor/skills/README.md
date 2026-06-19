# Coding-agent skill pack

Reusable Cursor skills from **[What can you do using a coding agent?](https://docs.google.com/document/d/1Y23tu2ePPexkBhh_G0RCK1fNio_NQ3EZuTbgWa_UyPA/edit)** — **Basics/Intermediate read**, **operate**, and **Advanced** exercises.

## Install

```bash
mkdir -p ~/.cursor/skills
cp -R PM4-6558-assignment/.cursor/skills/* ~/.cursor/skills/
```

Restart Cursor or open a new Agent chat.

---

## Quick invoke

| Goal | Skill |
|------|-------|
| Full read pack (B1–I2) | `/coding-agent-full-onboard` |
| Quick read (B1–B3) | `/coding-agent-read-any-service` |
| Advanced ticket (A1–A6) | `/coding-agent-advanced-pack` |
| Parallel plan | `/parallel-worktree-plan` |
| Run 2 worktrees | `/parallel-worktrees-execute` |
| Build FastAPI+Node+Rust | `/polyglot-mini-system` |
| Modernize deps (one step) | `/repo-modernization` |
| Review PR | `/pr-adversarial-review` |
| Fix perf bottleneck | `/performance-profile-fix` |
| Small fix | `/safe-change-in-repo` |
| Debug test | `/bug-diagnosis` |

---

## Read & operate (10 skills)

| Skill | Exercise |
|-------|----------|
| `coding-agent-full-onboard` | B1–I2 orchestrator |
| `coding-agent-read-any-service` | B1–B3 (+ optional I1/I2) |
| `repo-inventory` | B1 |
| `api-endpoint-map` | B2 |
| `test-discovery` | B3 |
| `er-diagram-from-repo` | I1 |
| `flow-trace` | I2 |
| `safe-change-in-repo` | I3 |
| `bug-diagnosis` | I6 |
| `pr-adversarial-review` | A5 |

---

## Advanced — parallel agent operator (6 skills)

| Skill | Exercise | Any repo? |
|-------|----------|-----------|
| [`coding-agent-advanced-pack`](coding-agent-advanced-pack/SKILL.md) | A1–A6 router | ✅ |
| [`parallel-worktree-plan`](parallel-worktree-plan/SKILL.md) | A1 | ✅ |
| [`parallel-worktrees-execute`](parallel-worktrees-execute/SKILL.md) | A2 | ✅ |
| [`polyglot-mini-system`](polyglot-mini-system/SKILL.md) | A3 | ⚠️ new build |
| [`repo-modernization`](repo-modernization/SKILL.md) | A4 | ✅ |
| [`performance-profile-fix`](performance-profile-fix/SKILL.md) | A6 | ✅ |

A5 = `pr-adversarial-review` (listed above).

**Suggested FO flow:** `coding-agent-full-onboard` → A1 → A2 → work → A5 before merge.

---

## Not skill-packaged

| Exercises | Reason |
|-----------|--------|
| B4–B6 | Single-language greenfield templates |
| I4 | Two-component pair (similar to A3 lite) |
| D1–D6 | Terraform, compose, CI, K8s, observability |

---

## Rules

- [`docs/cursor-rules/`](../docs/cursor-rules/) — `agent-verification`, `java-spring-safe-change`

## Evidence (PM4-6558)

| Range | Artifacts |
|-------|-----------|
| B1–I2 | `evidence/B/B1-repo-inventory.md` … `evidence/I/I2-end-to-end-flow.md` |
| I3, I6 | `evidence/I/I3-small-safe-change.md`, `evidence/I/I6-bug-diagnosis.md` |
| A1–A6 | `evidence/A/A1-parallel-plan.md` … `evidence/A/A6-performance.md` |
