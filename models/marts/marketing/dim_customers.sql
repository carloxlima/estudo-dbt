with customers as (

     select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as ( 

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

payment as ( 

    select * from {{ ref('stg_stripe__payments') }}

),

payment_orders as (

select
    orders.customer_id,
    sum (case when payment.status = 'success' then payment.amount end) as lifetime_value
from orders
left join payment using (order_id)
group by 1

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce (customer_orders.number_of_orders, 0) 
        as number_of_orders,
        coalesce (payment_orders.lifetime_value, 0) 
        as lifetime_value
    from customers

    left join customer_orders using (customer_id)
    left join payment_orders using (customer_id)

)

select * from final