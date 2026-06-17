CREATE TABLE IF NOT EXISTS transactions (
    transaction_id VARCHAR(32) PRIMARY KEY,
    amount         NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    currency       VARCHAR(3) NOT NULL,
    user_id        VARCHAR(64) NOT NULL,
    merchant_id    VARCHAR(64) NOT NULL,
    status         VARCHAR(16) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'SCORED')),
    risk_score     SMALLINT,
    risk_level     VARCHAR(16),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions (status);
