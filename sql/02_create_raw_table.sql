CREATE TABLE IF NOT EXISTS raw.import_batches (
    batch_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_filename TEXT NOT NULL,
    file_hash TEXT NOT NULL UNIQUE,
    imported_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.transactions (
    raw_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    batch_id BIGINT NOT NULL
        REFERENCES raw.import_batches(batch_id),

    source_row BIGINT NOT NULL,

    invoice_number TEXT,
    stock_code TEXT,
    description TEXT,
    quantity TEXT,
    invoice_date TEXT,
    unit_price TEXT,
    customer_id TEXT,
    country TEXT,

    CONSTRAINT uq_source_record
        UNIQUE (batch_id, source_row)
);
