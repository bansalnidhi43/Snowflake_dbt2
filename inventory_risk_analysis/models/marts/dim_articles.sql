select
    article_id, article_name, category, status, unit_cost,
    (status = 'ACTIVE') as is_active
from {{ ref('stg_articles') }}