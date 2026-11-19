CREATE OR REPLACE VIEW analytics.revenue_transactions AS
SELECT
    *,
    quantity * unit_price AS line_amount
FROM analytics.transactions_classified
WHERE
    (transaction_type = 'SALE_CANDIDATE'
    AND unit_price > 0)
    OR
    (transaction_type = 'CANCELLATION'            
    AND quantity < 0
    AND unit_price > 0);

SELECT COUNT(*) AS revenue_rows
FROM analytics.revenue_transactions;

SELECT
    transaction_type,
    COUNT(*) AS record_count,
    SUM(line_amount) AS total_amount
FROM analytics.revenue_transactions
GROUP BY transaction_type
ORDER BY transaction_type;