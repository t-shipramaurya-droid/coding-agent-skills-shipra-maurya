#!/usr/bin/env node
/**
 * A6 baseline/after benchmark: per-transaction subprocess vs batch scoring.
 * Usage: node benchmark/bench-scoring.mjs [--mode=per-tx|batch]
 */
import { performance } from "node:perf_hooks";
import { scoreWithRustEngine, scoreBatchWithRustEngine } from "../worker/src/worker.js";

const COUNT = Number(process.env.BENCH_COUNT || 50);
const mode = process.argv.find((a) => a.startsWith("--mode="))?.split("=")[1] || "both";

function makeTransactions(n) {
  return Array.from({ length: n }, (_, i) => ({
    transaction_id: `tx-bench-${i}`,
    amount: 100 + (i % 900),
    currency: "USD",
    user_id: `user-${i % 10}`,
    merchant_id: i % 20 === 0 ? "M999" : "M100",
  }));
}

function bench(label, fn) {
  const start = performance.now();
  const result = fn();
  const ms = performance.now() - start;
  console.log(`${label}: ${ms.toFixed(2)} ms (${COUNT} transactions)`);
  return { ms, result };
}

const transactions = makeTransactions(COUNT);

if (mode === "per-tx" || mode === "both") {
  bench("per-tx (spawn per transaction)", () => {
    const scores = [];
    for (const tx of transactions) {
      scores.push(scoreWithRustEngine(tx));
    }
    return scores;
  });
}

if (mode === "batch" || mode === "both") {
  bench("batch (single subprocess)", () => scoreBatchWithRustEngine(transactions));
}
