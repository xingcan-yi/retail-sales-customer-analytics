SELECT COUNT(*) AS null_flag_rows
FROM staging.transactions
WHERE is_cancellation IS NULL
   OR is_negative_quantity IS NULL
   OR is_missing_customer IS NULL
   OR is_missing_description IS NULL
   OR is_negative_price IS NULL;