---
name: parallel-worktrees-execute
description: >-
  A2 execute parallel worktrees — create 2+ worktrees, independent lane changes,
  merge/reconcile, test. Use after parallel-worktree-plan or when user asks to
  run parallel agent lanes on any git repo.
---

# Execute parallel worktrees (A2)

**Actually run** two or more parallel lanes, then reconcile cleanly.

## Prerequisites

- A1 plan exists OR user gives lane scopes inline
- Clean git state on base branch
- Disjoint file ownership per lane

## Procedure

1. **Create worktrees** — `git worktree add` + branch per lane; paste `git worktree list`.
2. **Lane work** — one agent session per worktree (or sequential simulation with commits per lane).
3. **Record outputs** — commit hash, files changed, test result per lane.
4. **Merge/reconcile** — merge lane branches into reconcile branch OR cherry-pick; document conflicts.
5. **Final test** — run verification from A1 plan on merged result.
6. **Cleanup** — optional `git worktree remove` commands.

## Output template

`<output-dir>/A2-parallel-worktrees.md`:

```markdown
# A2 — Execute Two Parallel Worktrees

**Ticket:** {KEY} | **Repo:** `{path}` | **Reconcile branch:** `{branch}`

## 1. Commands used
\`\`\`bash
cd {repo}
git worktree add ../{repo}-lane-a -b lane/{KEY}-a
git worktree add ../{repo}-lane-b -b lane/{KEY}-b
git worktree list
\`\`\`

## 2. Branch / worktree names
| Lane | Path | Branch | Focus |

## 3. Separate outputs per lane
### Lane A — {commit}
| File | Change |
**Test:** `{cmd}` → {result}

### Lane B — {commit}
...

## 4. Merge / reconcile steps
\`\`\`bash
git checkout -b {reconcile} {base}
git merge lane/{KEY}-a
git merge lane/{KEY}-b
\`\`\`

## 5. Test result (merged)
\`\`\`
{output}
\`\`\`

## 6. Conflict notes
{None or resolution}

## Agent suggested vs manually verified
| Item | Agent | Manual |
```

## Rules

- Run **real** git commands; paste actual `worktree list` and test output.
- If merge conflicts: resolve minimally; document what you kept.
- Do not force-push to shared branches unless user asks.

## Reference

`PM4-6558-assignment/evidence/A/A2-parallel-worktrees.md`.
