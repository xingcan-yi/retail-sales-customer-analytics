CREATE OR REPLACE VIEW analytics.rfm_base AS 
SELECT
    *,
    quantity * unit_price AS line_amount
FROM analytics.transactions_classified
WHERE NOT is_missing_customer
  AND quantity > 0
  AND unit_price > 0
  AND transaction_type = 'SALE_CANDIDATE';

SELECT COUNT(*) AS rfm_rows
FROM analytics.rfm_base;

SELECT
    COUNT(DISTINCT customer_id) AS customer_count,
    COUNT(DISTINCT invoice_number) AS invoice_count,
    SUM(line_amount) AS total_purchase_value
FROM analytics.rfm_base;