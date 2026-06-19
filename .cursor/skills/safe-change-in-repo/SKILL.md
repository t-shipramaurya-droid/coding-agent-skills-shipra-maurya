---
name: safe-change-in-repo
description: >-
  I3 small safe change in an unfamiliar repo — minimal diff, branch, test update,
  risk assessment, agent vs manual table. Use when making a focused fix or feature
  slice on any imported service with a Jira ticket or clear scope.
---

# Small safe change (I3)

Make a **minimal, focused change** in an unfamiliar module: branch → small diff → test → risk notes.

## Prerequisites

- Run read skills first if repo is new: `repo-inventory`, `api-endpoint-map`, `test-discovery`
- User provides: **ticket/scope**, **what to change**, **base branch** (default `main` / `stage` / `develop`)
- Apply rule: `java-spring-safe-change.mdc` for Java/Spring repos

## Procedure

1. **Create branch** — `assignment/{TICKET}-{short-slug}` or `{TICKET}-{short-slug}` from base.
2. **Locate entry point** — grep + read call chain; cite why each file is touched.
3. **Keep diff minimal** — one concern; no drive-by refactors.
4. **Add or update test** — extend existing test class when possible.
5. **Run targeted tests** — exact command + paste result.
6. **Risk assessment** — table: risk, level, mitigation.
7. **Agent vs manual** — what agent suggested vs what you ran/read.

## Output template

Write `<output-dir>/I3-safe-change.md` (or ticket-named doc):

```markdown
# I3 — Small Safe Change: {summary}

**Ticket:** {KEY} | **Repo:** `{name}` | **Branch:** `{branch}`

## Change summary
{1–3 sentences}

## Diff / branch
| File | Change |
|------|--------|

## Why these files
| File | Reason |

## Call chain (if non-obvious)
\`\`\`
entry → … → side effect
\`\`\`

## Test command and result
\`\`\`bash
{command}
\`\`\`
{BUILD SUCCESSFUL / N passed}

## Risk assessment
| Risk | Level | Mitigation |

## Agent suggested vs manually verified
| Item | Agent | Manual verification |

## Code change (before → after)
{minimal snippet if helpful}
```

## Verification rules

- Never claim tests pass without running them.
- If full suite is out of scope, say so and list what was run vs deferred.
- No merge to production branches unless user explicitly asks.

## Reference

Example: `PM4-6558-assignment/evidence/I/I3-small-safe-change.md`.
