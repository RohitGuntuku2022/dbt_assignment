SELECT
    {{ dbt_utils.generate_surrogate_key(['REGION_ID']) }} AS REGION_key,  -- Surrogate key, preferred for joins
    ZONE,
    PLANET,
	REGION_ID
FROM {{ ref('src_regions') }}


    