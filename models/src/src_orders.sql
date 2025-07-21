WITH raw_orders AS (
    SELECT
        *
    FROM {{ source('raw', 'orders') }}
)

select 
    lower(STATUS) as status,
	ORDER_ID ,
	cast (ORDER_DATE as date) as ORDER_DATE,
	CUSTOMER_ID
from raw_orders