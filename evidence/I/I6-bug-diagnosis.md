# I6 — Bug Diagnosis with Agent

**Ticket:** PM4-6558  
**Repo:** `artifacts/I4-convert-pair/service` (FastAPI currency convert)  
**Seeded bug location:** `app/converter.py` — pivot currency math

---

## 1. Reproduction steps

**Symptom:** Converting **EUR → USD** returns wrong amount; **USD → INR** still looks correct.

```bash
cd PM4-6558-assignment/artifacts/I4-convert-pair/service
source .venv/bin/activate
pytest tests/test_converter.py::test_eur_to_usd -q
```

**Actual failure:**

```
FAILED tests/test_converter.py::test_eur_to_usd - assert 84.64 == 100.0
```

**Manual curl (with uvicorn running):**

```bash
curl -s -X POST http://127.0.0.1:8000/convert \
  -H 'Content-Type: application/json' \
  -d '{"amount": 92, "from_currency": "EUR", "to_currency": "USD"}'
# Buggy: {"converted_amount": 84.64, ...}
# Fixed: {"converted_amount": 100.0, ...}
```

**Node CLI symptom:**

```bash
node ../client/src/cli.js 92 EUR USD
# Buggy: 92 EUR = 84.64 USD
# Fixed: 92 EUR = 100.0 USD
```

---

## 2. Root cause

| Item | Detail |
|------|--------|
| **File** | `service/app/converter.py` |
| **Function** | `convert_amount()` |
| **Lines** | USD-pivot calculation (lines ~29–31) |

**Buggy code:**

```python
amount_in_usd = amount * RATES_TO_USD[from_code]   # WRONG
converted = amount_in_usd * RATES_TO_USD[to_code]
```

`RATES_TO_USD` stores **how many units of each currency equal 1 USD** (e.g. EUR = 0.92 means 0.92 EUR = 1 USD). To convert **from** EUR **to** USD you must **divide** by the source rate to get USD, not multiply.

- 92 EUR ÷ 0.92 = **100 USD** (correct)
- 92 EUR × 0.92 = **84.64** (bug)

USD → INR still appeared correct by accident (× 1.0 × 83) which is why the bug was subtle.

---

## 3. Minimal fix

```python
amount_in_usd = amount / RATES_TO_USD[from_code]
converted = amount_in_usd * RATES_TO_USD[to_code]
```

One operator change (`*` → `/` on the pivot step). No API or test structure changes required.

---

## 4. Verification

```bash
cd PM4-6558-assignment/artifacts/I4-convert-pair/service
.venv/bin/pytest -q
```

**Result after fix:**

```
7 passed
```

---

## 5. Risk assessment

| Risk | Level | Notes |
|------|-------|-------|
| Regression on USD pairs | Low | USD rate is 1.0; divide/multiply equivalent |
| Other currency pairs | Fixed | EUR, GBP, INR cross-rates now correct |
| API contract change | None | Response shape unchanged |

---

## 6. Agent suggested vs manually verified

| Step | Agent | Manual verification |
|------|-------|---------------------|
| Reproduce via pytest | Ran `test_eur_to_usd` → fail 84.64 vs 100 | ✅ Match failure output |
| Root cause in converter.py | Traced `RATES_TO_USD` semantics | ✅ Read dict comment + math |
| Fix is single `/` not `*` | Applied minimal diff | ✅ |
| Full suite green | `pytest -q` → 7 passed | ✅ Run locally |
| curl / CLI proof | Documented | ⏳ Optional with uvicorn |

---

## Assignment checklist (I6)

| Requirement | Done |
|-------------|------|
| Reproduction steps | ✅ |
| Root cause + file paths | ✅ |
| Minimal fix | ✅ |
| Verification command + result | ✅ pytest 7/7 |
| Agent vs manual table | ✅ |
