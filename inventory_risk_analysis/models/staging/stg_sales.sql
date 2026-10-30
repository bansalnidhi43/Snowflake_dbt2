with source as (
    select * from {{ source('raw', 'raw_sales') }}
)
select
    sale_date::date              as sale_date,
    upper(trim(article_id))      as article_id,
    upper(trim(dc_id))           as dc_id,
    units_sold::number(18,0)     as units_sold,
    loaded_at
from source
qualify row_number() over (
    partition by sale_date, upper(trim(article_id)), upper(trim(dc_id))
    order by loaded_at desc
) = 1