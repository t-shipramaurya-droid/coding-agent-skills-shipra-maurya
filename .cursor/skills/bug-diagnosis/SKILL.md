---
name: bug-diagnosis
description: >-
  I6 bug diagnosis — reproduce failure, root cause with file paths, minimal fix,
  verification, agent vs manual. Use when debugging a failing test, seeded bug,
  or production issue on any imported service.
---

# Bug diagnosis (I6)

**Reproduce → root cause → minimal fix → verify.** Works on any stack.

## Procedure

1. **Reproduce** — failing test, curl, or user steps; capture exact error/output.
2. **Narrow** — stack trace, git bisect hint, or last changed file; read root function.
3. **Root cause** — file, function, lines; explain *why* wrong not just *what* wrong.
4. **Minimal fix** — smallest change; avoid unrelated edits.
5. **Verify** — run same repro + related test suite; paste output.
6. **Agent vs manual** — table.

## Output template

`<output-dir>/I6-bug-diagnosis.md`:

```markdown
# I6 — Bug Diagnosis: {symptom}

**Repo:** `{name}` | **Area:** {module/endpoint}

## 1. Reproduction steps
\`\`\`bash
{commands}
\`\`\`
**Actual failure:**
\`\`\`
{error excerpt}
\`\`\`

## 2. Root cause
| Item | Detail |
|------|--------|
| File | `{path}` |
| Function | `{name}` |
| Lines | {range} |

{Explain the logic error in plain language}

## 3. Minimal fix
{snippet or diff summary}

## 4. Verification
\`\`\`bash
{command}
\`\`\`
**Result:** {N passed / BUILD SUCCESSFUL}

## 5. Risk assessment
| Risk | Level | Notes |

## Agent suggested vs manually verified
| Item | Agent | Manual |
```

## Tips by stack

| Stack | First checks |
|-------|--------------|
| Python | pytest node id, traceback bottom frame |
| Java | surefire report, failing `@Test` method |
| Node | jest/vitest output, `--verbose` |
| Spring Kafka | header/listener utils, consumer retry paths |

## Reference

Example: `PM4-6558-assignment/evidence/I/I6-bug-diagnosis.md`.
