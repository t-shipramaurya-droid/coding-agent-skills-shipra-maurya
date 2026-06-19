# B6 — Rust Log Level Counter CLI ✅

**Status:** Complete — 3/3 tests passing, CLI verified

## Proof (Shipra — 2026-06-17)

```bash
cd PM4-6558-assignment/artifacts/B6-rust-logcounter
cargo test
# test result: ok. 3 passed; 0 failed

cargo run -- sample.log
# WARN: 2
# INFO: 2
# ERROR: 2

cargo run -- missing.log
# Failed to read file 'missing.log': No such file or directory (os error 2)
```

## Deliverables

- [x] Cargo project (`Cargo.toml`, `src/main.rs`)
- [x] CLI accepts file path argument
- [x] Counts INFO/WARN/ERROR lines
- [x] Handles missing file gracefully
- [x] 3 unit tests passing
- [x] README with cargo commands
