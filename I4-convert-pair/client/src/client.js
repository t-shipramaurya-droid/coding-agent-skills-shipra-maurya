const DEFAULT_BASE_URL = "http://127.0.0.1:8000";

export function buildConvertUrl(baseUrl, path = "/convert") {
  return new URL(path, baseUrl.endsWith("/") ? baseUrl : `${baseUrl}/`).toString();
}

export function parseArgs(argv) {
  const args = argv.slice(2);
  if (args.length === 3) {
    const amount = Number(args[0]);
    const fromCurrency = args[1];
    const toCurrency = args[2];
    if (!Number.isFinite(amount) || amount <= 0) {
      throw new Error("Amount must be a positive number");
    }
    return { amount, fromCurrency, toCurrency, baseUrl: DEFAULT_BASE_URL };
  }

  let amount;
  let fromCurrency;
  let toCurrency;
  let baseUrl = process.env.CONVERT_API_URL || DEFAULT_BASE_URL;

  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (arg === "--amount") amount = Number(args[++i]);
    else if (arg === "--from") fromCurrency = args[++i];
    else if (arg === "--to") toCurrency = args[++i];
    else if (arg === "--url") baseUrl = args[++i];
    else throw new Error(`Unknown argument: ${arg}`);
  }

  if (!Number.isFinite(amount) || amount <= 0) {
    throw new Error("Amount must be a positive number");
  }
  if (!fromCurrency || !toCurrency) {
    throw new Error("Usage: convert-cli <amount> <FROM> <TO>  OR  --amount N --from USD --to INR");
  }

  return { amount, fromCurrency, toCurrency, baseUrl };
}

export async function convertViaApi({ amount, fromCurrency, toCurrency, baseUrl }, fetchFn = fetch) {
  const url = buildConvertUrl(baseUrl);
  const response = await fetchFn(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      amount,
      from_currency: fromCurrency,
      to_currency: toCurrency,
    }),
  });

  const body = await response.json();
  if (!response.ok) {
    const detail = body.detail || JSON.stringify(body);
    throw new Error(`Convert failed (${response.status}): ${detail}`);
  }
  return body;
}

export function formatResult(result) {
  return `${result.amount} ${result.from_currency} = ${result.converted_amount} ${result.to_currency} (rate: ${result.rate})`;
}
