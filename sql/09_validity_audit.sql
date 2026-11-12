-- Q1: Count the number of records where quantity cannot be converted to an integer.
WITH invalid_quantity AS (
    SELECT *
    FROM raw.transactions
    WHERE quantity !~ '^-?[0-9]+$'
      OR quantity IS NULL
      OR BTRIM(quantity) = ''
)
SELECT COUNT(*) AS invalid_quantity_count
FROM invalid_quantity;


-- Q2: Count the number of records where unit_price does not match the expected numeric format.
WITH invalid_unit_price AS (
    SELECT *
    FROM raw.transactions
    WHERE unit_price !~ '^-?[0-9]+(\.[0-9]+)?$'
      OR unit_price IS NULL
      OR BTRIM(unit_price) = ''
)
SELECT COUNT(*) AS invalid_unit_price_count
FROM invalid_unit_price;


-- Q3: Among records with valid numeric formats, count the number of records where:
-- quantity < 0 (Negative Quantity)
-- quantity = 0 (Zero Quantity)
-- unit_price < 0 (Negative Unit Price)
WITH converted_data AS (
    SELECT
        CASE
            WHEN BTRIM(quantity) ~ '^-?[0-9]+$'
            THEN BTRIM(quantity)::NUMERIC
        END AS quantity_num,

        CASE
            WHEN BTRIM(unit_price) ~ '^-?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(unit_price)::NUMERIC
        END AS unit_price_num
    FROM raw.transactions
)
SELECT
    COUNT(*) FILTER (
        WHERE quantity_num < 0
    ) AS negative_quantity_count,

    COUNT(*) FILTER (
        WHERE quantity_num = 0
    ) AS zero_quantity_count,

    COUNT(*) FILTER (
        WHERE unit_price_num < 0
    ) AS negative_unit_price_count
FROM converted_data;

-- Q4: Count the number of records where invoice_number starts with the letter C, indicating a potential cancellation transaction.
WITH potential_cancellation AS (
    SELECT *
    FROM raw.transactions
    WHERE invoice_number LIKE 'C%'
)
SELECT 
    COUNT(*) AS potential_cancellation_count,
    COUNT(DISTINCT invoice_number) AS distinct_potential_cancellation_count
FROM potential_cancellation;