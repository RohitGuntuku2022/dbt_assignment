SELECT
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} AS PRODUCT_key,  -- Surrogate key, preferred for joins
    SKU,
	COST,
	CATEGORY,
	PRODUCT_ID,
	PRODUCT_NAME
FROM {{ ref('src_products') }}