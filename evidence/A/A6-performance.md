# A6 — Performance Profiling and Targeted Improvement

**Ticket:** PM4-6558 (assignment)  
**Target:** `artifacts/A3-fraud-score` Node worker + Rust engine  
**Date:** 2026-06-17

---

## 1. Problem statement

The A3 polyglot worker scores pending transactions by calling the Rust CLI via `spawnSync` **once per transaction**. Process startup dominates wall time when the pending queue grows.

---

## 2. Baseline measurement

**Method:** Custom benchmark script — `benchmark/bench-scoring.mjs`  
**Hardware:** Local macOS (Node v26, Rust debug build)  
**Workload:** Synthetic pending transactions (mixed amounts/merchants)

```bash
cd PM4-6558-assignment/artifacts/A3-fraud-score
cargo build --quiet --manifest-path engine/Cargo.toml
BENCH_COUNT=50  node benchmark/bench-scoring.mjs --mode=per-tx
BENCH_COUNT=100 node benchmark/bench-scoring.mjs --mode=per-tx
```

| Transactions | Mode | Wall time | Per transaction |
|-------------|------|-----------|-----------------|
| 50 | per-tx (`spawnSync` loop) | **25,916 ms** | ~518 ms |
| 100 | per-tx (`spawnSync` loop) | **50,862 ms** | ~509 ms |

**Observation:** Time scales **linearly** with transaction count (~500 ms/tx) — classic subprocess-per-item overhead, not scoring CPU.

---

## 3. Profiling approach

| Step | Tool / method | Finding |
|------|---------------|---------|
| Code read | `worker/src/worker.js` | `processPendingOnce` looped `scoreWithRustEngine` → one `spawnSync` per tx |
| Timing benchmark | `benchmark/bench-scoring.mjs` | ~500 ms/tx regardless of amount complexity |
| Sanity check | Single `scoreWithRustEngine` in tests | ~1.4 s includes `cargo build` on cold start; warm spawn still ~500 ms |

**Bottleneck:** **Process spawn + JSON IPC per transaction**, not Rust scoring logic (which runs in microseconds).

---

## 4. Targeted fix (minimal, no rewrite)

**Strategy:** Batch all pending transactions into **one** stdin payload (JSON array) and **one** subprocess call. Keep single-object CLI input for backward compatibility.

### Changes

| File | Change |
|------|--------|
| `engine/src/lib.rs` | Add `score_transactions(&[ScoreRequest])` |
| `engine/src/main.rs` | Accept JSON object **or** array on stdin |
| `worker/src/worker.js` | Add `scoreBatchWithRustEngine`; use in `processPendingOnce` |
| `benchmark/bench-scoring.mjs` | Reproducible before/after harness |
| Tests | Rust batch parity test; Node batch vs single deepEqual |

**Not changed:** FastAPI service, scoring rules, single-tx API (`scoreWithRustEngine` still works).

---

## 5. After measurement

```bash
BENCH_COUNT=50  node benchmark/bench-scoring.mjs --mode=batch
BENCH_COUNT=100 node benchmark/bench-scoring.mjs --mode=batch
```

| Transactions | Mode | Wall time | Per transaction | vs baseline |
|-------------|------|-----------|-----------------|-------------|
| 50 | batch (1 subprocess) | **512 ms** | ~10 ms | **~50× faster** (98% reduction) |
| 100 | batch (1 subprocess) | **501 ms** | ~5 ms | **~101× faster** (99% reduction) |

Batch time stays **flat** as N grows — confirms spawn was the bottleneck.

---

## 6. Behavior verification (unchanged semantics)

```bash
cd engine && cargo test -q          # 4 passed (incl. batch parity)
cd worker && npm test               # 3 passed (batch deepEqual vs single)
cd service && .venv/bin/pytest -q   # 3 passed
```

Node test `batch scoring matches single scoring` asserts identical JSON for each transaction before vs after optimization.

---

## 7. Rollback

Revert `processPendingOnce` to per-transaction loop and remove array handling in `engine/src/main.rs`. Single-tx path unchanged so rollback is isolated to worker batch call + engine array branch.

---

## 8. Assignment checklist (A6)

| Requirement | Done |
|-------------|------|
| Baseline measurement with method and numbers | ✅ §2 |
| Profiling approach + profile findings | ✅ §3 |
| Bottleneck explanation | ✅ §3 |
| Small targeted code change | ✅ §4 |
| After measurement showing improvement | ✅ §5 |
| Tests proving behavior unchanged | ✅ §6 |

**Note:** Like A4, changes kept **local** (no push/MR required for assignment proof).
