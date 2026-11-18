WITH transaction_type_info AS (
    SELECT
        *,
        CASE
            WHEN is_cancellation THEN 'CANCELLATION'
            WHEN NOT is_cancellation AND quantity < 0 THEN 'ADJUSTMENT_CANDIDATE'
            WHEN NOT is_cancellation AND quantity > 0 THEN 'SALE_CANDIDATE'
            ELSE 'REVIEW_REQUIRED'
        END AS transaction_type
    FROM staging.transactions
)
SELECT
    transaction_type,
    COUNT(*) AS type_count
FROM transaction_type_info
GROUP BY transaction_type;