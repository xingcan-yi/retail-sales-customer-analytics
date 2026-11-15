-- Source Record Reconciliation

SELECT COUNT(*)
FROM raw.transactions AS r
LEFT JOIN staging.transactions AS s
    ON r.raw_id = s.raw_id
WHERE s.raw_id IS NULL;

SELECT COUNT(*)
FROM staging.transactions AS s
LEFT JOIN raw.transactions AS r
    ON s.raw_id = r.raw_id
WHERE r.raw_id IS NULL;

-- Converted Value Reconciliation

SELECT COUNT(*)
FROM raw.transactions AS r
LEFT JOIN staging.transactions AS s
    ON r.raw_id = s.raw_id
WHERE
    r.quantity::INTEGER IS DISTINCT FROM s.quantity
    OR r.invoice_date::TIMESTAMP IS DISTINCT FROM s.invoice_date
    OR r.unit_price::NUMERIC IS DISTINCT FROM s.unit_price;