# Cursor rules (optional)

Two rule snippets used during PM4-6558. Copy into a project’s `.cursor/rules/` to activate in Cursor.

| Rule file | Scope | Purpose |
|-----------|-------|---------|
| [`agent-verification.mdc`](agent-verification.mdc) | Always apply | Agent vs manual verification, minimal diffs |
| [`java-spring-safe-change.mdc`](java-spring-safe-change.mdc) | `**/*.{java,gradle}` | Safe edits on Spring Boot FO services |

## Install in a repo

```bash
mkdir -p .cursor/rules
cp docs/cursor-rules/*.mdc .cursor/rules/
```

Cursor picks them up automatically on next chat in that workspace.
