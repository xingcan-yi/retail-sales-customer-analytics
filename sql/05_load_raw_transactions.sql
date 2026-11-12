
WITH new_batch AS (
    INSERT INTO raw.import_batches (
        source_filename,
        file_hash
    )
    VALUES (
        'online_retail.csv',
        'c820e928a9cb01d05738b0c36b5033ef661eccfb82f09f2e5ce8542da73b0b99'
    )
    ON CONFLICT (file_hash) DO NOTHING
    RETURNING batch_id
),
inserted_rows AS (
    INSERT INTO raw.transactions (
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
        nb.batch_id,
        b.source_row,
        b.invoice_number,
        b.stock_code,
        b.description,
        b.quantity,
        b.invoice_date,
        b.unit_price,
        b.customer_id,
        b.country
    FROM ingestion.retail_numbered_buffer AS b
    CROSS JOIN new_batch AS nb
    RETURNING raw_id
)
SELECT COUNT(*) AS inserted_rows
FROM inserted_rows;
