{{ config(
    materialized='incremental',
    unique_key='stock_sales_key',
    incremental_strategy='merge',
    on_schema_change='append_new_columns'
) }}

with inventory as (
    select * from {{ ref('stg_inventory_snapshot') }}
    {% if is_incremental() %}
    where snapshot_date >= (
        select dateadd('day', -{{ var('lookback_days') }}, max(snapshot_date)) from {{ this }}
    )
    {% endif %}
),

sales as (
    select * from {{ ref('stg_sales') }}
    {% if is_incremental() %}
    where sale_date >= (
        select dateadd('day', -{{ var('lookback_days') }}, max(snapshot_date)) from {{ this }}
    )
    {% endif %}
)

select
    md5(concat_ws('|', i.snapshot_date::string, i.article_id, i.dc_id)) as stock_sales_key,
    i.snapshot_date,
    i.article_id,
    i.dc_id,
    i.on_hand_qty,
    coalesce(s.units_sold, 0) as units_sold,
    current_timestamp()       as dbt_updated_at
from inventory i
left join sales s
    on  i.snapshot_date = s.sale_date
    and i.article_id    = s.article_id
    and i.dc_id         = s.dc_id