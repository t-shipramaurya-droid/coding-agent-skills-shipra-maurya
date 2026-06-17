# A1 — Multi-Worktree Parallel Plan (Retrospective)

**Ticket:** PM4-6558 (assignment) · **Real work:** PM4-6500  
**Repo:** `eq-order-hold-consumer`  
**Base branch:** `origin/stage`  
**Delivered branch:** `tests/PM4-6500-integration-test-cases` (3 commits, 18 files)

This is a **retrospective** plan — how PM4-6500 *should have been* split across parallel agent lanes before implementation. Actual delivery was sequential on one branch; this documents the safer parallel approach.

---

## 1. Task decomposition

**Goal:** Add Testcontainers-based integration tests for `eq-order-hold-consumer` with Bitbucket CI running `./gradlew integrationTest`.

| Lane | ID | Scope | Outcome |
|------|----|--------|---------|
| **Lane 1** | `build-it` | Gradle: `@Tag("integration")`, `integrationTest` task, JaCoCo IT report, Testcontainers BOM deps | `./gradlew integrationTest` task exists; unit `test` excludes integration tag |
| **Lane 2** | `infra-it` | Shared container infra: MySQL/Redis Testcontainers, SQL seed, Spring initializer, IT profile properties | Containers start; JDBC/Redis injected into Spring context |
| **Lane 3** | `tests-it` | `@Tag("integration")` test classes: context, health, IR processor, infra smoke | 6 integration tests pass with Docker |
| **Lane 4** | `ci-it` | Bitbucket readiness: `gradlew`, `testcontainers.properties`, CI hardening (health URL, Kafka inactive window) | `pr-verify-stage` IT step passes |

**Out of scope for all lanes:** production code changes, unit test rewrites, Kafka broker Testcontainer (not required for Phase 1).

---

## 2. Worktree / branch names

All branches from `origin/stage`:

```text
lane/PM4-6500-build-it      ← Lane 1
lane/PM4-6500-infra-it      ← Lane 2
lane/PM4-6500-tests-it      ← Lane 3
lane/PM4-6500-ci-it         ← Lane 4
```

**Worktree commands (if executed for A2):**

```bash
cd eq-order-hold-consumer
git fetch origin stage

git worktree add ../eq-ohc-build  -b lane/PM4-6500-build-it origin/stage
git worktree add ../eq-ohc-infra  -b lane/PM4-6500-infra-it origin/stage
git worktree add ../eq-ohc-tests  -b lane/PM4-6500-tests-it origin/stage
git worktree add ../eq-ohc-ci     -b lane/PM4-6500-ci-it    origin/stage
```

---

## 3. Agent prompt per lane

### Lane 1 — `build-it`

```text
Repo: eq-order-hold-consumer, branch from stage.
Task: Gradle integration test wiring only.

- Add Testcontainers BOM 1.20.4 test deps (mysql, junit-jupiter)
- Register integrationTest task: includeTags 'integration', exclude from test task
- Add jacocoIntegrationTestReport → reports/tests/integrationTest-coverage/
- Do NOT add test Java classes yet — use a stub @Tag("integration") test if needed to compile
- Verify: ./gradlew test && ./gradlew integrationTest (may skip without Docker)

Constraints: do not modify src/main; do not remove existing unit tests.
```

### Lane 2 — `infra-it`

```text
Repo: eq-order-hold-consumer, branch from stage.
Task: Testcontainers infrastructure for Spring ITs.

- OrderHoldIntegrationTestContainers (MySQL 8.0.36-debian + Redis 7)
- init-it-mysql.sql (IR_USERS, HOLD_ORDERS, AMO_HOLD_ORDERS)
- OrderHoldIntegrationTestInitializer (inject JDBC + Redis + Slack props)
- application-integrationtest.properties (Kafka listeners inactive, stub URLs)
- IntegrationTestSupportConfig (@Primary mock RedisClientService)
- AbstractOrderHoldIntegrationTest base class

Constraints: assume Lane 1 merged OR add minimal integrationTest task locally.
Do not write feature IT assertions yet — infra smoke only.
```

### Lane 3 — `tests-it`

```text
Repo: eq-order-hold-consumer, branch from stage (after Lane 2 merged).
Task: Integration test cases using shared infra.

- ApplicationContextIntegrationTest
- health/HealthControllerIntegrationTest (TestRestTemplate /health)
- kafka/IrStatusProcessorIntegrationTest (MySQL: IR insert, hold order PUMP_READY)
- Refactor InfrastructureTestcontainersIT to use shared containers + @Tag("integration")

Constraints: extend AbstractOrderHoldIntegrationTest; @Tag("integration") on all ITs.
No mocks of class under test for IrStatusProcessor — real MySQL only.
```

### Lane 4 — `ci-it`

```text
Repo: eq-order-hold-consumer, branch from stage (after Lanes 1–3 merged).
Task: Bitbucket CI compatibility.

- Add gradlew + gradle/wrapper (pipeline runs chmod +x ./gradlew)
- src/test/resources/testcontainers.properties (checks.disable=true)
- Fix HealthControllerIntegrationTest path for context-path
- Set kafka.consumer.inactive.windows=00:00-23:59 in IT profile

Verify: bitbucket-pipelines.yml already imports pr-verify-stage@tmpl — no yml change unless missing.
Document: IT step runs ./gradlew integrationTest with DinD.
```

---

## 4. Shared constraints (all lanes)

| Rule | Reason |
|------|--------|
| Base branch = **`stage`** | Team convention; PM4-6500 branched from stage |
| Tag all ITs with `@Tag("integration")` | Unit `./gradlew test` must stay fast, no Docker |
| Single shared container holder | `OrderHoldIntegrationTestContainers` — one MySQL + Redis per JVM |
| `@ActiveProfiles("integrationtest")` | Isolated properties; never hit stg DB/Redis |
| `assumeTrue(dockerAvailable)` in `@BeforeAll` | Graceful skip locally without Docker |
| Do not change `src/main/java` unless unavoidable | PM4-6500 is test-only scope |
| Java 21 + Spring Boot 3.3.4 | Match existing toolchain |
| Context path `/consumerorderhold` | Health IT must use `/health` with TestRestTemplate |

---

## 5. Merge order

```text
stage
  └── merge Lane 1 (build-it)          ← first: task + tags exist
        └── merge Lane 2 (infra-it)    ← containers + profile before tests
              └── merge Lane 3 (tests-it)
                    └── merge Lane 4 (ci-it)   ← last: gradlew + CI tweaks
```

**Why this order:**

1. **Lane 1 first** — without `integrationTest` task and tag filters, other lanes cannot verify cleanly.
2. **Lane 2 before 3** — test classes depend on `AbstractOrderHoldIntegrationTest` + initializer.
3. **Lane 3 before 4** — CI fixes are meaningless until tests exist.
4. **Lane 4 last** — `gradlew` and hardening are independent but easiest to validate against full suite.

**Actual delivery (retrospective note):** All four lanes landed in 3 commits on one branch (`2bf01a4` → `425433e` → `8f302bd`), which caused sequential rework (e.g. gradlew discovered only after Bitbucket failure).

---

## 6. Conflict & risk plan

| Conflict hotspot | Lanes affected | Risk | Mitigation |
|------------------|----------------|------|------------|
| `build.gradle` | 1, 4 | **HIGH** | Lane 1 owns gradle until merged; Lane 4 only adds wrapper + minor edits |
| `InfrastructureTestcontainersIT.java` | 2, 3 | **MEDIUM** | Lane 2 creates shared infra; Lane 3 refactors IT in one commit |
| `application-integrationtest.properties` | 2, 4 | **MEDIUM** | Lane 2 creates file; Lane 4 adds Kafka window line only |
| `src/test/resources/` | 2, 3, 4 | **LOW** | Separate files per concern (sql, properties, testcontainers.properties) |
| `.gitignore` | 4 | **LOW** | Remove gradlew ignore entries — Lane 4 only |

**Rollback:** Each lane is one PR; revert lane commit if IT step fails. Lane 1 rollback disables IT task entirely.

**Known production risk:** None — test-only changes.

---

## 7. Verification plan

| After merge | Command | Expected |
|-------------|---------|----------|
| Lane 1 | `./gradlew test` | All unit tests pass; no Docker |
| Lane 1 | `./gradlew integrationTest` | 0–1 tests; skips OK without Docker |
| Lane 2 | `./gradlew integrationTest` | Infra smoke passes with Docker |
| Lane 3 | `./gradlew integrationTest` | 6 tests pass (or skip without Docker) |
| Lane 4 | `./gradlew test integrationTest` | Full local verify |
| Lane 4 | Bitbucket `pr-verify-stage` | parallel: unit ✅ quality ✅ IT ✅ |

**Evidence captured (actual branch):**

- Commits: `2bf01a4`, `425433e`, `8f302bd`
- PR: `tests/PM4-6500-integration-test-cases` → `stage` (#14)
- Files: 18 changed, +836 / −56 lines

---

## 8. What we did vs ideal parallel path

| Aspect | Actual (sequential) | Ideal (A1 plan) |
|--------|---------------------|-----------------|
| Commits | 3 on one branch | 4 lane PRs, sequential merge |
| Bitbucket gradlew failure | Found in CI | Lane 4 would add gradlew before first push |
| Time to first green CI | 2 pipeline failures | 1 failure max if Lane 4 merges before PR |
| Agent context | One long session | 4 focused sessions, smaller diffs |

---

## 9. Agent suggested vs manually verified

| Item | Agent | Manual |
|------|-------|--------|
| Lane split reduces `build.gradle` conflicts | Proposed in plan | ✅ Observed — 3 commits all touched `build.gradle` |
| pr-verify-stage needs gradlew | Initially missed | ✅ Bitbucket pipeline #18 proved it |
| Docker required on IT runner | Documented in skill | ✅ Template runs `./gradlew integrationTest` |
| Parallel infra + tests safe | Plan assumes merge order | ✅ No main-code overlap in diff stat |

---

## 10. Assignment checklist (A1)

| Requirement | Done |
|-------------|------|
| Task decomposition | ✅ §1 |
| Worktree / branch names | ✅ §2 |
| Agent prompt per lane | ✅ §3 |
| Shared constraints | ✅ §4 |
| Merge order | ✅ §5 |
| Conflict / risk plan | ✅ §6 |
| Verification plan | ✅ §7 |

**Next on ladder:** **A2** — actually execute two parallel worktrees (e.g. Phase 2 IT cases on `eq-order-hold-consumer`).
