"""Currency conversion with hardcoded exchange rates (assignment exercise)."""

from __future__ import annotations

from typing import Final

SUPPORTED_CURRENCIES: Final[frozenset[str]] = frozenset({"USD", "EUR", "INR", "GBP"})

# Rates expressed as units of currency per 1 USD
RATES_TO_USD: Final[dict[str, float]] = {
    "USD": 1.0,
    "EUR": 0.92,
    "GBP": 0.79,
    "INR": 83.0,
}


def convert_amount(amount: float, from_currency: str, to_currency: str) -> dict[str, float | str]:
    from_code = from_currency.upper()
    to_code = to_currency.upper()

    if from_code not in SUPPORTED_CURRENCIES:
        raise ValueError(f"Unsupported source currency: {from_currency}")
    if to_code not in SUPPORTED_CURRENCIES:
        raise ValueError(f"Unsupported target currency: {to_currency}")
    if amount <= 0:
        raise ValueError("Amount must be greater than zero")

    # Convert via USD as pivot: amount_in_usd = amount / rate_from; result = amount_in_usd * rate_to
    amount_in_usd = amount / RATES_TO_USD[from_code]
    converted = amount_in_usd * RATES_TO_USD[to_code]
    rate = RATES_TO_USD[to_code] / RATES_TO_USD[from_code]

    return {
        "amount": round(amount, 2),
        "from_currency": from_code,
        "to_currency": to_code,
        "rate": round(rate, 4),
        "converted_amount": round(converted, 2),
    }
