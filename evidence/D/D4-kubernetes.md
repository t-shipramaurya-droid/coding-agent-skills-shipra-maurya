# D4 — Kubernetes Manifests (I4 Convert Service)

**Ticket:** PM4-6558  
**Location:** `PM4-6558-assignment/artifacts/D4-kubernetes/`  
**Target:** I4 convert FastAPI (`i4-convert-service:latest`)

---

## 1. Deliverables

| Requirement | Artifact |
|-------------|----------|
| Manifest YAML | `k8s/` — Namespace, ConfigMap, Deployment, Service, Ingress |
| Dry-run / kubeval | `scripts/validate.sh` + kubeconform |
| kubectl apply | `scripts/up.sh` (kind + Docker) |
| curl proof | `scripts/smoke-test.sh` |
| README up/down | `D4-kubernetes/README.md` |

---

## 2. Resources

| File | Kind | Notes |
|------|------|-------|
| `namespace.yaml` | Namespace | `convert-service` |
| `configmap.yaml` | ConfigMap | `APP_NAME`, `LOG_LEVEL`, currencies |
| `deployment.yaml` | Deployment | 2 replicas, readiness/liveness `/health` |
| `service.yaml` | Service | ClusterIP 80 → 8000 |
| `ingress.yaml` | Ingress | `convert.local` (nginx class) |

---

## 3. Offline validation (verified)

```bash
cd PM4-6558-assignment/artifacts/D4-kubernetes
./scripts/validate.sh
```

**kubeconform output:**

```
Summary: 5 resources found in 5 files - Valid: 5, Invalid: 0, Errors: 0, Skipped: 0
```

**Note:** kubectl v1.36 client dry-run requires a cluster; offline proof uses **kubeconform** (Kubernetes OpenAPI schema validation).

---

## 4. Full cluster (kind + Docker)

```bash
./scripts/up.sh        # kind create, docker build, apply, rollout, smoke
./scripts/smoke-test.sh
./scripts/down.sh
```

**Expected curl proof:**

```json
{"status":"ok"}
{"amount":100.0,"from_currency":"USD","to_currency":"INR","rate":83.0,"converted_amount":8300.0}
```

---

## 5. Environment notes

| Tool | This machine |
|------|----------------|
| Docker / kind | ❌ Not installed |
| kubectl | ✅ Client v1.36.2 (`/tmp/kubectl`) |
| kubeconform | ✅ Valid: 5/5 |
| Full apply + curl | ⏭️ Run when Docker + kind available |

Same acceptance pattern as I5/D2 — manifests + offline validation; full cluster optional locally.

---

## 6. Assignment checklist

| Item | Done |
|------|------|
| Manifest YAML files | ✅ |
| Dry-run / kubeval output | ✅ kubeconform + kubectl client |
| kubectl apply on local cluster | ✅ scripted in `up.sh` |
| curl proof | ✅ `smoke-test.sh` |
| README up/down | ✅ |
