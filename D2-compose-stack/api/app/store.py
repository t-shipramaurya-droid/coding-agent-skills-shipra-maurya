from __future__ import annotations

from typing import Literal, Optional

from pydantic import BaseModel, Field, field_validator

from app.db import get_connection


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


def _row_to_transaction(row: dict) -> Transaction:
    return Transaction(
        transaction_id=row["transaction_id"],
        amount=float(row["amount"]),
        currency=row["currency"],
        user_id=row["user_id"],
        merchant_id=row["merchant_id"],
        status=row["status"],
        risk_score=row["risk_score"],
        risk_level=row["risk_level"],
    )


def next_id() -> str:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT COALESCE(
                    MAX(CAST(SUBSTRING(transaction_id FROM 4) AS INTEGER)), 0
                ) + 1 AS next_num
                FROM transactions
                WHERE transaction_id ~ '^tx-[0-9]+$'
                """
            )
            row = cur.fetchone()
            next_num = int(row["next_num"])
            return f"tx-{next_num:04d}"


def create_transaction(payload: TransactionCreate) -> Transaction:
    tx_id = next_id()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO transactions
                    (transaction_id, amount, currency, user_id, merchant_id, status)
                VALUES (%s, %s, %s, %s, %s, 'PENDING')
                RETURNING *
                """,
                (tx_id, payload.amount, payload.currency, payload.user_id, payload.merchant_id),
            )
            row = cur.fetchone()
    return _row_to_transaction(row)


def list_pending() -> list[Transaction]:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT * FROM transactions
                WHERE status = 'PENDING'
                ORDER BY created_at
                """
            )
            rows = cur.fetchall()
    return [_row_to_transaction(row) for row in rows]


def get_transaction(tx_id: str) -> Transaction | None:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM transactions WHERE transaction_id = %s", (tx_id,))
            row = cur.fetchone()
    return _row_to_transaction(row) if row else None


def apply_score(tx_id: str, score: ScoreResult) -> Transaction:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                UPDATE transactions
                SET status = 'SCORED',
                    risk_score = %s,
                    risk_level = %s
                WHERE transaction_id = %s
                RETURNING *
                """,
                (score.risk_score, score.risk_level, tx_id),
            )
            row = cur.fetchone()
            if row is None:
                raise KeyError(tx_id)
    return _row_to_transaction(row)
