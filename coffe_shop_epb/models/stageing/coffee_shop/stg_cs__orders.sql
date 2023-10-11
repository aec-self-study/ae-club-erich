{{ config(
  materialized = "table",
  cluster_by = "date_time_created"
) }}
select
cast(id as string) as order_id,
created_at date_time_created,
customer_id,
total as order_total,
address as order_address,
state as order_state,
zip as order_zip
from {{ source('coffee_shop', 'orders') }}