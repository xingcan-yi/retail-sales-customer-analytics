-- 1. Total rows
SELECT COUNT(*) AS total_rows
FROM ingestion.retail_buffer;

-- 2. Missing invoice numbers
SELECT COUNT(*) AS missing_invoice_numbers
FROM ingestion.retail_buffer
WHERE invoice_number IS NULL
   OR TRIM(invoice_number) = '';

-- 3. Sample records
SELECT *
FROM ingestion.retail_buffer
LIMIT 10;