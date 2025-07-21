WITH raw_customers AS (
    SELECT
        *
    FROM {{ source('raw', 'customers') }}
)

select 
    customer_id, 
    FIRST_NAME,
	LAST_NAME,
	REGION_ID,
	EMAIL,
	cast(signup_date as date) as signup_date
from raw_customers