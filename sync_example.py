#!/usr/bin/env python3
import sys
import logging
import psycopg
from psycopg.types.json import Jsonb

logging.basicConfig(
    level=logging.DEBUG,
    format="[%(asctime)s] [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stderr)],
)


def log_notice(diag):
    if diag.severity == "NOTICE":
        logging.debug(diag.message_primary)


with psycopg.connect("postgresql://postgres:secret@127.0.0.1:5432/postgres") as conn:
    conn.add_notice_handler(log_notice)
    with conn.cursor() as cur:
        cur.execute(
            """
                SELECT create_order1(
                    _order => jsonb_populate_record(
                        NULL::orders,
                        %(order)s
                    ),
                    _order_items => (
                        SELECT array_agg(t)
                        FROM jsonb_populate_recordset(
                            NULL::order_items,
                            %(order_items)s
                        ) AS t
                    )
                );
            """,
            {
                'order': Jsonb({
                    "name": "order 2",
                    "order_type": "ENTRY",
                    "planned_execution_datetime_range": "[2022-02-22 00:00:00,)"
                }),
                "order_items": Jsonb([
                    {
                        "name": "item 1",
                        "quantity": 10
                    },
                    {
                        "name": "item 2",
                        "quantity": 5
                    }
                ])
            }
        )
