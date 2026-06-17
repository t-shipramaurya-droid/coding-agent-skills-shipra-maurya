# B6 — Rust Log Level Counter CLI

Counts `INFO`, `WARN`, and `ERROR` occurrences in a log file.

## Install Rust + Cargo (one-time)

Cargo is not installed on your machine yet. Pick **one** method:

### Option A — rustup (recommended)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustc --version
cargo --version
```

### Option B — Homebrew (macOS)

```bash
brew install rust
cargo --version
```

### Option C — SDKMAN (if you use sdkman for everything)

```bash
sdk list rust          # see available versions
sdk install rust       # if listed
```

After install, **open a new terminal** or run `source "$HOME/.cargo/env"`.

## Build

```bash
cd PM4-6558-assignment/B6-rust-logcounter
cargo build
```

## Run

```bash
cargo run -- sample.log
```

Expected output:

```
INFO: 2
WARN: 2
ERROR: 2
```

## Missing file (graceful error)

```bash
cargo run -- missing.log
# Failed to read file 'missing.log': ...
```

## Test

```bash
cargo test
```

## Release build

```bash
cargo build --release
./target/release/logcounter sample.log
```
