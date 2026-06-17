# Suggested screenshots for HR / evaluator

**Included in repo (ready for GitHub):**

| File | Description |
|------|-------------|
| [`01-pytest-all-green.png`](01-pytest-all-green.png) | I4 service — 9/9 pytest passed |
| [`02-d6-panel-data-json.png`](02-d6-panel-data-json.png) | D6 `panel-data.json` in editor |
| [`03-d6-prove-local-terminal.png`](03-d6-prove-local-terminal.png) | D6 `prove-local.sh` full output |
| [`04-d6-metrics-grep.png`](04-d6-metrics-grep.png) | D6 Prometheus `convert_requests_total` grep |

Referenced from root [`README.md`](../../README.md) § Verification screenshots.

---

## Optional additional screenshot

| Filename | What | How |
|----------|------|-----|
| `02-jira-pm4-6558-submitted.png` | Jira In Review + submission comment | Browser screenshot of PM4-6558 |

---

## Legacy capture instructions (if re-taking screenshots)

**Filename:** `01-pytest-all-green.png`

**Why:** Proves you ran and verified code, not only wrote docs.

**Best option (shows breadth):** I4 convert service — **9 tests** including D6 metrics.

```bash
cd PM4-6558-assignment/I4-convert-pair/service
source .venv/bin/activate   # or: .venv/bin/pytest
pip install -r requirements-dev.txt   # if needed
pytest -v
```

**Frame the terminal so it shows:**
- Command: `pytest -v` (or `pytest -q`)
- Last line: `9 passed` (or `X passed in Y.YYs`)
- A few test names visible, e.g. `test_convert_api.py`, `test_metrics.py`

**Alternative (pick one if you prefer):**
- A3: `cd A3-fraud-score/service && pytest -v` → 3 passed
- B4: `cd B4-fastapi && pytest -v` → 4 passed
- D3: `cd D3-ci && ./scripts/run-ci-local.sh` → ruff + pytest + npm all green

---

## Screenshot 2 — Jira submission (required)

**Filename:** `02-jira-pm4-6558-submitted.png`

**URL:** https://paytmmoney.atlassian.net/browse/PM4-6558

**Frame the browser so it shows:**
- Issue key: **PM4-6558**
- Summary: coding agent skills assignment
- Status: **In Review** (or Done)
- Your final **submission summary comment** visible (scroll if needed)
- Assignee: **Shipra Maurya**

**Tip:** Expand your latest comment (“Assignment submission summary”) so evaluators see the exercise table without opening the repo.

**Crop:** Hide unrelated tabs; full-width Jira issue view is enough.

---

## Screenshot 3 — Observability / metrics proof (required)

**Filename:** `03-d6-metrics-panel-data.png`

**Why:** D6 asks for dashboard panel data; you have JSON proof without Grafana/Docker.

**Option A — JSON file (easiest, no server running):**

```bash
open PM4-6558-assignment/D6-observability/artifacts/panel-data.json
```

**Frame the editor/viewer showing:**
- `"status": "success"`
- `"result"` array with `convert_requests_total` entries (USD→EUR, USD→INR, EUR→USD)
- Query string at bottom: `sum(rate(convert_requests_total[1m]))...`

**Option B — Live `/metrics` after load (stronger):**

```bash
cd PM4-6558-assignment/D6-observability
./scripts/prove-local.sh
# In another terminal:
curl -s http://127.0.0.1:8000/metrics | grep convert_requests_total
```

Screenshot terminal with lines like:

```
convert_requests_total{from_currency="USD",status="success",to_currency="EUR"} 21.0
```

**Option C — If you run Docker later:** Grafana panel “Convert request rate (D6 panel)” → save as `03-grafana-convert-rate.png` instead.

---

## Optional 4th screenshot (nice to have)

| Filename | What | How |
|----------|------|-----|
| `04-github-repo-overview.png` | Repo root on GitHub | After push: README + folder list visible |
| `04-d3-ci-local-green.png` | CI simulation | `cd D3-ci && ./scripts/run-ci-local.sh` |
| `04-bitbucket-pr14.png` | Real FO work | Bitbucket PR #14 tests green |

---

## After adding files

1. Save PNGs in this folder (`docs/screenshots/`)
2. Add to root `README.md` (optional block):

```markdown
## Screenshots

| | |
|---|---|
| Tests | ![pytest](docs/screenshots/01-pytest-all-green.png) |
| Jira | ![jira](docs/screenshots/02-jira-pm4-6558-submitted.png) |
| Metrics | ![metrics](docs/screenshots/03-d6-metrics-panel-data.png) |
```

3. Commit and push:

```bash
git add docs/screenshots/
git commit -m "Add evaluation screenshots"
git push
```

---

## Checklist before you screenshot

- [ ] Terminal font large enough to read when zoomed out (14–16pt)
- [ ] No API keys, tokens, or internal passwords in frame
- [ ] Jira screenshot shows **your** submission comment
- [ ] Filenames match `01-`, `02-`, `03-` for easy ordering
