SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT source_row) AS unique_source_rows,
    MIN(source_row) AS first_source_row,
    MAX(source_row) AS last_source_row,
    COUNT(DISTINCT batch_id) AS batch_count
FROM raw.transactions;