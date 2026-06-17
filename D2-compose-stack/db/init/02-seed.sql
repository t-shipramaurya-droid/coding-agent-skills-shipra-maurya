-- Seed pending transactions for E2E (loaded on first db start)
INSERT INTO transactions (transaction_id, amount, currency, user_id, merchant_id, status)
VALUES
    ('tx-seed-001', 150.00, 'USD', 'user-1', 'M100', 'PENDING'),
    ('tx-seed-002', 1200.00, 'USD', 'bad-user', 'M999', 'PENDING')
ON CONFLICT (transaction_id) DO NOTHING;
