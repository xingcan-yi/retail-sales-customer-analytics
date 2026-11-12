WITH missing_info_1 AS (
    SELECT
        COUNT(*) AS total_rows,

        count(*) FILTER(
            WHERE customer_id IS NULL
            OR BTRIM(customer_id) = ''
        ) AS missing_customer_count,

        COUNT(*) FILTER(
            WHERE description IS NULL
            OR BTRIM(description) = ''
        ) AS missing_description_count
    FROM raw.transactions
),
missing_info_2 AS (
    SELECT
        *,

        ROUND(
            100.0 * 
            missing_customer_count / NULLIF(total_rows, 0),
            2
        ) AS missing_customer_pct,

        ROUND(
            100.0 * 
            missing_description_count / NULLIF(total_rows, 0),
            2
        ) AS missing_description_pct
    FROM missing_info_1
)
SELECT * FROM missing_info_2;
