select dc_id, dc_name, region
from {{ ref('stg_distribution_centers') }}