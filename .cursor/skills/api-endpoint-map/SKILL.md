---
name: api-endpoint-map
description: >-
  B2 API endpoint map for any service — HTTP routes to handlers/controllers,
  auth, query params, errors. Use for API mapping, route inventory, OpenAPI
  cross-check, or B2 on an unfamiliar repo.
---

# API endpoint map (B2)

Map **every externally exposed route** to its handler. Prefer OpenAPI/Swagger if present; otherwise read annotations or route definitions.

## Procedure

1. Check `docs/openapi.yml`, `swagger.json`, `api.yaml`, or framework swagger plugin output.
2. Grep/read route sources:
   - Spring: `@GetMapping`, `@PostMapping`, `@RequestMapping`
   - Express/Fastify: `router.get`, `app.post`
   - FastAPI: `@app.get`, `@router.post`
   - Actix/Axum: macro routes
3. Build table: **Method | Full path | Handler | Auth | Notes**
4. Include health/actuator/management ports if documented.
5. Document query/body params and standard response/error envelope.
6. List **source files** used.

## Output template

`<output-dir>/B2-api-endpoint-map.md`:

```markdown
# B2 — API Endpoint Map: {service-name}

**Context path:** `{prefix}` | **OpenAPI:** `{path or "none in repo"}`

## Exposed HTTP endpoints
| Method | Full path | Controller / handler | Auth |
|--------|-----------|----------------------|------|

## Query / body parameters
| Param | Required | Description |

## Error responses
| Status | Trigger | Handler |

## Source files
- ...

## Agent suggested vs manually verified
| Item | Agent | Manual |
|------|-------|--------|
| Route count | annotation scan | ✅ matched OpenAPI / spot-checked |
```

## Verification

Cross-check route count against OpenAPI or one live `curl`/`httpie` if service runs locally.

## Reference

Example: `PM4-6558-assignment/B2-api-endpoint-map.md`.
