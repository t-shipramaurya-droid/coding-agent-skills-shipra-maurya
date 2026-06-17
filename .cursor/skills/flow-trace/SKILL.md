---
name: flow-trace
description: >-
  I2 end-to-end flow trace — one endpoint, event, or cron from entry to DB/API/
  queue side effects with sequence diagram. Use for flow tracing, debugging path
  mapping, or I2 on any service.
---

# End-to-end flow trace (I2)

Trace **one entry point** through every major file/function to final side effects.

## Procedure

1. User provides entry point (or pick the main business endpoint from B2):
   - HTTP: `GET /api/v1/foo`
   - Event: Kafka topic + consumer class
   - Cron: `@Scheduled` or job name
2. Start at controller/handler/listener; follow calls into services, repos, clients.
3. Record **external dependencies** (DB, Redis, Kafka, HTTP clients).
4. Note **read vs write** side effects.
5. Build step table: **Step | File | Function | Action**
6. Add Mermaid **sequenceDiagram**.
7. List **known uncertainties** (dynamic routing, reflection, AOP).

## Output template

`<output-dir>/I2-end-to-end-flow.md`:

```markdown
# I2 — End-to-End Flow Trace: {entry-point}

## Entry point
`{METHOD} {path}` or `{Topic} → {ConsumerClass}`

## Step-by-step path
| Step | File | Function | Action |

## External dependencies
| System | When used |

## DB / cache / queue side effects
- ...

## Sequence diagram
\`\`\`mermaid
sequenceDiagram
  participant Client
  participant Controller
  participant Service
  participant DB
  Client->>Controller: request
  Controller->>Service: ...
\`\`\`

## Known uncertainty
- ...

## Agent suggested vs manually verified
| Item | Agent | Manual |
|------|-------|--------|
| Call chain | static read | ✅ traced N hops, spot-checked imports |
```

## Reference

Example: `PM4-6558-assignment/I2-end-to-end-flow.md`.
