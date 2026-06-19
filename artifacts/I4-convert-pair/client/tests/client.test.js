import assert from "node:assert/strict";
import { describe, it } from "node:test";

import {
  buildConvertUrl,
  convertViaApi,
  formatResult,
  parseArgs,
} from "../src/client.js";

describe("parseArgs", () => {
  it("parses positional amount and currencies", () => {
    const parsed = parseArgs(["node", "cli.js", "100", "USD", "INR"]);
    assert.equal(parsed.amount, 100);
    assert.equal(parsed.fromCurrency, "USD");
    assert.equal(parsed.toCurrency, "INR");
  });

  it("parses long flags", () => {
    const parsed = parseArgs([
      "node",
      "cli.js",
      "--amount",
      "50",
      "--from",
      "EUR",
      "--to",
      "USD",
    ]);
    assert.equal(parsed.amount, 50);
    assert.equal(parsed.fromCurrency, "EUR");
    assert.equal(parsed.toCurrency, "USD");
  });

  it("rejects invalid amount", () => {
    assert.throws(
      () => parseArgs(["node", "cli.js", "0", "USD", "INR"]),
      /positive number/,
    );
  });
});

describe("convertViaApi", () => {
  it("posts JSON payload and returns parsed body", async () => {
    const calls = [];
    const mockFetch = async (url, init) => {
      calls.push({ url, init });
      return {
        ok: true,
        status: 200,
        json: async () => ({
          amount: 100,
          from_currency: "USD",
          to_currency: "INR",
          rate: 83,
          converted_amount: 8300,
        }),
      };
    };

    const result = await convertViaApi(
      { amount: 100, fromCurrency: "USD", toCurrency: "INR", baseUrl: "http://localhost:8000" },
      mockFetch,
    );

    assert.equal(result.converted_amount, 8300);
    assert.equal(calls.length, 1);
    assert.equal(calls[0].init.method, "POST");
    assert.deepEqual(JSON.parse(calls[0].init.body), {
      amount: 100,
      from_currency: "USD",
      to_currency: "INR",
    });
  });

  it("surfaces API errors", async () => {
    const mockFetch = async () => ({
      ok: false,
      status: 400,
      json: async () => ({ detail: "Unsupported target currency: JPY" }),
    });

    await assert.rejects(
      () =>
        convertViaApi(
          { amount: 10, fromCurrency: "USD", toCurrency: "JPY", baseUrl: "http://localhost:8000" },
          mockFetch,
        ),
      /Unsupported target currency/,
    );
  });
});

describe("formatResult", () => {
  it("formats human-readable output", () => {
    const line = formatResult({
      amount: 100,
      from_currency: "USD",
      to_currency: "INR",
      rate: 83,
      converted_amount: 8300,
    });
    assert.equal(line, "100 USD = 8300 INR (rate: 83)");
  });
});

describe("buildConvertUrl", () => {
  it("joins base url and convert path", () => {
    assert.equal(buildConvertUrl("http://127.0.0.1:8000"), "http://127.0.0.1:8000/convert");
  });
});
