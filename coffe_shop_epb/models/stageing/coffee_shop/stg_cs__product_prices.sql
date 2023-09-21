select 
cast(id as string) as product_price_id,
cast(product_id as string) as product_id,
price,
created_at as date_time_created,
ended_at as date_time_ended
from {{ source('coffee_shop', 'product_prices') }}
