SELECT
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,  -- Surrogate key, preferred for joins
    customer_id,
    first_name,
    last_name,
    email,
    signup_date,
    region_id
FROM {{ ref('src_customers') }}
