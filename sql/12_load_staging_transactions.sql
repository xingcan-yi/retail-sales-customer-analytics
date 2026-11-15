-- Load typed transactions into Staging Layer

INSERT INTO staging.transactions (
    raw_id,
    batch_id,
    source_row,
    invoice_number,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
)
SELECT
    raw_id,
    batch_id,
    source_row,
    invoice_number,
    stock_code,
    description,

    CASE
        WHEN BTRIM(quantity) ~ '^-?[0-9]+$'
        THEN BTRIM(quantity)::INTEGER
    END AS quantity,

    CASE
        WHEN BTRIM(invoice_date) ~
             '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
        THEN BTRIM(invoice_date)::TIMESTAMP
    END AS invoice_date,

    CASE
        WHEN BTRIM(unit_price) ~
             '^-?[0-9]+(\.[0-9]+)?$'
        THEN BTRIM(unit_price)::NUMERIC
    END AS unit_price,

    customer_id,
    country
FROM raw.transactions
ON CONFLICT (raw_id) DO NOTHING;
