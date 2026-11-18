# Transaction Classification Rules

## 1. Overview

This document defines the transaction classification and analysis eligibility rules for the Online Retail dataset, which contains **541,909 transaction records**.

Transactions are classified based on whether their invoice numbers begin with `C` and whether their quantities are positive or negative.

The purpose is to distinguish potential sales, cancellations, and adjustment activities, and to establish consistent filtering rules for revenue and customer RFM analysis.

## 2. Transaction Classification

The transactions are classified into four categories:

| Transaction Type | Classification Rule | Record Count |
|---|---|---:|
| `CANCELLATION` | Invoice number begins with `C` | 9,288 |
| `ADJUSTMENT_CANDIDATE` | Invoice number does not begin with `C`, and quantity is negative | 1,336 |
| `SALE_CANDIDATE` | Invoice number does not begin with `C`, and quantity is positive | 531,285 |
| `REVIEW_REQUIRED` | Records that do not satisfy the above conditions | 0 |
| **Total** | | **541,909** |

These classifications describe observed transaction characteristics rather than confirmed business events.

### Investigation of Adjustment Candidates

Further investigation of the 1,336 `ADJUSTMENT_CANDIDATE` records revealed:

- All 1,336 records have zero unit prices.
- All 1,336 records have missing customer identifiers.
- 862 records (64.52%) have missing product descriptions.
- The records cover 1,082 distinct stock codes.

These characteristics suggest that some records may represent inventory adjustments or other non-standard operations. However, their exact business meaning remains unconfirmed.

## 3. Defining Analysis Eligibility

Different analyses require different eligibility rules.

### Revenue Analysis

A transaction is eligible when:

- It is classified as `SALE_CANDIDATE` and has a positive unit price; or
- It is classified as `CANCELLATION`, has a negative quantity, and has a positive unit price.

Eligible cancellations contribute negative transaction values, calculated as `quantity × unit_price`.

Customer identifiers are not required for overall revenue analysis.

### Paid Purchase RFM Analysis

A transaction is eligible when all the following conditions are satisfied:

- It is classified as `SALE_CANDIDATE`.
- The quantity is positive.
- The unit price is positive.
- The customer identifier is not missing or empty.

These rules identify eligible purchase records for subsequent customer-level analysis.

## 4. Analysis Eligibility Counts

| Analysis | Eligible Records | Excluded Records |
|---|---:|---:|
| Revenue Analysis | 539,392 | 2,517 |
| Paid Purchase RFM Analysis | 397,884 | 144,025 |

Each analysis is evaluated independently against the complete dataset of 541,909 records.

The counts represent transaction lines rather than distinct invoices or customers.

## 5. Assumptions, Limitations and Next Steps

The classification and eligibility rules are based on observed data characteristics and the current analytical objectives.

Several limitations remain:

- Cancellation indicators do not independently confirm that a financial refund occurred.
- The business meaning of adjustment candidates has not been verified.
- Zero-price transactions are excluded from the current paid-transaction analysis.
- The RFM eligibility rules identify purchase records but do not yet determine how cancellations affect customer-level Monetary values.

No records are removed from the Raw or Staging Layers as a result of these classifications.

The next stage will apply these rules to create reusable analytical datasets and calculate revenue and customer-level metrics.