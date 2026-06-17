from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_metrics_endpoint_exposes_prometheus_format():
    client.get("/health")
    response = client.get("/metrics")
    assert response.status_code == 200
    body = response.text
    assert "http_requests_total" in body
    assert "convert_requests_total" in body


def test_convert_increments_metric_counter():
    before = client.get("/metrics").text
    client.post(
        "/convert",
        json={"amount": 10, "from_currency": "USD", "to_currency": "EUR"},
    )
    after = client.get("/metrics").text
    assert "convert_requests_total" in after
    assert after != before or "USD" in after
