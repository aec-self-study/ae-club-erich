with week_customer as (select distinct customer_id,category, cast(order_week as date) order_week, sum(price) as revenue
                       from {{ref('int__product_amount')}}
                       group by 1, 2,3),
     customer_first as (select customer_id, format_date('%Q(%Y)', min(cast(order_week as date))) as quarter_acquired,min(cast(order_week as date)) as order_week_c_min
                        from {{ref('int__product_amount')}}
                        group by 1),
     report_week as (select order_week
                     from unnest(GENERATE_DATE_ARRAY(
                             (select cast(min(order_week) as date) from {{ref('int__product_amount')}}),
                             (select cast(max(order_week) as date) from {{ref('int__product_amount')}}), interval 1
                             week)) as order_week),
     customer_report_week as (select order_week, quarter_acquired, customer_id,ROW_NUMBER() over (partition by customer_id order by order_week) as week
                              from report_week rw
                                       left join customer_first cf on rw.order_week >= cf.order_week_c_min)
select order_week,
       customer_id,
       category,
       quarter_acquired,
       COALESCE(revenue, 0)                                             as revenue,
       sum(revenue) over (partition by customer_id order by order_week) as cumulative_revenue,
       week
from customer_report_week
         left join week_customer using (order_week,customer_id)
order by customer_id