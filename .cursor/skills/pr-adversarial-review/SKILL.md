---
name: pr-adversarial-review
description: >-
  A5 adversarial PR review — correctness, security, tests, performance,
  maintainability with severity and blocking classification. Use when reviewing
  any agent-generated or human PR, before merge, or for PM4-6558 A5-style review.
---

# Adversarial PR review (A5)

Review a PR **as a skeptical human** — not a cheerleader. Works on any repo/PR.

## Inputs

| Input | Required |
|-------|----------|
| PR URL or branch name | Yes |
| Base branch | Default `main` / `stage` |
| Scope note | Optional (e.g. "tests only") |

## Procedure

1. **Summarize PR** — commits, files changed, +/− lines, production vs test touch.
2. **Diff review** — read changed files; trace call paths for logic changes.
3. **Issue list** — table with severity (Critical/High/Medium/Low/Info), blocking Y/N, area, finding, suggested fix, verification step.
4. **Blocking gate** — explicit list; if none, state why (e.g. test-only PR).
5. **What looks good** — adversarial pass still notes strengths.
6. **Verdict** — Approve / Approve with follow-ups / Request changes.
7. **Agent vs manual** — what you read in diff vs what you ran (tests, curl).

## Output template

`<output-dir>/A5-pr-review.md`:

```markdown
# A5 — PR Review: {title}

**PR:** {url or branch → base} | **Scope:** {N files, +X/−Y}

**Verdict:** {Approve | Approve with follow-ups | Request changes} — {one line}

## PR summary
| Commit | Purpose |

## Issue list
| # | Severity | Blocking? | Area | Finding | Suggested fix | Verification |

## Blocking issues
{None or list}

## What looks good
| Check | Assessment |

## Agent suggested vs manually verified
| Item | Agent | Manual |

## Recommended follow-ups
- ...
```

## Review checklist

- [ ] Correctness — edge cases, nulls, off-by-one, race conditions
- [ ] Security — secrets, injection, auth bypass, unsafe defaults
- [ ] Tests — meaningful assertions vs mocks-only; skipped tests = green?
- [ ] Performance — N+1, unbounded loops, redundant containers/context loads
- [ ] Maintainability — duplication, naming, docs, rollback path

## Reference

Example: `PM4-6558-assignment/evidence/A/A5-pr-review.md` (PM4-6500 Testcontainers PR).
