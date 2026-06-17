# Coding-agent skill pack (any imported service)

Reusable Cursor skills derived from **[What can you do using a coding agent?](https://docs.google.com/document/d/1Y23tu2ePPexkBhh_G0RCK1fNio_NQ3EZuTbgWa_UyPA/edit)**.

## Install for daily use (all projects)

```bash
mkdir -p ~/.cursor/skills
cp -R PM4-6558-assignment/.cursor/skills/* ~/.cursor/skills/
```

Restart Cursor or open a new chat.

## Quick invoke

| Goal | Skill |
|------|-------|
| Full read pack + index | `/coding-agent-full-onboard` |
| B1–B3 only | `/coding-agent-read-any-service` |
| One exercise | `/repo-inventory`, `/test-discovery`, etc. |
| Small fix with ticket | `/safe-change-in-repo` |
| Debug failing test | `/bug-diagnosis` |
| Review a PR | `/pr-adversarial-review` |

## Skill map (10 skills)

| Skill | Assignment | Works on any service? |
|-------|------------|------------------------|
| [`coding-agent-full-onboard`](coding-agent-full-onboard/SKILL.md) | B1–I2 orchestrator | ✅ + writes `docs/agent-read/README.md` |
| [`coding-agent-read-any-service`](coding-agent-read-any-service/SKILL.md) | B1–B3 (+ optional I1/I2) | ✅ lighter orchestrator |
| [`repo-inventory`](repo-inventory/SKILL.md) | B1 | ✅ |
| [`api-endpoint-map`](api-endpoint-map/SKILL.md) | B2 | ✅ |
| [`test-discovery`](test-discovery/SKILL.md) | B3 | ✅ |
| [`er-diagram-from-repo`](er-diagram-from-repo/SKILL.md) | I1 | ✅ |
| [`flow-trace`](flow-trace/SKILL.md) | I2 | ✅ |
| [`safe-change-in-repo`](safe-change-in-repo/SKILL.md) | I3 | ✅ (needs ticket/scope) |
| [`bug-diagnosis`](bug-diagnosis/SKILL.md) | I6 | ✅ |
| [`pr-adversarial-review`](pr-adversarial-review/SKILL.md) | A5 | ✅ (any PR) |

## Not skill-packaged

| Exercises | Reason |
|-----------|--------|
| B4–B6 | Greenfield new apps |
| I4, A3 | Multi-component builds |
| A1–A2, A4, A6 | Parallel work, modernization, perf — org `be-*` skills |
| D1–D6 | Infra/DevOps artifacts |

## Rules (constrain agent behavior)

Copy from [`docs/cursor-rules/`](../docs/cursor-rules/) or use [`.cursor/rules/`](../rules/):

- `agent-verification.mdc` — require manual test proof
- `java-spring-safe-change.mdc` — safe edits on Spring FO repos

## Evidence from PM4-6558

| Exercise | Example artifact |
|----------|------------------|
| B1–I2 | `B1-repo-inventory.md` … `I2-end-to-end-flow.md` |
| I3 | `I3-small-safe-change.md` |
| I6 | `I6-bug-diagnosis.md` |
| A5 | `A5-pr-review.md` |
