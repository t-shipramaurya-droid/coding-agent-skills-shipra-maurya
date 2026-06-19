---
name: parallel-worktree-plan
description: >-
  A1 multi-worktree parallel plan — decompose a feature into agent lanes,
  branch names, prompts, merge order, conflict plan. Use before splitting work
  across worktrees or parallel Cursor sessions on any repo.
---

# Parallel worktree plan (A1)

Produce a **safe parallel plan** before any agent writes code in multiple lanes.

## Inputs

| Input | Required |
|-------|----------|
| Ticket key + goal | Yes |
| Repo path | Yes |
| Base branch | Default `origin/stage` |
| Max lanes | Default 2–4 |

## Procedure

1. **Decompose** feature into lanes with **disjoint file ownership** (docs vs tests vs build vs prod code).
2. **Name branches** — `lane/{TICKET}-{slug}` from base.
3. **Write agent prompt per lane** — scope, files allowed, files forbidden, verify command.
4. **Shared constraints** — base branch, no prod secrets, test command, merge order.
5. **Merge order** — build/infra → tests → docs → CI (or justify).
6. **Conflict/risk plan** — what if two lanes touch same file?
7. **Verification plan** — per lane + after merge.

## Output template

`<output-dir>/A1-parallel-plan.md`:

```markdown
# A1 — Multi-Worktree Parallel Plan: {ticket}

**Repo:** `{path}` | **Base:** `{branch}` | **Goal:** {one line}

## 1. Task decomposition
| Lane | ID | Scope | Outcome | Files touched |

## 2. Worktree / branch names
\`\`\`bash
git worktree add ../{repo}-lane-a -b lane/{TICKET}-a {base}
\`\`\`

## 3. Agent prompt per lane
### Lane A — {name}
\`\`\`
Scope: ...
Do NOT touch: ...
Verify: ...
\`\`\`

## 4. Shared constraints
- ...

## 5. Merge order
1. Lane X → Lane Y → reconcile branch

## 6. Conflict / risk plan
| Risk | Mitigation |

## 7. Verification plan
| When | Command | Expected |

## Agent suggested vs manually verified
| Item | Agent | Manual |
```

## Rules

- **Never** assign two lanes the same file unless merge order is explicit.
- Prefer **2 lanes** for first A2 execution (assignment minimum).
- Out-of-scope list per lane prevents agent scope creep.

## Reference

`PM4-6558-assignment/evidence/A/A1-parallel-plan.md` (PM4-6500 retrospective).
