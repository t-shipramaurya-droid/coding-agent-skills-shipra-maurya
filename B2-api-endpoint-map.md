# B2 — API Endpoint Map: eq-nudge-info-service

**Context path:** `/nudge-info` | **OpenAPI:** `docs/openapi.yml`

## Exposed HTTP endpoints

| Method | Full path | Controller | Handler | Auth |
|--------|-----------|------------|---------|------|
| GET | `/nudge-info/health` | `HealthController` | `health()` | None |
| GET | `/nudge-info/api/v1/scrip` | `NudgeScripApiController` | `getNudgeInfoForScrip()` | pmclient OAuth |
| GET | `/nudge-info/api/v2/scrip` | `NudgeScripApiControllerV2` | `getNudgeInfoForScrip()` | pmclient OAuth |
| GET | `/nudge-info/api/v3/scrip` | `NudgeScripApiControllerV3` | `getNudgeInfoForScrip()` | pmclient OAuth |

## Query parameters (v1/v2/v3)

| Param | Required | Description |
|-------|----------|-------------|
| `scrip_id` | Yes | Scrip identifier |
| `segment` | Yes | `E` (equity) or `D` (derivatives) |
| `exchange` | Yes | `NSE` or `BSE` |
| `isin` | Conditional | Required for segment `E`; must be empty for segment `D` (v2/v3) |

## Response envelope

```json
{
  "data": { /* NudgeDetails / V2 / V3 */ },
  "meta": { "status": "OK", "message": "..." }
}
```

## Error responses

| Status | Trigger | Handler |
|--------|---------|---------|
| 400 | Validation failure | `NudgeInfoExceptionHandler.handleValidationException` |
| 500 | Unexpected error | `NudgeInfoExceptionHandler.handleGenericException` |

## Actuator (management port 8000)

| Path | Purpose |
|------|---------|
| `/actuator/prometheus` | Prometheus metrics |

## Source files

- Constants: `src/main/java/.../constants/NudgeConstants.java`
- Controllers: `src/main/java/.../controller/*.java`
- OpenAPI spec: `docs/openapi.yml`
- Architecture: `docs/architecture.md`
