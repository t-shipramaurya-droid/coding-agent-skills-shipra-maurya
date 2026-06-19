# B1 — Repo Artifact Inventory: eq-nudge-info-service

**Ticket:** PM4-6558 | **Repo:** `eq-nudge-info-service` | **Time target:** 30 min

## Module layout

| Item | Value |
|------|-------|
| Type | Single-module Gradle project |
| Build file | `build.gradle` |
| Java | 21 (Spring Boot 3.3.4) |
| Context path | `/nudge-info` |

## Controllers (4)

| Class | Path | Purpose |
|-------|------|---------|
| `NudgeScripApiController` | `controller/NudgeScripApiController.java` | v1 nudge scrip API |
| `NudgeScripApiControllerV2` | `controller/NudgeScripApiControllerV2.java` | v2 nudge scrip API |
| `NudgeScripApiControllerV3` | `controller/NudgeScripApiControllerV3.java` | v3 nudge scrip API |
| `HealthController` | `controller/HealthController.java` | Health check |

## Services (7 interfaces + 5 impls)

| Class | Path | Purpose |
|-------|------|---------|
| `NudgeScripApiService` / `NudgeScripApiServiceImpl` | `service/` | v1 business logic |
| `NudgeScripApiServiceV2` / `NudgeScripApiServiceV2Impl` | `service/impl/` | v2 business logic |
| `NudgeScripApiServiceV3` / `NudgeScripApiServiceV3Impl` | `service/impl/` | v3 business logic |
| `RedisService` / `DefaultRedisServiceImpl` | `service/` | Redis cache access |
| `NudgeScripRedisServiceImpl` | `service/impl/` | Nudge-specific Redis ops |

## Repositories (1)

| Class | Path | Purpose |
|-------|------|---------|
| `SecurityMasterRepository` | `repositories/oms/SecurityMasterRepository.java` | OMS MySQL native queries for ISIN/instrument lookup |

## Entities / Models (2)

| Class | Table | Purpose |
|-------|-------|---------|
| `SecurityMaster` | `SECURITY_MASTER` | JPA entity for OMS security master |
| `SecurityMasterId` | (embedded PK) | Composite key: exchange + segment + scrip code |

## DTOs (request + response)

| Class | Path |
|-------|------|
| `NudgeScripInfoParamData` | `dto/request/` |
| `NudgeScripInfoParamDataV2` | `dto/request/` |
| `NudgeDetails`, `NudgeDetailsV2`, `NudgeDetailsV3` | `dto/response/` |
| `ResponseDto`, `Meta` | `dto/response/` |
| `SecurityMasterResult`, `ScripIdentifiersDto` | `dto/` |

## Config (4)

| Class | Purpose |
|-------|---------|
| `JpaConfig` | Primary OMS datasource + JPA |
| `FoEntityConfig` | FO entity manager config |
| `RedisConfig` | Redis connection |
| `ComponentScanConfig` | Component scan |

## Validators / Validation

| Class | Purpose |
|-------|---------|
| `RequestValidation` | Bean validation orchestration |
| `NotUndefinedValidator`, `EnumValidator` | Custom validators |

## Exceptions + Handler

| Class | Purpose |
|-------|---------|
| `ValidationException`, `GenericException` | Domain exceptions |
| `NudgeInfoExceptionHandler` | `@ControllerAdvice` — 400/500 JSON responses |

## Utilities / Converters / Mappers

| Class | Purpose |
|-------|---------|
| `NudgeRedisUtil` | Redis key generation |
| `NudgeRequestMapper` | Request param mapping |
| `TupleToSecurityMasterResultConverter` | JPA Tuple → DTO |

## Enums / Constants

| Class | Purpose |
|-------|---------|
| `ExchangeEnum`, `SegmentEnum`, `ScripTypes` | Domain enums |
| `NudgeConstants` | API paths, Redis key prefixes, JSON field names |

## Application entry

| Class | Path |
|-------|------|
| `EqNudgeInfoServiceApplication` | Root Spring Boot app |

## External dependencies (not in-repo)

- **Redis** — nudge cache (ASM/GSM, surveillance, T1, ban flags)
- **MySQL OMS** — `SECURITY_MASTER` table (DBA-owned, no Flyway in repo)
- **pmclient** — OAuth auth filter for public APIs
