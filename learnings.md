# Pipeline Learnings — PM4-6558

**Assignee:** Shipra Maurya  
**Last updated:** 2026-06-17  
**Evidence folder:** `PM4-6558-assignment/`  
**Self-eval:** [`00-basics-self-eval.md`](00-basics-self-eval.md) + Google Doc yes/no table (OCL / PML version)

---

## What worked well

1. **Jira MCP integration** — Reading PM4-6558, posting progress comments, and tagging worked smoothly.
2. **Repo discovery on eq-nudge-info-service** — Agent produced B1/B2/I1/I2 artifacts in ~15 min from an unfamiliar repo.
3. **Existing docs** — `docs/architecture.md`, `docs/openapi.yml`, and README accelerated context gathering.
4. **be-plan on real FO ticket** — `/be-plan PM4-6500` published to Confluence; drove PM4-6500 Testcontainers IT work.
5. **Polyglot exercises** — Reusing patterns across B4/B5, I4, A3, D2/D6 reduced ramp-up time.
6. **Offline verification pattern** — When Docker was unavailable, `terraform test`, kubeconform, and local pytest/npm/cargo proofs still satisfied assignment intent.

---

## Gaps found

| Gap | Severity | Detail |
|-----|----------|--------|
| Meta-ticket vs feature-ticket | Medium | be-plan assumes API contract + Flyway migrations; PM4-6558 is a learning ticket — needed Delivery Spec adaptation |
| No Confluence PRD for assignment | Low | Phase 2 skipped; Google Doc not readable via MCP |
| Gradle wrapper SSL locally | Medium | `./gradlew` failed on corporate SSL; mitigated via sdkman `gradle` + D5 bootstrap |
| No Docker on dev machine | Medium | I5/D2/D4/D6 full stack runs deferred; artifacts + offline validation used instead |
| codegraph MCP unavailable | Low | Fell back to grep/file reads for repo context (worked fine for this repo size) |
| PM4-6500 PR merge | Low | PR #14 pending green pipeline / merge to `stage` |

---

## Agent suggested vs manually verified

| Claim | Agent source | Manual verification |
|-------|-------------|---------------------|
| 45 test classes in eq-nudge-info-service | Glob search | ✅ Verified file count |
| 90% JaCoCo minimum | build.gradle | ✅ Read file directly |
| B3 gradle test passes | Agent run | ✅ BUILD SUCCESSFUL |
| B4–B6 / I4 / A3 tests | Agent run | ✅ pytest / npm / cargo verified |
| A6 ~50× batch scoring speedup | Benchmark script | ✅ 50 tx: 25.9s → 512ms |
| D1 terraform plan 12 resources | terraform test | ✅ mock plan passed |
| D4 k8s manifests valid | kubeconform | ✅ 5/5 Valid |
| D5 bootstrap one-command | make bootstrap | ✅ BUILD SUCCESSFUL (unit tests) |
| D6 metrics after load | prove-local.sh | ✅ panel-data.json with convert counters |
| PM4-6500 ITs in CI | PR review | ✅ Approve; DinD pipeline on Bitbucket |

---

## Recommendations (post-assignment)

1. Install Docker Desktop locally to run D2/D4/D6 full stack and I5 container proof end-to-end.
2. Merge PM4-6500 PR #14 when Bitbucket pipeline is green.
3. Push optional branches (`assignment/PM4-6558-A4`, assignment folder) if team wants remote review.
4. Run `/be-execute PM4-6500` verification gates if FO delivery pipeline requires archival.

---

## Assignment progress (complete)

| Exercise | Status | Artifact |
|----------|--------|----------|
| B1 Repo inventory | ✅ | `B1-repo-inventory.md` |
| B2 API map | ✅ | `B2-api-endpoint-map.md` |
| B3 Test discovery | ✅ | `B3-test-discovery.md` (eq-nudge-info-service) |
| B4 FastAPI | ✅ | `B4-fastapi/` — 4/4 tests |
| B5 Node.js | ✅ | `B5-nodejs/` — 3/3 tests |
| B6 Rust CLI | ✅ | `B6-rust-logcounter/` — 3/3 tests |
| I1 ER diagram | ✅ | `I1-er-diagram.md` |
| I2 Flow trace | ✅ | `I2-end-to-end-flow.md` |
| I3 Small safe change | ✅ | `I3-small-safe-change.md` — branch `assignment/PM4-6558-I3` |
| I4 Polyglot pair | ✅ | `I4-convert-pair/` + `I4-polyglot-pair.md` |
| I5 Dockerize | ✅ | `I5-dockerize.md` + Dockerfile (uvicorn proof; Docker optional) |
| I6 Bug diagnosis | ✅ | `I6-bug-diagnosis.md` |
| A1 Parallel plan | ✅ | `A1-parallel-plan.md` |
| A2 Parallel worktrees | ✅ | `A2-parallel-worktrees.md` |
| A3 Fraud-score system | ✅ | `A3-fraud-score/` — cargo 3, pytest 3, npm 2 |
| A4 Modernization | ✅ | `A4-modernization.md` — MySQL driver P1 on `assignment/PM4-6558-A4` |
| A5 PR review | ✅ | `A5-pr-review.md` — PM4-6500 approve |
| A6 Performance | ✅ | `A6-performance.md` — batch subprocess ~50× faster |
| D1 Terraform | ✅ | `D1-terraform/` — validate + mock plan |
| D2 docker-compose | ✅ | `D2-compose-stack/` — compose + E2E scripts |
| D3 CI pipeline | ✅ | `D3-ci/` — GitHub Actions + local CI sim |
| D4 Kubernetes | ✅ | `D4-kubernetes/` — kubeconform 5/5 |
| D5 Bootstrap | ✅ | `D5-reproducible-env.md` + `eq-order-hold-consumer/Makefile` |
| D6 Observability | ✅ | `D6-observability/` — metrics + panel-data.json |
| /be-plan PM4-6500 | ✅ | [Confluence plan](https://paytmmoney.atlassian.net/wiki/spaces/PM/pages/748716084) |
| PM4-6500 implementation | ✅ | PR #14 — Testcontainers ITs + JaCoCo |

---

## Submission checklist

- [x] All exercises B1–B6, I1–I6, A1–A6, D1–D6 documented
- [x] `learnings.md` updated
- [x] Google Doc self-eval yes/no table filled
- [x] Repo self-eval [`00-basics-self-eval.md`](00-basics-self-eval.md) with evidence column
- [x] Cursor rules + “How I used Cursor” in README
- [x] Reusable skill pack in `.cursor/skills/` (10 skills — read, I3/I6, A5)
- [x] Jira PM4-6558 → Submit for Review
- [x] GitHub repo pushed for HR — https://github.com/t-shipramaurya-droid/coding-agent-skills-shipra-maurya
- [x] Verification screenshots in `docs/screenshots/` (4 PNGs, linked from README)
