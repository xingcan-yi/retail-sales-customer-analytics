# Data Quality Audit Report

## 1. Overview

This report presents the results of a data quality audit conducted on the raw retail transaction dataset, comprising **541,909 records**.

The audit evaluates four key dimensions of data quality: **completeness, duplication, validity, and consistency**. Its purpose is to identify potential data quality issues and establish a reliable foundation for subsequent data cleaning and analytical modelling.

## 2. Completeness

The completeness assessment identified missing values in two fields:

- **CustomerID:** 135,080 records (24.93%) contain missing customer identifiers.
- **Description:** 1,454 records (0.27%) contain missing product descriptions.

The relatively high proportion of missing customer identifiers may significantly affect customer-level analyses, particularly customer segmentation, retention analysis, and RFM modelling.

## 3. Duplication

The duplication assessment identified the following:

- **20,059 invoice numbers** are associated with multiple transaction lines. This does not necessarily indicate duplication, as a single invoice may contain multiple products.
- **4,879 groups of records** share identical values across all eight original business fields.
- These groups contain **5,268 excess duplicate records**, calculated by excluding the first occurrence within each group.

Identical business-field values do not necessarily indicate erroneous records. Further investigation is required before determining whether any records should be removed.

## 4. Validity

The validity assessment examined the formatting and numerical characteristics of transaction quantities and unit prices.

**Data type validation:**
- All quantity values conform to the defined integer format.
- All unit prices conform to the defined decimal format.

**Numerical value validation:**
- **10,624 records** contain negative quantities.
- **0 records** contain zero quantities.
- **2 records** contain negative unit prices.

Negative quantities may represent cancellations, returns, or other transaction adjustments. These records should therefore be investigated rather than automatically classified as invalid.

## 5. Consistency

Transaction records were classified into four categories based on whether the invoice number begins with `C` and whether the quantity is negative.

| Category | Invoice Indicator | Quantity | Record Count |
|---|---|---|---:|
| A | Starts with C | Negative | 9,288 |
| B | Starts with C | Non-negative | 0 |
| C | Does not start with C | Negative | 1,336 |
| D | Does not start with C | Non-negative | 531,285 |
| **Total** | | | **541,909** |

**Key finding:**

A total of **1,336 records (Category C)** contain negative quantities despite having invoice numbers that do not begin with `C`.

This discrepancy suggests that negative quantities are not exclusively associated with explicitly marked cancellation invoices.

An initial examination of 10 Category C records revealed zero unit prices and missing product descriptions. These characteristics may indicate inventory adjustments or other non-standard transaction activities, although their underlying business meaning remains unconfirmed.

Further investigation is required to determine the appropriate treatment of these records in downstream analyses.

## 6. Conclusion and Next Steps

The audit identified several issues requiring consideration before analytical modelling:

- Missing customer identifiers may limit the reliability and coverage of customer-level analyses.
- Exact business-field duplicates require further examination before any deduplication decisions.
- Negative quantities and unit prices require appropriate classification and validation.
- Transactions with negative quantities but no cancellation indicator require further investigation.

**No records were modified or removed during this audit.** All original transaction records remain preserved in the Raw Layer.

The findings will inform the design of the subsequent Staging Layer, where data type conversion, transaction classification, and data quality rules will be implemented.