BEGIN;

ALTER TABLE staging.transactions
    ADD COLUMN is_cancellation BOOLEAN,
    ADD COLUMN is_negative_quantity BOOLEAN,
    ADD COLUMN is_missing_customer BOOLEAN,
    ADD COLUMN is_missing_description BOOLEAN,
    ADD COLUMN is_negative_price BOOLEAN;

UPDATE staging.transactions
SET
    is_cancellation = CASE 
        WHEN invoice_number LIKE 'C%' THEN TRUE
        ELSE FALSE
    END,

    is_negative_quantity = CASE
        WHEN quantity < 0 THEN TRUE
        ELSE FALSE
    END,

    is_missing_customer = CASE
        WHEN customer_id IS NULL OR BTRIM(customer_id) = '' THEN TRUE
        ELSE FALSE
    END,

    is_missing_description = CASE
        WHEN description IS NULL OR BTRIM(description) = '' THEN TRUE
        ELSE FALSE
    END,

    is_negative_price = CASE
        WHEN unit_price < 0 THEN TRUE
        ELSE FALSE
    END;

ALTER TABLE staging.transactions
    ALTER COLUMN is_cancellation SET NOT NULL,
    ALTER COLUMN is_negative_quantity SET NOT NULL,
    ALTER COLUMN is_missing_customer SET NOT NULL,
    ALTER COLUMN is_missing_description SET NOT NULL,
    ALTER COLUMN is_negative_price SET NOT NULL;

COMMIT;