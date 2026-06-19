let transactions = [];
let balance = 0;

function validateTransaction(input) {
  const amount = Number(input.amount);
  const type = input.type;

  if (!Number.isFinite(amount) || amount <= 0) {
    const err = new Error('amount must be a positive number');
    err.statusCode = 400;
    throw err;
  }
  if (type !== 'credit' && type !== 'debit') {
    const err = new Error('type must be credit or debit');
    err.statusCode = 400;
    throw err;
  }
  if (type === 'debit' && amount > balance) {
    const err = new Error('Insufficient balance for debit');
    err.statusCode = 400;
    throw err;
  }

  return {
    amount,
    type,
    description: String(input.description || '').trim().slice(0, 200),
  };
}

function createTransaction(input) {
  const payload = validateTransaction(input);
  const tx = { id: transactions.length + 1, ...payload };
  transactions.push(tx);

  if (payload.type === 'credit') {
    balance += payload.amount;
  } else {
    balance -= payload.amount;
  }

  return tx;
}

function listTransactions() {
  return [...transactions];
}

function getBalance() {
  return { balance: Math.round(balance * 100) / 100 };
}

function resetState() {
  transactions = [];
  balance = 0;
}

module.exports = {
  createTransaction,
  listTransactions,
  getBalance,
  resetState,
};
