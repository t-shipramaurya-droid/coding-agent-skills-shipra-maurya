---
name: repo-modernization
description: >-
  A4 repository modernization — analyze deps/config with evidence, prioritized
  plan, implement highest-value lowest-risk first step, verify and rollback notes.
  Use on any repo for dependency upgrades, build hygiene, or tech debt triage.
---

# Repository modernization (A4)

**Analyze → prioritize → implement one safe step → verify.**

## Procedure

1. **Scan evidence** — `build.gradle`, `pom.xml`, `package.json`, CI config, README, `.sdkmanrc`, Docker.
2. **Findings table** — area, finding, file:line evidence, severity.
3. **Prioritized plan** — value × risk × effort; pick **P1** first step (low risk, high value).
4. **Implement P1 only** — one branch, minimal diff; do not batch risky upgrades.
5. **Verify** — build, unit tests, lint; note skipped ITs.
6. **Rollback notes** — how to revert (git revert, dependency pin restore).

## Output template

`<output-dir>/A4-modernization.md`:

```markdown
# A4 — Repository Modernization: {repo}

**Branch:** `{branch}` | **Date:** {date}

## 1. Findings (evidence)
| # | Area | Finding | Evidence | Severity |

## 2. Prioritised plan
| Priority | Item | Value | Risk | Effort |

## 3. First step implemented (P1)
| File | Change |
**Why P1:** ...

## 4. Verification
\`\`\`bash
{command}
\`\`\`
{BUILD SUCCESSFUL / N passed}

## 5. Rollback
\`\`\`bash
git revert {commit}  # or restore dependency line
\`\`\`

## 6. Deferred (P2+)
- ...

## Agent suggested vs manually verified
| Item | Agent | Manual |
```

## Rules

- **One P1 change per run** — e.g. MySQL driver only, not driver + Kafka + Redis together.
- Flag **security** findings (hardcoded creds) even if out of scope for this PR.
- Spring Boot: prefer BOM-managed versions over manual pins.
- Apply `java-spring-safe-change.mdc` on Java repos.

## Reference

`PM4-6558-assignment/evidence/A/A4-modernization.md` (MySQL connector-j migration).
