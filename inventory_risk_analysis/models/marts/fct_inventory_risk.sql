select
    d.stock_sales_key,
    d.snapshot_date,
    d.article_id,
    d.dc_id,
    d.on_hand_qty,
    d.units_sold,
    round(d.avg_daily_sales_28d, 2) as avg_daily_sales_28d,
    {{ days_of_cover('d.on_hand_qty', 'd.avg_daily_sales_28d') }} as days_of_cover,
    {{ inventory_risk_status('d.on_hand_qty', 'd.avg_daily_sales_28d') }} as risk_status,
    greatest(
        d.on_hand_qty - coalesce(d.avg_daily_sales_28d, 0) * {{ var('excess_days_threshold') }},
        0
    ) as excess_qty,
    greatest(
        d.on_hand_qty - coalesce(d.avg_daily_sales_28d, 0) * {{ var('excess_days_threshold') }},
        0
    ) * a.unit_cost as excess_value
from {{ ref('int_inventory_demand') }} d
left join {{ ref('dim_articles') }} a
    on d.article_id = a.article_id