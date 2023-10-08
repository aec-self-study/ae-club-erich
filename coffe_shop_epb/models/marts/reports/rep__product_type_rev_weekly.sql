SELECT
   order_week,
   category,
   SUM(
      price
   ) total_revenue
FROM
{{ ref('int__product_amount') }} orders
GROUP BY
   1,
   2
