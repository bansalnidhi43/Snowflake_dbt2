select
    upper(trim(article_id))      as article_id,
    trim(article_name)           as article_name,
    upper(trim(category))        as category,
    upper(trim(status))          as status,
    unit_cost::number(10,2)      as unit_cost
from {{ source('raw', 'raw_articles') }}