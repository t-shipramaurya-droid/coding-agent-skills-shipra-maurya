import pytest
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


@pytest.fixture(autouse=True)
def reset():
    client.post("/_reset")
    yield
    client.post("/_reset")


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_create_credit_and_get_balance():
    response = client.post("/transactions", json={"amount": 100.0, "type": "credit"})
    assert response.status_code == 201
    assert response.json()["id"] == 1

    balance = client.get("/balance")
    assert balance.status_code == 200
    assert balance.json()["balance"] == 100.0


def test_debit_rejected_when_insufficient_balance():
    response = client.post("/transactions", json={"amount": 50.0, "type": "debit"})
    assert response.status_code == 400
    assert "Insufficient balance" in response.json()["detail"]


def test_list_transactions():
    client.post("/transactions", json={"amount": 10.0, "type": "credit", "description": "salary"})
    client.post("/transactions", json={"amount": 3.0, "type": "debit"})

    response = client.get("/transactions")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert data[0]["description"] == "salary"


def test_rejects_non_positive_amount():
    response = client.post("/transactions", json={"amount": 0, "type": "credit"})
    assert response.status_code == 422
