# A4 — Repository Modernization Plan

**Ticket:** PM4-6558 (assignment)  
**Repo:** `eq-order-hold-consumer`  
**Branch (first step):** `assignment/PM4-6558-A4`  
**Analysis date:** 2026-06-17

---

## 1. Findings (evidence from repo)

| # | Area | Finding | Evidence | Severity |
|---|------|---------|----------|----------|
| F1 | Dependencies | **Deprecated MySQL driver** — `mysql:mysql-connector-java:8.0.28` renamed/retired; Spring Boot 3 docs recommend `com.mysql:mysql-connector-j` | `build.gradle:88` | **High** |
| F2 | Dependencies | **Spring Boot 2.x Redis starter on Boot 3.3 app** — `spring-boot-starter-data-redis:2.1.0.RELEASE` pinned manually | `build.gradle:118` | **High** |
| F3 | Dependencies | **Stale spring-kafka** — explicit `2.7.1` while Boot 3.3.4 BOM manages 3.x | `build.gradle:82` | **High** |
| F4 | Build | **Duplicate `group` / `version` and redundant `apply plugin`** blocks | `build.gradle:44-49` | Medium |
| F5 | Build | **Per-starter version `:3.3.4` pins** — redundant when `io.spring.dependency-management` + Boot plugin present | `build.gradle:76-80` | Medium |
| F6 | CI/CD | **Gradle wrapper was gitignored** — Bitbucket failed until wrapper committed (PM4-6500) | `.gitignore`, pipeline #18 | Medium (fixed on PM4-6500 branch) |
| F7 | Tooling | **SonarQube plugin 2.6** — predates Gradle 8 / Java 21 toolchain | `build.gradle:18` | Medium |
| F8 | Docs | **Default GitLab README template** — no run/test/IT instructions for developers | `README.md` | Low |
| F9 | Testing | **Integration tests added (PM4-6500)** — good; Phase 2 AMO/pump ITs still open | `src/test/java/com/paytmmoney/integration/` | Info |
| F10 | Security | **Hardcoded Maven credentials in build.gradle** — pre-existing; should move to env/gradle.properties | `build.gradle:57-59` | High (out of A4 scope — needs infra ticket) |

---

## 2. Prioritised modernization plan

| Priority | Item | Value | Risk | Effort |
|----------|------|-------|------|--------|
| **P1** ✅ | F1 — Migrate to `com.mysql:mysql-connector-j` (Boot BOM) | Security + SB3 alignment | **Low** | 15 min |
| P2 | F2 — Upgrade Redis starter to Boot 3 managed `spring-boot-starter-data-redis` | Runtime stability | Medium | 2–4 h + QA |
| P3 | F3 — Remove spring-kafka version pin; use Boot BOM | Kafka compatibility | Medium | 2–4 h + QA |
| P4 | F4/F5 — build.gradle hygiene (dedupe plugins/versions) | Maintainability | Low | 1 h |
| P5 | F7 — Upgrade SonarQube Gradle plugin | CI quality gate | Medium | 2 h |
| P6 | F8 — Replace README with runbook (link `docs/guides/integration-tests.md`) | DevEx | Low | 1 h |
| P7 | F9 — Phase 2 integration tests (AMO pump flow) | Coverage | Low | 1–2 days |
| — | F10 — Externalize Maven credentials | Security | High (process) | Infra ticket |

---

## 3. First step implemented (P1)

### Change

```diff
- implementation 'mysql:mysql-connector-java:8.0.28'
+ runtimeOnly 'com.mysql:mysql-connector-j'
```

**Why this step first:**

- Official Spring Boot 3 migration path for MySQL
- Version managed by Boot BOM (no manual pin)
- `runtimeOnly` — driver not needed at compile time
- No application code changes
- Low blast radius; easy rollback

**Commit branch:** `assignment/PM4-6558-A4`

---

## 4. Verification

```bash
sdk use java 21.0.2-amzn
sdk use gradle 8.10.2
cd eq-order-hold-consumer
gradle test --no-daemon
```

**Result:** `BUILD SUCCESSFUL` — all unit tests pass after driver migration.

**Optional:**

```bash
./gradlew dependencies --configuration runtimeClasspath | grep mysql
# expect com.mysql:mysql-connector-j (Boot-managed version)
```

---

## 5. Rollback notes

```bash
git checkout assignment/PM4-6558-A4~1 -- build.gradle
# or revert commit:
# implementation 'mysql:mysql-connector-java:8.0.28'
gradle test
```

No database schema or API changes — rollback is a one-line dependency revert.

---

## 6. Agent suggested vs manually verified

| Item | Agent | Manual |
|------|-------|--------|
| mysql-connector-java deprecated | Spring Boot 3 docs / build.gradle read | ✅ |
| First step low risk | Chose runtime driver swap only | ✅ |
| Tests pass | `gradle test` | ✅ BUILD SUCCESSFUL |
| Redis/Kafka upgrades deferred | Higher regression risk | ✅ Documented as P2/P3 |

---

## 7. Assignment checklist (A4)

| Requirement | Done |
|-------------|------|
| Findings with evidence | ✅ §1 |
| Prioritised plan | ✅ §2 |
| First step implemented | ✅ §3 — `build.gradle` |
| Verification | ✅ §4 |
| Rollback notes | ✅ §5 |

**Next recommended repo step:** P2 — align Redis starter to Spring Boot 3.3 BOM (separate PR with QA).
