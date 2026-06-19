# Runnable artifacts

Code, infra, and scripts built for PM4-6558. **Write-ups and proof narrative** live in [`../evidence/`](../evidence/).

| Folder | Exercise | Quick verify |
|--------|----------|--------------|
| [B4-fastapi](B4-fastapi/) | B4 | `cd B4-fastapi && pytest -v` |
| [B5-nodejs](B5-nodejs/) | B5 | `npm test` |
| [B6-rust-logcounter](B6-rust-logcounter/) | B6 | `cargo test` |
| [I4-convert-pair](I4-convert-pair/) | I4, I5, I6 | `pytest` + `npm test` |
| [A3-fraud-score](A3-fraud-score/) | A3, A6 | cargo + pytest + npm |
| [D1-terraform](D1-terraform/) | D1 | `./scripts/tf-verify.sh` |
| [D2-compose-stack](D2-compose-stack/) | D2 | `./scripts/test-stack.sh` |
| [D3-ci](D3-ci/) | D3 | `./scripts/run-ci-local.sh` |
| [D4-kubernetes](D4-kubernetes/) | D4 | `./scripts/validate.sh` |
| [D6-observability](D6-observability/) | D6 | `./scripts/prove-local.sh` |

From repo root:

```bash
cd PM4-6558-assignment/artifacts/D6-observability && ./scripts/prove-local.sh
```
