---
name: performance-profile-fix
description: >-
  A6 performance profiling — baseline numbers, find bottleneck, minimal targeted
  fix, after measurement, behavior unchanged. Use on any script, service, or
  worker with measurable slowness.
---

# Performance profile and fix (A6)

Find a **real bottleneck**, fix it **minimally**, prove improvement with numbers.

## Procedure

1. **Baseline** — define workload, run benchmark, record wall time + method (script, hyperfine, pytest-benchmark, etc.).
2. **Profile** — explain approach: timing logs, Node `--prof`, Rust flamegraph, repeated spawn count, SQL EXPLAIN.
3. **Bottleneck** — one paragraph: what dominates time and why.
4. **Targeted fix** — small diff; no broad rewrite.
5. **After measurement** — same workload, same method, compare numbers (include % or × speedup).
6. **Behavior check** — tests still pass; semantics unchanged.

## Output template

`<output-dir>/A6-performance.md`:

```markdown
# A6 — Performance: {target}

**Target:** `{path}` | **Date:** {date}

## 1. Problem statement
{What is slow and why it matters}

## 2. Baseline measurement
| Workload | Method | Wall time | Per-unit |
\`\`\`bash
{benchmark command}
\`\`\`

## 3. Profiling approach
| Step | Tool | Finding |

## 4. Bottleneck
{Plain language explanation}

## 5. Targeted code change
{Minimal diff summary}

## 6. After measurement
| Workload | Before | After | Speedup |

## 7. Tests / behavior unchanged
\`\`\`bash
{test command}
\`\`\`

## Agent suggested vs manually verified
| Item | Agent | Manual |
```

## Common patterns

| Smell | Often fix |
|-------|-----------|
| `spawnSync` / exec per item | Batch stdin, persistent process, pool |
| N+1 queries | Batch fetch, join |
| Sync I/O in hot loop | Async or buffer |
| Rebuild Spring context per test | Shared test instance (careful) |

## Rules

- Numbers must be **reproducible** — include exact command and environment note.
- If improvement is within noise, say so honestly.
- Do not claim speedup without re-running benchmark yourself.

## Reference

`PM4-6558-assignment/evidence/A/A6-performance.md` (batch Rust scoring ~50×).
