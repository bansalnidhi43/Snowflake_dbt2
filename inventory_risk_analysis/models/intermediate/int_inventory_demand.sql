select
    *,
    avg(units_sold) over (
        partition by article_id, dc_id
        order by snapshot_date
        rows between 27 preceding and current row
    ) as avg_daily_sales_28d
from {{ ref('int_daily_stock_sales') }}