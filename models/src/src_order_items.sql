WITH raw_order_items AS (
    SELECT
        *
    FROM {{ source('raw', 'order_items') }}
)
select 
    ORDER_ID,
	cast (QUANTITY as int) as QUANTITY,
	PRODUCT_ID,
	cast (UNIT_PRICE as float) as UNIT_PRICE,
from raw_order_items where cast(quantity as int) > 0 and cast(unit_price as float) > 0
	
