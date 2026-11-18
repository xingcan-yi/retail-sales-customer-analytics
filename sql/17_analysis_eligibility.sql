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
),

transaction_type_info_2 AS (
    SELECT
        COUNT(*) FILTER(
            WHERE
            (transaction_type = 'SALE_CANDIDATE'
            AND unit_price > 0)
            OR
            (transaction_type = 'CANCELLATION'
            AND quantity < 0
            AND unit_price > 0)
        ) AS revenue_eligible_count,

        COUNT(*) FILTER(
            WHERE NOT is_missing_customer
            AND quantity > 0
            AND unit_price > 0
            AND transaction_type = 'SALE_CANDIDATE'
        ) AS rfm_eligible_count,

        COUNT(*) AS total_rows

    FROM transaction_type_info
)

SELECT
    revenue_eligible_count,
    total_rows - revenue_eligible_count AS revenue_excluded_count,
    rfm_eligible_count,
    total_rows - rfm_eligible_count AS rfm_excluded_count
FROM transaction_type_info_2;