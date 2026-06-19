from fastapi.testclient import TestClient

from app.main import app
from app.store import reset_store

client = TestClient(app)


def setup_function():
    reset_store()
    client.post("/_reset")


def test_ingest_and_fetch_pending():
    create = client.post(
        "/transactions",
        json={
            "amount": 120,
            "currency": "USD",
            "user_id": "user-1",
            "merchant_id": "M100",
        },
    )
    assert create.status_code == 201
    tx_id = create.json()["transaction_id"]

    pending = client.get("/transactions/pending")
    assert pending.status_code == 200
    assert len(pending.json()) == 1
    assert pending.json()[0]["transaction_id"] == tx_id


def test_submit_score_marks_transaction_scored():
    create = client.post(
        "/transactions",
        json={
            "amount": 120,
            "currency": "USD",
            "user_id": "user-1",
            "merchant_id": "M100",
        },
    )
    tx_id = create.json()["transaction_id"]

    score = client.post(
        f"/transactions/{tx_id}/score",
        json={
            "transaction_id": tx_id,
            "risk_score": 25,
            "risk_level": "LOW",
            "reasons": ["amount_under_500"],
        },
    )
    assert score.status_code == 200
    assert score.json()["status"] == "SCORED"

    pending = client.get("/transactions/pending")
    assert pending.json() == []


def test_rejects_invalid_amount():
    response = client.post(
        "/transactions",
        json={"amount": 0, "currency": "USD", "user_id": "u", "merchant_id": "M1"},
    )
    assert response.status_code == 422
