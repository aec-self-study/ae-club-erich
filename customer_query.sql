with customers as (
select id as customer_id, name, email from `analytics-engineers-club.coffee_shop.customers`),
orders as (
select customer_id, count(distinct id) as num_of_orders, min(created_at) as first_order from `analytics-engineers-club.coffee_shop.orders`
group by 1)
select customer_id, name, email,ifnull(num_of_orders,0) as number_of_orders, first_order from customers
left join orders using(customer_id)