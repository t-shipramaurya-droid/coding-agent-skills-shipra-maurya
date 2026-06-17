# D3 — CI Pipeline

GitHub Actions workflow for **I4 convert service**: lint → test → Docker image build.

## Workflow

**File:** `.github/workflows/convert-service-ci.yml`

| Job | Steps |
|-----|--------|
| `lint-and-test` | Matrix Python **3.11 + 3.12**, pip cache, `ruff check`, `pytest` |
| `client-test` | Node 20, npm cache, `npm test` |
| `docker-build` | Buildx + GHA cache, tag `:latest` and `:${{ github.sha }}`, smoke `/health` |

## Install at repo root (for real GitHub runs)

```bash
./scripts/install-workflow.sh /path/to/your/repo
git add .github/workflows/convert-service-ci.yml
git commit -m "Add convert service CI"
git push
```

## Local simulation (no Docker)

```bash
chmod +x scripts/*.sh
./scripts/run-ci-local.sh
```

## Failure mode demo

```bash
./scripts/demo-failure.sh
# Output: artifacts/failure-demo.log
```

Injects `test_intentional_fail.py`, pytest fails, file removed after demo.

## act (optional)

If [nektos/act](https://github.com/nektos/act) is installed:

```bash
act push -W .github/workflows/convert-service-ci.yml -j lint-and-test
```

Requires Docker.

## Cache / matrix

- **pip cache** via `actions/setup-python` + `cache-dependency-path`
- **npm cache** via `actions/setup-node`
- **Docker layer cache** via `cache-from/to: type=gha`
- **Matrix:** Python 3.11 and 3.12
