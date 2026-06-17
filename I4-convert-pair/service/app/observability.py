"""Structured logging and Prometheus metrics for D6 observability."""

from __future__ import annotations

import json
import logging
import time
from datetime import datetime, timezone
from typing import Any, Callable

from prometheus_client import Counter, Histogram, generate_latest
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "path", "status"],
)
REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency in seconds",
    ["method", "path"],
    buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5),
)
CONVERT_COUNT = Counter(
    "convert_requests_total",
    "Currency convert operations",
    ["from_currency", "to_currency", "status"],
)


class JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        message = record.getMessage()
        if message.startswith("{") and message.endswith("}"):
            return message
        payload = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": message,
        }
        return json.dumps(payload, ensure_ascii=True)


def configure_logging() -> None:
    handler = logging.StreamHandler()
    handler.setFormatter(JsonFormatter())
    root = logging.getLogger()
    root.handlers.clear()
    root.addHandler(handler)
    root.setLevel(logging.INFO)


def struct_log(logger: logging.Logger, event: str, **fields: Any) -> None:
    payload = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "level": "INFO",
        "logger": logger.name,
        "event": event,
        **fields,
    }
    logger.info(json.dumps(payload, ensure_ascii=True))


def metrics_response() -> Response:
    return Response(generate_latest(), media_type="text/plain; version=0.0.4; charset=utf-8")


class ObservabilityMiddleware(BaseHTTPMiddleware):
    def __init__(self, app: Callable, logger_name: str = "convert-service") -> None:
        super().__init__(app)
        self.logger = logging.getLogger(logger_name)

    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        start = time.perf_counter()
        path = request.url.path
        method = request.method
        status = 500

        try:
            response = await call_next(request)
            status = response.status_code
            return response
        finally:
            duration = time.perf_counter() - start
            route_path = path if path in {"/health", "/metrics", "/rates", "/convert"} else path
            REQUEST_COUNT.labels(method=method, path=route_path, status=str(status)).inc()
            REQUEST_LATENCY.labels(method=method, path=route_path).observe(duration)
            struct_log(
                self.logger,
                "http_request",
                method=method,
                path=route_path,
                status=status,
                duration_ms=round(duration * 1000, 2),
            )
