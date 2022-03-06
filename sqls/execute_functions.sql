SELECT create_order1(
    _order => NULL,
    _order_items => NULL
);

SELECT create_order1(
    _order => ROW(NULL, 'order 1', 'ENTRY', '[2022-02-22 00:00:00,)', NULL, NULL)::orders,
    _order_items => ARRAY[
        ROW(NULL, NULL, 'item 1', NULL, NULL, 10)::order_items,
        ROW(NULL, NULL, 'item 2', NULL, NULL, 5)::order_items
    ]
);


SELECT create_order1(
    _order => json_populate_record(
        NULL::orders,
        '{
           "name": "order 1",
           "order_type": "ENTRY",
           "planned_execution_datetime_range": "[2022-02-22 00:00:00,)"
        }'
    ),
    _order_items => ARRAY[
        json_populate_record(
            NULL::order_items,
            '{
                "name": "item 1",
                "quantity": 10
            }'
        ),
        json_populate_record(
            NULL::order_items,
            '{
                "name": "item 2",
                "quantity": 5
            }'
        )
    ]
);
