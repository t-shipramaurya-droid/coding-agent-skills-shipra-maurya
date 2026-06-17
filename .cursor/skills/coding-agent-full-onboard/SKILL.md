---
name: coding-agent-full-onboard
description: >-
  Full service onboarding — runs B1, B2, B3, I1, I2 on any imported repo and
  writes docs/agent-read/README.md index. Use when user says "onboard this service",
  "full repo read", or wants complete PM4-6558 read pack in one shot.
---

# Full service onboard

Run the **complete read pack** on any imported service and produce a linked artifact folder.

## When to use

- New repo clone — first hour on a service
- Handoff doc for teammates or HR evidence
- Before I3 safe change or ticket work

## Inputs

| Input | Default |
|-------|---------|
| Repo path | Workspace root |
| Output dir | `<repo>/docs/agent-read/` |
| Flow entry (I2) | Main business endpoint from B2, or user-specified |
| Service display name | From folder name or `application.yml` |

## Execution order (do not skip verification)

1. **repo-inventory** → `B1-repo-inventory.md`
2. **api-endpoint-map** → `B2-api-endpoint-map.md`
3. **test-discovery** → `B3-test-discovery.md` (**must run tests**)
4. **er-diagram-from-repo** → `I1-er-diagram.md`
5. **flow-trace** → `I2-end-to-end-flow.md` (one entry from B2 or user)
6. **Write index** → `README.md` (template below)
7. **Summary footer** — aggregate agent vs manual from B3 at minimum

## Index template (`docs/agent-read/README.md`)

```markdown
# Agent read pack — {service-name}

Generated: {date} | Repo: `{path}` | Curriculum: PM4-6558 read exercises

## Artifacts

| File | Exercise | Description |
|------|----------|-------------|
| [B1-repo-inventory.md](./B1-repo-inventory.md) | B1 | Module/class inventory |
| [B2-api-endpoint-map.md](./B2-api-endpoint-map.md) | B2 | Routes → handlers |
| [B3-test-discovery.md](./B3-test-discovery.md) | B3 | Tests + command output |
| [I1-er-diagram.md](./I1-er-diagram.md) | I1 | ER diagram + Mermaid |
| [I2-end-to-end-flow.md](./I2-end-to-end-flow.md) | I2 | One flow trace |

## Quick facts
- **Stack:** {detected}
- **Test command:** `{from B3}`
- **Test result:** {pass/fail summary}
- **Primary API:** {top endpoint from B2}

## Next steps (optional skills)
- Safe change: `/safe-change-in-repo` + ticket
- Bug fix: `/bug-diagnosis`
- PR review: `/pr-adversarial-review`

## Agent suggested vs manually verified
| Item | Agent | Manual |
|------|-------|--------|
| B3 tests | inferred command | ✅ executed |
| Spot-check paths | search | ✅ N files opened |
```

## Prompt template

```
/coding-agent-full-onboard
Repo: /path/to/service
Output: docs/agent-read/
I2 entry: GET /api/v1/foo
```

## Related skills

| Lighter pack | This skill |
|--------------|------------|
| `coding-agent-read-any-service` | B1–B3 only (+ optional I1/I2) |
| `coding-agent-full-onboard` | B1 + B2 + B3 + I1 + I2 + README index |

## Time budget

~2 hours total (matches B1+B2+B3+I1+I2 assignment targets). Stop and note partial completion if blocked (no creds, Docker, etc.).
