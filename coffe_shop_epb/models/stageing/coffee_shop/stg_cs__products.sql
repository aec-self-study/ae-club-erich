select
cast(id as string) as product_id,
name as product_name,
category,
created_at as date_time_created
from {{ source('coffee_shop', 'products') }}