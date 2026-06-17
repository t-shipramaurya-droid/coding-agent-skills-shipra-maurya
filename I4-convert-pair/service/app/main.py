from __future__ import annotations

import logging

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, field_validator

from app.converter import SUPPORTED_CURRENCIES, convert_amount
from app.observability import (
    CONVERT_COUNT,
    ObservabilityMiddleware,
    configure_logging,
    metrics_response,
    struct_log,
)

configure_logging()
logger = logging.getLogger("convert-service")

app = FastAPI(title="Currency Convert Service", version="1.0.0")
app.add_middleware(ObservabilityMiddleware)


class ConvertRequest(BaseModel):
    amount: float = Field(..., gt=0, description="Positive amount to convert")
    from_currency: str = Field(..., min_length=3, max_length=3)
    to_currency: str = Field(..., min_length=3, max_length=3)

    @field_validator("from_currency", "to_currency")
    @classmethod
    def normalize_currency(cls, value: str) -> str:
        return value.strip().upper()


class ConvertResponse(BaseModel):
    amount: float
    from_currency: str
    to_currency: str
    rate: float
    converted_amount: float


def _log_event(event: str, fields: dict) -> None:
    struct_log(logger, event, **fields)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/metrics")
def metrics() -> object:
    return metrics_response()


@app.post("/convert", response_model=ConvertResponse)
def convert(payload: ConvertRequest) -> ConvertResponse:
    try:
        result = convert_amount(payload.amount, payload.from_currency, payload.to_currency)
        CONVERT_COUNT.labels(
            from_currency=result["from_currency"],
            to_currency=result["to_currency"],
            status="success",
        ).inc()
        _log_event(
            "convert_success",
            {
                "from_currency": result["from_currency"],
                "to_currency": result["to_currency"],
                "amount": result["amount"],
                "converted_amount": result["converted_amount"],
            },
        )
        return ConvertResponse(**result)
    except ValueError as exc:
        CONVERT_COUNT.labels(
            from_currency=payload.from_currency,
            to_currency=payload.to_currency,
            status="error",
        ).inc()
        _log_event(
            "convert_error",
            {
                "from_currency": payload.from_currency,
                "to_currency": payload.to_currency,
                "error": str(exc),
            },
        )
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@app.get("/rates")
def list_rates() -> dict:
    return {
        "supported": sorted(SUPPORTED_CURRENCIES),
        "rates_to_usd": {"USD": 1.0, "EUR": 0.92, "GBP": 0.79, "INR": 83.0},
    }
