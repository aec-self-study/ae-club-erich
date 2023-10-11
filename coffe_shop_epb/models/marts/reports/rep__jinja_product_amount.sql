{{ config(
  materialized = "table"
) }}
{% set product_types = get_product_types() %}

select
  date_trunc(date_time_created, month) as date_month,
  {% for product_type in product_types %}
    sum(case when category = '{{ product_type }}' then 1 else 0 end) as {{ product_type|replace(' ','_') }}_amount,
  {% endfor %}
from {{ ref('int__product_amount') }}
group by 1