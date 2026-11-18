/*
Investigate transactions with negative quantities but without an explicit cancellation indicator. 
Examine their unit prices, missing descriptions, customer identifiers, 
and stock codes to identify potential business patterns.
*/
WITH category_c AS (
    SELECT * FROM staging.transactions
    WHERE
        invoice_number NOT LIKE 'C%'
        AND quantity < 0
)
SELECT
    COUNT(*) AS c_count,

    COUNT(*) FILTER(
        WHERE unit_price = 0 
    ) AS zero_price_count,

    COUNT(*) FILTER(
        WHERE is_missing_description
    ) AS missing_description_count,

    COUNT(*) FILTER(
        WHERE is_missing_customer
    ) AS missing_customer_count,

    COUNT(DISTINCT stock_code) AS distinct_stock_code_count
FROM category_c;