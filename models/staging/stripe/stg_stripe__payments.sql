select 
id as payment_id,
orderId as order_id,
paymentmethod as payment_method,
status,
amount / 100 as amount,
created as created_at
from {{ source('stripe', 'payment') }}