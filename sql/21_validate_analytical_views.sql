/*
Q1 — Source Record Integrity
Verify that every record in the analytical views can be traced back to an existing record in the Staging Layer.
*/

SELECT COUNT(*)
FROM analytics.revenue_transactions AS a
LEFT JOIN staging.transactions AS s
    ON s.raw_id = a.raw_id
WHERE s.raw_id IS NULL;

SELECT COUNT(*)
FROM analytics.rfm_base AS a
LEFT JOIN staging.transactions AS s
    ON s.raw_id = a.raw_id
WHERE s.raw_id IS NULL;

/*
Q2 — Analytical Dataset Reconciliation
Reconcile analytical view record counts against the eligibility rules established during the transaction classification stage.
*/

SELECT COUNT(*) AS analytics_transactions_classified_count
FROM analytics.transactions_classified;

SELECT COUNT(*) AS analytics_revenue_transactions_count
FROM analytics.revenue_transactions;

SELECT COUNT(*) AS analytics_rfm_base_count
FROM analytics.rfm_base;
