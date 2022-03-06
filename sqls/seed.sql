CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

DROP TABLE IF EXISTS orders, order_items CASCADE;
DROP TYPE IF EXISTS order_type_enum CASCADE;

CREATE TYPE order_type_enum AS ENUM (
    'ENTRY',
    'EXIT'
);

CREATE TABLE orders (
    id                                UUID PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
    name                              VARCHAR(200) NOT NULL,
    order_type                        order_type_enum NOT NULL,
    planned_execution_datetime_range  TSTZRANGE NOT NULL,
    effective_executed_at             TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    metadata                          JSONB DEFAULT NULL
);

CREATE TABLE order_items (
    id                UUID PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,

    order_id          UUID NOT NULL,
    name              VARCHAR(200) NOT NULL,
    metadata          JSONB DEFAULT NULL,
    position          INTEGER DEFAULT NULL,
    quantity          INTEGER DEFAULT NULL,

    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
);

CREATE INDEX order_items_order_id_index ON order_items (order_id);

CREATE OR REPLACE FUNCTION create_order1(
    _order orders,
    _order_items order_items[] DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    RAISE NOTICE '_order %', _order;

    RAISE NOTICE 'LOWER(_order.planned_execution_datetime_range) %', LOWER(_order.planned_execution_datetime_range);

    RAISE NOTICE '_order_items %', _order_items;
END;
$$ language plpgsql security definer;

