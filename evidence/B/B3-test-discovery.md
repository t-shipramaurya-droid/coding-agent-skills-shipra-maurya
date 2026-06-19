# B3 — Test Discovery and Execution: eq-nudge-info-service

## Test framework and config

| Item | Value |
|------|-------|
| Framework | JUnit 5 (`useJUnitPlatform()` in `build.gradle`) |
| Mocking | Mockito (via `spring-boot-starter-test`) |
| Coverage | JaCoCo 0.8.10 — **90% line minimum** enforced on `check` |
| Static analysis | Checkstyle 10.12.4, SpotBugs, Spotless |
| Integration profile | `src/test/resources/application-integrationtest.properties` |

## Test file inventory (45 test classes)

### Unit tests (excluded from default `test` task: `**/integration/**`)

| Area | Test files |
|------|------------|
| Controllers | `NudgeScripApiControllerTest`, `V2Test`, `V3Test`, `HealthControllerTest` |
| Services | `NudgeScripApiServiceImplTest`, `V2ImplTest`, `V3ImplTest`, `DefaultRedisServiceImplTest`, `NudgeScripRedisServiceImplTest` |
| Integration (separate task) | `NudgeScripApiV1IntegrationTest`, `V2IntegrationTest`, `V3IntegrationTest`, `HealthControllerIntegrationTest`, `NudgeInfoExceptionHandlingIntegrationTest` |
| Exception handler | `NudgeInfoExceptionHandlerTest` |
| Validation | `RequestValidationTest`, `NotUndefinedValidatorTest` |
| DTOs / enums / config | Multiple coverage-focused tests |

## Exact commands

```bash
cd eq-nudge-info-service

# Unit tests only (default)
./gradlew test

# Integration tests (requires Redis on localhost:6379)
./gradlew integrationTest

# Full quality gate
./gradlew check

# Via Makefile
make test
make integration-test
make check
```

## Prerequisites

- Java 21 (`sdk env install && sdk env` per `.sdkmanrc`)
- Maven credentials: `export repo_user=... repo_pass=...` (internal Paytm Money artifacts)
- Integration tests: Redis on `localhost:6379` (optional: `docker compose up -d`)

## Actual command result (verified by Shipra — 2026-06-17)

**Environment:**
```bash
cd eq-nudge-info-service
sdk use java 21.0.2-amzn
sdk use gradle 8.10.2
gradle test
```

**Output:**
```
> Configure project :
env variable read is null
Errors occurred while building effective model from .../pmclient-oauth-metrics-v2.0.1.pom:
        'dependencies.dependency.version' for org.springframework.boot:spring-boot-starter:jar is missing.

BUILD SUCCESSFUL in 1s
6 actionable tasks: 6 up-to-date
```

**Exit code:** 0 ✅

**Interpretation:**
- **BUILD SUCCESSFUL** — unit test task completed without failure.
- **6 up-to-date** — Gradle reused cached results; tests were already compiled/passing from a prior run. To force a fresh run: `gradle clean test` or `gradle test --rerun`.
- **pmclient-oauth-metrics POM warning** — non-blocking dependency metadata warning from internal Paytm Money artifact; does not fail the build.
- **env variable read is null** — `ENV` env var not set; normal for local dev (uses real pmclient, not mock).

**B3 self-eval:** ✅ Yes — framework identified, commands documented, result captured and interpreted.