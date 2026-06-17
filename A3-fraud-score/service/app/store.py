from __future__ import annotations

from typing import Literal, Optional

from pydantic import BaseModel, Field, field_validator

_transactions: dict[str, dict] = {}
_counter = 0


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


def next_id() -> str:
    global _counter
    _counter += 1
    return f"tx-{_counter:04d}"


def create_transaction(payload: TransactionCreate) -> Transaction:
    tx_id = next_id()
    tx = Transaction(
        transaction_id=tx_id,
        amount=payload.amount,
        currency=payload.currency,
        user_id=payload.user_id,
        merchant_id=payload.merchant_id,
        status="PENDING",
    )
    _transactions[tx_id] = tx.model_dump()
    return tx


def list_pending() -> list[Transaction]:
    return [
        Transaction(**data)
        for data in _transactions.values()
        if data["status"] == "PENDING"
    ]


def get_transaction(tx_id: str) -> Transaction | None:
    data = _transactions.get(tx_id)
    return Transaction(**data) if data else None


def apply_score(tx_id: str, score: ScoreResult) -> Transaction:
    if tx_id not in _transactions:
        raise KeyError(tx_id)
    record = _transactions[tx_id]
    record["risk_score"] = score.risk_score
    record["risk_level"] = score.risk_level
    record["status"] = "SCORED"
    return Transaction(**record)


def reset_store() -> None:
    global _counter
    _transactions.clear()
    _counter = 0
