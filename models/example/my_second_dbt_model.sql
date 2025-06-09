
-- Use the `ref` function to select from other models
{{ config(enabled = False) }}
select *
from {{ ref('my_first_dbt_model') }}
where id = 1
