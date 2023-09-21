select 
id as order_item_id,
order_id,
cast(product_id as string) as product_id
from {{source('coffee_shop', 'order_items')}}