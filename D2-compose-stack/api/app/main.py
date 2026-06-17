from __future__ import annotations

from fastapi import FastAPI, HTTPException

from app.db import wait_for_db
from app.store import (
    ScoreResult,
    Transaction,
    TransactionCreate,
    apply_score,
    create_transaction,
    get_transaction,
    list_pending,
)

app = FastAPI(title="D2 Fraud Stack API", version="1.0.0")


@app.on_event("startup")
def on_startup() -> None:
    wait_for_db()


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/transactions", response_model=Transaction, status_code=201)
def ingest_transaction(payload: TransactionCreate) -> Transaction:
    return create_transaction(payload)


@app.get("/transactions/pending", response_model=list[Transaction])
def pending_transactions() -> list[Transaction]:
    return list_pending()


@app.get("/transactions/{transaction_id}", response_model=Transaction)
def fetch_transaction(transaction_id: str) -> Transaction:
    tx = get_transaction(transaction_id)
    if tx is None:
        raise HTTPException(status_code=404, detail="Transaction not found")
    return tx


@app.post("/transactions/{transaction_id}/score", response_model=Transaction)
def submit_score(transaction_id: str, score: ScoreResult) -> Transaction:
    if score.transaction_id != transaction_id:
        raise HTTPException(status_code=400, detail="transaction_id mismatch")
    try:
        return apply_score(transaction_id, score)
    except KeyError as exc:
        raise HTTPException(status_code=404, detail="Transaction not found") from exc
