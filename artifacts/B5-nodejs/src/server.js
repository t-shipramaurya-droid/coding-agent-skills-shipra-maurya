const http = require('http');
const { createTransaction, listTransactions, getBalance, resetState } = require('./store');

const PORT = process.env.PORT || 3000;

function sendJson(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(body));
}

function parseBody(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', chunk => { data += chunk; });
    req.on('end', () => {
      if (!data) return resolve({});
      try {
        resolve(JSON.parse(data));
      } catch (err) {
        reject(new Error('Invalid JSON'));
      }
    });
    req.on('error', reject);
  });
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  try {
    if (req.method === 'GET' && url.pathname === '/health') {
      return sendJson(res, 200, { status: 'ok' });
    }

    if (req.method === 'POST' && url.pathname === '/transactions') {
      const body = await parseBody(req);
      const tx = createTransaction(body);
      return sendJson(res, 201, tx);
    }

    if (req.method === 'GET' && url.pathname === '/transactions') {
      return sendJson(res, 200, listTransactions());
    }

    if (req.method === 'GET' && url.pathname === '/balance') {
      return sendJson(res, 200, getBalance());
    }

    if (req.method === 'POST' && url.pathname === '/_reset') {
      resetState();
      return sendJson(res, 200, { status: 'reset' });
    }

    sendJson(res, 404, { error: 'Not found' });
  } catch (err) {
    const status = err.statusCode || 400;
    sendJson(res, status, { error: err.message });
  }
});

if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`Transaction service listening on http://localhost:${PORT}`);
  });
}

module.exports = { server, parseBody, sendJson };
