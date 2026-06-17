from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_convert_endpoint_success():
    response = client.post(
        "/convert",
        json={"amount": 100, "from_currency": "USD", "to_currency": "INR"},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["converted_amount"] == 8300.0
    assert body["from_currency"] == "USD"
    assert body["to_currency"] == "INR"


def test_convert_rejects_invalid_amount():
    response = client.post(
        "/convert",
        json={"amount": -5, "from_currency": "USD", "to_currency": "EUR"},
    )
    assert response.status_code == 422


def test_convert_rejects_unsupported_currency():
    response = client.post(
        "/convert",
        json={"amount": 10, "from_currency": "USD", "to_currency": "JPY"},
    )
    assert response.status_code == 400
    assert "Unsupported target" in response.json()["detail"]
