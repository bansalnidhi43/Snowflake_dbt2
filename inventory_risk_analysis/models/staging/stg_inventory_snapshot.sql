with source as (
    select * from {{ source('raw', 'raw_inventory_snapshot') }}
)
select
    snapshot_date::date          as snapshot_date,
    upper(trim(article_id))      as article_id,
    upper(trim(dc_id))           as dc_id,
    on_hand_qty::number(18,0)    as on_hand_qty,
    loaded_at
from source
qualify row_number() over (
    partition by snapshot_date, upper(trim(article_id)), upper(trim(dc_id))
    order by loaded_at desc
) = 1