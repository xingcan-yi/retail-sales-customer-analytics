-- Q1: Count invoices with multiple lines
SELECT
    COUNT(*) AS duplicated_invoice_count
FROM (
    SELECT invoice_number
    FROM raw.transactions
    WHERE invoice_number IS NOT NULL
      AND BTRIM(invoice_number) <> ''
    GROUP BY invoice_number
    HAVING COUNT(*) > 1
) AS invoice_groups;


-- Q2: Find the 10 invoices with the most lines
SELECT
    invoice_number,
    COUNT(*) AS line_count
FROM raw.transactions
WHERE invoice_number IS NOT NULL
  AND BTRIM(invoice_number) <> ''
GROUP BY invoice_number
ORDER BY line_count DESC, invoice_number
LIMIT 10;


-- Q3: Check duplicate source identifiers
SELECT
    batch_id,
    source_row,
    COUNT(*) AS occurrence_count
FROM raw.transactions
GROUP BY batch_id, source_row
HAVING COUNT(*) > 1;

-- Q4: Check the completely duplicated lines
WITH duplicate_groups AS (
    SELECT
        invoice_number, stock_code, description, quantity,
        invoice_date, unit_price, customer_id, country,
        COUNT(*) AS group_size
    FROM raw.transactions
    GROUP BY
        invoice_number, stock_code, description, quantity,
        invoice_date, unit_price, customer_id, country
    HAVING COUNT(*) > 1
)
SELECT
    COUNT(*) AS duplicate_group_count,
    SUM(group_size - 1) AS excess_duplicate_rows
FROM duplicate_groups;