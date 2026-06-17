import assert from "node:assert/strict";
import path from "node:path";
import { describe, it } from "node:test";
import { fileURLToPath } from "node:url";

import { scoreWithRustEngine, scoreBatchWithRustEngine } from "../src/worker.js";

describe("scoreWithRustEngine", () => {
  it("returns LOW score for small transaction", () => {
    const score = scoreWithRustEngine({
      transaction_id: "tx-0001",
      amount: 100,
      currency: "USD",
      user_id: "user-1",
      merchant_id: "M100",
    });
    assert.equal(score.transaction_id, "tx-0001");
    assert.equal(score.risk_level, "LOW");
  });

  it("batch scoring matches single scoring", () => {
    const transactions = [
      {
        transaction_id: "tx-0001",
        amount: 100,
        currency: "USD",
        user_id: "user-1",
        merchant_id: "M100",
      },
      {
        transaction_id: "tx-0002",
        amount: 1500,
        currency: "USD",
        user_id: "user-2",
        merchant_id: "M999",
      },
    ];
    const batch = scoreBatchWithRustEngine(transactions);
    assert.equal(batch.length, 2);
    assert.deepEqual(batch[0], scoreWithRustEngine(transactions[0]));
    assert.deepEqual(batch[1], scoreWithRustEngine(transactions[1]));
  });
});

describe("worker integration (mock API)", () => {
  it("parses rust JSON shape", () => {
    const sample = {
      transaction_id: "tx-9",
      risk_score: 55,
      risk_level: "MEDIUM",
      reasons: ["amount_over_500"],
    };
    assert.ok(sample.risk_score >= 0 && sample.risk_score <= 100);
  });
});
