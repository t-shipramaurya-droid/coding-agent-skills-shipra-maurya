const { describe, it, before, after, beforeEach } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const { server } = require('../src/server');
const { resetState } = require('../src/store');

const PORT = 3001;

function request(method, path, body) {
  return new Promise((resolve, reject) => {
    const payload = body ? JSON.stringify(body) : null;
    const req = http.request(
      { host: '127.0.0.1', port: PORT, path, method, headers: { 'Content-Type': 'application/json' } },
      (res) => {
        let data = '';
        res.on('data', chunk => { data += chunk; });
        res.on('end', () => resolve({ status: res.statusCode, body: data ? JSON.parse(data) : {} }));
      }
    );
    req.on('error', reject);
    if (payload) req.write(payload);
    req.end();
  });
}

describe('transaction service', () => {
  before(async () => {
    await new Promise((resolve, reject) => {
      server.once('error', reject);
      server.listen(PORT, resolve);
    });
  });

  after(async () => {
    await new Promise(resolve => server.close(resolve));
  });

  beforeEach(() => {
    resetState();
  });

  it('creates credit and updates balance', async () => {
    const created = await request('POST', '/transactions', { amount: 100, type: 'credit' });
    assert.equal(created.status, 201);
    assert.equal(created.body.id, 1);

    const balance = await request('GET', '/balance');
    assert.equal(balance.body.balance, 100);
  });

  it('rejects debit when balance is insufficient', async () => {
    const response = await request('POST', '/transactions', { amount: 25, type: 'debit' });
    assert.equal(response.status, 400);
    assert.match(response.body.error, /Insufficient balance/);
  });

  it('lists transactions', async () => {
    await request('POST', '/transactions', { amount: 10, type: 'credit', description: 'pay' });
    await request('POST', '/transactions', { amount: 2, type: 'debit' });
    const list = await request('GET', '/transactions');
    assert.equal(list.body.length, 2);
    assert.equal(list.body[0].description, 'pay');
  });
});
