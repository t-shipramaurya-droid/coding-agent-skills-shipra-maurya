#!/usr/bin/env node
import { convertViaApi, formatResult, parseArgs } from "./client.js";

async function main() {
  try {
    const options = parseArgs(process.argv);
    const result = await convertViaApi(options);
    console.log(formatResult(result));
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
}

main();
