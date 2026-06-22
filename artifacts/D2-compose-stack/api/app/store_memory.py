"""In-memory store for local E2E without Docker/Postgres (FRAUD_STORE=memory)."""

from __future__ import annotations

from typing import Literal, Optional

from pydantic import BaseModel, Field, field_validator


class TransactionCreate(BaseModel):
    amount: float = Field(..., gt=0)
    currency: str = Field(..., min_length=3, max_length=3)
    user_id: str = Field(..., min_length=1)
    merchant_id: str = Field(..., min_length=1)

    @field_validator("currency")
    @classmethod
    def normalize_currency(cls, value: str) -> str:
        return value.strip().upper()


class Transaction(BaseModel):
    transaction_id: str
    amount: float
    currency: str
    user_id: str
    merchant_id: str
    status: Literal["PENDING", "SCORED"]
    risk_score: Optional[int] = None
    risk_level: Optional[str] = None


class ScoreResult(BaseModel):
    transaction_id: str
    risk_score: int = Field(..., ge=0, le=100)
    risk_level: str
    reasons: list[str] = Field(default_factory=list)


_TRANSACTIONS: dict[str, dict] = {
    "tx-seed-001": {
        "transaction_id": "tx-seed-001",
        "amount": 150.0,
        "currency": "USD",
        "user_id": "user-1",
        "merchant_id": "M100",
        "status": "PENDING",
        "risk_score": None,
        "risk_level": None,
    },
    "tx-seed-002": {
        "transaction_id": "tx-seed-002",
        "amount": 1200.0,
        "currency": "USD",
        "user_id": "bad-user",
        "merchant_id": "M999",
        "status": "PENDING",
        "risk_score": None,
        "risk_level": None,
    },
}
_NEXT_NUM = 3


def _row_to_transaction(row: dict) -> Transaction:
    return Transaction(**row)


def next_id() -> str:
    global _NEXT_NUM
    tx_id = f"tx-{_NEXT_NUM:04d}"
    _NEXT_NUM += 1
    return tx_id


def create_transaction(payload: TransactionCreate) -> Transaction:
    tx_id = next_id()
    row = {
        "transaction_id": tx_id,
        "amount": payload.amount,
        "currency": payload.currency,
        "user_id": payload.user_id,
        "merchant_id": payload.merchant_id,
        "status": "PENDING",
        "risk_score": None,
        "risk_level": None,
    }
    _TRANSACTIONS[tx_id] = row
    return _row_to_transaction(row)


def list_pending() -> list[Transaction]:
    return [
        _row_to_transaction(row)
        for row in _TRANSACTIONS.values()
        if row["status"] == "PENDING"
    ]


def get_transaction(tx_id: str) -> Transaction | None:
    row = _TRANSACTIONS.get(tx_id)
    return _row_to_transaction(row) if row else None


def apply_score(tx_id: str, score: ScoreResult) -> Transaction:
    if tx_id not in _TRANSACTIONS:
        raise KeyError(tx_id)
    row = _TRANSACTIONS[tx_id]
    row["status"] = "SCORED"
    row["risk_score"] = score.risk_score
    row["risk_level"] = score.risk_level
    return _row_to_transaction(row)
