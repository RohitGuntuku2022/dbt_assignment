WITH raw_products AS (
    SELECT
        *
    FROM {{ source('raw', 'products') }}
)

select 
    SKU,
	cast (COST as float) as COST,
	CATEGORY,
	PRODUCT_ID,
	PRODUCT_NAME
from raw_products