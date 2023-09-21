SELECT
    id as customer_id,
    `name` as customer_name,
    email as customer_email
FROM
    {{ source('coffee_shop', 'customers') }}
