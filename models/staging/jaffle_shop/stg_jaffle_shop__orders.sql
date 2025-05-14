select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from `estudos-337621.dbt_raw.orders`