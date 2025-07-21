-- models/analytics/fact_orders.sql

select
  -- Unique surrogate key at the order line item level
  {{ dbt_utils.generate_surrogate_key(['o.order_id', 'oi.product_id']) }} as order_key,

  -- Business and natural keys
  o.order_id,
  oi.product_id,


  -- Surrogate foreign keys for fast, SCD-compliant joins
  c.customer_key,
  p.product_key,
  r.region_key,

-- date column 
  o.order_date,
  

  -- Measures and calculations
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) as total_price,

  -- Categorical attributes
  o.status,

  -- Flags and business columns
  case when oi.quantity = 1 then true else false end as is_single_item,
  case when lower(o.status) = 'completed' then true else false end as is_completed,
-- Audit fields
  current_timestamp as etl_loaded_at

from {{ ref('src_orders') }} o
join {{ ref('src_order_items') }} oi    on o.order_id = oi.order_id
join {{ ref('dim_customers') }} c      on o.customer_id = c.customer_id
join {{ ref('dim_products') }} p       on oi.product_id = p.product_id
join {{ ref('dim_regions') }} r        on c.region_id = r.region_id

where
    oi.quantity > 0
    and oi.unit_price > 0
