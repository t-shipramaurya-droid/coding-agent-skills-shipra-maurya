# A2 — Execute Two Parallel Worktrees

**Ticket:** PM4-6558 (assignment) · **Base work:** PM4-6500 IT branch  
**Repo:** `eq-order-hold-consumer`  
**Reconcile branch:** `assignment/PM4-6558-A2`

---

## 1. Commands used to create worktrees

Base commit: `8f302bd` on `tests/PM4-6500-integration-test-cases`

```bash
cd eq-order-hold-consumer

git worktree add ../eq-order-hold-consumer-wt-a2-docs \
  -b lane/PM4-6558-A2-it-docs

git worktree add ../eq-order-hold-consumer-wt-a2-hold \
  -b lane/PM4-6558-A2-hold-it

git worktree list
```

**Output:**

```text
.../eq-order-hold-consumer             8f302bd [tests/PM4-6500-integration-test-cases]
.../eq-order-hold-consumer-wt-a2-docs  8f302bd [lane/PM4-6558-A2-it-docs]
.../eq-order-hold-consumer-wt-a2-hold  8f302bd [lane/PM4-6558-A2-hold-it]
```

---

## 2. Branch / worktree names

| Lane | Worktree path | Branch | Agent focus |
|------|---------------|--------|-------------|
| **A** | `eq-order-hold-consumer-wt-a2-docs` | `lane/PM4-6558-A2-it-docs` | Documentation only |
| **B** | `eq-order-hold-consumer-wt-a2-hold` | `lane/PM4-6558-A2-hold-it` | New integration test |

**Design choice:** Lanes touch **disjoint files** (docs vs test Java) to avoid merge conflicts — per A1 retrospective merge order.

---

## 3. Separate outputs per lane

### Lane A — `4c44ae0`

**Commit:** `PM4-6558 A2 lane A: add integration test runbook`

| File | Change |
|------|--------|
| `docs/guides/integration-tests.md` | +48 lines — local `./gradlew test` / `integrationTest`, Bitbucket IT step, reports |

### Lane B — `9c24773`

**Commit:** `PM4-6558 A2 lane B: add HoldOrdersJdbcIntegrationTest`

| File | Change |
|------|--------|
| `src/test/java/com/paytmmoney/integration/repository/HoldOrdersJdbcIntegrationTest.java` | +45 lines — insert/read `HOLD_ORDERS` via Testcontainers MySQL |

---

## 4. Final merge / reconcile steps

```bash
cd eq-order-hold-consumer
git checkout -b assignment/PM4-6558-A2

git merge lane/PM4-6558-A2-it-docs -m "Merge lane A: integration test runbook"
# Fast-forward — no conflicts

git merge lane/PM4-6558-A2-hold-it -m "Merge lane B: HoldOrdersJdbcIntegrationTest"
# Merge made by 'ort' strategy — no conflicts
```

**Reconcile commit:** `2143ec3`

---

## 5. Test results

```bash
sdk use java 21.0.2-amzn
sdk use gradle 8.10.2
cd eq-order-hold-consumer
gradle test compileTestJava --no-daemon
```

**Result:** `BUILD SUCCESSFUL` — unit tests pass; new IT class compiles.

**Integration test (requires Docker):**

```bash
./gradlew integrationTest
# 7 tests → 7 with new HoldOrdersJdbcIntegrationTest when Docker available
```

---

## 6. Conflict notes

| Merge | Conflicts | Notes |
|-------|-----------|-------|
| Lane A → reconcile | **None** | Fast-forward; docs-only |
| Lane B → reconcile | **None** | Orthogonal path (`docs/` vs `src/test/.../repository/`) |

**Why no conflicts:** A1 plan intentionally separated doc lane from test lane. If both lanes had edited `build.gradle`, conflicts would be likely.

---

## 7. Cleanup (optional)

```bash
git worktree remove ../eq-order-hold-consumer-wt-a2-docs
git worktree remove ../eq-order-hold-consumer-wt-a2-hold
```

---

## 8. Agent suggested vs manually verified

| Item | Agent | Manual |
|------|-------|--------|
| Worktrees from PM4-6500 base | Created 2 branches at `8f302bd` | ✅ `git worktree list` |
| Disjoint file lanes | Docs vs test Java | ✅ No merge conflicts |
| `gradle test` after merge | BUILD SUCCESSFUL | ✅ Run locally |
| `./gradlew` SSL issue | Use system `gradle` locally | ✅ Known env limitation |

---

## 9. Assignment checklist (A2)

| Requirement | Done |
|-------------|------|
| Commands to create worktrees | ✅ §1 |
| Branch / worktree names | ✅ §2 |
| Separate lane outputs | ✅ §3 |
| Merge / reconcile steps | ✅ §4 |
| Test result | ✅ §5 |
| Conflict notes | ✅ §6 — zero conflicts |

**Next:** A3 (polyglot mini-system) or A5 (review PM4-6500 PR).
