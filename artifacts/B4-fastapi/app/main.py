from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, field_validator
from typing import Literal

app = FastAPI(title="Transaction Service", version="1.0.0")

_transactions: list[dict] = []
_balance: float = 0.0


class TransactionCreate(BaseModel):
    amount: float = Field(..., gt=0, description="Positive transaction amount")
    type: Literal["credit", "debit"]
    description: str = Field(default="", max_length=200)

    @field_validator("description")
    @classmethod
    def strip_description(cls, value: str) -> str:
        return value.strip()


class Transaction(TransactionCreate):
    id: int


@app.post("/transactions", response_model=Transaction, status_code=201)
def create_transaction(payload: TransactionCreate) -> Transaction:
    global _balance
    if payload.type == "debit" and payload.amount > _balance:
        raise HTTPException(status_code=400, detail="Insufficient balance for debit")

    tx_id = len(_transactions) + 1
    tx = Transaction(id=tx_id, **payload.model_dump())
    _transactions.append(tx.model_dump())

    if payload.type == "credit":
        _balance += payload.amount
    else:
        _balance -= payload.amount

    return tx


@app.get("/transactions", response_model=list[Transaction])
def list_transactions() -> list[Transaction]:
    return [Transaction(**tx) for tx in _transactions]


@app.get("/balance")
def get_balance() -> dict[str, float]:
    return {"balance": round(_balance, 2)}


@app.post("/_reset")
def reset_state() -> dict[str, str]:
    global _balance
    _transactions.clear()
    _balance = 0.0
    return {"status": "reset"}
