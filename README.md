# 📊 PLANETKART dbt Project

## 🚀 Project Overview

This dbt project implements an **analytics-ready data warehouse** for **PLANETKART** on **Snowflake**, organizing data into a robust **star schema**, applying key warehousing patterns like **surrogate keys** and **slow-changing dimensions**, and enforcing data quality through **tests** and **snapshots**.

---

## 🧠 Design Decisions

### 🔹 Schema Organization

#### **Staging Layer (`PLANETKART_STAGE`)**
- All raw tables are represented as **sources**.
- **Staging models** perform light transformations, standardize column names/types, and act as **atomic building blocks** for further modeling.

#### **Analytics Layer (`PLANETKART_ANALYTICS`)**
- **Dimension tables**: `dim_customers`, `dim_products`, `dim_regions`
- **Fact table**: `fact_orders`
- **Surrogate keys**:
  - Used as **primary keys** in dimension tables
  - Used as **foreign keys** in the fact table
- Supports robust joins and **SCD2 tracking**
- Designed for fast, flexible **analytics** and **business reporting**

---

### 🏗️ Data Warehouse Concepts

#### **⭐ Star Schema**
- Central **fact table** surrounded by descriptive **dimension tables**
- Simplifies analytics, enables efficient queries, and ensures business context

#### **🔑 Surrogate Keys**
- Generated using **dbt macros**
- Insulate warehouse from natural key changes
- Enable historical tracking (SCD2)

#### **🕓 Slowly Changing Dimensions (SCD)**

- **Type 2 SCD**:
  - Implemented for **customers**
  - Uses **dbt snapshots** with the `check` strategy
  - Enables historical analysis of attribute changes

#### **🧪 Testing**
- Uses **built-in dbt tests** and `dbt-utils`:
  - `not_null`
  - `unique`
  - `accepted_values`
  - **Anomaly checks**

#### **📦 Macros for DRY Logic**
- Common transformations (e.g., **surrogate key generation**) are implemented as **reusable macros** for consistency and maintainability

---

## 🧭 Schema Diagram

### **Logical Star Schema** (ER Diagram via Mermaid)

> You can view this directly using [Mermaid live editor](https://mermaid.live) or paste into a supported Markdown viewer.

<pre>
erDiagram
    CUSTOMERS {
        customer_key pk
        customer_id
        first_name
        last_name
        email
        region_id
        signup_date
    }
    PRODUCTS {
        product_key pk
        product_id
        product_name
        category
        cost
        sku
    }
    REGIONS {
        region_key pk
        region_id
        zone
        planet
    }
    FACT_ORDERS {
        CUSTOMER_KEY
        ETL_LOADED_AT
        IS_COMPLETED
        IS_SINGLE_ITEM
        ORDER_DATE
        ORDER_ID
        ORDER_KEY
        PRODUCT_ID
        PRODUCT_KEY
        QUANTITY
        REGION_KEY
        STATUS
        TOTAL_PRICE
        UNIT_PRICE
    }
    CUSTOMERS ||--o{ FACT_ORDERS : ""
    PRODUCTS ||--o{ FACT_ORDERS : ""
    REGIONS ||--o{ CUSTOMERS : ""
</pre>

## Lineage Diagram
<img width="1398" height="713" alt="image" src="https://github.com/user-attachments/assets/640a6e74-a483-4e64-8d69-b305744e9c6f" />

---

## 🧪 How to Run and Test This Project

### ✅ Prerequisites

- **Python 3.8+**
- `dbt-core` and `dbt-snowflake` installed
- Access to a **Snowflake trial account** with necessary privileges
- All raw tables present in schema: `PLANETKART_RAW`
  - `customers`
  - `products`
  - `orders`
  - `order_items`
  - `regions`

###
```bash
# 1. Clone the repository
git clone <this_repo_url>
cd dbt_assignment

# 2. Set up dbt profile
# Edit your ~/.dbt/profiles.yml file to include Snowflake connection details
# Example profile setup is detailed in the project instructions

# 3. Install dbt packages
dbt deps

# 4. Build all models
dbt run

# 5. Run data tests
dbt test
# This runs all schema and custom tests (e.g., not_null, unique, accepted_values, anomalies)

# 6. Run snapshots for SCD2 tracking
dbt snapshot
# This records historical changes for the customer dimension

# 7. Check source freshness on _AIRBYTE_EXTRACTED_AT field
dbt source freshness
# Ensures raw data is arriving on schedule

# 8. Generate and view documentation
dbt docs generate
dbt docs serve
# Navigate to the DAG lineage graph for a visual overview of the full pipeline
```

### Sample Project Folder Structure
<pre>
models/
  ├── sources.yml
  ├── src/
  │   ├── src_customers.sql
  │   ├── src_products.sql
  │   ├── src_order_items.sql
  │   ├── src_orders.sql
  │   └── src_regions.sql
  ├── dims/
  │   ├── dim_customers.sql
  │   ├── dim_products.sql
  │   ├── dim_regions.sql
  │   └── fact_orders.sql
  └── snapshots/
      └── customers_snapshot.sql
macros/
  └── generate_schema_name.sql
README.md
</pre>


### 📝 Notes

- **Design assumptions**, **column mappings**, and **macro usage** are documented in:
  - Inline model comments
  - This `README.md`

- Tests are defined in model YAML files (per-model) and cover key business rules.

- If a data source does **not** have a `loaded_at` column, **freshness checks are skipped**

- Adapt the structure to fit your project and **dbt best practices**
