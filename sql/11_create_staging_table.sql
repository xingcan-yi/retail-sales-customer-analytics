CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.transactions (
    raw_id BIGINT PRIMARY KEY
        REFERENCES raw.transactions(raw_id),

    batch_id BIGINT NOT NULL,
    source_row BIGINT NOT NULL,

    invoice_number TEXT,
    stock_code TEXT,
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMP,
    unit_price NUMERIC,
    customer_id TEXT,
    country TEXT
);