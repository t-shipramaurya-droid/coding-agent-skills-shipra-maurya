# I3 — Small Safe Change in Unfamiliar Repo

**Ticket:** PM4-6558 (Coding Agent Skills Assignment)  
**Repo:** `eq-order-hold-consumer`  
**Branch:** `assignment/PM4-6558-I3` (from `origin/stage`)  
**Time box:** ~45 min

---

## Change summary

Fixed a bug in `KafkaHeadersUtil.processRetryHeadersForFailedMsg` where retry count was **appended** as a duplicate Kafka header instead of **replaced**. `getHeaderValue()` always reads the first header, so retries never incremented past the original value — affecting failed-message republish logic in `KafkaProducerFactory` / `BaseConsumer`.

---

## Diff / branch

```bash
git checkout -b assignment/PM4-6558-I3 origin/stage
# 2 files changed — see below
```

| File | Change |
|------|--------|
| `src/main/java/com/paytmmoney/utils/KafkaHeadersUtil.java` | Use `setHeaderValue()` to replace `RETRY_COUNT` instead of `headers.add()` |
| `src/test/java/com/paytmmoney/utils/KafkaHeadersUtilTest.java` | Expect `"3"` when incrementing from `"2"` (was `"2"` — documented bug) |

---

## Why these files

| File | Reason |
|------|--------|
| `KafkaHeadersUtil.java` | Entry point for retry header mutation on failed Kafka messages; used by `KafkaProducerFactory` and consumed by `BaseConsumer` retry gate |
| `KafkaHeadersUtilTest.java` | Existing unit tests already covered this method; one test explicitly noted the duplicate-header bug |

**Call chain (verified via grep):**

```
BaseConsumer (reads RETRY_COUNT via getHeaderValue)
  ← KafkaProducerFactory.publishEvent(..., processRetryHeadersForFailedMsg(...))
      ← KafkaHeadersUtil.processRetryHeadersForFailedMsg
```

---

## Test command and result

```bash
sdk use java 21.0.2-amzn
sdk use gradle 8.10.2
cd eq-order-hold-consumer
gradle test --tests com.paytmmoney.utils.KafkaHeadersUtilTest --no-daemon
```

**Result:** `BUILD SUCCESSFUL` — 7/7 tests in `KafkaHeadersUtilTest` pass.

---

## Risk assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| Retry count now actually increments | **Low (fix)** | Matches intended behavior; `BaseConsumer` max-retry check depends on correct count |
| Behavior change for messages already in retry topics with duplicate headers | **Low** | `setHeaderValue` removes all matching keys before add; `getHeaderValue` reads first only — cleaner state going forward |
| Regression in other header ops | **Very low** | Reuses existing `setHeaderValue()` already tested in same class |
| Production deploy | **N/A for assignment** | Learning branch only; not merged to stage |

---

## Agent suggested vs manually verified

| Item | Agent | Manual verification |
|------|-------|---------------------|
| Bug exists (duplicate header on increment) | Found via reading `KafkaHeadersUtilTest` comment + source | ✅ Read both files; confirmed `headers.add` leaves stale first header |
| `setHeaderValue` is safe to reuse | Suggested refactor | ✅ Read `setHeaderValue` — removes key then adds |
| `BaseConsumer` depends on this header | Grep for `RETRY_COUNT` | ✅ Traced to `BaseConsumer.java` line 78 |
| Tests pass | Ran `gradle test --tests ...` | ✅ BUILD SUCCESSFUL locally |
| Full suite pass | Not run (scope: I3 minimal) | ⏳ Run `./gradlew test` before any real PR |

---

## Code change (before → after)

**Before** — appended duplicate header; `getHeaderValue` still returned old value:

```java
headers.add(CommonConstants.RETRY_COUNT, String.valueOf(retryCount+1).getBytes(...));
```

**After** — single canonical header via existing helper:

```java
setHeaderValue(headers, CommonConstants.RETRY_COUNT, String.valueOf(nextRetryCount));
```

---

## Next exercises on the ladder

| Exercise | Status |
|----------|--------|
| I3 | ✅ This document |
| I4 — FastAPI + Node client pair | Pending |
| I5 — Dockerize and run | Pending |
