select
    upper(trim(dc_id))           as dc_id,
    trim(dc_name)                as dc_name,
    upper(trim(region))          as region
from {{ source('raw', 'raw_distribution_centers') }}