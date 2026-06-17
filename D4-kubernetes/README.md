# D4 — Kubernetes manifests (I4 convert service)

K8s manifests for **I4 convert FastAPI** — Deployment, Service, ConfigMap, Ingress.

## Manifests (`k8s/`)

| File | Resource |
|------|----------|
| `namespace.yaml` | `convert-service` namespace |
| `configmap.yaml` | App metadata env vars |
| `deployment.yaml` | 2 replicas, probes on `/health` |
| `service.yaml` | ClusterIP `:80` → pod `:8000` |
| `ingress.yaml` | `convert.local` → service (optional, nginx) |

**Image:** `i4-convert-service:latest` (build from `I4-convert-pair/service`)

## Validate (no cluster required)

```bash
chmod +x scripts/*.sh
./scripts/validate.sh
```

Uses `kubectl apply --dry-run=client`.

## Full local cluster (kind + Docker)

```bash
./scripts/up.sh      # kind create, build image, apply, rollout, smoke
./scripts/smoke-test.sh
./scripts/down.sh
```

### Manual curl proof

```bash
kubectl -n convert-service port-forward svc/convert-service 18000:80
curl http://127.0.0.1:18000/health
curl -X POST http://127.0.0.1:18000/convert \
  -H 'Content-Type: application/json' \
  -d '{"amount":100,"from_currency":"USD","to_currency":"INR"}'
```

## Teardown

```bash
./scripts/down.sh
```

## No Docker / no kind?

Run `./scripts/validate.sh` for client dry-run (assignment-acceptable, same as I5/D2 pattern).

Install tooling when ready:

```bash
brew install kubectl kind
brew install --cask docker
```
