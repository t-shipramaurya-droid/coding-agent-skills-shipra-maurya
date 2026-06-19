from __future__ import annotations

import os
import time
from contextlib import contextmanager
from typing import Generator, Optional

import psycopg
from psycopg.rows import dict_row

DEFAULT_DATABASE_URL = "postgresql://fraud:fraud@localhost:5432/fraud"


def database_url() -> str:
    return os.environ.get("DATABASE_URL", DEFAULT_DATABASE_URL)


@contextmanager
def get_connection() -> Generator[psycopg.Connection, None, None]:
    conn = psycopg.connect(database_url(), row_factory=dict_row)
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def wait_for_db(max_attempts: int = 30, delay_seconds: float = 2.0) -> None:
    last_error: Optional[Exception] = None
    for _ in range(max_attempts):
        try:
            with get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT 1")
            return
        except Exception as exc:  # noqa: BLE001 — startup retry loop
            last_error = exc
            time.sleep(delay_seconds)
    raise RuntimeError(f"Database not ready after {max_attempts} attempts") from last_error
