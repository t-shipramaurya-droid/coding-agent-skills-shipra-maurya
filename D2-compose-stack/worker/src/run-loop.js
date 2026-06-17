#!/usr/bin/env node
import { processPendingOnce } from "./worker.js";

const apiBaseUrl = process.env.FRAUD_API_URL || "http://api:8100";
const enginePath = process.env.FRAUD_ENGINE_PATH;
const pollIntervalMs = Number(process.env.WORKER_POLL_MS || 3000);

async function sleep(ms) {
  await new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  console.log(`[worker] starting — api=${apiBaseUrl} poll=${pollIntervalMs}ms`);

  while (true) {
    try {
      const processed = await processPendingOnce(apiBaseUrl, enginePath || undefined);
      if (processed.length > 0) {
        for (const tx of processed) {
          console.log(
            `[worker] scored ${tx.transaction_id}: score=${tx.risk_score} level=${tx.risk_level}`,
          );
        }
      }
    } catch (error) {
      console.error(`[worker] error: ${error.message}`);
    }
    await sleep(pollIntervalMs);
  }
}

main();
