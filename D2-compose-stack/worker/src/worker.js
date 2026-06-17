import { spawnSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ENGINE_DIR = path.resolve(__dirname, "../../engine");
const DEV_ENGINE = path.join(ENGINE_DIR, "target/debug/fraud-score");
const DEFAULT_ENGINE = process.env.FRAUD_ENGINE_PATH || DEV_ENGINE;

export function ensureEngineBuilt(enginePath = DEFAULT_ENGINE) {
  if (fs.existsSync(enginePath)) {
    return enginePath;
  }
  if (enginePath !== DEV_ENGINE) {
    throw new Error(`Engine binary not found at ${enginePath}`);
  }
  const build = spawnSync("cargo", ["build", "--quiet", "--target-dir", "target"], {
    cwd: ENGINE_DIR,
    encoding: "utf8",
  });
  if (build.status !== 0) {
    throw new Error(build.stderr || "cargo build failed");
  }
  return DEV_ENGINE;
}

export async function fetchPending(apiBaseUrl) {
  const response = await fetch(new URL("/transactions/pending", apiBaseUrl));
  if (!response.ok) {
    throw new Error(`Failed to fetch pending transactions: ${response.status}`);
  }
  return response.json();
}

function toEnginePayload(transaction) {
  return {
    transaction_id: transaction.transaction_id,
    amount: transaction.amount,
    currency: transaction.currency,
    user_id: transaction.user_id,
    merchant_id: transaction.merchant_id,
  };
}

function runEngine(resolvedEngine, payload) {
  const result = spawnSync(resolvedEngine, [], {
    input: payload,
    encoding: "utf8",
  });

  if (result.error) {
    throw result.error;
  }
  if (result.status !== 0) {
    throw new Error(result.stderr || `Rust engine exited with ${result.status}`);
  }

  return JSON.parse(result.stdout.trim());
}

export function scoreBatchWithRustEngine(transactions, enginePath = DEFAULT_ENGINE) {
  const resolvedEngine = ensureEngineBuilt(enginePath);
  const payload = JSON.stringify(transactions.map(toEnginePayload));
  return runEngine(resolvedEngine, payload);
}

export async function submitScore(apiBaseUrl, score) {
  const response = await fetch(
    new URL(`/transactions/${score.transaction_id}/score`, apiBaseUrl),
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(score),
    },
  );

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Score submit failed (${response.status}): ${body}`);
  }
  return response.json();
}

export async function processPendingOnce(apiBaseUrl, enginePath = DEFAULT_ENGINE) {
  const pending = await fetchPending(apiBaseUrl);
  if (pending.length === 0) {
    return [];
  }

  const scores = scoreBatchWithRustEngine(pending, enginePath);
  const results = [];

  for (const score of scores) {
    const updated = await submitScore(apiBaseUrl, score);
    results.push(updated);
  }

  return results;
}
