/*
Q1 — Cancellation and Negative Quantity Consistency

Classify all transaction records into four categories based on the invoice cancellation indicator and the sign of quantity:
- Category A: Invoice number starts with C and quantity is negative.
- Category B: Invoice number starts with C and quantity is non-negative.
- Category C: Invoice number does not start with C and quantity is negative.
- Category D: Invoice number does not start with C and quantity is non-negative.
*/
WITH converted_data AS (
    SELECT
        invoice_number,
        CASE
            WHEN BTRIM(quantity) ~ '^-?[0-9]+$'
            THEN BTRIM(quantity)::NUMERIC
        END AS quantity_num
    FROM raw.transactions
)
SELECT
    COUNT(*) FILTER (
        WHERE invoice_number LIKE 'C%'
          AND quantity_num < 0
    ) AS category_a,

    COUNT(*) FILTER (
        WHERE invoice_number LIKE 'C%'
          AND quantity_num >= 0
    ) AS category_b,

    COUNT(*) FILTER (
        WHERE invoice_number NOT LIKE 'C%'
          AND quantity_num < 0
    ) AS category_c,

    COUNT(*) FILTER (
        WHERE invoice_number NOT LIKE 'C%'
          AND quantity_num >= 0
    ) AS category_d
FROM converted_data;


/*
Q2 — Investigation of Potentially Inconsistent Transactions

Investigate transaction records where the cancellation indicator and quantity sign appear inconsistent.
- Category B: Cancellation invoices with non-negative quantities.
- Category C: Non-cancellation invoices with negative quantities.
Retrieve 10 sample records from each category, including the following fields:

invoice_number, stock_code, quantity, unit_price, description

Examine the records to identify potential data quality issues or legitimate business explanations.
*/
WITH converted_data AS (
    SELECT
        *,
        CASE
            WHEN BTRIM(quantity) ~ '^-?[0-9]+$'
            THEN BTRIM(quantity)::NUMERIC
        END AS quantity_num
    FROM raw.transactions
),
classified AS (
    SELECT
        *,
        CASE
            WHEN invoice_number LIKE 'C%' AND quantity_num < 0 THEN 'A'
            WHEN invoice_number LIKE 'C%' AND quantity_num >= 0 THEN 'B'
            WHEN invoice_number NOT LIKE 'C%' AND quantity_num < 0 THEN 'C'
            WHEN invoice_number NOT LIKE 'C%' AND quantity_num >= 0 THEN 'D'
        END AS category
    FROM converted_data
),
classified_2 AS (
    SELECT
        *,
        COUNT(*) OVER(
            PARTITION BY category
        ) AS category_capacity,
        ROW_NUMBER() OVER(
            PARTITION BY category
            ORDER BY source_row
        ) AS sample_rank
    FROM classified
)
SELECT
    invoice_number, stock_code, quantity, unit_price, description, category, category_capacity
FROM classified_2
WHERE (category = 'B' OR category = 'C') AND sample_rank <= 10
ORDER BY category;
    