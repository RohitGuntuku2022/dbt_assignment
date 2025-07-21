WITH raw_regions AS (
    SELECT
        *
    FROM
    {{ source('raw', 'regions') }}
)

select 
    ZONE,
    PLANET,
	REGION_ID
from raw_regions
