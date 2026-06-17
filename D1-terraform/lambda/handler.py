"""Minimal currency convert Lambda for PM4-6558 D1 (mirrors I4 convert logic)."""

from __future__ import annotations

import json
import logging
from typing import Any

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SUPPORTED = frozenset({"USD", "EUR", "INR", "GBP"})
RATES_TO_USD = {"USD": 1.0, "EUR": 0.92, "GBP": 0.79, "INR": 83.0}


def _response(status_code: int, body: dict[str, Any]) -> dict[str, Any]:
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }


def _convert(amount: float, from_currency: str, to_currency: str) -> dict[str, Any]:
    from_code = from_currency.upper()
    to_code = to_currency.upper()

    if from_code not in SUPPORTED:
        raise ValueError(f"Unsupported source currency: {from_currency}")
    if to_code not in SUPPORTED:
        raise ValueError(f"Unsupported target currency: {to_currency}")
    if amount <= 0:
        raise ValueError("Amount must be greater than zero")

    amount_in_usd = amount / RATES_TO_USD[from_code]
    converted = amount_in_usd * RATES_TO_USD[to_code]
    rate = RATES_TO_USD[to_code] / RATES_TO_USD[from_code]

    return {
        "amount": round(amount, 2),
        "from_currency": from_code,
        "to_currency": to_code,
        "rate": round(rate, 4),
        "converted_amount": round(converted, 2),
    }


def lambda_handler(event: dict[str, Any], _context: Any) -> dict[str, Any]:
    route_key = event.get("routeKey") or event.get("rawPath") or ""
    logger.info("request route=%s", route_key)

    if route_key == "GET /health" or event.get("rawPath") == "/health":
        return _response(200, {"status": "ok"})

    try:
        raw_body = event.get("body") or "{}"
        payload = json.loads(raw_body)
        result = _convert(
            float(payload.get("amount", 0)),
            str(payload.get("from_currency", "")),
            str(payload.get("to_currency", "")),
        )
        return _response(200, result)
    except (ValueError, TypeError, json.JSONDecodeError) as exc:
        logger.warning("bad request: %s", exc)
        return _response(400, {"error": str(exc)})
