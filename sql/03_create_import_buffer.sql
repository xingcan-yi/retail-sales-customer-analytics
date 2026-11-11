CREATE SCHEMA IF NOT EXISTS ingestion;

CREATE TABLE IF NOT EXISTS ingestion.retail_buffer (
    invoice_number TEXT,
    stock_code TEXT,
    description TEXT,
    quantity TEXT,
    invoice_date TEXT,
    unit_price TEXT,
    customer_id TEXT,
    country TEXT
);

CREATE TABLE IF NOT EXISTS ingestion.retail_numbered_buffer (
    source_row BIGINT,
    invoice_number TEXT,
    stock_code TEXT,
    description TEXT,
    quantity TEXT,
    invoice_date TEXT,
    unit_price TEXT,
    customer_id TEXT,
    country TEXT
);