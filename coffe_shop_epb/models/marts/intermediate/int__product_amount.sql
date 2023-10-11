{{ config(
  materialized = "table",
  cluster_by = "category",
  partition_by = {"field":"date_time_created",
  "data_type":"timestamp",
  "granularity":"day"}
) }}
WITH orders AS (
   SELECT
      order_id,
      customer_id,
      DATE_TRUNC(
         date_time_created,
         isoweek
      ) AS order_week,
      date_time_created
   FROM
      {{ ref('stg_cs__orders') }}
),
order_items AS (
   SELECT
      order_item_id,
      product_id,
      order_id
   FROM
      {{ ref('stg_cs__order_items') }}
),
product_prices AS (
   SELECT
      *
   FROM
      {{ ref('stg_cs__product_prices') }}
),
products AS (
   SELECT
      product_id,
      category
   FROM
      {{ ref('stg_cs__products') }}
)
select order_id,
customer_id,
order_week,
order_item_id,
category,
product_price_id,
order_items.product_id,
price,
orders.date_time_created,
date_time_ended
FROM
   orders
   LEFT JOIN order_items USING (order_id)
   LEFT JOIN products USING (product_id)
   LEFT JOIN product_prices
   ON products.product_id = order_items.product_id
   AND orders.date_time_created >= product_prices.date_time_created
   AND orders.date_time_created < product_prices.date_time_ended
