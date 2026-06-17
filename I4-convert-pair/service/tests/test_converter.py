import pytest

from app.converter import convert_amount


def test_usd_to_inr():
    result = convert_amount(100, "USD", "INR")
    assert result["converted_amount"] == 8300.0
    assert result["rate"] == 83.0


def test_eur_to_usd():
    result = convert_amount(92, "EUR", "USD")
    assert result["converted_amount"] == 100.0


def test_rejects_unknown_currency():
    with pytest.raises(ValueError, match="Unsupported source"):
        convert_amount(10, "XYZ", "USD")


def test_rejects_non_positive_amount():
    with pytest.raises(ValueError, match="greater than zero"):
        convert_amount(0, "USD", "EUR")
