#!/usr/bin/env node
import { processPendingOnce } from "./worker.js";

const apiBaseUrl = process.env.FRAUD_API_URL || "http://127.0.0.1:8100";
const enginePath = process.env.FRAUD_ENGINE_PATH;

async function main() {
  try {
    const processed = await processPendingOnce(
      apiBaseUrl,
      enginePath || undefined,
    );
    if (processed.length === 0) {
      console.log("No pending transactions.");
      return;
    }
    for (const tx of processed) {
      console.log(
        `${tx.transaction_id}: score=${tx.risk_score} level=${tx.risk_level}`,
      );
    }
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
}

main();
