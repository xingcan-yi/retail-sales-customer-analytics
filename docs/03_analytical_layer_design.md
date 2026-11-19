# Analytical Layer Design

## 1. Overview

This document describes the architecture and design decisions of the Analytical Layer for the Online Retail dataset.

A dedicated `analytics` schema has been created to organise reusable analytical views. Three views support transaction classification, revenue analysis, and customer RFM analysis.

Based on the previously established eligibility rules, the Analytical Layer contains **539,392 revenue-eligible transaction records** and **397,884 RFM-eligible transaction records**.

Separate views are used for revenue and RFM analysis because their eligibility criteria differ.

## 2. Architecture Decision

The Staging Layer uses physical tables to persist the results of data type conversion and quality flag calculations. This avoids repeating these transformations during analytical queries and provides a stable, indexable data source.

The Analytical Layer uses standard PostgreSQL views rather than additional physical tables.

This design offers three main advantages:

- **Maintainability:** Business rules can be maintained centrally and reused across downstream analyses.
- **Data Freshness:** Views reflect changes to the underlying Staging data when queried.
- **Storage Efficiency:** Views do not separately store their query results, reducing unnecessary data duplication.

However, views do not automatically synchronise the Staging Layer with the Raw Layer. Data ingestion and transformation remain separate responsibilities.

## 3. Analytical Views

Three views have been created within the `analytics` schema.

### 3.1 Transaction Classification View

**View:** `analytics.transactions_classified`

This view reads records from `staging.transactions` and adds a calculated `transaction_type` field.

It classifies transactions into four categories: `CANCELLATION`, `ADJUSTMENT_CANDIDATE`, `SALE_CANDIDATE`, and `REVIEW_REQUIRED`.

The classification logic is centralised so that downstream analytical views can reuse the same business definitions.

### 3.2 Revenue Analysis View

**View:** `analytics.revenue_transactions`

This view reads from `analytics.transactions_classified` and applies the revenue eligibility rules established during the transaction classification stage.

It includes eligible positive-value sales and negative-value cancellation transactions.

A calculated `line_amount` field represents the transaction-line value:

`line_amount = quantity × unit_price`

### 3.3 RFM Base View

**View:** `analytics.rfm_base`

This view also reads from `analytics.transactions_classified`, but applies the Paid Purchase RFM eligibility rules.

It includes positive-quantity, positive-price sales with valid customer identifiers.

The view provides transaction-level data for subsequent customer-level RFM calculations.

## 4. Validation Results

The Analytical Layer was validated through source record integrity checks and record count reconciliation.

Source integrity checks used `LEFT JOIN` queries to identify analytical records without corresponding `raw_id` values in `staging.transactions`.

Both the Revenue View and RFM Base View returned **zero unmatched records**.

The following record counts were also verified:

| Analytical View | Record Count |
|---|---:|
| `analytics.transactions_classified` | 541,909 |
| `analytics.revenue_transactions` | 539,392 |
| `analytics.rfm_base` | 397,884 |

These results are consistent with the classification and eligibility rules established in the previous stage.

## 5. Limitations & Next Steps

Although standard views provide maintainability and storage efficiency, complex analytical queries may become computationally expensive as the underlying dataset grows.

PostgreSQL can optimise queries involving views, so performance bottlenecks should be identified through execution plan analysis rather than assumed from the number of dependent views.

Future optimisation may involve indexes, materialized views, or physical summary tables where justified by query performance measurements.

The Analytical Layer currently provides reusable transaction-level datasets but does not yet include aggregated revenue reports or customer-level RFM metrics.

The next stage will focus on revenue trend analysis and customer-level RFM calculations using the validated analytical views.