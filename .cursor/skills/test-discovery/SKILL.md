---
name: test-discovery
description: >-
  B3 test discovery for any service — find framework, config, test files, exact
  run commands, and execute tests. Use when user asks how to run tests, test
  framework identification, or B3 on a new repo.
---

# Test discovery (B3)

Find **framework, config, files, commands** — then **run** the default test command and capture output.

## Procedure

1. **Detect framework** from build files:

   | Signal | Likely framework |
   |--------|------------------|
   | `build.gradle` + `useJUnitPlatform` | JUnit 5 |
   | `pom.xml` + `surefire` | JUnit |
   | `package.json` + `jest` | Jest |
   | `vitest.config` | Vitest |
   | `pytest.ini`, `pyproject.toml [tool.pytest]` | pytest |
   | `Cargo.toml` | `cargo test` |
   | `go test` | Go testing |

2. Glob test dirs: `src/test`, `**/*Test.java`, `**/*.test.ts`, `tests/`, `__tests__/`.
3. Find coverage/lint config (JaCoCo, istanbul, etc.).
4. Read README/Makefile for canonical commands.
5. **Run** the primary unit-test command (not integration unless user asks).
6. Record pass/fail, prerequisites (Java version, Redis, Docker), and interpretation of failures.

## Output template

`<output-dir>/B3-test-discovery.md`:

```markdown
# B3 — Test Discovery: {service-name}

## Test framework and config
| Item | Value |

## Test file inventory ({N} classes/files)
| Area | Test files |

## Exact commands
\`\`\`bash
# copy-paste commands
\`\`\`

## Prerequisites
- ...

## Command result
\`\`\`
(paste actual output — BUILD SUCCESSFUL / N passed / failure excerpt)
\`\`\`

## Agent suggested vs manually verified
| Item | Agent | Manual |
|------|-------|--------|
| Test command | inferred from build file | ✅ executed: `{command}` |
| Result | — | ✅ / ❌ with output above |
```

## Rules

- **Never** claim tests pass without running the command.
- If run fails (SSL, missing creds, no Docker): document honestly + workaround tried.
- Integration tests: note tag/profile and whether skipped locally.

## Reference

Example: `PM4-6558-assignment/B3-test-discovery.md`.
